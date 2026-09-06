import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_state.dart';
import '../../core/network/api_client.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _name = TextEditingController(text: 'Athlete');
  final _age = TextEditingController(text: '28');
  final _height = TextEditingController(text: '180');
  final _weight = TextEditingController(text: '80');
  final _years = TextEditingController(text: '2');
  final _days = TextEditingController(text: '4');
  final _duration = TextEditingController(text: '60');
  final _injury = TextEditingController();
  var _sex = 0;
  var _experience = 1;
  var _goal = 0;
  var _equipment = 0;
  var _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _age.dispose();
    _height.dispose();
    _weight.dispose();
    _years.dispose();
    _days.dispose();
    _duration.dispose();
    _injury.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    setState(() => _busy = true);
    try {
      final api = ref.read(apiClientProvider);
      await api.dio.post('/api/onboarding', data: {
        'displayName': _name.text.trim(),
        'age': int.parse(_age.text),
        'sex': _sex,
        'heightCm': double.parse(_height.text),
        'bodyWeightKg': double.parse(_weight.text),
        'experience': _experience,
        'yearsTraining': double.parse(_years.text),
        'primaryGoal': _goal,
        'secondaryGoal': null,
        'trainingDaysPerWeek': int.parse(_days.text),
        'preferredSessionMinutes': int.parse(_duration.text),
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
        'baselineLifts': <Map<String, dynamic>>[],
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
    return Scaffold(
      appBar: AppBar(title: const Text('Onboarding')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name')),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: TextField(controller: _age, decoration: const InputDecoration(labelText: 'Age'), keyboardType: TextInputType.number)),
            const SizedBox(width: 12),
            Expanded(child: TextField(controller: _years, decoration: const InputDecoration(labelText: 'Years training'), keyboardType: TextInputType.number)),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: TextField(controller: _height, decoration: const InputDecoration(labelText: 'Height (cm)'), keyboardType: TextInputType.number)),
            const SizedBox(width: 12),
            Expanded(child: TextField(controller: _weight, decoration: const InputDecoration(labelText: 'Weight (kg)'), keyboardType: TextInputType.number)),
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
          const SizedBox(height: 12),
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
          Row(children: [
            Expanded(child: TextField(controller: _days, decoration: const InputDecoration(labelText: 'Days / week'), keyboardType: TextInputType.number)),
            const SizedBox(width: 12),
            Expanded(child: TextField(controller: _duration, decoration: const InputDecoration(labelText: 'Session min'), keyboardType: TextInputType.number)),
          ]),
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
          const SizedBox(height: 12),
          TextField(controller: _injury, decoration: const InputDecoration(labelText: 'Injuries / limitations (optional)')),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: _busy ? null : _finish,
            child: Text(_busy ? 'Generating program…' : 'Save & generate program'),
          ),
        ],
      ),
    );
  }
}
