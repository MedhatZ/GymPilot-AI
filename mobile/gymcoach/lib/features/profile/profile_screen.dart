import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymcoach/l10n/app_localizations.dart';

import '../../core/auth/auth_state.dart';
import '../../core/config/personal_mode_service.dart';
import '../../core/l10n/locale_controller.dart';
import '../../core/network/api_client.dart';
import '../../data/repositories/gym_models.dart';
import '../../data/repositories/repository_providers.dart';
import '../wearable/wearable_health_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String _aiCoachKey = 'trainingEngineOnly';
  String _aiStatus = 'NotConfigured';
  String? _aiModel;

  @override
  void initState() {
    super.initState();
    _loadAiStatus();
  }

  Future<void> _loadAiStatus() async {
    final personal = ref.read(personalModeServiceProvider);
    if (personal.isEnabled) {
      if (!mounted) return;
      setState(() {
        _aiCoachKey = 'trainingEngineOnDevice';
        _aiStatus = 'NotConfigured';
        _aiModel = null;
      });
      return;
    }
    try {
      final res = await ref.read(apiClientProvider).dio.get('/api/personal/status');
      final data = Map<String, dynamic>.from(res.data as Map);
      if (!mounted) return;
      setState(() {
        final coach = data['aiCoach']?.toString() ?? '';
        _aiCoachKey = coach.contains('on-device') || coach.contains('Training Engine Only')
            ? (coach.contains('on-device') ? 'trainingEngineOnDevice' : 'trainingEngineOnly')
            : 'raw:$coach';
        _aiStatus = data['aiStatus']?.toString() ?? 'NotConfigured';
        _aiModel = data['aiModel']?.toString();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _aiCoachKey = 'trainingEngineOnly';
        _aiStatus = 'Error';
        _aiModel = null;
      });
    }
  }

  String _aiCoachLabel(AppLocalizations l10n) {
    if (_aiCoachKey == 'trainingEngineOnDevice') return l10n.trainingEngineOnDevice;
    if (_aiCoachKey == 'trainingEngineOnly') return l10n.trainingEngineOnly;
    if (_aiCoachKey.startsWith('raw:')) return _aiCoachKey.substring(4);
    return l10n.trainingEngineOnly;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final personal = ref.watch(personalModeServiceProvider);
    final locale = ref.watch(localeControllerProvider);
    final wearable = ref.watch(wearableProvider);
    final statusLabel = switch (_aiStatus) {
      'Connected' => l10n.statusConnected,
      'Error' => l10n.statusError,
      _ => l10n.statusNotConfigured,
    };

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.language),
              subtitle: Text(
                locale.languageCode == 'ar' ? l10n.languageArabic : l10n.languageEnglish,
              ),
            ),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(value: 'en', label: Text(l10n.languageEnglish)),
                ButtonSegment(value: 'ar', label: Text(l10n.languageArabic)),
              ],
              selected: {locale.languageCode == 'ar' ? 'ar' : 'en'},
              onSelectionChanged: (s) {
                final code = s.first;
                ref.read(localeControllerProvider.notifier).setLocale(Locale(code));
              },
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.personalMode),
              subtitle: Text(personal.isEnabled ? l10n.personalModeOn : l10n.personalModeOff),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.units),
              subtitle: Text(personal.config.units),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.defaultIncrement),
              subtitle: Text('${personal.config.defaultWeightIncrementKg} kg'),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.dataSource),
              subtitle: Text(personal.isEnabled ? l10n.localDrift : personal.config.apiBaseUrl),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.editProfile),
              subtitle: Text(l10n.editProfileSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _editProfile(context, ref, l10n),
            ),
            const Divider(),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.huaweiHealth),
              subtitle: FutureBuilder(
                future: wearable.isAvailable(),
                builder: (context, snap) => Text(
                  snap.data == true ? l10n.huaweiConnected : l10n.huaweiNotConnected,
                ),
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.aiCoach),
              subtitle: Text(_aiCoachLabel(l10n)),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.openaiStatus),
              subtitle: Text(
                _aiModel == null || _aiModel!.isEmpty
                    ? statusLabel
                    : '$statusLabel · $_aiModel',
              ),
            ),
            const Divider(),
            Text(l10n.about),
            Text(l10n.aboutBody),
            const SizedBox(height: 24),
            if (!personal.isEnabled)
              FilledButton(
                onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
                child: Text(l10n.signOut),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _editProfile(BuildContext context, WidgetRef ref, AppLocalizations l10n) async {
    try {
      final onboarding = ref.read(onboardingRepositoryProvider);
      final data = await onboarding.getProfile() ?? <String, dynamic>{};
      final name = TextEditingController(text: data['displayName']?.toString() ?? '');
      final weight = TextEditingController(text: '${data['bodyWeightKg'] ?? 80}');
      final days = TextEditingController(text: '${data['trainingDaysPerWeek'] ?? 4}');
      if (!context.mounted) return;
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.editProfile),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: name, decoration: InputDecoration(labelText: l10n.labelName)),
                TextField(
                  controller: weight,
                  decoration: InputDecoration(labelText: l10n.labelWeightKg),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: days,
                  decoration: InputDecoration(labelText: l10n.labelDaysWeekShort),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l10n.cancel)),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l10n.save)),
          ],
        ),
      );
      if (ok != true) return;
      await onboarding.updateProfile(OnboardingInput(
        displayName: name.text.trim(),
        age: (data['age'] as num?)?.toInt() ?? 30,
        sex: (data['sex'] as num?)?.toInt() ?? 0,
        heightCm: (data['heightCm'] as num?)?.toDouble() ?? 178,
        bodyWeightKg: double.tryParse(weight.text) ?? 80,
        experience: (data['experience'] as num?)?.toInt() ?? 1,
        yearsTraining: (data['yearsTraining'] as num?)?.toDouble() ?? 3,
        primaryGoal: (data['primaryGoal'] as num?)?.toInt() ?? 0,
        secondaryGoal: (data['secondaryGoal'] as num?)?.toInt(),
        trainingDaysPerWeek: int.tryParse(days.text) ?? 4,
        preferredSessionMinutes: (data['preferredSessionMinutes'] as num?)?.toInt() ?? 60,
        equipmentSetting: (data['equipmentSetting'] as num?)?.toInt() ?? 0,
        injuryNotes: null,
        baselineBenchKg: null,
      ));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.profileSaved)));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.profileSaveFailed)),
        );
      }
    }
  }
}
