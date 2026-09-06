// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'جيم كوتش AI';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navWorkout => 'التمرين';

  @override
  String get navProgress => 'التقدّم';

  @override
  String get navCoach => 'المدرّب';

  @override
  String get navSettings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get next => 'التالي';

  @override
  String get back => 'رجوع';

  @override
  String get skip => 'تخطي';

  @override
  String get done => 'تم';

  @override
  String get save => 'حفظ';

  @override
  String get cancel => 'إلغاء';

  @override
  String get refresh => 'تحديث';

  @override
  String get generating => 'جارٍ الإنشاء…';

  @override
  String get generateProgram => 'إنشاء البرنامج';

  @override
  String quickSetupTitle(String step) {
    return 'إعداد سريع · $step';
  }

  @override
  String get stepProfile => 'الملف الشخصي';

  @override
  String get stepGoal => 'الهدف';

  @override
  String get stepSchedule => 'الجدول';

  @override
  String get stepLimitations => 'القيود';

  @override
  String get stepStrength => 'القوة (اختياري)';

  @override
  String get labelName => 'الاسم';

  @override
  String get labelAge => 'العمر';

  @override
  String get labelYearsTraining => 'سنوات التدريب';

  @override
  String get labelHeightCm => 'الطول سم';

  @override
  String get labelWeightKg => 'الوزن كجم';

  @override
  String get labelSex => 'الجنس';

  @override
  String get sexMale => 'ذكر';

  @override
  String get sexFemale => 'أنثى';

  @override
  String get sexOther => 'آخر';

  @override
  String get sexPreferNot => 'أفضل عدم الإفصاح';

  @override
  String get labelExperience => 'الخبرة';

  @override
  String get expBeginner => 'مبتدئ';

  @override
  String get expIntermediate => 'متوسط';

  @override
  String get expAdvanced => 'متقدم';

  @override
  String get labelPrimaryGoal => 'الهدف الأساسي';

  @override
  String get labelSecondaryGoal => 'هدف ثانوي (اختياري)';

  @override
  String get goalNone => 'لا يوجد';

  @override
  String get goalHypertrophy => 'تضخيم عضلي';

  @override
  String get goalStrength => 'قوة';

  @override
  String get goalStrengthHypertrophy => 'قوة + تضخيم';

  @override
  String get goalBodyRecomp => 'إعادة تكوين الجسم';

  @override
  String get goalGeneralFitness => 'لياقة عامة';

  @override
  String get labelEquipment => 'المعدات';

  @override
  String get equipmentFullGym => 'صالة متكاملة';

  @override
  String get equipmentHomeGym => 'جيم منزلي';

  @override
  String get equipmentCustom => 'مخصص';

  @override
  String get labelDaysPerWeek => 'أيام التدريب / أسبوع';

  @override
  String get labelSessionMinutes => 'مدة الجلسة بالدقائق';

  @override
  String get labelInjuries => 'إصابات / تمارين يجب تجنبها';

  @override
  String get optionalHint => 'اختياري';

  @override
  String get strengthOptionalHelp =>
      'اختياري: أدخل أحدث وزن لتمرين البنش (مثل 80). اتركه فارغًا للتخطي.';

  @override
  String get labelBenchOptional => 'وزن البنش كجم (اختياري)';

  @override
  String get setupFailedOffline =>
      'تعذر إكمال الإعداد. في الوضع الشخصي يعمل بدون إنترنت — حاول مرة أخرى.';

  @override
  String get setupFailedGeneric => 'فشل الإعداد. راجع البيانات وحاول مرة أخرى.';

  @override
  String get todaysWorkout => 'تمرين اليوم';

  @override
  String get noWorkoutYet => 'لا يوجد تمرين بعد';

  @override
  String get completeSetupForProgram => 'أكمل الإعداد لإنشاء برنامجك.';

  @override
  String get startWorkout => 'ابدأ التمرين';

  @override
  String get resumeWorkout => 'استئناف التمرين';

  @override
  String get activeWorkout => 'تمرين نشط';

  @override
  String get resume => 'استئناف';

  @override
  String get program => 'البرنامج';

  @override
  String get noActiveProgram => 'لا يوجد برنامج نشط';

  @override
  String get noEndDate => 'بدون تاريخ انتهاء — يستمر طالما التقدّم إيجابي.';

  @override
  String get whyThisProgram => 'لماذا هذا البرنامج؟';

  @override
  String get programReasonDefault =>
      'تم إنشاؤه من ملفك وأهدافك وجدولك ومعداتك. التغييرات مبنية على الأدلة وليست على التقويم.';

  @override
  String get workout => 'التمرين';

  @override
  String get quickReadiness => 'جاهزية سريعة (اختياري)';

  @override
  String get energy => 'الطاقة';

  @override
  String get soreness => 'الإجهاد العضلي';

  @override
  String get motivation => 'الحافز';

  @override
  String get levelLow => 'منخفض';

  @override
  String get levelNormal => 'عادي';

  @override
  String get levelModerate => 'متوسط';

  @override
  String get levelHigh => 'مرتفع';

  @override
  String get finish => 'إنهاء';

  @override
  String get finishWorkout => 'إنهاء التمرين';

  @override
  String get howWasWorkout => 'كيف كان التمرين؟';

  @override
  String get difficultyVeryEasy => 'سهل جدًا';

  @override
  String get difficultyGood => 'جيد';

  @override
  String get difficultyHard => 'صعب';

  @override
  String get difficultyVeryHard => 'صعب جدًا';

  @override
  String get anyPain => 'هل يوجد ألم؟';

  @override
  String get yes => 'نعم';

  @override
  String get no => 'لا';

  @override
  String get logSet => 'تسجيل المجموعة';

  @override
  String get sets => 'المجموعات';

  @override
  String get warmup => 'إحماء';

  @override
  String get replaceExercise => 'استبدال التمرين';

  @override
  String get painDiscomfort => 'ألم / انزعاج';

  @override
  String get suggested => 'المقترح';

  @override
  String get target => 'الهدف';

  @override
  String get workoutSummary => 'ملخص التمرين';

  @override
  String get duration => 'المدة';

  @override
  String get workingSets => 'مجموعات العمل';

  @override
  String get exercises => 'التمارين';

  @override
  String get volume => 'الحجم';

  @override
  String get newPr => 'رقم قياسي جديد';

  @override
  String get progress => 'التقدّم';

  @override
  String get overview => 'نظرة عامة';

  @override
  String get history => 'السجل';

  @override
  String get recentPrs => 'أحدث الأرقام القياسية';

  @override
  String sessionsTracked(int count) {
    return 'جلسات متتبعة: $count تمارين';
  }

  @override
  String get readiness => 'الجاهزية';

  @override
  String get continueRecommendation =>
      'التوصية: الاستمرار طالما التقدّم إيجابي. لا يوجد انتهاء بالتقويم.';

  @override
  String get progressEmpty => 'استمر في تسجيل التمارين لبناء سجل محلي.';

  @override
  String get historyHelp =>
      'تظهر التمارين المكتملة بعد إنهاء الجلسات. السجل مبني على العمل المسجّل فقط.';

  @override
  String sessionsCount(int count) {
    return '$count جلسات';
  }

  @override
  String get progressing => '↑ يتقدّم';

  @override
  String get monitor => '→ راقب';

  @override
  String get coach => 'المدرّب';

  @override
  String get coachIntro =>
      'اسأل عن التقدّم أو الأوزان أو الثبات أو قرارات البرنامج. الإجابات مبنية على بياناتك المسجّلة.';

  @override
  String get askCoachHint => 'اسأل المدرّب…';

  @override
  String get coachThinking => 'المدرّب يفكر…';

  @override
  String get you => 'أنت';

  @override
  String get sourceOpenAi => 'المصدر: OpenAI';

  @override
  String get sourceTrainingEngine => 'المصدر: محرك التدريب';

  @override
  String get coachFallback =>
      'رد محرك التدريب — استمر في تسجيل المجموعات. تغيير البرنامج يحتاج أدلة عبر جلسات متعددة وليس أسابيع التقويم.';

  @override
  String get coachUnavailable => 'المدرّب غير متاح — عرض رد محرك التدريب.';

  @override
  String get presetProgressing => 'هل أتقدّم؟';

  @override
  String get presetWhyWeight => 'لماذا هذا الوزن اليوم؟';

  @override
  String get presetDeload => 'هل أحتاج تخفيف حمل؟';

  @override
  String get presetChangeProgram => 'هل أغيّر برنامجي؟';

  @override
  String get presetImproved => 'ما الذي تحسّن مؤخرًا؟';

  @override
  String get settings => 'الإعدادات';

  @override
  String get personalMode => 'الوضع الشخصي';

  @override
  String get personalModeOn => 'مفعّل — مستقل على الجهاز (بدون خادم)';

  @override
  String get personalModeOff => 'معطّل';

  @override
  String get units => 'الوحدات';

  @override
  String get defaultIncrement => 'زيادة الوزن الافتراضية';

  @override
  String get dataSource => 'مصدر البيانات';

  @override
  String get localDrift => 'قاعدة بيانات محلية Drift';

  @override
  String get editProfile => 'تعديل الملف';

  @override
  String get editProfileSubtitle => 'الأهداف والجدول والقيود';

  @override
  String get huaweiHealth => 'هواوي هيلث';

  @override
  String get huaweiConnected => 'متصل / متاح';

  @override
  String get huaweiNotConnected => 'غير متصل (نسخة تطوير — يلزم إعداد)';

  @override
  String get aiCoach => 'مدرّب الذكاء';

  @override
  String get openaiStatus => 'حالة OpenAI';

  @override
  String get statusConnected => 'متصل';

  @override
  String get statusError => 'خطأ';

  @override
  String get statusNotConfigured => 'غير مضبوط';

  @override
  String get trainingEngineOnly => 'محرك التدريب فقط';

  @override
  String get trainingEngineOnDevice => 'محرك التدريب فقط (على الجهاز)';

  @override
  String get about => 'حول';

  @override
  String get aboutBody =>
      'جيم كوتش AI للنسخة الشخصية. التغذية خارج النطاق. البرامج لا تنتهي بالتقويم.';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get profileSaved => 'تم حفظ الملف';

  @override
  String get profileSaveFailed => 'تعذر حفظ الملف. حاول مرة أخرى.';

  @override
  String get couldNotLoadHome => 'تعذر تحميل الرئيسية. حدّث بعد الإعداد.';

  @override
  String get couldNotLoadProgram => 'تعذر تحميل البرنامج.';

  @override
  String get couldNotStartWorkout =>
      'تعذر بدء التمرين من البرنامج المحلي. أكمل الإعداد السريع أولًا.';

  @override
  String dayLabel(int number) {
    return 'اليوم $number';
  }

  @override
  String lastWorkout(String name) {
    return 'آخر تمرين: $name';
  }

  @override
  String versionStatus(Object version, Object status) {
    return 'الإصدار $version · $status';
  }

  @override
  String startedAt(Object date) {
    return 'بدأ في $date';
  }

  @override
  String get weight => 'الوزن';

  @override
  String get reps => 'التكرارات';

  @override
  String get rirOptional => 'RIR (اختياري)';

  @override
  String get skipRir => 'تخطي RIR';

  @override
  String get warmupSet => 'مجموعة إحماء';

  @override
  String get replaceForSession => 'استبدال لهذه الجلسة';

  @override
  String get alternativeExercise => 'تمرين بديل';

  @override
  String get replace => 'استبدال';

  @override
  String get painNoted =>
      'تم تسجيل الألم لهذه الجلسة (ليس نصيحة طبية). يمكنك المتابعة.';

  @override
  String restTimer(int seconds) {
    return 'راحة $seconds ث';
  }

  @override
  String pausedTimer(int seconds) {
    return 'متوقف $seconds ث';
  }

  @override
  String get pause => 'إيقاف مؤقت';

  @override
  String get add30s => '+30 ث';

  @override
  String get reset => 'إعادة';

  @override
  String get noSetsYet => 'لا توجد مجموعات بعد';

  @override
  String workingSetHash(int number) {
    return 'عمل · #$number';
  }

  @override
  String targetSetsReps(int sets, int minReps, int maxReps) {
    return 'الهدف $sets × $minReps-$maxReps';
  }

  @override
  String suggestedWeight(String weight) {
    return 'المقترح: $weight كجم';
  }

  @override
  String substitutedFrom(String name) {
    return 'بديل عن $name';
  }

  @override
  String recentPr(String value) {
    return 'رقم قياسي حديث: $value';
  }

  @override
  String readinessWithScore(Object score, Object label) {
    return 'الجاهزية: $score ($label)';
  }

  @override
  String exercisesCount(int count) {
    return '$count تمارين';
  }

  @override
  String daySessionMeta(String dayLabel, Object exercises, Object minutes) {
    return '$dayLabel · $exercises تمارين · ~$minutes د';
  }

  @override
  String get labelDaysWeekShort => 'أيام / أسبوع';

  @override
  String bestProgressLine(Object weight, Object e1rm, String trend) {
    return 'أفضل $weight كجم · e1RM $e1rm · $trend';
  }

  @override
  String durationValue(Object value) {
    return 'المدة: $value';
  }

  @override
  String workingSetsValue(Object count) {
    return 'مجموعات العمل: $count';
  }

  @override
  String exercisesValue(Object count) {
    return 'التمارين: $count';
  }

  @override
  String volumeValue(Object value) {
    return 'الحجم: $value كجم';
  }

  @override
  String whyReason(String reason) {
    return 'لماذا: $reason';
  }
}
