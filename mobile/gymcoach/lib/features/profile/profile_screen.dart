import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_state.dart';
import '../../core/config/personal_mode_service.dart';
import '../../core/network/api_client.dart';
import '../wearable/wearable_health_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  String _aiCoach = 'Training Engine Only';
  String _aiStatus = 'NotConfigured';
  String? _aiModel;

  @override
  void initState() {
    super.initState();
    _loadAiStatus();
  }

  Future<void> _loadAiStatus() async {
    try {
      final res = await ref.read(apiClientProvider).dio.get('/api/personal/status');
      final data = Map<String, dynamic>.from(res.data as Map);
      if (!mounted) return;
      setState(() {
        _aiCoach = data['aiCoach']?.toString() ?? 'Training Engine Only';
        _aiStatus = data['aiStatus']?.toString() ?? 'NotConfigured';
        _aiModel = data['aiModel']?.toString();
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _aiCoach = 'Training Engine Only';
        _aiStatus = 'Error';
        _aiModel = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final personal = ref.watch(personalModeServiceProvider);
    final wearable = ref.watch(wearableProvider);
    final statusLabel = switch (_aiStatus) {
      'Connected' => 'Connected',
      'Error' => 'Error',
      _ => 'Not configured',
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Personal Mode'),
            subtitle: Text(personal.isEnabled ? 'Enabled — no login required' : 'Disabled'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Units'),
            subtitle: Text(personal.config.units),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Default weight increment'),
            subtitle: Text('${personal.config.defaultWeightIncrementKg} kg'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('API'),
            subtitle: Text(personal.config.apiBaseUrl),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Edit profile'),
            subtitle: const Text('Goals, schedule, limitations'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _editProfile(context, ref),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Huawei Health'),
            subtitle: FutureBuilder(
              future: wearable.isAvailable(),
              builder: (context, snap) => Text(
                snap.data == true ? 'Connected / available' : 'Not connected (dev stub — credentials required)',
              ),
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('AI Coach'),
            subtitle: Text(_aiCoach),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('OpenAI status'),
            subtitle: Text(
              _aiModel == null || _aiModel!.isEmpty
                  ? statusLabel
                  : '$statusLabel · $_aiModel',
            ),
          ),
          const Divider(),
          const Text('About'),
          const Text('GymCoach AI Personal MVP. Nutrition is out of scope. Programs do not expire on a calendar.'),
          const SizedBox(height: 24),
          if (!personal.isEnabled)
            FilledButton(
              onPressed: () => ref.read(authControllerProvider.notifier).signOut(),
              child: const Text('Sign out'),
            ),
        ],
      ),
    );
  }

  Future<void> _editProfile(BuildContext context, WidgetRef ref) async {
    try {
      final me = await ref.read(apiClientProvider).dio.get('/api/onboarding/me');
      final data = Map<String, dynamic>.from(me.data as Map);
      final name = TextEditingController(text: data['displayName']?.toString() ?? '');
      final weight = TextEditingController(text: '${data['bodyWeightKg'] ?? 80}');
      final days = TextEditingController(text: '${data['trainingDaysPerWeek'] ?? 4}');
      if (!context.mounted) return;
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Edit profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
              TextField(controller: weight, decoration: const InputDecoration(labelText: 'Weight kg'), keyboardType: TextInputType.number),
              TextField(controller: days, decoration: const InputDecoration(labelText: 'Days / week'), keyboardType: TextInputType.number),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
          ],
        ),
      );
      if (ok != true) return;
      await ref.read(apiClientProvider).dio.post('/api/onboarding', data: {
        'displayName': name.text.trim(),
        'age': data['age'] ?? 30,
        'sex': data['sex'] ?? 0,
        'heightCm': data['heightCm'] ?? 178,
        'bodyWeightKg': double.tryParse(weight.text) ?? 80,
        'experience': data['experience'] ?? 1,
        'yearsTraining': data['yearsTraining'] ?? 3,
        'primaryGoal': data['primaryGoal'] ?? 0,
        'secondaryGoal': data['secondaryGoal'],
        'trainingDaysPerWeek': int.tryParse(days.text) ?? 4,
        'preferredSessionMinutes': data['preferredSessionMinutes'] ?? 60,
        'equipmentSetting': data['equipmentSetting'] ?? 0,
        'equipmentIds': <String>[],
        'limitations': data['limitations'] ?? [],
        'baselineLifts': data['baselineLifts'] ?? [],
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile saved')));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    }
  }
}
