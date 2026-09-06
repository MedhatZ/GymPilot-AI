import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gymcoach/l10n/app_localizations.dart';

import '../../core/auth/auth_state.dart';
import '../../data/repositories/gym_models.dart';
import '../../data/repositories/repository_providers.dart';

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
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final input = OnboardingInput(
        displayName: _name.text.trim().isEmpty ? 'Athlete' : _name.text.trim(),
        age: int.tryParse(_age.text) ?? 30,
        sex: _sex,
        heightCm: double.tryParse(_height.text) ?? 178,
        bodyWeightKg: double.tryParse(_weight.text) ?? 80,
        experience: _experience,
        yearsTraining: double.tryParse(_years.text) ?? 1,
        primaryGoal: _goal,
        secondaryGoal: _secondaryGoal < 0 ? null : _secondaryGoal,
        trainingDaysPerWeek: int.tryParse(_days.text) ?? 4,
        preferredSessionMinutes: int.tryParse(_duration.text) ?? 60,
        equipmentSetting: _equipment,
        injuryNotes: _injury.text.trim().isEmpty ? null : _injury.text.trim(),
        baselineBenchKg: skipBaseline || _bench.text.trim().isEmpty
            ? null
            : double.tryParse(_bench.text),
      );

      final onboarding = ref.read(onboardingRepositoryProvider);
      final programs = ref.read(programRepositoryProvider);
      await onboarding.completeSetup(input);
      await programs.generateInitial(input);
      await ref.read(authControllerProvider.notifier).markOnboarded();
    } catch (e) {
      if (mounted) {
        final msg = e.toString().contains('SocketException') ||
                e.toString().contains('DioException') ||
                e.toString().contains('connection')
            ? l10n.setupFailedOffline
            : l10n.setupFailedGeneric;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final titles = [
      l10n.stepProfile,
      l10n.stepGoal,
      l10n.stepSchedule,
      l10n.stepLimitations,
      l10n.stepStrength,
    ];
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          l10n.quickSetupTitle(titles[_step]),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: LinearProgressIndicator(value: (_step + 1) / 5),
          ),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: _buildStep(l10n),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Material(
        elevation: 6,
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, 12, 20, 12 + bottomInset),
          child: _buildBottomNav(l10n),
        ),
      ),
    );
  }

  Widget _buildBottomNav(AppLocalizations l10n) {
    if (_step < 4) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_step > 0)
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton(
                onPressed: () => setState(() => _step--),
                child: Text(l10n.back),
              ),
            ),
          FilledButton(
            onPressed: () => setState(() => _step++),
            style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
            child: Text(l10n.next),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton(
            onPressed: () => setState(() => _step--),
            child: Text(l10n.back),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _busy ? null : () => _finish(skipBaseline: true),
                style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                child: Text(l10n.skip),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: _busy ? null : () => _finish(),
                style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                child: Text(_busy ? l10n.generating : l10n.generateProgram),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep(AppLocalizations l10n) {
    switch (_step) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(controller: _name, decoration: InputDecoration(labelText: l10n.labelName)),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _age,
                  decoration: InputDecoration(labelText: l10n.labelAge),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _years,
                  decoration: InputDecoration(labelText: l10n.labelYearsTraining),
                  keyboardType: TextInputType.number,
                ),
              ),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _height,
                  decoration: InputDecoration(labelText: l10n.labelHeightCm),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _weight,
                  decoration: InputDecoration(labelText: l10n.labelWeightKg),
                  keyboardType: TextInputType.number,
                ),
              ),
            ]),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: _sex,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.labelSex),
              items: [
                DropdownMenuItem(value: 0, child: Text(l10n.sexMale)),
                DropdownMenuItem(value: 1, child: Text(l10n.sexFemale)),
                DropdownMenuItem(value: 2, child: Text(l10n.sexOther)),
                DropdownMenuItem(value: 3, child: Text(l10n.sexPreferNot, overflow: TextOverflow.ellipsis)),
              ],
              onChanged: (v) => setState(() => _sex = v ?? 0),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: _experience,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.labelExperience),
              items: [
                DropdownMenuItem(value: 0, child: Text(l10n.expBeginner)),
                DropdownMenuItem(value: 1, child: Text(l10n.expIntermediate)),
                DropdownMenuItem(value: 2, child: Text(l10n.expAdvanced)),
              ],
              onChanged: (v) => setState(() => _experience = v ?? 1),
            ),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<int>(
              initialValue: _goal,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.labelPrimaryGoal),
              items: [
                DropdownMenuItem(value: 0, child: Text(l10n.goalHypertrophy)),
                DropdownMenuItem(value: 1, child: Text(l10n.goalStrength)),
                DropdownMenuItem(value: 2, child: Text(l10n.goalStrengthHypertrophy, overflow: TextOverflow.ellipsis)),
                DropdownMenuItem(value: 3, child: Text(l10n.goalBodyRecomp)),
                DropdownMenuItem(value: 4, child: Text(l10n.goalGeneralFitness)),
              ],
              onChanged: (v) => setState(() => _goal = v ?? 0),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: _secondaryGoal,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.labelSecondaryGoal),
              items: [
                DropdownMenuItem(value: -1, child: Text(l10n.goalNone)),
                DropdownMenuItem(value: 0, child: Text(l10n.goalHypertrophy)),
                DropdownMenuItem(value: 1, child: Text(l10n.goalStrength)),
                DropdownMenuItem(value: 2, child: Text(l10n.goalStrengthHypertrophy, overflow: TextOverflow.ellipsis)),
                DropdownMenuItem(value: 4, child: Text(l10n.goalGeneralFitness)),
              ],
              onChanged: (v) => setState(() => _secondaryGoal = v ?? -1),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<int>(
              initialValue: _equipment,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.labelEquipment),
              items: [
                DropdownMenuItem(value: 0, child: Text(l10n.equipmentFullGym)),
                DropdownMenuItem(value: 1, child: Text(l10n.equipmentHomeGym)),
                DropdownMenuItem(value: 2, child: Text(l10n.equipmentCustom)),
              ],
              onChanged: (v) => setState(() => _equipment = v ?? 0),
            ),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _days,
              decoration: InputDecoration(labelText: l10n.labelDaysPerWeek),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _duration,
              decoration: InputDecoration(labelText: l10n.labelSessionMinutes),
              keyboardType: TextInputType.number,
            ),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _injury,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: l10n.labelInjuries,
                hintText: l10n.optionalHint,
              ),
            ),
          ],
        );
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.strengthOptionalHelp),
            const SizedBox(height: 12),
            TextField(
              controller: _bench,
              decoration: InputDecoration(labelText: l10n.labelBenchOptional),
              keyboardType: TextInputType.number,
            ),
          ],
        );
    }
  }
}
