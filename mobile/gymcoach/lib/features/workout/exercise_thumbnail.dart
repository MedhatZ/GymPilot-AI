import 'package:flutter/material.dart';

import '../../training/exercise_catalog.dart';

/// Small form thumbnail resolved from the built-in exercise catalog.
class ExerciseThumbnail extends StatelessWidget {
  const ExerciseThumbnail({
    super.key,
    this.catalogExerciseId,
    this.exerciseName,
    this.size = 40,
    this.borderRadius = 8,
  });

  final String? catalogExerciseId;
  final String? exerciseName;
  final double size;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final asset = ExerciseCatalog.imageAssetFor(
      catalogExerciseId: catalogExerciseId,
      exerciseName: exerciseName,
    );
    final scheme = Theme.of(context).colorScheme;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: SizedBox(
        width: size,
        height: size,
        child: asset == null
            ? ColoredBox(
                color: scheme.surfaceContainerHighest,
                child: Icon(Icons.fitness_center, size: size * 0.45, color: scheme.onSurfaceVariant),
              )
            : Image.asset(
                asset,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => ColoredBox(
                  color: scheme.surfaceContainerHighest,
                  child: Icon(Icons.fitness_center, size: size * 0.45, color: scheme.onSurfaceVariant),
                ),
              ),
      ),
    );
  }
}
