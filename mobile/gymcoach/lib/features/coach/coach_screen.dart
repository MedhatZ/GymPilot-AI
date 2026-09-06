import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymcoach/l10n/app_localizations.dart';

import '../../data/repositories/repository_providers.dart';

class _ChatMessage {
  _ChatMessage({required this.text, required this.isUser, this.source, this.confidence});
  final String text;
  final bool isUser;
  final String? source;
  final num? confidence;
}

class CoachScreen extends ConsumerStatefulWidget {
  const CoachScreen({super.key});

  @override
  ConsumerState<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends ConsumerState<CoachScreen> {
  final _controller = TextEditingController();
  final _messages = <_ChatMessage>[];
  var _busy = false;
  String? _error;
  var _seeded = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _ensureIntro(AppLocalizations l10n) {
    if (_seeded) return;
    _seeded = true;
    _messages.add(_ChatMessage(text: l10n.coachIntro, isUser: false, source: 'SYSTEM'));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ensureIntro(AppLocalizations.of(context));
  }

  Future<void> _ask(String q, AppLocalizations l10n) async {
    final question = q.trim();
    if (question.isEmpty || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
      _messages.add(_ChatMessage(text: question, isUser: true));
      _controller.clear();
    });
    try {
      final answer = await ref.read(coachRepositoryProvider).ask(question);
      setState(() {
        _messages.add(_ChatMessage(
          text: answer.answer,
          isUser: false,
          source: answer.source,
          confidence: answer.confidence,
        ));
      });
    } catch (_) {
      setState(() {
        _error = l10n.coachUnavailable;
        _messages.add(_ChatMessage(
          text: l10n.coachFallback,
          isUser: false,
          source: 'TRAINING_ENGINE',
        ));
      });
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final presets = [
      l10n.presetProgressing,
      l10n.presetWhyWeight,
      l10n.presetDeload,
      l10n.presetChangeProgram,
      l10n.presetImproved,
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: Text(l10n.coach)),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: presets
                    .map((q) => ActionChip(label: Text(q), onPressed: _busy ? null : () => _ask(q, l10n)))
                    .toList(),
              ),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(_error!, style: TextStyle(color: theme.colorScheme.error, fontSize: 13)),
              ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length + (_busy ? 1 : 0),
                itemBuilder: (_, i) {
                  if (_busy && i == _messages.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                          const SizedBox(width: 12),
                          Text(l10n.coachThinking),
                        ],
                      ),
                    );
                  }
                  final m = _messages[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: Column(
                      crossAxisAlignment: m.isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          m.isUser ? l10n.you : l10n.coach,
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(m.text, style: const TextStyle(fontSize: 16, height: 1.35)),
                        if (!m.isUser && m.source != null && m.source != 'SYSTEM')
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              m.source == 'OPENAI'
                                  ? '${l10n.sourceOpenAi}${m.confidence != null ? ' · ${(m.confidence! * 100).round()}%' : ''}'
                                  : l10n.sourceTrainingEngine,
                              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !_busy,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (v) => _ask(v, l10n),
                      decoration: InputDecoration(
                        hintText: l10n.askCoachHint,
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _busy ? null : () => _ask(_controller.text, l10n),
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
