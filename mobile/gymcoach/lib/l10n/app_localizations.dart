import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'GymCoach AI'**
  String get appTitle;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navWorkout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get navWorkout;

  /// No description provided for @navProgress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get navProgress;

  /// No description provided for @navCoach.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get navCoach;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get languageArabic;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @generating.
  ///
  /// In en, this message translates to:
  /// **'Generating…'**
  String get generating;

  /// No description provided for @generateProgram.
  ///
  /// In en, this message translates to:
  /// **'Generate program'**
  String get generateProgram;

  /// No description provided for @quickSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick setup · {step}'**
  String quickSetupTitle(String step);

  /// No description provided for @stepProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get stepProfile;

  /// No description provided for @stepGoal.
  ///
  /// In en, this message translates to:
  /// **'Goal'**
  String get stepGoal;

  /// No description provided for @stepSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get stepSchedule;

  /// No description provided for @stepLimitations.
  ///
  /// In en, this message translates to:
  /// **'Limitations'**
  String get stepLimitations;

  /// No description provided for @stepStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength (optional)'**
  String get stepStrength;

  /// No description provided for @labelName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get labelName;

  /// No description provided for @labelAge.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get labelAge;

  /// No description provided for @labelYearsTraining.
  ///
  /// In en, this message translates to:
  /// **'Years training'**
  String get labelYearsTraining;

  /// No description provided for @labelHeightCm.
  ///
  /// In en, this message translates to:
  /// **'Height cm'**
  String get labelHeightCm;

  /// No description provided for @labelWeightKg.
  ///
  /// In en, this message translates to:
  /// **'Weight kg'**
  String get labelWeightKg;

  /// No description provided for @labelSex.
  ///
  /// In en, this message translates to:
  /// **'Sex'**
  String get labelSex;

  /// No description provided for @sexMale.
  ///
  /// In en, this message translates to:
  /// **'Male'**
  String get sexMale;

  /// No description provided for @sexFemale.
  ///
  /// In en, this message translates to:
  /// **'Female'**
  String get sexFemale;

  /// No description provided for @sexOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get sexOther;

  /// No description provided for @sexPreferNot.
  ///
  /// In en, this message translates to:
  /// **'Prefer not to say'**
  String get sexPreferNot;

  /// No description provided for @labelExperience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get labelExperience;

  /// No description provided for @expBeginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get expBeginner;

  /// No description provided for @expIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get expIntermediate;

  /// No description provided for @expAdvanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get expAdvanced;

  /// No description provided for @labelPrimaryGoal.
  ///
  /// In en, this message translates to:
  /// **'Primary goal'**
  String get labelPrimaryGoal;

  /// No description provided for @labelSecondaryGoal.
  ///
  /// In en, this message translates to:
  /// **'Secondary goal (optional)'**
  String get labelSecondaryGoal;

  /// No description provided for @goalNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get goalNone;

  /// No description provided for @goalHypertrophy.
  ///
  /// In en, this message translates to:
  /// **'Hypertrophy'**
  String get goalHypertrophy;

  /// No description provided for @goalStrength.
  ///
  /// In en, this message translates to:
  /// **'Strength'**
  String get goalStrength;

  /// No description provided for @goalStrengthHypertrophy.
  ///
  /// In en, this message translates to:
  /// **'Strength + Hypertrophy'**
  String get goalStrengthHypertrophy;

  /// No description provided for @goalBodyRecomp.
  ///
  /// In en, this message translates to:
  /// **'Body recomposition'**
  String get goalBodyRecomp;

  /// No description provided for @goalGeneralFitness.
  ///
  /// In en, this message translates to:
  /// **'General fitness'**
  String get goalGeneralFitness;

  /// No description provided for @labelEquipment.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get labelEquipment;

  /// No description provided for @equipmentFullGym.
  ///
  /// In en, this message translates to:
  /// **'Full gym'**
  String get equipmentFullGym;

  /// No description provided for @equipmentHomeGym.
  ///
  /// In en, this message translates to:
  /// **'Home gym'**
  String get equipmentHomeGym;

  /// No description provided for @equipmentCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get equipmentCustom;

  /// No description provided for @labelDaysPerWeek.
  ///
  /// In en, this message translates to:
  /// **'Training days / week'**
  String get labelDaysPerWeek;

  /// No description provided for @labelSessionMinutes.
  ///
  /// In en, this message translates to:
  /// **'Session minutes'**
  String get labelSessionMinutes;

  /// No description provided for @labelInjuries.
  ///
  /// In en, this message translates to:
  /// **'Injuries / exercises to avoid'**
  String get labelInjuries;

  /// No description provided for @optionalHint.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optionalHint;

  /// No description provided for @strengthOptionalHelp.
  ///
  /// In en, this message translates to:
  /// **'Optional: enter a recent Bench Press working set (e.g. 80). Leave blank to skip.'**
  String get strengthOptionalHelp;

  /// No description provided for @labelBenchOptional.
  ///
  /// In en, this message translates to:
  /// **'Bench Press kg (optional)'**
  String get labelBenchOptional;

  /// No description provided for @setupFailedOffline.
  ///
  /// In en, this message translates to:
  /// **'Could not finish setup. In Personal Mode this should work offline — please try again.'**
  String get setupFailedOffline;

  /// No description provided for @setupFailedGeneric.
  ///
  /// In en, this message translates to:
  /// **'Setup failed. Please check your inputs and try again.'**
  String get setupFailedGeneric;

  /// No description provided for @todaysWorkout.
  ///
  /// In en, this message translates to:
  /// **'TODAY\'S WORKOUT'**
  String get todaysWorkout;

  /// No description provided for @noWorkoutYet.
  ///
  /// In en, this message translates to:
  /// **'No workout yet'**
  String get noWorkoutYet;

  /// No description provided for @completeSetupForProgram.
  ///
  /// In en, this message translates to:
  /// **'Complete setup to generate a program.'**
  String get completeSetupForProgram;

  /// No description provided for @startWorkout.
  ///
  /// In en, this message translates to:
  /// **'START WORKOUT'**
  String get startWorkout;

  /// No description provided for @resumeWorkout.
  ///
  /// In en, this message translates to:
  /// **'RESUME WORKOUT'**
  String get resumeWorkout;

  /// No description provided for @activeWorkout.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE WORKOUT'**
  String get activeWorkout;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'RESUME'**
  String get resume;

  /// No description provided for @program.
  ///
  /// In en, this message translates to:
  /// **'Program'**
  String get program;

  /// No description provided for @noActiveProgram.
  ///
  /// In en, this message translates to:
  /// **'No active program'**
  String get noActiveProgram;

  /// No description provided for @noEndDate.
  ///
  /// In en, this message translates to:
  /// **'No end date — continues while you progress.'**
  String get noEndDate;

  /// No description provided for @whyThisProgram.
  ///
  /// In en, this message translates to:
  /// **'Why this program?'**
  String get whyThisProgram;

  /// No description provided for @programReasonDefault.
  ///
  /// In en, this message translates to:
  /// **'Generated from your profile, goals, schedule, and equipment. Changes are evidence-based, not calendar-based.'**
  String get programReasonDefault;

  /// No description provided for @workout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get workout;

  /// No description provided for @quickReadiness.
  ///
  /// In en, this message translates to:
  /// **'Quick readiness (optional)'**
  String get quickReadiness;

  /// No description provided for @energy.
  ///
  /// In en, this message translates to:
  /// **'Energy'**
  String get energy;

  /// No description provided for @soreness.
  ///
  /// In en, this message translates to:
  /// **'Soreness'**
  String get soreness;

  /// No description provided for @motivation.
  ///
  /// In en, this message translates to:
  /// **'Motivation'**
  String get motivation;

  /// No description provided for @levelLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get levelLow;

  /// No description provided for @levelNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get levelNormal;

  /// No description provided for @levelModerate.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get levelModerate;

  /// No description provided for @levelHigh.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get levelHigh;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'FINISH'**
  String get finish;

  /// No description provided for @finishWorkout.
  ///
  /// In en, this message translates to:
  /// **'Finish workout'**
  String get finishWorkout;

  /// No description provided for @howWasWorkout.
  ///
  /// In en, this message translates to:
  /// **'How was the workout?'**
  String get howWasWorkout;

  /// No description provided for @difficultyVeryEasy.
  ///
  /// In en, this message translates to:
  /// **'Very Easy'**
  String get difficultyVeryEasy;

  /// No description provided for @difficultyGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get difficultyGood;

  /// No description provided for @difficultyHard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get difficultyHard;

  /// No description provided for @difficultyVeryHard.
  ///
  /// In en, this message translates to:
  /// **'Very Hard'**
  String get difficultyVeryHard;

  /// No description provided for @anyPain.
  ///
  /// In en, this message translates to:
  /// **'Any pain?'**
  String get anyPain;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @logSet.
  ///
  /// In en, this message translates to:
  /// **'Log set'**
  String get logSet;

  /// No description provided for @sets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get sets;

  /// No description provided for @warmup.
  ///
  /// In en, this message translates to:
  /// **'Warm-up'**
  String get warmup;

  /// No description provided for @replaceExercise.
  ///
  /// In en, this message translates to:
  /// **'Replace exercise'**
  String get replaceExercise;

  /// No description provided for @painDiscomfort.
  ///
  /// In en, this message translates to:
  /// **'Pain / discomfort'**
  String get painDiscomfort;

  /// No description provided for @suggested.
  ///
  /// In en, this message translates to:
  /// **'Suggested'**
  String get suggested;

  /// No description provided for @target.
  ///
  /// In en, this message translates to:
  /// **'Target'**
  String get target;

  /// No description provided for @workoutSummary.
  ///
  /// In en, this message translates to:
  /// **'Workout summary'**
  String get workoutSummary;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @workingSets.
  ///
  /// In en, this message translates to:
  /// **'Working sets'**
  String get workingSets;

  /// No description provided for @exercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercises;

  /// No description provided for @volume.
  ///
  /// In en, this message translates to:
  /// **'Volume'**
  String get volume;

  /// No description provided for @newPr.
  ///
  /// In en, this message translates to:
  /// **'NEW PR'**
  String get newPr;

  /// No description provided for @progress.
  ///
  /// In en, this message translates to:
  /// **'Progress'**
  String get progress;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @recentPrs.
  ///
  /// In en, this message translates to:
  /// **'Recent PRs'**
  String get recentPrs;

  /// No description provided for @sessionsTracked.
  ///
  /// In en, this message translates to:
  /// **'Sessions tracked: {count} lifts'**
  String sessionsTracked(int count);

  /// No description provided for @readiness.
  ///
  /// In en, this message translates to:
  /// **'Readiness'**
  String get readiness;

  /// No description provided for @continueRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Recommendation: CONTINUE while progression remains positive. No calendar expiration.'**
  String get continueRecommendation;

  /// No description provided for @progressEmpty.
  ///
  /// In en, this message translates to:
  /// **'Keep logging workouts to build on-device history.'**
  String get progressEmpty;

  /// No description provided for @historyHelp.
  ///
  /// In en, this message translates to:
  /// **'Completed workouts appear after you finish sessions. History is built from real logged work only.'**
  String get historyHelp;

  /// No description provided for @sessionsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions'**
  String sessionsCount(int count);

  /// No description provided for @progressing.
  ///
  /// In en, this message translates to:
  /// **'↑ progressing'**
  String get progressing;

  /// No description provided for @monitor.
  ///
  /// In en, this message translates to:
  /// **'→ monitor'**
  String get monitor;

  /// No description provided for @coach.
  ///
  /// In en, this message translates to:
  /// **'Coach'**
  String get coach;

  /// No description provided for @coachIntro.
  ///
  /// In en, this message translates to:
  /// **'Ask about progress, loads, plateaus, or program decisions. Answers are grounded in your logged training data.'**
  String get coachIntro;

  /// No description provided for @askCoachHint.
  ///
  /// In en, this message translates to:
  /// **'Ask the coach…'**
  String get askCoachHint;

  /// No description provided for @coachThinking.
  ///
  /// In en, this message translates to:
  /// **'Coach is thinking…'**
  String get coachThinking;

  /// No description provided for @you.
  ///
  /// In en, this message translates to:
  /// **'You'**
  String get you;

  /// No description provided for @sourceOpenAi.
  ///
  /// In en, this message translates to:
  /// **'Source: OpenAI'**
  String get sourceOpenAi;

  /// No description provided for @sourceTrainingEngine.
  ///
  /// In en, this message translates to:
  /// **'Source: Training Engine'**
  String get sourceTrainingEngine;

  /// No description provided for @coachFallback.
  ///
  /// In en, this message translates to:
  /// **'Training-engine fallback — keep logging working sets. Program changes require multi-session evidence, not calendar weeks.'**
  String get coachFallback;

  /// No description provided for @coachUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Coach unavailable — showing training-engine fallback.'**
  String get coachUnavailable;

  /// No description provided for @presetProgressing.
  ///
  /// In en, this message translates to:
  /// **'Am I progressing?'**
  String get presetProgressing;

  /// No description provided for @presetWhyWeight.
  ///
  /// In en, this message translates to:
  /// **'Why is today\'s weight recommended?'**
  String get presetWhyWeight;

  /// No description provided for @presetDeload.
  ///
  /// In en, this message translates to:
  /// **'Do I need a deload?'**
  String get presetDeload;

  /// No description provided for @presetChangeProgram.
  ///
  /// In en, this message translates to:
  /// **'Should I change my program?'**
  String get presetChangeProgram;

  /// No description provided for @presetImproved.
  ///
  /// In en, this message translates to:
  /// **'What improved recently?'**
  String get presetImproved;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @personalMode.
  ///
  /// In en, this message translates to:
  /// **'Personal Mode'**
  String get personalMode;

  /// No description provided for @personalModeOn.
  ///
  /// In en, this message translates to:
  /// **'Enabled — standalone on-device (no backend required)'**
  String get personalModeOn;

  /// No description provided for @personalModeOff.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get personalModeOff;

  /// No description provided for @units.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get units;

  /// No description provided for @defaultIncrement.
  ///
  /// In en, this message translates to:
  /// **'Default weight increment'**
  String get defaultIncrement;

  /// No description provided for @dataSource.
  ///
  /// In en, this message translates to:
  /// **'Data source'**
  String get dataSource;

  /// No description provided for @localDrift.
  ///
  /// In en, this message translates to:
  /// **'Local Drift database'**
  String get localDrift;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit profile'**
  String get editProfile;

  /// No description provided for @editProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Goals, schedule, limitations'**
  String get editProfileSubtitle;

  /// No description provided for @huaweiHealth.
  ///
  /// In en, this message translates to:
  /// **'Huawei Health'**
  String get huaweiHealth;

  /// No description provided for @huaweiConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected / available'**
  String get huaweiConnected;

  /// No description provided for @huaweiNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Not connected (dev stub — credentials required)'**
  String get huaweiNotConnected;

  /// No description provided for @aiCoach.
  ///
  /// In en, this message translates to:
  /// **'AI Coach'**
  String get aiCoach;

  /// No description provided for @openaiStatus.
  ///
  /// In en, this message translates to:
  /// **'OpenAI status'**
  String get openaiStatus;

  /// No description provided for @statusConnected.
  ///
  /// In en, this message translates to:
  /// **'Connected'**
  String get statusConnected;

  /// No description provided for @statusError.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get statusError;

  /// No description provided for @statusNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get statusNotConfigured;

  /// No description provided for @trainingEngineOnly.
  ///
  /// In en, this message translates to:
  /// **'Training Engine Only'**
  String get trainingEngineOnly;

  /// No description provided for @trainingEngineOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Training Engine Only (on-device)'**
  String get trainingEngineOnDevice;

  /// No description provided for @about.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get about;

  /// No description provided for @aboutBody.
  ///
  /// In en, this message translates to:
  /// **'GymCoach AI Personal MVP. Nutrition is out of scope. Programs do not expire on a calendar.'**
  String get aboutBody;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @profileSaved.
  ///
  /// In en, this message translates to:
  /// **'Profile saved'**
  String get profileSaved;

  /// No description provided for @profileSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save profile. Try again.'**
  String get profileSaveFailed;

  /// No description provided for @couldNotLoadHome.
  ///
  /// In en, this message translates to:
  /// **'Could not load home. Pull to refresh after setup.'**
  String get couldNotLoadHome;

  /// No description provided for @couldNotLoadProgram.
  ///
  /// In en, this message translates to:
  /// **'Could not load program.'**
  String get couldNotLoadProgram;

  /// No description provided for @couldNotStartWorkout.
  ///
  /// In en, this message translates to:
  /// **'Could not start workout from your local program. Finish Quick setup first.'**
  String get couldNotStartWorkout;

  /// No description provided for @dayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day {number}'**
  String dayLabel(int number);

  /// No description provided for @lastWorkout.
  ///
  /// In en, this message translates to:
  /// **'Last: {name}'**
  String lastWorkout(String name);

  /// No description provided for @versionStatus.
  ///
  /// In en, this message translates to:
  /// **'Version {version} · {status}'**
  String versionStatus(Object version, Object status);

  /// No description provided for @startedAt.
  ///
  /// In en, this message translates to:
  /// **'Started {date}'**
  String startedAt(Object date);

  /// No description provided for @weight.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get weight;

  /// No description provided for @reps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get reps;

  /// No description provided for @rirOptional.
  ///
  /// In en, this message translates to:
  /// **'RIR (optional)'**
  String get rirOptional;

  /// No description provided for @skipRir.
  ///
  /// In en, this message translates to:
  /// **'Skip RIR'**
  String get skipRir;

  /// No description provided for @warmupSet.
  ///
  /// In en, this message translates to:
  /// **'Warm-up set'**
  String get warmupSet;

  /// No description provided for @replaceForSession.
  ///
  /// In en, this message translates to:
  /// **'Replace for this session'**
  String get replaceForSession;

  /// No description provided for @alternativeExercise.
  ///
  /// In en, this message translates to:
  /// **'Alternative exercise'**
  String get alternativeExercise;

  /// No description provided for @replace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replace;

  /// No description provided for @painNoted.
  ///
  /// In en, this message translates to:
  /// **'Pain noted for this session (not medical advice). You can continue.'**
  String get painNoted;

  /// No description provided for @restTimer.
  ///
  /// In en, this message translates to:
  /// **'Rest {seconds}s'**
  String restTimer(int seconds);

  /// No description provided for @pausedTimer.
  ///
  /// In en, this message translates to:
  /// **'Paused {seconds}s'**
  String pausedTimer(int seconds);

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @add30s.
  ///
  /// In en, this message translates to:
  /// **'+30s'**
  String get add30s;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @noSetsYet.
  ///
  /// In en, this message translates to:
  /// **'No sets yet'**
  String get noSetsYet;

  /// No description provided for @workingSetHash.
  ///
  /// In en, this message translates to:
  /// **'Working · #{number}'**
  String workingSetHash(int number);

  /// No description provided for @targetSetsReps.
  ///
  /// In en, this message translates to:
  /// **'Target {sets} × {minReps}-{maxReps}'**
  String targetSetsReps(int sets, int minReps, int maxReps);

  /// No description provided for @suggestedWeight.
  ///
  /// In en, this message translates to:
  /// **'Suggested: {weight} kg'**
  String suggestedWeight(String weight);

  /// No description provided for @substitutedFrom.
  ///
  /// In en, this message translates to:
  /// **'Substituted from {name}'**
  String substitutedFrom(String name);

  /// No description provided for @recentPr.
  ///
  /// In en, this message translates to:
  /// **'Recent PR: {value}'**
  String recentPr(String value);

  /// No description provided for @readinessWithScore.
  ///
  /// In en, this message translates to:
  /// **'Readiness: {score} ({label})'**
  String readinessWithScore(Object score, Object label);

  /// No description provided for @exercisesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} exercises'**
  String exercisesCount(int count);

  /// No description provided for @daySessionMeta.
  ///
  /// In en, this message translates to:
  /// **'{dayLabel} · {exercises} exercises · ~{minutes} min'**
  String daySessionMeta(String dayLabel, Object exercises, Object minutes);

  /// No description provided for @labelDaysWeekShort.
  ///
  /// In en, this message translates to:
  /// **'Days / week'**
  String get labelDaysWeekShort;

  /// No description provided for @bestProgressLine.
  ///
  /// In en, this message translates to:
  /// **'Best {weight} kg · e1RM {e1rm} · {trend}'**
  String bestProgressLine(Object weight, Object e1rm, String trend);

  /// No description provided for @durationValue.
  ///
  /// In en, this message translates to:
  /// **'Duration: {value}'**
  String durationValue(Object value);

  /// No description provided for @workingSetsValue.
  ///
  /// In en, this message translates to:
  /// **'Working sets: {count}'**
  String workingSetsValue(Object count);

  /// No description provided for @exercisesValue.
  ///
  /// In en, this message translates to:
  /// **'Exercises: {count}'**
  String exercisesValue(Object count);

  /// No description provided for @volumeValue.
  ///
  /// In en, this message translates to:
  /// **'Volume: {value} kg'**
  String volumeValue(Object value);

  /// No description provided for @whyReason.
  ///
  /// In en, this message translates to:
  /// **'Why: {reason}'**
  String whyReason(String reason);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
