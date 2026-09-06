// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'GymCoach AI';

  @override
  String get navHome => 'Home';

  @override
  String get navWorkout => 'Workout';

  @override
  String get navProgress => 'Progress';

  @override
  String get navCoach => 'Coach';

  @override
  String get navSettings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get next => 'Next';

  @override
  String get back => 'Back';

  @override
  String get skip => 'Skip';

  @override
  String get done => 'Done';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get refresh => 'Refresh';

  @override
  String get generating => 'Generating…';

  @override
  String get generateProgram => 'Generate program';

  @override
  String quickSetupTitle(String step) {
    return 'Quick setup · $step';
  }

  @override
  String get stepProfile => 'Profile';

  @override
  String get stepGoal => 'Goal';

  @override
  String get stepSchedule => 'Schedule';

  @override
  String get stepLimitations => 'Limitations';

  @override
  String get stepStrength => 'Strength (optional)';

  @override
  String get labelName => 'Name';

  @override
  String get labelAge => 'Age';

  @override
  String get labelYearsTraining => 'Years training';

  @override
  String get labelHeightCm => 'Height cm';

  @override
  String get labelWeightKg => 'Weight kg';

  @override
  String get labelSex => 'Sex';

  @override
  String get sexMale => 'Male';

  @override
  String get sexFemale => 'Female';

  @override
  String get sexOther => 'Other';

  @override
  String get sexPreferNot => 'Prefer not to say';

  @override
  String get labelExperience => 'Experience';

  @override
  String get expBeginner => 'Beginner';

  @override
  String get expIntermediate => 'Intermediate';

  @override
  String get expAdvanced => 'Advanced';

  @override
  String get labelPrimaryGoal => 'Primary goal';

  @override
  String get labelSecondaryGoal => 'Secondary goal (optional)';

  @override
  String get goalNone => 'None';

  @override
  String get goalHypertrophy => 'Hypertrophy';

  @override
  String get goalStrength => 'Strength';

  @override
  String get goalStrengthHypertrophy => 'Strength + Hypertrophy';

  @override
  String get goalBodyRecomp => 'Body recomposition';

  @override
  String get goalGeneralFitness => 'General fitness';

  @override
  String get labelEquipment => 'Equipment';

  @override
  String get equipmentFullGym => 'Full gym';

  @override
  String get equipmentHomeGym => 'Home gym';

  @override
  String get equipmentCustom => 'Custom';

  @override
  String get labelDaysPerWeek => 'Training days / week';

  @override
  String get labelSessionMinutes => 'Session minutes';

  @override
  String get labelInjuries => 'Injuries / exercises to avoid';

  @override
  String get optionalHint => 'Optional';

  @override
  String get strengthOptionalHelp =>
      'Optional: enter a recent Bench Press working set (e.g. 80). Leave blank to skip.';

  @override
  String get labelBenchOptional => 'Bench Press kg (optional)';

  @override
  String get setupFailedOffline =>
      'Could not finish setup. In Personal Mode this should work offline — please try again.';

  @override
  String get setupFailedGeneric =>
      'Setup failed. Please check your inputs and try again.';

  @override
  String get todaysWorkout => 'TODAY\'S WORKOUT';

  @override
  String get noWorkoutYet => 'No workout yet';

  @override
  String get completeSetupForProgram => 'Complete setup to generate a program.';

  @override
  String get startWorkout => 'START WORKOUT';

  @override
  String get resumeWorkout => 'RESUME WORKOUT';

  @override
  String get activeWorkout => 'ACTIVE WORKOUT';

  @override
  String get resume => 'RESUME';

  @override
  String get program => 'Program';

  @override
  String get noActiveProgram => 'No active program';

  @override
  String get noEndDate => 'No end date — continues while you progress.';

  @override
  String get whyThisProgram => 'Why this program?';

  @override
  String get programReasonDefault =>
      'Generated from your profile, goals, schedule, and equipment. Changes are evidence-based, not calendar-based.';

  @override
  String get workout => 'Workout';

  @override
  String get quickReadiness => 'Quick readiness (optional)';

  @override
  String get energy => 'Energy';

  @override
  String get soreness => 'Soreness';

  @override
  String get motivation => 'Motivation';

  @override
  String get levelLow => 'Low';

  @override
  String get levelNormal => 'Normal';

  @override
  String get levelModerate => 'Moderate';

  @override
  String get levelHigh => 'High';

  @override
  String get finish => 'FINISH';

  @override
  String get finishWorkout => 'Finish workout';

  @override
  String get howWasWorkout => 'How was the workout?';

  @override
  String get difficultyVeryEasy => 'Very Easy';

  @override
  String get difficultyGood => 'Good';

  @override
  String get difficultyHard => 'Hard';

  @override
  String get difficultyVeryHard => 'Very Hard';

  @override
  String get anyPain => 'Any pain?';

  @override
  String get yes => 'Yes';

  @override
  String get no => 'No';

  @override
  String get logSet => 'Log set';

  @override
  String get sets => 'Sets';

  @override
  String get warmup => 'Warm-up';

  @override
  String get replaceExercise => 'Replace exercise';

  @override
  String get painDiscomfort => 'Pain / discomfort';

  @override
  String get suggested => 'Suggested';

  @override
  String get target => 'Target';

  @override
  String get workoutSummary => 'Workout summary';

  @override
  String get duration => 'Duration';

  @override
  String get workingSets => 'Working sets';

  @override
  String get exercises => 'Exercises';

  @override
  String get volume => 'Volume';

  @override
  String get newPr => 'NEW PR';

  @override
  String get progress => 'Progress';

  @override
  String get overview => 'Overview';

  @override
  String get history => 'History';

  @override
  String get recentPrs => 'Recent PRs';

  @override
  String sessionsTracked(int count) {
    return 'Sessions tracked: $count lifts';
  }

  @override
  String get readiness => 'Readiness';

  @override
  String get continueRecommendation =>
      'Recommendation: CONTINUE while progression remains positive. No calendar expiration.';

  @override
  String get progressEmpty =>
      'Keep logging workouts to build on-device history.';

  @override
  String get historyHelp =>
      'Completed workouts appear after you finish sessions. History is built from real logged work only.';

  @override
  String sessionsCount(int count) {
    return '$count sessions';
  }

  @override
  String get progressing => '↑ progressing';

  @override
  String get monitor => '→ monitor';

  @override
  String get coach => 'Coach';

  @override
  String get coachIntro =>
      'Ask about progress, loads, plateaus, or program decisions. Answers are grounded in your logged training data.';

  @override
  String get askCoachHint => 'Ask the coach…';

  @override
  String get coachThinking => 'Coach is thinking…';

  @override
  String get you => 'You';

  @override
  String get sourceOpenAi => 'Source: OpenAI';

  @override
  String get sourceTrainingEngine => 'Source: Training Engine';

  @override
  String get coachFallback =>
      'Training-engine fallback — keep logging working sets. Program changes require multi-session evidence, not calendar weeks.';

  @override
  String get coachUnavailable =>
      'Coach unavailable — showing training-engine fallback.';

  @override
  String get presetProgressing => 'Am I progressing?';

  @override
  String get presetWhyWeight => 'Why is today\'s weight recommended?';

  @override
  String get presetDeload => 'Do I need a deload?';

  @override
  String get presetChangeProgram => 'Should I change my program?';

  @override
  String get presetImproved => 'What improved recently?';

  @override
  String get settings => 'Settings';

  @override
  String get personalMode => 'Personal Mode';

  @override
  String get personalModeOn =>
      'Enabled — standalone on-device (no backend required)';

  @override
  String get personalModeOff => 'Disabled';

  @override
  String get units => 'Units';

  @override
  String get defaultIncrement => 'Default weight increment';

  @override
  String get dataSource => 'Data source';

  @override
  String get localDrift => 'Local Drift database';

  @override
  String get editProfile => 'Edit profile';

  @override
  String get editProfileSubtitle => 'Goals, schedule, limitations';

  @override
  String get huaweiHealth => 'Huawei Health';

  @override
  String get huaweiConnected => 'Connected / available';

  @override
  String get huaweiNotConnected =>
      'Not connected (dev stub — credentials required)';

  @override
  String get aiCoach => 'AI Coach';

  @override
  String get openaiStatus => 'OpenAI status';

  @override
  String get statusConnected => 'Connected';

  @override
  String get statusError => 'Error';

  @override
  String get statusNotConfigured => 'Not configured';

  @override
  String get trainingEngineOnly => 'Training Engine Only';

  @override
  String get trainingEngineOnDevice => 'Training Engine Only (on-device)';

  @override
  String get about => 'About';

  @override
  String get aboutBody =>
      'GymCoach AI Personal MVP. Nutrition is out of scope. Programs do not expire on a calendar.';

  @override
  String get signOut => 'Sign out';

  @override
  String get profileSaved => 'Profile saved';

  @override
  String get profileSaveFailed => 'Could not save profile. Try again.';

  @override
  String get couldNotLoadHome =>
      'Could not load home. Pull to refresh after setup.';

  @override
  String get couldNotLoadProgram => 'Could not load program.';

  @override
  String get couldNotStartWorkout =>
      'Could not start workout from your local program. Finish Quick setup first.';

  @override
  String dayLabel(int number) {
    return 'Day $number';
  }

  @override
  String lastWorkout(String name) {
    return 'Last: $name';
  }

  @override
  String versionStatus(Object version, Object status) {
    return 'Version $version · $status';
  }

  @override
  String startedAt(Object date) {
    return 'Started $date';
  }

  @override
  String get weight => 'Weight';

  @override
  String get reps => 'Reps';

  @override
  String get rirOptional => 'RIR (optional)';

  @override
  String get skipRir => 'Skip RIR';

  @override
  String get warmupSet => 'Warm-up set';

  @override
  String get replaceForSession => 'Replace for this session';

  @override
  String get alternativeExercise => 'Alternative exercise';

  @override
  String get replace => 'Replace';

  @override
  String get painNoted =>
      'Pain noted for this session (not medical advice). You can continue.';

  @override
  String restTimer(int seconds) {
    return 'Rest ${seconds}s';
  }

  @override
  String pausedTimer(int seconds) {
    return 'Paused ${seconds}s';
  }

  @override
  String get pause => 'Pause';

  @override
  String get add30s => '+30s';

  @override
  String get reset => 'Reset';

  @override
  String get noSetsYet => 'No sets yet';

  @override
  String workingSetHash(int number) {
    return 'Working · #$number';
  }

  @override
  String targetSetsReps(int sets, int minReps, int maxReps) {
    return 'Target $sets × $minReps-$maxReps';
  }

  @override
  String suggestedWeight(String weight) {
    return 'Suggested: $weight kg';
  }

  @override
  String substitutedFrom(String name) {
    return 'Substituted from $name';
  }

  @override
  String recentPr(String value) {
    return 'Recent PR: $value';
  }

  @override
  String readinessWithScore(Object score, Object label) {
    return 'Readiness: $score ($label)';
  }

  @override
  String exercisesCount(int count) {
    return '$count exercises';
  }

  @override
  String daySessionMeta(String dayLabel, Object exercises, Object minutes) {
    return '$dayLabel · $exercises exercises · ~$minutes min';
  }

  @override
  String get labelDaysWeekShort => 'Days / week';

  @override
  String bestProgressLine(Object weight, Object e1rm, String trend) {
    return 'Best $weight kg · e1RM $e1rm · $trend';
  }

  @override
  String durationValue(Object value) {
    return 'Duration: $value';
  }

  @override
  String workingSetsValue(Object count) {
    return 'Working sets: $count';
  }

  @override
  String exercisesValue(Object count) {
    return 'Exercises: $count';
  }

  @override
  String volumeValue(Object value) {
    return 'Volume: $value kg';
  }

  @override
  String whyReason(String reason) {
    return 'Why: $reason';
  }
}
