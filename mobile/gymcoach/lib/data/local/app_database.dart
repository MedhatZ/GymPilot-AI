import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

class WorkoutSessions extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get programDayId => text().nullable()();
  TextColumn get programName => text().nullable()();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get difficulty => integer().nullable()();
  BoolColumn get painReported => boolean().withDefault(const Constant(false))();
  TextColumn get readinessJson => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class WorkoutExercises extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId =>
      text().references(WorkoutSessions, #id, onDelete: KeyAction.cascade)();
  TextColumn get serverExerciseId => text().nullable()();
  TextColumn get exerciseName => text()();
  IntColumn get position => integer()();
  IntColumn get targetSets => integer().withDefault(const Constant(3))();
  IntColumn get minReps => integer().withDefault(const Constant(6))();
  IntColumn get maxReps => integer().withDefault(const Constant(8))();
  RealColumn get suggestedWeight => real().nullable()();
  IntColumn get restSeconds => integer().withDefault(const Constant(90))();
  RealColumn get loadIncrement => real().withDefault(const Constant(2.5))();
  TextColumn get previousPerformanceJson => text().nullable()();
  TextColumn get substitutedFromName => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class WorkoutSets extends Table {
  TextColumn get id => text()();
  TextColumn get exerciseId =>
      text().references(WorkoutExercises, #id, onDelete: KeyAction.cascade)();
  IntColumn get setNumber => integer().withDefault(const Constant(1))();
  RealColumn get weight => real()();
  IntColumn get reps => integer()();
  IntColumn get rir => integer().nullable()();
  BoolColumn get isWarmup => boolean().withDefault(const Constant(false))();
  TextColumn get note => text().nullable()();
  DateTimeColumn get loggedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class SyncOperations extends Table {
  TextColumn get id => text()();
  TextColumn get entityType => text()();
  TextColumn get entityId => text()();
  TextColumn get operation => text()();
  TextColumn get payload => text()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DriftDatabase(
  tables: [WorkoutSessions, WorkoutExercises, WorkoutSets, SyncOperations],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());
  AppDatabase.forTesting(super.executor);

  static QueryExecutor _openConnection() => driftDatabase(name: 'gymcoach_v2');

  @override
  int get schemaVersion => 2;

  Future<void> createSession(WorkoutSessionsCompanion session) =>
      into(workoutSessions).insert(session, mode: InsertMode.insertOrReplace);

  Future<void> createExercise(WorkoutExercisesCompanion exercise) =>
      into(workoutExercises).insert(exercise, mode: InsertMode.insertOrReplace);

  Future<void> saveSetOffline({
    required WorkoutSetsCompanion workoutSet,
    required SyncOperationsCompanion syncOperation,
  }) =>
      transaction(() async {
        await into(workoutSets).insert(workoutSet, mode: InsertMode.insertOrReplace);
        await into(syncOperations).insert(syncOperation);
      });

  Future<void> updateSet(WorkoutSetsCompanion set) =>
      (update(workoutSets)..where((t) => t.id.equals(set.id.value))).write(set);

  Future<void> deleteSet(String setId) =>
      (delete(workoutSets)..where((t) => t.id.equals(setId))).go();

  Future<WorkoutSession?> getActiveSession() {
    return (select(workoutSessions)
          ..where((s) => s.completedAt.isNull())
          ..orderBy([(s) => OrderingTerm.desc(s.startedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<List<WorkoutExercise>> exercisesForSession(String sessionId) {
    return (select(workoutExercises)
          ..where((e) => e.sessionId.equals(sessionId))
          ..orderBy([(e) => OrderingTerm.asc(e.position)]))
        .get();
  }

  Future<void> completeSession({
    required String sessionId,
    required int difficulty,
    required bool painReported,
  }) {
    return (update(workoutSessions)..where((s) => s.id.equals(sessionId))).write(
      WorkoutSessionsCompanion(
        completedAt: Value(DateTime.now().toUtc()),
        difficulty: Value(difficulty),
        painReported: Value(painReported),
      ),
    );
  }

  Stream<List<WorkoutSet>> watchSets(String exerciseId) {
    return (select(workoutSets)
          ..where((set) => set.exerciseId.equals(exerciseId))
          ..orderBy([(set) => OrderingTerm.asc(set.setNumber), (set) => OrderingTerm.asc(set.loggedAt)]))
        .watch();
  }

  Future<List<WorkoutSet>> setsForExercise(String exerciseId) {
    return (select(workoutSets)
          ..where((set) => set.exerciseId.equals(exerciseId))
          ..orderBy([(set) => OrderingTerm.asc(set.setNumber)]))
        .get();
  }
}
