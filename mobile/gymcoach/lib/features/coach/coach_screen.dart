import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/network/api_client.dart';

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
  final _messages = <_ChatMessage>[
    _ChatMessage(
      text: 'Ask about progress, loads, plateaus, or program decisions. Answers are grounded in your logged training data.',
      isUser: false,
      source: 'SYSTEM',
    ),
  ];
  var _busy = false;
  String? _error;

  static const _presets = [
    'Am I progressing?',
    "Why is today's weight recommended?",
    'Do I need a deload?',
    'Should I change my program?',
    'What improved recently?',
  ];

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _ask(String q) async {
    final question = q.trim();
    if (question.isEmpty || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
      _messages.add(_ChatMessage(text: question, isUser: true));
      _controller.clear();
    });
    try {
      final res = await ref.read(apiClientProvider).dio.post('/api/coach/ask', data: {
        'question': question,
        'exerciseId': null,
      });
      final data = Map<String, dynamic>.from(res.data as Map);
      setState(() {
        _messages.add(_ChatMessage(
          text: data['answer']?.toString() ?? 'No answer returned.',
          isUser: false,
          source: data['source']?.toString(),
          confidence: data['confidence'] as num?,
        ));
      });
    } catch (_) {
      setState(() {
        _error = 'Could not reach coach — showing training-engine fallback.';
        _messages.add(_ChatMessage(
          text:
              'Training-engine fallback — keep logging working sets. Program changes require multi-session evidence, not calendar weeks.',
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Coach')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _presets
                  .map((q) => ActionChip(label: Text(q), onPressed: _busy ? null : () => _ask(q)))
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
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)),
                        SizedBox(width: 12),
                        Text('Coach is thinking…'),
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
                        m.isUser ? 'You' : 'Coach',
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
                                ? 'Source: OpenAI${m.confidence != null ? ' · ${(m.confidence! * 100).round()}%' : ''}'
                                : 'Source: Training Engine',
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      enabled: !_busy,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _ask,
                      decoration: const InputDecoration(
                        hintText: 'Ask the coach…',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _busy ? null : () => _ask(_controller.text),
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
