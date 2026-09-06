import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_state.dart';
import '../../core/network/api_client.dart';

/// Compact Personal Mode first-run setup (5 short steps).
class SetupFlowScreen extends ConsumerStatefulWidget {
  const SetupFlowScreen({super.key});

  @override
  ConsumerState<SetupFlowScreen> createState() => _SetupFlowScreenState();
}

class _SetupFlowScreenState extends ConsumerState<SetupFlowScreen> {
  var _step = 0;
  final _name = TextEditingController(text: 'Athlete');
  final _age = TextEditingController(text: '30');
  final _height = TextEditingController(text: '178');
  final _weight = TextEditingController(text: '80');
  final _years = TextEditingController(text: '3');
  final _days = TextEditingController(text: '4');
  final _duration = TextEditingController(text: '60');
  final _injury = TextEditingController();
  final _bench = TextEditingController();
  var _sex = 0;
  var _experience = 1;
  var _goal = 0;
  var _secondaryGoal = -1;
  var _equipment = 0;
  var _busy = false;

  @override
  void dispose() {
    for (final c in [_name, _age, _height, _weight, _years, _days, _duration, _injury, _bench]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _finish({bool skipBaseline = false}) async {
    setState(() => _busy = true);
    try {
      final api = ref.read(apiClientProvider);
      final baselines = <Map<String, dynamic>>[];
      if (!skipBaseline && _bench.text.trim().isNotEmpty) {
        // Best-effort: attach when exercise catalog available later
      }
      await api.dio.post('/api/onboarding', data: {
        'displayName': _name.text.trim(),
        'age': int.tryParse(_age.text) ?? 30,
        'sex': _sex,
        'heightCm': double.tryParse(_height.text) ?? 178,
        'bodyWeightKg': double.tryParse(_weight.text) ?? 80,
        'experience': _experience,
        'yearsTraining': double.tryParse(_years.text) ?? 1,
        'primaryGoal': _goal,
        'secondaryGoal': _secondaryGoal < 0 ? null : _secondaryGoal,
        'trainingDaysPerWeek': int.tryParse(_days.text) ?? 4,
        'preferredSessionMinutes': int.tryParse(_duration.text) ?? 60,
        'equipmentSetting': _equipment,
        'equipmentIds': <String>[],
        'limitations': _injury.text.trim().isEmpty
            ? <Map<String, dynamic>>[]
            : [
                {
                  'injuryDescription': _injury.text.trim(),
                  'painArea': null,
                  'avoidedExerciseId': null,
                  'movementRestriction': null,
                }
              ],
        'baselineLifts': baselines,
      });
      await api.dio.post('/api/programs/generate');
      await ref.read(authControllerProvider.notifier).markOnboarded();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final titles = ['Profile', 'Goal', 'Schedule', 'Limitations', 'Strength (optional)'];
    return Scaffold(
      appBar: AppBar(title: Text('Quick setup · ${titles[_step]}')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            LinearProgressIndicator(value: (_step + 1) / 5),
            const SizedBox(height: 20),
            Expanded(child: _buildStep()),
            Row(
              children: [
                if (_step > 0)
                  TextButton(onPressed: () => setState(() => _step--), child: const Text('Back')),
                const Spacer(),
                if (_step < 4)
                  FilledButton(
                    onPressed: () => setState(() => _step++),
                    child: const Text('Next'),
                  )
                else ...[
                  TextButton(onPressed: _busy ? null : () => _finish(skipBaseline: true), child: const Text('Skip')),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: _busy ? null : () => _finish(),
                    child: Text(_busy ? 'Generating…' : 'Generate program'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return ListView(children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: TextField(controller: _age, decoration: const InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number)),
            const SizedBox(width: 12),
            Expanded(child: TextField(controller: _years, decoration: const InputDecoration(labelText: 'Years training'), keyboardType: TextInputType.number)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: TextField(controller: _height, decoration: const InputDecoration(labelText: 'Height cm'), keyboardType: TextInputType.number)),
            const SizedBox(width: 12),
            Expanded(child: TextField(controller: _weight, decoration: const InputDecoration(labelText: 'Weight kg'), keyboardType: TextInputType.number)),
          ]),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: _sex,
            decoration: const InputDecoration(labelText: 'Sex'),
            items: const [
              DropdownMenuItem(value: 0, child: Text('Male')),
              DropdownMenuItem(value: 1, child: Text('Female')),
              DropdownMenuItem(value: 2, child: Text('Other')),
              DropdownMenuItem(value: 3, child: Text('Prefer not to say')),
            ],
            onChanged: (v) => setState(() => _sex = v ?? 0),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: _experience,
            decoration: const InputDecoration(labelText: 'Experience'),
            items: const [
              DropdownMenuItem(value: 0, child: Text('Beginner')),
              DropdownMenuItem(value: 1, child: Text('Intermediate')),
              DropdownMenuItem(value: 2, child: Text('Advanced')),
            ],
            onChanged: (v) => setState(() => _experience = v ?? 1),
          ),
        ]);
      case 1:
        return ListView(children: [
          DropdownButtonFormField<int>(
            initialValue: _goal,
            decoration: const InputDecoration(labelText: 'Primary goal'),
            items: const [
              DropdownMenuItem(value: 0, child: Text('Hypertrophy')),
              DropdownMenuItem(value: 1, child: Text('Strength')),
              DropdownMenuItem(value: 2, child: Text('Strength + Hypertrophy')),
              DropdownMenuItem(value: 3, child: Text('Body recomposition')),
              DropdownMenuItem(value: 4, child: Text('General fitness')),
            ],
            onChanged: (v) => setState(() => _goal = v ?? 0),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: _secondaryGoal,
            decoration: const InputDecoration(labelText: 'Secondary goal (optional)'),
            items: const [
              DropdownMenuItem(value: -1, child: Text('None')),
              DropdownMenuItem(value: 0, child: Text('Hypertrophy')),
              DropdownMenuItem(value: 1, child: Text('Strength')),
              DropdownMenuItem(value: 2, child: Text('Strength + Hypertrophy')),
              DropdownMenuItem(value: 4, child: Text('General fitness')),
            ],
            onChanged: (v) => setState(() => _secondaryGoal = v ?? -1),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int>(
            initialValue: _equipment,
            decoration: const InputDecoration(labelText: 'Equipment'),
            items: const [
              DropdownMenuItem(value: 0, child: Text('Full gym')),
              DropdownMenuItem(value: 1, child: Text('Home gym')),
              DropdownMenuItem(value: 2, child: Text('Custom')),
            ],
            onChanged: (v) => setState(() => _equipment = v ?? 0),
          ),
        ]);
      case 2:
        return ListView(children: [
          TextField(controller: _days, decoration: const InputDecoration(labelText: 'Training days / week'), keyboardType: TextInputType.number),
          const SizedBox(height: 12),
          TextField(controller: _duration, decoration: const InputDecoration(labelText: 'Session minutes'), keyboardType: TextInputType.number),
        ]);
      case 3:
        return ListView(children: [
          TextField(
            controller: _injury,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Injuries / exercises to avoid',
              hintText: 'Optional',
            ),
          ),
        ]);
      default:
        return ListView(children: [
          const Text('Optional: enter a recent Bench Press working set (e.g. 80). Leave blank to skip.'),
          const SizedBox(height: 12),
          TextField(controller: _bench, decoration: const InputDecoration(labelText: 'Bench Press kg (optional)'), keyboardType: TextInputType.number),
        ]);
    }
  }
}
