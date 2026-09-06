import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/auth_state.dart';
import '../../data/repositories/gym_models.dart';
import '../../data/repositories/repository_providers.dart';

/// Legacy single-page onboarding — uses the same local/cloud repositories as Quick setup.
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
      final input = OnboardingInput(
        displayName: _name.text.trim(),
        age: int.tryParse(_age.text) ?? 28,
        sex: _sex,
        heightCm: double.tryParse(_height.text) ?? 180,
        bodyWeightKg: double.tryParse(_weight.text) ?? 80,
        experience: _experience,
        yearsTraining: double.tryParse(_years.text) ?? 2,
        primaryGoal: _goal,
        trainingDaysPerWeek: int.tryParse(_days.text) ?? 4,
        preferredSessionMinutes: int.tryParse(_duration.text) ?? 60,
        equipmentSetting: _equipment,
        injuryNotes: _injury.text.trim().isEmpty ? null : _injury.text.trim(),
      );
      await ref.read(onboardingRepositoryProvider).completeSetup(input);
      await ref.read(programRepositoryProvider).generateInitial(input);
      await ref.read(authControllerProvider.notifier).markOnboarded();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Setup failed. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Onboarding')),
      body: SafeArea(
        child: ListView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
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
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Sex'),
              items: const [
                DropdownMenuItem(value: 0, child: Text('Male')),
                DropdownMenuItem(value: 1, child: Text('Female')),
                DropdownMenuItem(value: 2, child: Text('Other')),
                DropdownMenuItem(value: 3, child: Text('Prefer not to say', overflow: TextOverflow.ellipsis)),
              ],
              onChanged: (v) => setState(() => _sex = v ?? 0),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: _experience,
              isExpanded: true,
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
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Primary goal'),
              items: const [
                DropdownMenuItem(value: 0, child: Text('Hypertrophy')),
                DropdownMenuItem(value: 1, child: Text('Strength')),
                DropdownMenuItem(value: 2, child: Text('Strength + Hypertrophy', overflow: TextOverflow.ellipsis)),
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
              isExpanded: true,
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
      ),
    );
  }
}
