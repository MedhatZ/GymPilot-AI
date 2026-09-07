/// Built-in exercise catalog for on-device program generation.
class CatalogExercise {
  const CatalogExercise({
    required this.id,
    required this.name,
    required this.pattern,
    required this.isCompound,
    this.loadIncrementKg = 2.5,
    this.imageAsset,
  });

  final String id;
  final String name;
  final String pattern;
  final bool isCompound;
  final double loadIncrementKg;

  /// Optional thumbnail under `assets/exercises/`.
  final String? imageAsset;

  String get resolvedImageAsset => imageAsset ?? 'assets/exercises/$id.png';
}

class ExerciseCatalog {
  static const all = <CatalogExercise>[
    CatalogExercise(id: 'ex-squat', name: 'Back Squat', pattern: 'Squat', isCompound: true),
    CatalogExercise(id: 'ex-goblet', name: 'Goblet Squat', pattern: 'Squat', isCompound: true),
    CatalogExercise(id: 'ex-rdl', name: 'Romanian Deadlift', pattern: 'Hinge', isCompound: true),
    CatalogExercise(id: 'ex-dl', name: 'Conventional Deadlift', pattern: 'Hinge', isCompound: true),
    CatalogExercise(id: 'ex-bench', name: 'Bench Press', pattern: 'HorizontalPush', isCompound: true),
    CatalogExercise(id: 'ex-dbpress', name: 'Dumbbell Bench Press', pattern: 'HorizontalPush', isCompound: true),
    CatalogExercise(id: 'ex-row', name: 'Barbell Row', pattern: 'HorizontalPull', isCompound: true),
    CatalogExercise(id: 'ex-cablerow', name: 'Seated Cable Row', pattern: 'HorizontalPull', isCompound: true),
    CatalogExercise(id: 'ex-ohp', name: 'Overhead Press', pattern: 'VerticalPush', isCompound: true),
    CatalogExercise(id: 'ex-lat', name: 'Lat Pulldown', pattern: 'VerticalPull', isCompound: true),
    CatalogExercise(id: 'ex-pullup', name: 'Pull-Up', pattern: 'VerticalPull', isCompound: true),
    CatalogExercise(id: 'ex-lunge', name: 'Walking Lunge', pattern: 'Lunge', isCompound: true),
    CatalogExercise(id: 'ex-legpress', name: 'Leg Press', pattern: 'Squat', isCompound: true),
    CatalogExercise(id: 'ex-curl', name: 'Dumbbell Curl', pattern: 'Isolation', isCompound: false, loadIncrementKg: 1.25),
    CatalogExercise(id: 'ex-triceps', name: 'Triceps Pushdown', pattern: 'Isolation', isCompound: false, loadIncrementKg: 1.25),
    CatalogExercise(id: 'ex-plank', name: 'Plank', pattern: 'Core', isCompound: false, loadIncrementKg: 0),
    CatalogExercise(id: 'ex-crunch', name: 'Cable Crunch', pattern: 'Core', isCompound: false, loadIncrementKg: 1.25),
    CatalogExercise(id: 'ex-fly', name: 'Dumbbell Fly', pattern: 'HorizontalPush', isCompound: false, loadIncrementKg: 1.25),
    CatalogExercise(id: 'ex-lateral', name: 'Lateral Raise', pattern: 'VerticalPush', isCompound: false, loadIncrementKg: 1.25),
    CatalogExercise(id: 'ex-facepull', name: 'Face Pull', pattern: 'HorizontalPull', isCompound: false, loadIncrementKg: 1.25),
  ];

  static CatalogExercise? byId(String id) {
    for (final e in all) {
      if (e.id == id) return e;
    }
    return null;
  }

  static CatalogExercise? byNameContains(String needle) {
    final n = needle.toLowerCase();
    for (final e in all) {
      if (e.name.toLowerCase().contains(n)) return e;
    }
    return null;
  }

  static String? imageAssetFor({String? catalogExerciseId, String? exerciseName}) {
    if (catalogExerciseId != null && catalogExerciseId.isNotEmpty) {
      final byId = ExerciseCatalog.byId(catalogExerciseId);
      if (byId != null) return byId.resolvedImageAsset;
    }
    if (exerciseName != null && exerciseName.trim().isNotEmpty) {
      final needle = exerciseName.trim().toLowerCase();
      for (final e in all) {
        if (e.name.toLowerCase() == needle) return e.resolvedImageAsset;
      }
      for (final e in all) {
        if (needle.contains(e.name.toLowerCase()) || e.name.toLowerCase().contains(needle)) {
          return e.resolvedImageAsset;
        }
      }
    }
    return null;
  }
}
