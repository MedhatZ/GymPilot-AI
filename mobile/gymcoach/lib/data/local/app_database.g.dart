// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WorkoutSessionsTable extends WorkoutSessions
    with TableInfo<$WorkoutSessionsTable, WorkoutSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _programDayIdMeta = const VerificationMeta(
    'programDayId',
  );
  @override
  late final GeneratedColumn<String> programDayId = GeneratedColumn<String>(
    'program_day_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _programNameMeta = const VerificationMeta(
    'programName',
  );
  @override
  late final GeneratedColumn<String> programName = GeneratedColumn<String>(
    'program_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _completedAtMeta = const VerificationMeta(
    'completedAt',
  );
  @override
  late final GeneratedColumn<DateTime> completedAt = GeneratedColumn<DateTime>(
    'completed_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<int> difficulty = GeneratedColumn<int>(
    'difficulty',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _painReportedMeta = const VerificationMeta(
    'painReported',
  );
  @override
  late final GeneratedColumn<bool> painReported = GeneratedColumn<bool>(
    'pain_reported',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("pain_reported" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _readinessJsonMeta = const VerificationMeta(
    'readinessJson',
  );
  @override
  late final GeneratedColumn<String> readinessJson = GeneratedColumn<String>(
    'readiness_json',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    programDayId,
    programName,
    startedAt,
    completedAt,
    difficulty,
    painReported,
    readinessJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('program_day_id')) {
      context.handle(
        _programDayIdMeta,
        programDayId.isAcceptableOrUnknown(
          data['program_day_id']!,
          _programDayIdMeta,
        ),
      );
    }
    if (data.containsKey('program_name')) {
      context.handle(
        _programNameMeta,
        programName.isAcceptableOrUnknown(
          data['program_name']!,
          _programNameMeta,
        ),
      );
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('completed_at')) {
      context.handle(
        _completedAtMeta,
        completedAt.isAcceptableOrUnknown(
          data['completed_at']!,
          _completedAtMeta,
        ),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('pain_reported')) {
      context.handle(
        _painReportedMeta,
        painReported.isAcceptableOrUnknown(
          data['pain_reported']!,
          _painReportedMeta,
        ),
      );
    }
    if (data.containsKey('readiness_json')) {
      context.handle(
        _readinessJsonMeta,
        readinessJson.isAcceptableOrUnknown(
          data['readiness_json']!,
          _readinessJsonMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      programDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program_day_id'],
      ),
      programName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program_name'],
      ),
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      completedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}completed_at'],
      ),
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}difficulty'],
      ),
      painReported: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}pain_reported'],
      )!,
      readinessJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}readiness_json'],
      ),
    );
  }

  @override
  $WorkoutSessionsTable createAlias(String alias) {
    return $WorkoutSessionsTable(attachedDatabase, alias);
  }
}

class WorkoutSession extends DataClass implements Insertable<WorkoutSession> {
  final String id;
  final String name;
  final String? programDayId;
  final String? programName;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int? difficulty;
  final bool painReported;
  final String? readinessJson;
  const WorkoutSession({
    required this.id,
    required this.name,
    this.programDayId,
    this.programName,
    required this.startedAt,
    this.completedAt,
    this.difficulty,
    required this.painReported,
    this.readinessJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || programDayId != null) {
      map['program_day_id'] = Variable<String>(programDayId);
    }
    if (!nullToAbsent || programName != null) {
      map['program_name'] = Variable<String>(programName);
    }
    map['started_at'] = Variable<DateTime>(startedAt);
    if (!nullToAbsent || completedAt != null) {
      map['completed_at'] = Variable<DateTime>(completedAt);
    }
    if (!nullToAbsent || difficulty != null) {
      map['difficulty'] = Variable<int>(difficulty);
    }
    map['pain_reported'] = Variable<bool>(painReported);
    if (!nullToAbsent || readinessJson != null) {
      map['readiness_json'] = Variable<String>(readinessJson);
    }
    return map;
  }

  WorkoutSessionsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSessionsCompanion(
      id: Value(id),
      name: Value(name),
      programDayId: programDayId == null && nullToAbsent
          ? const Value.absent()
          : Value(programDayId),
      programName: programName == null && nullToAbsent
          ? const Value.absent()
          : Value(programName),
      startedAt: Value(startedAt),
      completedAt: completedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(completedAt),
      difficulty: difficulty == null && nullToAbsent
          ? const Value.absent()
          : Value(difficulty),
      painReported: Value(painReported),
      readinessJson: readinessJson == null && nullToAbsent
          ? const Value.absent()
          : Value(readinessJson),
    );
  }

  factory WorkoutSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSession(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      programDayId: serializer.fromJson<String?>(json['programDayId']),
      programName: serializer.fromJson<String?>(json['programName']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      completedAt: serializer.fromJson<DateTime?>(json['completedAt']),
      difficulty: serializer.fromJson<int?>(json['difficulty']),
      painReported: serializer.fromJson<bool>(json['painReported']),
      readinessJson: serializer.fromJson<String?>(json['readinessJson']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'programDayId': serializer.toJson<String?>(programDayId),
      'programName': serializer.toJson<String?>(programName),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'completedAt': serializer.toJson<DateTime?>(completedAt),
      'difficulty': serializer.toJson<int?>(difficulty),
      'painReported': serializer.toJson<bool>(painReported),
      'readinessJson': serializer.toJson<String?>(readinessJson),
    };
  }

  WorkoutSession copyWith({
    String? id,
    String? name,
    Value<String?> programDayId = const Value.absent(),
    Value<String?> programName = const Value.absent(),
    DateTime? startedAt,
    Value<DateTime?> completedAt = const Value.absent(),
    Value<int?> difficulty = const Value.absent(),
    bool? painReported,
    Value<String?> readinessJson = const Value.absent(),
  }) => WorkoutSession(
    id: id ?? this.id,
    name: name ?? this.name,
    programDayId: programDayId.present ? programDayId.value : this.programDayId,
    programName: programName.present ? programName.value : this.programName,
    startedAt: startedAt ?? this.startedAt,
    completedAt: completedAt.present ? completedAt.value : this.completedAt,
    difficulty: difficulty.present ? difficulty.value : this.difficulty,
    painReported: painReported ?? this.painReported,
    readinessJson: readinessJson.present
        ? readinessJson.value
        : this.readinessJson,
  );
  WorkoutSession copyWithCompanion(WorkoutSessionsCompanion data) {
    return WorkoutSession(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      programDayId: data.programDayId.present
          ? data.programDayId.value
          : this.programDayId,
      programName: data.programName.present
          ? data.programName.value
          : this.programName,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      completedAt: data.completedAt.present
          ? data.completedAt.value
          : this.completedAt,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      painReported: data.painReported.present
          ? data.painReported.value
          : this.painReported,
      readinessJson: data.readinessJson.present
          ? data.readinessJson.value
          : this.readinessJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSession(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('programDayId: $programDayId, ')
          ..write('programName: $programName, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('difficulty: $difficulty, ')
          ..write('painReported: $painReported, ')
          ..write('readinessJson: $readinessJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    programDayId,
    programName,
    startedAt,
    completedAt,
    difficulty,
    painReported,
    readinessJson,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSession &&
          other.id == this.id &&
          other.name == this.name &&
          other.programDayId == this.programDayId &&
          other.programName == this.programName &&
          other.startedAt == this.startedAt &&
          other.completedAt == this.completedAt &&
          other.difficulty == this.difficulty &&
          other.painReported == this.painReported &&
          other.readinessJson == this.readinessJson);
}

class WorkoutSessionsCompanion extends UpdateCompanion<WorkoutSession> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> programDayId;
  final Value<String?> programName;
  final Value<DateTime> startedAt;
  final Value<DateTime?> completedAt;
  final Value<int?> difficulty;
  final Value<bool> painReported;
  final Value<String?> readinessJson;
  final Value<int> rowid;
  const WorkoutSessionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.programDayId = const Value.absent(),
    this.programName = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.completedAt = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.painReported = const Value.absent(),
    this.readinessJson = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSessionsCompanion.insert({
    required String id,
    required String name,
    this.programDayId = const Value.absent(),
    this.programName = const Value.absent(),
    required DateTime startedAt,
    this.completedAt = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.painReported = const Value.absent(),
    this.readinessJson = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       startedAt = Value(startedAt);
  static Insertable<WorkoutSession> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? programDayId,
    Expression<String>? programName,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? completedAt,
    Expression<int>? difficulty,
    Expression<bool>? painReported,
    Expression<String>? readinessJson,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (programDayId != null) 'program_day_id': programDayId,
      if (programName != null) 'program_name': programName,
      if (startedAt != null) 'started_at': startedAt,
      if (completedAt != null) 'completed_at': completedAt,
      if (difficulty != null) 'difficulty': difficulty,
      if (painReported != null) 'pain_reported': painReported,
      if (readinessJson != null) 'readiness_json': readinessJson,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? programDayId,
    Value<String?>? programName,
    Value<DateTime>? startedAt,
    Value<DateTime?>? completedAt,
    Value<int?>? difficulty,
    Value<bool>? painReported,
    Value<String?>? readinessJson,
    Value<int>? rowid,
  }) {
    return WorkoutSessionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      programDayId: programDayId ?? this.programDayId,
      programName: programName ?? this.programName,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      difficulty: difficulty ?? this.difficulty,
      painReported: painReported ?? this.painReported,
      readinessJson: readinessJson ?? this.readinessJson,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (programDayId.present) {
      map['program_day_id'] = Variable<String>(programDayId.value);
    }
    if (programName.present) {
      map['program_name'] = Variable<String>(programName.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (completedAt.present) {
      map['completed_at'] = Variable<DateTime>(completedAt.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<int>(difficulty.value);
    }
    if (painReported.present) {
      map['pain_reported'] = Variable<bool>(painReported.value);
    }
    if (readinessJson.present) {
      map['readiness_json'] = Variable<String>(readinessJson.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSessionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('programDayId: $programDayId, ')
          ..write('programName: $programName, ')
          ..write('startedAt: $startedAt, ')
          ..write('completedAt: $completedAt, ')
          ..write('difficulty: $difficulty, ')
          ..write('painReported: $painReported, ')
          ..write('readinessJson: $readinessJson, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutExercisesTable extends WorkoutExercises
    with TableInfo<$WorkoutExercisesTable, WorkoutExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverExerciseIdMeta = const VerificationMeta(
    'serverExerciseId',
  );
  @override
  late final GeneratedColumn<String> serverExerciseId = GeneratedColumn<String>(
    'server_exercise_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _exerciseNameMeta = const VerificationMeta(
    'exerciseName',
  );
  @override
  late final GeneratedColumn<String> exerciseName = GeneratedColumn<String>(
    'exercise_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetSetsMeta = const VerificationMeta(
    'targetSets',
  );
  @override
  late final GeneratedColumn<int> targetSets = GeneratedColumn<int>(
    'target_sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _minRepsMeta = const VerificationMeta(
    'minReps',
  );
  @override
  late final GeneratedColumn<int> minReps = GeneratedColumn<int>(
    'min_reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(6),
  );
  static const VerificationMeta _maxRepsMeta = const VerificationMeta(
    'maxReps',
  );
  @override
  late final GeneratedColumn<int> maxReps = GeneratedColumn<int>(
    'max_reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(8),
  );
  static const VerificationMeta _suggestedWeightMeta = const VerificationMeta(
    'suggestedWeight',
  );
  @override
  late final GeneratedColumn<double> suggestedWeight = GeneratedColumn<double>(
    'suggested_weight',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restSecondsMeta = const VerificationMeta(
    'restSeconds',
  );
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
    'rest_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(90),
  );
  static const VerificationMeta _loadIncrementMeta = const VerificationMeta(
    'loadIncrement',
  );
  @override
  late final GeneratedColumn<double> loadIncrement = GeneratedColumn<double>(
    'load_increment',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.5),
  );
  static const VerificationMeta _previousPerformanceJsonMeta =
      const VerificationMeta('previousPerformanceJson');
  @override
  late final GeneratedColumn<String> previousPerformanceJson =
      GeneratedColumn<String>(
        'previous_performance_json',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _substitutedFromNameMeta =
      const VerificationMeta('substitutedFromName');
  @override
  late final GeneratedColumn<String> substitutedFromName =
      GeneratedColumn<String>(
        'substituted_from_name',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    serverExerciseId,
    exerciseName,
    position,
    targetSets,
    minReps,
    maxReps,
    suggestedWeight,
    restSeconds,
    loadIncrement,
    previousPerformanceJson,
    substitutedFromName,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('server_exercise_id')) {
      context.handle(
        _serverExerciseIdMeta,
        serverExerciseId.isAcceptableOrUnknown(
          data['server_exercise_id']!,
          _serverExerciseIdMeta,
        ),
      );
    }
    if (data.containsKey('exercise_name')) {
      context.handle(
        _exerciseNameMeta,
        exerciseName.isAcceptableOrUnknown(
          data['exercise_name']!,
          _exerciseNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseNameMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('target_sets')) {
      context.handle(
        _targetSetsMeta,
        targetSets.isAcceptableOrUnknown(data['target_sets']!, _targetSetsMeta),
      );
    }
    if (data.containsKey('min_reps')) {
      context.handle(
        _minRepsMeta,
        minReps.isAcceptableOrUnknown(data['min_reps']!, _minRepsMeta),
      );
    }
    if (data.containsKey('max_reps')) {
      context.handle(
        _maxRepsMeta,
        maxReps.isAcceptableOrUnknown(data['max_reps']!, _maxRepsMeta),
      );
    }
    if (data.containsKey('suggested_weight')) {
      context.handle(
        _suggestedWeightMeta,
        suggestedWeight.isAcceptableOrUnknown(
          data['suggested_weight']!,
          _suggestedWeightMeta,
        ),
      );
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
        _restSecondsMeta,
        restSeconds.isAcceptableOrUnknown(
          data['rest_seconds']!,
          _restSecondsMeta,
        ),
      );
    }
    if (data.containsKey('load_increment')) {
      context.handle(
        _loadIncrementMeta,
        loadIncrement.isAcceptableOrUnknown(
          data['load_increment']!,
          _loadIncrementMeta,
        ),
      );
    }
    if (data.containsKey('previous_performance_json')) {
      context.handle(
        _previousPerformanceJsonMeta,
        previousPerformanceJson.isAcceptableOrUnknown(
          data['previous_performance_json']!,
          _previousPerformanceJsonMeta,
        ),
      );
    }
    if (data.containsKey('substituted_from_name')) {
      context.handle(
        _substitutedFromNameMeta,
        substitutedFromName.isAcceptableOrUnknown(
          data['substituted_from_name']!,
          _substitutedFromNameMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      serverExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_exercise_id'],
      ),
      exerciseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_name'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      targetSets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_sets'],
      )!,
      minReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_reps'],
      )!,
      maxReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_reps'],
      )!,
      suggestedWeight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}suggested_weight'],
      ),
      restSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_seconds'],
      )!,
      loadIncrement: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}load_increment'],
      )!,
      previousPerformanceJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}previous_performance_json'],
      ),
      substitutedFromName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}substituted_from_name'],
      ),
    );
  }

  @override
  $WorkoutExercisesTable createAlias(String alias) {
    return $WorkoutExercisesTable(attachedDatabase, alias);
  }
}

class WorkoutExercise extends DataClass implements Insertable<WorkoutExercise> {
  final String id;
  final String sessionId;
  final String? serverExerciseId;
  final String exerciseName;
  final int position;
  final int targetSets;
  final int minReps;
  final int maxReps;
  final double? suggestedWeight;
  final int restSeconds;
  final double loadIncrement;
  final String? previousPerformanceJson;
  final String? substitutedFromName;
  const WorkoutExercise({
    required this.id,
    required this.sessionId,
    this.serverExerciseId,
    required this.exerciseName,
    required this.position,
    required this.targetSets,
    required this.minReps,
    required this.maxReps,
    this.suggestedWeight,
    required this.restSeconds,
    required this.loadIncrement,
    this.previousPerformanceJson,
    this.substitutedFromName,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    if (!nullToAbsent || serverExerciseId != null) {
      map['server_exercise_id'] = Variable<String>(serverExerciseId);
    }
    map['exercise_name'] = Variable<String>(exerciseName);
    map['position'] = Variable<int>(position);
    map['target_sets'] = Variable<int>(targetSets);
    map['min_reps'] = Variable<int>(minReps);
    map['max_reps'] = Variable<int>(maxReps);
    if (!nullToAbsent || suggestedWeight != null) {
      map['suggested_weight'] = Variable<double>(suggestedWeight);
    }
    map['rest_seconds'] = Variable<int>(restSeconds);
    map['load_increment'] = Variable<double>(loadIncrement);
    if (!nullToAbsent || previousPerformanceJson != null) {
      map['previous_performance_json'] = Variable<String>(
        previousPerformanceJson,
      );
    }
    if (!nullToAbsent || substitutedFromName != null) {
      map['substituted_from_name'] = Variable<String>(substitutedFromName);
    }
    return map;
  }

  WorkoutExercisesCompanion toCompanion(bool nullToAbsent) {
    return WorkoutExercisesCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      serverExerciseId: serverExerciseId == null && nullToAbsent
          ? const Value.absent()
          : Value(serverExerciseId),
      exerciseName: Value(exerciseName),
      position: Value(position),
      targetSets: Value(targetSets),
      minReps: Value(minReps),
      maxReps: Value(maxReps),
      suggestedWeight: suggestedWeight == null && nullToAbsent
          ? const Value.absent()
          : Value(suggestedWeight),
      restSeconds: Value(restSeconds),
      loadIncrement: Value(loadIncrement),
      previousPerformanceJson: previousPerformanceJson == null && nullToAbsent
          ? const Value.absent()
          : Value(previousPerformanceJson),
      substitutedFromName: substitutedFromName == null && nullToAbsent
          ? const Value.absent()
          : Value(substitutedFromName),
    );
  }

  factory WorkoutExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutExercise(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      serverExerciseId: serializer.fromJson<String?>(json['serverExerciseId']),
      exerciseName: serializer.fromJson<String>(json['exerciseName']),
      position: serializer.fromJson<int>(json['position']),
      targetSets: serializer.fromJson<int>(json['targetSets']),
      minReps: serializer.fromJson<int>(json['minReps']),
      maxReps: serializer.fromJson<int>(json['maxReps']),
      suggestedWeight: serializer.fromJson<double?>(json['suggestedWeight']),
      restSeconds: serializer.fromJson<int>(json['restSeconds']),
      loadIncrement: serializer.fromJson<double>(json['loadIncrement']),
      previousPerformanceJson: serializer.fromJson<String?>(
        json['previousPerformanceJson'],
      ),
      substitutedFromName: serializer.fromJson<String?>(
        json['substitutedFromName'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'serverExerciseId': serializer.toJson<String?>(serverExerciseId),
      'exerciseName': serializer.toJson<String>(exerciseName),
      'position': serializer.toJson<int>(position),
      'targetSets': serializer.toJson<int>(targetSets),
      'minReps': serializer.toJson<int>(minReps),
      'maxReps': serializer.toJson<int>(maxReps),
      'suggestedWeight': serializer.toJson<double?>(suggestedWeight),
      'restSeconds': serializer.toJson<int>(restSeconds),
      'loadIncrement': serializer.toJson<double>(loadIncrement),
      'previousPerformanceJson': serializer.toJson<String?>(
        previousPerformanceJson,
      ),
      'substitutedFromName': serializer.toJson<String?>(substitutedFromName),
    };
  }

  WorkoutExercise copyWith({
    String? id,
    String? sessionId,
    Value<String?> serverExerciseId = const Value.absent(),
    String? exerciseName,
    int? position,
    int? targetSets,
    int? minReps,
    int? maxReps,
    Value<double?> suggestedWeight = const Value.absent(),
    int? restSeconds,
    double? loadIncrement,
    Value<String?> previousPerformanceJson = const Value.absent(),
    Value<String?> substitutedFromName = const Value.absent(),
  }) => WorkoutExercise(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    serverExerciseId: serverExerciseId.present
        ? serverExerciseId.value
        : this.serverExerciseId,
    exerciseName: exerciseName ?? this.exerciseName,
    position: position ?? this.position,
    targetSets: targetSets ?? this.targetSets,
    minReps: minReps ?? this.minReps,
    maxReps: maxReps ?? this.maxReps,
    suggestedWeight: suggestedWeight.present
        ? suggestedWeight.value
        : this.suggestedWeight,
    restSeconds: restSeconds ?? this.restSeconds,
    loadIncrement: loadIncrement ?? this.loadIncrement,
    previousPerformanceJson: previousPerformanceJson.present
        ? previousPerformanceJson.value
        : this.previousPerformanceJson,
    substitutedFromName: substitutedFromName.present
        ? substitutedFromName.value
        : this.substitutedFromName,
  );
  WorkoutExercise copyWithCompanion(WorkoutExercisesCompanion data) {
    return WorkoutExercise(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      serverExerciseId: data.serverExerciseId.present
          ? data.serverExerciseId.value
          : this.serverExerciseId,
      exerciseName: data.exerciseName.present
          ? data.exerciseName.value
          : this.exerciseName,
      position: data.position.present ? data.position.value : this.position,
      targetSets: data.targetSets.present
          ? data.targetSets.value
          : this.targetSets,
      minReps: data.minReps.present ? data.minReps.value : this.minReps,
      maxReps: data.maxReps.present ? data.maxReps.value : this.maxReps,
      suggestedWeight: data.suggestedWeight.present
          ? data.suggestedWeight.value
          : this.suggestedWeight,
      restSeconds: data.restSeconds.present
          ? data.restSeconds.value
          : this.restSeconds,
      loadIncrement: data.loadIncrement.present
          ? data.loadIncrement.value
          : this.loadIncrement,
      previousPerformanceJson: data.previousPerformanceJson.present
          ? data.previousPerformanceJson.value
          : this.previousPerformanceJson,
      substitutedFromName: data.substitutedFromName.present
          ? data.substitutedFromName.value
          : this.substitutedFromName,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExercise(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('serverExerciseId: $serverExerciseId, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('position: $position, ')
          ..write('targetSets: $targetSets, ')
          ..write('minReps: $minReps, ')
          ..write('maxReps: $maxReps, ')
          ..write('suggestedWeight: $suggestedWeight, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('loadIncrement: $loadIncrement, ')
          ..write('previousPerformanceJson: $previousPerformanceJson, ')
          ..write('substitutedFromName: $substitutedFromName')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    sessionId,
    serverExerciseId,
    exerciseName,
    position,
    targetSets,
    minReps,
    maxReps,
    suggestedWeight,
    restSeconds,
    loadIncrement,
    previousPerformanceJson,
    substitutedFromName,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutExercise &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.serverExerciseId == this.serverExerciseId &&
          other.exerciseName == this.exerciseName &&
          other.position == this.position &&
          other.targetSets == this.targetSets &&
          other.minReps == this.minReps &&
          other.maxReps == this.maxReps &&
          other.suggestedWeight == this.suggestedWeight &&
          other.restSeconds == this.restSeconds &&
          other.loadIncrement == this.loadIncrement &&
          other.previousPerformanceJson == this.previousPerformanceJson &&
          other.substitutedFromName == this.substitutedFromName);
}

class WorkoutExercisesCompanion extends UpdateCompanion<WorkoutExercise> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<String?> serverExerciseId;
  final Value<String> exerciseName;
  final Value<int> position;
  final Value<int> targetSets;
  final Value<int> minReps;
  final Value<int> maxReps;
  final Value<double?> suggestedWeight;
  final Value<int> restSeconds;
  final Value<double> loadIncrement;
  final Value<String?> previousPerformanceJson;
  final Value<String?> substitutedFromName;
  final Value<int> rowid;
  const WorkoutExercisesCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.serverExerciseId = const Value.absent(),
    this.exerciseName = const Value.absent(),
    this.position = const Value.absent(),
    this.targetSets = const Value.absent(),
    this.minReps = const Value.absent(),
    this.maxReps = const Value.absent(),
    this.suggestedWeight = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.loadIncrement = const Value.absent(),
    this.previousPerformanceJson = const Value.absent(),
    this.substitutedFromName = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutExercisesCompanion.insert({
    required String id,
    required String sessionId,
    this.serverExerciseId = const Value.absent(),
    required String exerciseName,
    required int position,
    this.targetSets = const Value.absent(),
    this.minReps = const Value.absent(),
    this.maxReps = const Value.absent(),
    this.suggestedWeight = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.loadIncrement = const Value.absent(),
    this.previousPerformanceJson = const Value.absent(),
    this.substitutedFromName = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       exerciseName = Value(exerciseName),
       position = Value(position);
  static Insertable<WorkoutExercise> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<String>? serverExerciseId,
    Expression<String>? exerciseName,
    Expression<int>? position,
    Expression<int>? targetSets,
    Expression<int>? minReps,
    Expression<int>? maxReps,
    Expression<double>? suggestedWeight,
    Expression<int>? restSeconds,
    Expression<double>? loadIncrement,
    Expression<String>? previousPerformanceJson,
    Expression<String>? substitutedFromName,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (serverExerciseId != null) 'server_exercise_id': serverExerciseId,
      if (exerciseName != null) 'exercise_name': exerciseName,
      if (position != null) 'position': position,
      if (targetSets != null) 'target_sets': targetSets,
      if (minReps != null) 'min_reps': minReps,
      if (maxReps != null) 'max_reps': maxReps,
      if (suggestedWeight != null) 'suggested_weight': suggestedWeight,
      if (restSeconds != null) 'rest_seconds': restSeconds,
      if (loadIncrement != null) 'load_increment': loadIncrement,
      if (previousPerformanceJson != null)
        'previous_performance_json': previousPerformanceJson,
      if (substitutedFromName != null)
        'substituted_from_name': substitutedFromName,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<String?>? serverExerciseId,
    Value<String>? exerciseName,
    Value<int>? position,
    Value<int>? targetSets,
    Value<int>? minReps,
    Value<int>? maxReps,
    Value<double?>? suggestedWeight,
    Value<int>? restSeconds,
    Value<double>? loadIncrement,
    Value<String?>? previousPerformanceJson,
    Value<String?>? substitutedFromName,
    Value<int>? rowid,
  }) {
    return WorkoutExercisesCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      serverExerciseId: serverExerciseId ?? this.serverExerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      position: position ?? this.position,
      targetSets: targetSets ?? this.targetSets,
      minReps: minReps ?? this.minReps,
      maxReps: maxReps ?? this.maxReps,
      suggestedWeight: suggestedWeight ?? this.suggestedWeight,
      restSeconds: restSeconds ?? this.restSeconds,
      loadIncrement: loadIncrement ?? this.loadIncrement,
      previousPerformanceJson:
          previousPerformanceJson ?? this.previousPerformanceJson,
      substitutedFromName: substitutedFromName ?? this.substitutedFromName,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (serverExerciseId.present) {
      map['server_exercise_id'] = Variable<String>(serverExerciseId.value);
    }
    if (exerciseName.present) {
      map['exercise_name'] = Variable<String>(exerciseName.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (targetSets.present) {
      map['target_sets'] = Variable<int>(targetSets.value);
    }
    if (minReps.present) {
      map['min_reps'] = Variable<int>(minReps.value);
    }
    if (maxReps.present) {
      map['max_reps'] = Variable<int>(maxReps.value);
    }
    if (suggestedWeight.present) {
      map['suggested_weight'] = Variable<double>(suggestedWeight.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    if (loadIncrement.present) {
      map['load_increment'] = Variable<double>(loadIncrement.value);
    }
    if (previousPerformanceJson.present) {
      map['previous_performance_json'] = Variable<String>(
        previousPerformanceJson.value,
      );
    }
    if (substitutedFromName.present) {
      map['substituted_from_name'] = Variable<String>(
        substitutedFromName.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutExercisesCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('serverExerciseId: $serverExerciseId, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('position: $position, ')
          ..write('targetSets: $targetSets, ')
          ..write('minReps: $minReps, ')
          ..write('maxReps: $maxReps, ')
          ..write('suggestedWeight: $suggestedWeight, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('loadIncrement: $loadIncrement, ')
          ..write('previousPerformanceJson: $previousPerformanceJson, ')
          ..write('substitutedFromName: $substitutedFromName, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WorkoutSetsTable extends WorkoutSets
    with TableInfo<$WorkoutSetsTable, WorkoutSet> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WorkoutSetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseIdMeta = const VerificationMeta(
    'exerciseId',
  );
  @override
  late final GeneratedColumn<String> exerciseId = GeneratedColumn<String>(
    'exercise_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setNumberMeta = const VerificationMeta(
    'setNumber',
  );
  @override
  late final GeneratedColumn<int> setNumber = GeneratedColumn<int>(
    'set_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _weightMeta = const VerificationMeta('weight');
  @override
  late final GeneratedColumn<double> weight = GeneratedColumn<double>(
    'weight',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _rirMeta = const VerificationMeta('rir');
  @override
  late final GeneratedColumn<int> rir = GeneratedColumn<int>(
    'rir',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isWarmupMeta = const VerificationMeta(
    'isWarmup',
  );
  @override
  late final GeneratedColumn<bool> isWarmup = GeneratedColumn<bool>(
    'is_warmup',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_warmup" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _loggedAtMeta = const VerificationMeta(
    'loggedAt',
  );
  @override
  late final GeneratedColumn<DateTime> loggedAt = GeneratedColumn<DateTime>(
    'logged_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    exerciseId,
    setNumber,
    weight,
    reps,
    rir,
    isWarmup,
    note,
    loggedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'workout_sets';
  @override
  VerificationContext validateIntegrity(
    Insertable<WorkoutSet> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('exercise_id')) {
      context.handle(
        _exerciseIdMeta,
        exerciseId.isAcceptableOrUnknown(data['exercise_id']!, _exerciseIdMeta),
      );
    } else if (isInserting) {
      context.missing(_exerciseIdMeta);
    }
    if (data.containsKey('set_number')) {
      context.handle(
        _setNumberMeta,
        setNumber.isAcceptableOrUnknown(data['set_number']!, _setNumberMeta),
      );
    }
    if (data.containsKey('weight')) {
      context.handle(
        _weightMeta,
        weight.isAcceptableOrUnknown(data['weight']!, _weightMeta),
      );
    } else if (isInserting) {
      context.missing(_weightMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('rir')) {
      context.handle(
        _rirMeta,
        rir.isAcceptableOrUnknown(data['rir']!, _rirMeta),
      );
    }
    if (data.containsKey('is_warmup')) {
      context.handle(
        _isWarmupMeta,
        isWarmup.isAcceptableOrUnknown(data['is_warmup']!, _isWarmupMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('logged_at')) {
      context.handle(
        _loggedAtMeta,
        loggedAt.isAcceptableOrUnknown(data['logged_at']!, _loggedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_loggedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WorkoutSet map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WorkoutSet(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      exerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_id'],
      )!,
      setNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}set_number'],
      )!,
      weight: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      rir: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rir'],
      ),
      isWarmup: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_warmup'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      loggedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}logged_at'],
      )!,
    );
  }

  @override
  $WorkoutSetsTable createAlias(String alias) {
    return $WorkoutSetsTable(attachedDatabase, alias);
  }
}

class WorkoutSet extends DataClass implements Insertable<WorkoutSet> {
  final String id;
  final String exerciseId;
  final int setNumber;
  final double weight;
  final int reps;
  final int? rir;
  final bool isWarmup;
  final String? note;
  final DateTime loggedAt;
  const WorkoutSet({
    required this.id,
    required this.exerciseId,
    required this.setNumber,
    required this.weight,
    required this.reps,
    this.rir,
    required this.isWarmup,
    this.note,
    required this.loggedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['exercise_id'] = Variable<String>(exerciseId);
    map['set_number'] = Variable<int>(setNumber);
    map['weight'] = Variable<double>(weight);
    map['reps'] = Variable<int>(reps);
    if (!nullToAbsent || rir != null) {
      map['rir'] = Variable<int>(rir);
    }
    map['is_warmup'] = Variable<bool>(isWarmup);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['logged_at'] = Variable<DateTime>(loggedAt);
    return map;
  }

  WorkoutSetsCompanion toCompanion(bool nullToAbsent) {
    return WorkoutSetsCompanion(
      id: Value(id),
      exerciseId: Value(exerciseId),
      setNumber: Value(setNumber),
      weight: Value(weight),
      reps: Value(reps),
      rir: rir == null && nullToAbsent ? const Value.absent() : Value(rir),
      isWarmup: Value(isWarmup),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      loggedAt: Value(loggedAt),
    );
  }

  factory WorkoutSet.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WorkoutSet(
      id: serializer.fromJson<String>(json['id']),
      exerciseId: serializer.fromJson<String>(json['exerciseId']),
      setNumber: serializer.fromJson<int>(json['setNumber']),
      weight: serializer.fromJson<double>(json['weight']),
      reps: serializer.fromJson<int>(json['reps']),
      rir: serializer.fromJson<int?>(json['rir']),
      isWarmup: serializer.fromJson<bool>(json['isWarmup']),
      note: serializer.fromJson<String?>(json['note']),
      loggedAt: serializer.fromJson<DateTime>(json['loggedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'exerciseId': serializer.toJson<String>(exerciseId),
      'setNumber': serializer.toJson<int>(setNumber),
      'weight': serializer.toJson<double>(weight),
      'reps': serializer.toJson<int>(reps),
      'rir': serializer.toJson<int?>(rir),
      'isWarmup': serializer.toJson<bool>(isWarmup),
      'note': serializer.toJson<String?>(note),
      'loggedAt': serializer.toJson<DateTime>(loggedAt),
    };
  }

  WorkoutSet copyWith({
    String? id,
    String? exerciseId,
    int? setNumber,
    double? weight,
    int? reps,
    Value<int?> rir = const Value.absent(),
    bool? isWarmup,
    Value<String?> note = const Value.absent(),
    DateTime? loggedAt,
  }) => WorkoutSet(
    id: id ?? this.id,
    exerciseId: exerciseId ?? this.exerciseId,
    setNumber: setNumber ?? this.setNumber,
    weight: weight ?? this.weight,
    reps: reps ?? this.reps,
    rir: rir.present ? rir.value : this.rir,
    isWarmup: isWarmup ?? this.isWarmup,
    note: note.present ? note.value : this.note,
    loggedAt: loggedAt ?? this.loggedAt,
  );
  WorkoutSet copyWithCompanion(WorkoutSetsCompanion data) {
    return WorkoutSet(
      id: data.id.present ? data.id.value : this.id,
      exerciseId: data.exerciseId.present
          ? data.exerciseId.value
          : this.exerciseId,
      setNumber: data.setNumber.present ? data.setNumber.value : this.setNumber,
      weight: data.weight.present ? data.weight.value : this.weight,
      reps: data.reps.present ? data.reps.value : this.reps,
      rir: data.rir.present ? data.rir.value : this.rir,
      isWarmup: data.isWarmup.present ? data.isWarmup.value : this.isWarmup,
      note: data.note.present ? data.note.value : this.note,
      loggedAt: data.loggedAt.present ? data.loggedAt.value : this.loggedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSet(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps, ')
          ..write('rir: $rir, ')
          ..write('isWarmup: $isWarmup, ')
          ..write('note: $note, ')
          ..write('loggedAt: $loggedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    exerciseId,
    setNumber,
    weight,
    reps,
    rir,
    isWarmup,
    note,
    loggedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WorkoutSet &&
          other.id == this.id &&
          other.exerciseId == this.exerciseId &&
          other.setNumber == this.setNumber &&
          other.weight == this.weight &&
          other.reps == this.reps &&
          other.rir == this.rir &&
          other.isWarmup == this.isWarmup &&
          other.note == this.note &&
          other.loggedAt == this.loggedAt);
}

class WorkoutSetsCompanion extends UpdateCompanion<WorkoutSet> {
  final Value<String> id;
  final Value<String> exerciseId;
  final Value<int> setNumber;
  final Value<double> weight;
  final Value<int> reps;
  final Value<int?> rir;
  final Value<bool> isWarmup;
  final Value<String?> note;
  final Value<DateTime> loggedAt;
  final Value<int> rowid;
  const WorkoutSetsCompanion({
    this.id = const Value.absent(),
    this.exerciseId = const Value.absent(),
    this.setNumber = const Value.absent(),
    this.weight = const Value.absent(),
    this.reps = const Value.absent(),
    this.rir = const Value.absent(),
    this.isWarmup = const Value.absent(),
    this.note = const Value.absent(),
    this.loggedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WorkoutSetsCompanion.insert({
    required String id,
    required String exerciseId,
    this.setNumber = const Value.absent(),
    required double weight,
    required int reps,
    this.rir = const Value.absent(),
    this.isWarmup = const Value.absent(),
    this.note = const Value.absent(),
    required DateTime loggedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       exerciseId = Value(exerciseId),
       weight = Value(weight),
       reps = Value(reps),
       loggedAt = Value(loggedAt);
  static Insertable<WorkoutSet> custom({
    Expression<String>? id,
    Expression<String>? exerciseId,
    Expression<int>? setNumber,
    Expression<double>? weight,
    Expression<int>? reps,
    Expression<int>? rir,
    Expression<bool>? isWarmup,
    Expression<String>? note,
    Expression<DateTime>? loggedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseId != null) 'exercise_id': exerciseId,
      if (setNumber != null) 'set_number': setNumber,
      if (weight != null) 'weight': weight,
      if (reps != null) 'reps': reps,
      if (rir != null) 'rir': rir,
      if (isWarmup != null) 'is_warmup': isWarmup,
      if (note != null) 'note': note,
      if (loggedAt != null) 'logged_at': loggedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WorkoutSetsCompanion copyWith({
    Value<String>? id,
    Value<String>? exerciseId,
    Value<int>? setNumber,
    Value<double>? weight,
    Value<int>? reps,
    Value<int?>? rir,
    Value<bool>? isWarmup,
    Value<String?>? note,
    Value<DateTime>? loggedAt,
    Value<int>? rowid,
  }) {
    return WorkoutSetsCompanion(
      id: id ?? this.id,
      exerciseId: exerciseId ?? this.exerciseId,
      setNumber: setNumber ?? this.setNumber,
      weight: weight ?? this.weight,
      reps: reps ?? this.reps,
      rir: rir ?? this.rir,
      isWarmup: isWarmup ?? this.isWarmup,
      note: note ?? this.note,
      loggedAt: loggedAt ?? this.loggedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (exerciseId.present) {
      map['exercise_id'] = Variable<String>(exerciseId.value);
    }
    if (setNumber.present) {
      map['set_number'] = Variable<int>(setNumber.value);
    }
    if (weight.present) {
      map['weight'] = Variable<double>(weight.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (rir.present) {
      map['rir'] = Variable<int>(rir.value);
    }
    if (isWarmup.present) {
      map['is_warmup'] = Variable<bool>(isWarmup.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (loggedAt.present) {
      map['logged_at'] = Variable<DateTime>(loggedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WorkoutSetsCompanion(')
          ..write('id: $id, ')
          ..write('exerciseId: $exerciseId, ')
          ..write('setNumber: $setNumber, ')
          ..write('weight: $weight, ')
          ..write('reps: $reps, ')
          ..write('rir: $rir, ')
          ..write('isWarmup: $isWarmup, ')
          ..write('note: $note, ')
          ..write('loggedAt: $loggedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncOperationsTable extends SyncOperations
    with TableInfo<$SyncOperationsTable, SyncOperation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncOperationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _operationMeta = const VerificationMeta(
    'operation',
  );
  @override
  late final GeneratedColumn<String> operation = GeneratedColumn<String>(
    'operation',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    operation,
    payload,
    attempts,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_operations';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncOperation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('operation')) {
      context.handle(
        _operationMeta,
        operation.isAcceptableOrUnknown(data['operation']!, _operationMeta),
      );
    } else if (isInserting) {
      context.missing(_operationMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncOperation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncOperation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      operation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}operation'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $SyncOperationsTable createAlias(String alias) {
    return $SyncOperationsTable(attachedDatabase, alias);
  }
}

class SyncOperation extends DataClass implements Insertable<SyncOperation> {
  final String id;
  final String entityType;
  final String entityId;
  final String operation;
  final String payload;
  final int attempts;
  final DateTime createdAt;
  const SyncOperation({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.operation,
    required this.payload,
    required this.attempts,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['operation'] = Variable<String>(operation);
    map['payload'] = Variable<String>(payload);
    map['attempts'] = Variable<int>(attempts);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SyncOperationsCompanion toCompanion(bool nullToAbsent) {
    return SyncOperationsCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      operation: Value(operation),
      payload: Value(payload),
      attempts: Value(attempts),
      createdAt: Value(createdAt),
    );
  }

  factory SyncOperation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncOperation(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      operation: serializer.fromJson<String>(json['operation']),
      payload: serializer.fromJson<String>(json['payload']),
      attempts: serializer.fromJson<int>(json['attempts']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'operation': serializer.toJson<String>(operation),
      'payload': serializer.toJson<String>(payload),
      'attempts': serializer.toJson<int>(attempts),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  SyncOperation copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? operation,
    String? payload,
    int? attempts,
    DateTime? createdAt,
  }) => SyncOperation(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    operation: operation ?? this.operation,
    payload: payload ?? this.payload,
    attempts: attempts ?? this.attempts,
    createdAt: createdAt ?? this.createdAt,
  );
  SyncOperation copyWithCompanion(SyncOperationsCompanion data) {
    return SyncOperation(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      operation: data.operation.present ? data.operation.value : this.operation,
      payload: data.payload.present ? data.payload.value : this.payload,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncOperation(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('attempts: $attempts, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    operation,
    payload,
    attempts,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncOperation &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.operation == this.operation &&
          other.payload == this.payload &&
          other.attempts == this.attempts &&
          other.createdAt == this.createdAt);
}

class SyncOperationsCompanion extends UpdateCompanion<SyncOperation> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> operation;
  final Value<String> payload;
  final Value<int> attempts;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const SyncOperationsCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.operation = const Value.absent(),
    this.payload = const Value.absent(),
    this.attempts = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncOperationsCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String operation,
    required String payload,
    this.attempts = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       entityId = Value(entityId),
       operation = Value(operation),
       payload = Value(payload),
       createdAt = Value(createdAt);
  static Insertable<SyncOperation> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? operation,
    Expression<String>? payload,
    Expression<int>? attempts,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (operation != null) 'operation': operation,
      if (payload != null) 'payload': payload,
      if (attempts != null) 'attempts': attempts,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncOperationsCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? operation,
    Value<String>? payload,
    Value<int>? attempts,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return SyncOperationsCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      operation: operation ?? this.operation,
      payload: payload ?? this.payload,
      attempts: attempts ?? this.attempts,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (operation.present) {
      map['operation'] = Variable<String>(operation.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncOperationsCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('operation: $operation, ')
          ..write('payload: $payload, ')
          ..write('attempts: $attempts, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AthleteProfilesTable extends AthleteProfiles
    with TableInfo<$AthleteProfilesTable, AthleteProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AthleteProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<int> sex = GeneratedColumn<int>(
    'sex',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<double> heightCm = GeneratedColumn<double>(
    'height_cm',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyWeightKgMeta = const VerificationMeta(
    'bodyWeightKg',
  );
  @override
  late final GeneratedColumn<double> bodyWeightKg = GeneratedColumn<double>(
    'body_weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _experienceMeta = const VerificationMeta(
    'experience',
  );
  @override
  late final GeneratedColumn<int> experience = GeneratedColumn<int>(
    'experience',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _yearsTrainingMeta = const VerificationMeta(
    'yearsTraining',
  );
  @override
  late final GeneratedColumn<double> yearsTraining = GeneratedColumn<double>(
    'years_training',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _primaryGoalMeta = const VerificationMeta(
    'primaryGoal',
  );
  @override
  late final GeneratedColumn<int> primaryGoal = GeneratedColumn<int>(
    'primary_goal',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _secondaryGoalMeta = const VerificationMeta(
    'secondaryGoal',
  );
  @override
  late final GeneratedColumn<int> secondaryGoal = GeneratedColumn<int>(
    'secondary_goal',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _trainingDaysPerWeekMeta =
      const VerificationMeta('trainingDaysPerWeek');
  @override
  late final GeneratedColumn<int> trainingDaysPerWeek = GeneratedColumn<int>(
    'training_days_per_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(4),
  );
  static const VerificationMeta _preferredSessionMinutesMeta =
      const VerificationMeta('preferredSessionMinutes');
  @override
  late final GeneratedColumn<int> preferredSessionMinutes =
      GeneratedColumn<int>(
        'preferred_session_minutes',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(60),
      );
  static const VerificationMeta _equipmentSettingMeta = const VerificationMeta(
    'equipmentSetting',
  );
  @override
  late final GeneratedColumn<int> equipmentSetting = GeneratedColumn<int>(
    'equipment_setting',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _injuryNotesMeta = const VerificationMeta(
    'injuryNotes',
  );
  @override
  late final GeneratedColumn<String> injuryNotes = GeneratedColumn<String>(
    'injury_notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _baselineBenchKgMeta = const VerificationMeta(
    'baselineBenchKg',
  );
  @override
  late final GeneratedColumn<double> baselineBenchKg = GeneratedColumn<double>(
    'baseline_bench_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastCompletedProgramDayIdMeta =
      const VerificationMeta('lastCompletedProgramDayId');
  @override
  late final GeneratedColumn<String> lastCompletedProgramDayId =
      GeneratedColumn<String>(
        'last_completed_program_day_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    displayName,
    age,
    sex,
    heightCm,
    bodyWeightKg,
    experience,
    yearsTraining,
    primaryGoal,
    secondaryGoal,
    trainingDaysPerWeek,
    preferredSessionMinutes,
    equipmentSetting,
    injuryNotes,
    baselineBenchKg,
    onboardingCompleted,
    lastCompletedProgramDayId,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'athlete_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<AthleteProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    } else if (isInserting) {
      context.missing(_heightCmMeta);
    }
    if (data.containsKey('body_weight_kg')) {
      context.handle(
        _bodyWeightKgMeta,
        bodyWeightKg.isAcceptableOrUnknown(
          data['body_weight_kg']!,
          _bodyWeightKgMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_bodyWeightKgMeta);
    }
    if (data.containsKey('experience')) {
      context.handle(
        _experienceMeta,
        experience.isAcceptableOrUnknown(data['experience']!, _experienceMeta),
      );
    }
    if (data.containsKey('years_training')) {
      context.handle(
        _yearsTrainingMeta,
        yearsTraining.isAcceptableOrUnknown(
          data['years_training']!,
          _yearsTrainingMeta,
        ),
      );
    }
    if (data.containsKey('primary_goal')) {
      context.handle(
        _primaryGoalMeta,
        primaryGoal.isAcceptableOrUnknown(
          data['primary_goal']!,
          _primaryGoalMeta,
        ),
      );
    }
    if (data.containsKey('secondary_goal')) {
      context.handle(
        _secondaryGoalMeta,
        secondaryGoal.isAcceptableOrUnknown(
          data['secondary_goal']!,
          _secondaryGoalMeta,
        ),
      );
    }
    if (data.containsKey('training_days_per_week')) {
      context.handle(
        _trainingDaysPerWeekMeta,
        trainingDaysPerWeek.isAcceptableOrUnknown(
          data['training_days_per_week']!,
          _trainingDaysPerWeekMeta,
        ),
      );
    }
    if (data.containsKey('preferred_session_minutes')) {
      context.handle(
        _preferredSessionMinutesMeta,
        preferredSessionMinutes.isAcceptableOrUnknown(
          data['preferred_session_minutes']!,
          _preferredSessionMinutesMeta,
        ),
      );
    }
    if (data.containsKey('equipment_setting')) {
      context.handle(
        _equipmentSettingMeta,
        equipmentSetting.isAcceptableOrUnknown(
          data['equipment_setting']!,
          _equipmentSettingMeta,
        ),
      );
    }
    if (data.containsKey('injury_notes')) {
      context.handle(
        _injuryNotesMeta,
        injuryNotes.isAcceptableOrUnknown(
          data['injury_notes']!,
          _injuryNotesMeta,
        ),
      );
    }
    if (data.containsKey('baseline_bench_kg')) {
      context.handle(
        _baselineBenchKgMeta,
        baselineBenchKg.isAcceptableOrUnknown(
          data['baseline_bench_kg']!,
          _baselineBenchKgMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    }
    if (data.containsKey('last_completed_program_day_id')) {
      context.handle(
        _lastCompletedProgramDayIdMeta,
        lastCompletedProgramDayId.isAcceptableOrUnknown(
          data['last_completed_program_day_id']!,
          _lastCompletedProgramDayIdMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AthleteProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AthleteProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      )!,
      sex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sex'],
      )!,
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}height_cm'],
      )!,
      bodyWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}body_weight_kg'],
      )!,
      experience: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}experience'],
      )!,
      yearsTraining: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}years_training'],
      )!,
      primaryGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}primary_goal'],
      )!,
      secondaryGoal: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}secondary_goal'],
      ),
      trainingDaysPerWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}training_days_per_week'],
      )!,
      preferredSessionMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}preferred_session_minutes'],
      )!,
      equipmentSetting: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}equipment_setting'],
      )!,
      injuryNotes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}injury_notes'],
      ),
      baselineBenchKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}baseline_bench_kg'],
      ),
      onboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_completed'],
      )!,
      lastCompletedProgramDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_completed_program_day_id'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AthleteProfilesTable createAlias(String alias) {
    return $AthleteProfilesTable(attachedDatabase, alias);
  }
}

class AthleteProfile extends DataClass implements Insertable<AthleteProfile> {
  final String id;
  final String displayName;
  final int age;
  final int sex;
  final double heightCm;
  final double bodyWeightKg;
  final int experience;
  final double yearsTraining;
  final int primaryGoal;
  final int? secondaryGoal;
  final int trainingDaysPerWeek;
  final int preferredSessionMinutes;
  final int equipmentSetting;
  final String? injuryNotes;
  final double? baselineBenchKg;
  final bool onboardingCompleted;
  final String? lastCompletedProgramDayId;
  final DateTime updatedAt;
  const AthleteProfile({
    required this.id,
    required this.displayName,
    required this.age,
    required this.sex,
    required this.heightCm,
    required this.bodyWeightKg,
    required this.experience,
    required this.yearsTraining,
    required this.primaryGoal,
    this.secondaryGoal,
    required this.trainingDaysPerWeek,
    required this.preferredSessionMinutes,
    required this.equipmentSetting,
    this.injuryNotes,
    this.baselineBenchKg,
    required this.onboardingCompleted,
    this.lastCompletedProgramDayId,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['display_name'] = Variable<String>(displayName);
    map['age'] = Variable<int>(age);
    map['sex'] = Variable<int>(sex);
    map['height_cm'] = Variable<double>(heightCm);
    map['body_weight_kg'] = Variable<double>(bodyWeightKg);
    map['experience'] = Variable<int>(experience);
    map['years_training'] = Variable<double>(yearsTraining);
    map['primary_goal'] = Variable<int>(primaryGoal);
    if (!nullToAbsent || secondaryGoal != null) {
      map['secondary_goal'] = Variable<int>(secondaryGoal);
    }
    map['training_days_per_week'] = Variable<int>(trainingDaysPerWeek);
    map['preferred_session_minutes'] = Variable<int>(preferredSessionMinutes);
    map['equipment_setting'] = Variable<int>(equipmentSetting);
    if (!nullToAbsent || injuryNotes != null) {
      map['injury_notes'] = Variable<String>(injuryNotes);
    }
    if (!nullToAbsent || baselineBenchKg != null) {
      map['baseline_bench_kg'] = Variable<double>(baselineBenchKg);
    }
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    if (!nullToAbsent || lastCompletedProgramDayId != null) {
      map['last_completed_program_day_id'] = Variable<String>(
        lastCompletedProgramDayId,
      );
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AthleteProfilesCompanion toCompanion(bool nullToAbsent) {
    return AthleteProfilesCompanion(
      id: Value(id),
      displayName: Value(displayName),
      age: Value(age),
      sex: Value(sex),
      heightCm: Value(heightCm),
      bodyWeightKg: Value(bodyWeightKg),
      experience: Value(experience),
      yearsTraining: Value(yearsTraining),
      primaryGoal: Value(primaryGoal),
      secondaryGoal: secondaryGoal == null && nullToAbsent
          ? const Value.absent()
          : Value(secondaryGoal),
      trainingDaysPerWeek: Value(trainingDaysPerWeek),
      preferredSessionMinutes: Value(preferredSessionMinutes),
      equipmentSetting: Value(equipmentSetting),
      injuryNotes: injuryNotes == null && nullToAbsent
          ? const Value.absent()
          : Value(injuryNotes),
      baselineBenchKg: baselineBenchKg == null && nullToAbsent
          ? const Value.absent()
          : Value(baselineBenchKg),
      onboardingCompleted: Value(onboardingCompleted),
      lastCompletedProgramDayId:
          lastCompletedProgramDayId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastCompletedProgramDayId),
      updatedAt: Value(updatedAt),
    );
  }

  factory AthleteProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AthleteProfile(
      id: serializer.fromJson<String>(json['id']),
      displayName: serializer.fromJson<String>(json['displayName']),
      age: serializer.fromJson<int>(json['age']),
      sex: serializer.fromJson<int>(json['sex']),
      heightCm: serializer.fromJson<double>(json['heightCm']),
      bodyWeightKg: serializer.fromJson<double>(json['bodyWeightKg']),
      experience: serializer.fromJson<int>(json['experience']),
      yearsTraining: serializer.fromJson<double>(json['yearsTraining']),
      primaryGoal: serializer.fromJson<int>(json['primaryGoal']),
      secondaryGoal: serializer.fromJson<int?>(json['secondaryGoal']),
      trainingDaysPerWeek: serializer.fromJson<int>(
        json['trainingDaysPerWeek'],
      ),
      preferredSessionMinutes: serializer.fromJson<int>(
        json['preferredSessionMinutes'],
      ),
      equipmentSetting: serializer.fromJson<int>(json['equipmentSetting']),
      injuryNotes: serializer.fromJson<String?>(json['injuryNotes']),
      baselineBenchKg: serializer.fromJson<double?>(json['baselineBenchKg']),
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
      lastCompletedProgramDayId: serializer.fromJson<String?>(
        json['lastCompletedProgramDayId'],
      ),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'displayName': serializer.toJson<String>(displayName),
      'age': serializer.toJson<int>(age),
      'sex': serializer.toJson<int>(sex),
      'heightCm': serializer.toJson<double>(heightCm),
      'bodyWeightKg': serializer.toJson<double>(bodyWeightKg),
      'experience': serializer.toJson<int>(experience),
      'yearsTraining': serializer.toJson<double>(yearsTraining),
      'primaryGoal': serializer.toJson<int>(primaryGoal),
      'secondaryGoal': serializer.toJson<int?>(secondaryGoal),
      'trainingDaysPerWeek': serializer.toJson<int>(trainingDaysPerWeek),
      'preferredSessionMinutes': serializer.toJson<int>(
        preferredSessionMinutes,
      ),
      'equipmentSetting': serializer.toJson<int>(equipmentSetting),
      'injuryNotes': serializer.toJson<String?>(injuryNotes),
      'baselineBenchKg': serializer.toJson<double?>(baselineBenchKg),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
      'lastCompletedProgramDayId': serializer.toJson<String?>(
        lastCompletedProgramDayId,
      ),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AthleteProfile copyWith({
    String? id,
    String? displayName,
    int? age,
    int? sex,
    double? heightCm,
    double? bodyWeightKg,
    int? experience,
    double? yearsTraining,
    int? primaryGoal,
    Value<int?> secondaryGoal = const Value.absent(),
    int? trainingDaysPerWeek,
    int? preferredSessionMinutes,
    int? equipmentSetting,
    Value<String?> injuryNotes = const Value.absent(),
    Value<double?> baselineBenchKg = const Value.absent(),
    bool? onboardingCompleted,
    Value<String?> lastCompletedProgramDayId = const Value.absent(),
    DateTime? updatedAt,
  }) => AthleteProfile(
    id: id ?? this.id,
    displayName: displayName ?? this.displayName,
    age: age ?? this.age,
    sex: sex ?? this.sex,
    heightCm: heightCm ?? this.heightCm,
    bodyWeightKg: bodyWeightKg ?? this.bodyWeightKg,
    experience: experience ?? this.experience,
    yearsTraining: yearsTraining ?? this.yearsTraining,
    primaryGoal: primaryGoal ?? this.primaryGoal,
    secondaryGoal: secondaryGoal.present
        ? secondaryGoal.value
        : this.secondaryGoal,
    trainingDaysPerWeek: trainingDaysPerWeek ?? this.trainingDaysPerWeek,
    preferredSessionMinutes:
        preferredSessionMinutes ?? this.preferredSessionMinutes,
    equipmentSetting: equipmentSetting ?? this.equipmentSetting,
    injuryNotes: injuryNotes.present ? injuryNotes.value : this.injuryNotes,
    baselineBenchKg: baselineBenchKg.present
        ? baselineBenchKg.value
        : this.baselineBenchKg,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    lastCompletedProgramDayId: lastCompletedProgramDayId.present
        ? lastCompletedProgramDayId.value
        : this.lastCompletedProgramDayId,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AthleteProfile copyWithCompanion(AthleteProfilesCompanion data) {
    return AthleteProfile(
      id: data.id.present ? data.id.value : this.id,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      age: data.age.present ? data.age.value : this.age,
      sex: data.sex.present ? data.sex.value : this.sex,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      bodyWeightKg: data.bodyWeightKg.present
          ? data.bodyWeightKg.value
          : this.bodyWeightKg,
      experience: data.experience.present
          ? data.experience.value
          : this.experience,
      yearsTraining: data.yearsTraining.present
          ? data.yearsTraining.value
          : this.yearsTraining,
      primaryGoal: data.primaryGoal.present
          ? data.primaryGoal.value
          : this.primaryGoal,
      secondaryGoal: data.secondaryGoal.present
          ? data.secondaryGoal.value
          : this.secondaryGoal,
      trainingDaysPerWeek: data.trainingDaysPerWeek.present
          ? data.trainingDaysPerWeek.value
          : this.trainingDaysPerWeek,
      preferredSessionMinutes: data.preferredSessionMinutes.present
          ? data.preferredSessionMinutes.value
          : this.preferredSessionMinutes,
      equipmentSetting: data.equipmentSetting.present
          ? data.equipmentSetting.value
          : this.equipmentSetting,
      injuryNotes: data.injuryNotes.present
          ? data.injuryNotes.value
          : this.injuryNotes,
      baselineBenchKg: data.baselineBenchKg.present
          ? data.baselineBenchKg.value
          : this.baselineBenchKg,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
      lastCompletedProgramDayId: data.lastCompletedProgramDayId.present
          ? data.lastCompletedProgramDayId.value
          : this.lastCompletedProgramDayId,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AthleteProfile(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('age: $age, ')
          ..write('sex: $sex, ')
          ..write('heightCm: $heightCm, ')
          ..write('bodyWeightKg: $bodyWeightKg, ')
          ..write('experience: $experience, ')
          ..write('yearsTraining: $yearsTraining, ')
          ..write('primaryGoal: $primaryGoal, ')
          ..write('secondaryGoal: $secondaryGoal, ')
          ..write('trainingDaysPerWeek: $trainingDaysPerWeek, ')
          ..write('preferredSessionMinutes: $preferredSessionMinutes, ')
          ..write('equipmentSetting: $equipmentSetting, ')
          ..write('injuryNotes: $injuryNotes, ')
          ..write('baselineBenchKg: $baselineBenchKg, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('lastCompletedProgramDayId: $lastCompletedProgramDayId, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    displayName,
    age,
    sex,
    heightCm,
    bodyWeightKg,
    experience,
    yearsTraining,
    primaryGoal,
    secondaryGoal,
    trainingDaysPerWeek,
    preferredSessionMinutes,
    equipmentSetting,
    injuryNotes,
    baselineBenchKg,
    onboardingCompleted,
    lastCompletedProgramDayId,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AthleteProfile &&
          other.id == this.id &&
          other.displayName == this.displayName &&
          other.age == this.age &&
          other.sex == this.sex &&
          other.heightCm == this.heightCm &&
          other.bodyWeightKg == this.bodyWeightKg &&
          other.experience == this.experience &&
          other.yearsTraining == this.yearsTraining &&
          other.primaryGoal == this.primaryGoal &&
          other.secondaryGoal == this.secondaryGoal &&
          other.trainingDaysPerWeek == this.trainingDaysPerWeek &&
          other.preferredSessionMinutes == this.preferredSessionMinutes &&
          other.equipmentSetting == this.equipmentSetting &&
          other.injuryNotes == this.injuryNotes &&
          other.baselineBenchKg == this.baselineBenchKg &&
          other.onboardingCompleted == this.onboardingCompleted &&
          other.lastCompletedProgramDayId == this.lastCompletedProgramDayId &&
          other.updatedAt == this.updatedAt);
}

class AthleteProfilesCompanion extends UpdateCompanion<AthleteProfile> {
  final Value<String> id;
  final Value<String> displayName;
  final Value<int> age;
  final Value<int> sex;
  final Value<double> heightCm;
  final Value<double> bodyWeightKg;
  final Value<int> experience;
  final Value<double> yearsTraining;
  final Value<int> primaryGoal;
  final Value<int?> secondaryGoal;
  final Value<int> trainingDaysPerWeek;
  final Value<int> preferredSessionMinutes;
  final Value<int> equipmentSetting;
  final Value<String?> injuryNotes;
  final Value<double?> baselineBenchKg;
  final Value<bool> onboardingCompleted;
  final Value<String?> lastCompletedProgramDayId;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AthleteProfilesCompanion({
    this.id = const Value.absent(),
    this.displayName = const Value.absent(),
    this.age = const Value.absent(),
    this.sex = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.bodyWeightKg = const Value.absent(),
    this.experience = const Value.absent(),
    this.yearsTraining = const Value.absent(),
    this.primaryGoal = const Value.absent(),
    this.secondaryGoal = const Value.absent(),
    this.trainingDaysPerWeek = const Value.absent(),
    this.preferredSessionMinutes = const Value.absent(),
    this.equipmentSetting = const Value.absent(),
    this.injuryNotes = const Value.absent(),
    this.baselineBenchKg = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.lastCompletedProgramDayId = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AthleteProfilesCompanion.insert({
    required String id,
    required String displayName,
    required int age,
    this.sex = const Value.absent(),
    required double heightCm,
    required double bodyWeightKg,
    this.experience = const Value.absent(),
    this.yearsTraining = const Value.absent(),
    this.primaryGoal = const Value.absent(),
    this.secondaryGoal = const Value.absent(),
    this.trainingDaysPerWeek = const Value.absent(),
    this.preferredSessionMinutes = const Value.absent(),
    this.equipmentSetting = const Value.absent(),
    this.injuryNotes = const Value.absent(),
    this.baselineBenchKg = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.lastCompletedProgramDayId = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       displayName = Value(displayName),
       age = Value(age),
       heightCm = Value(heightCm),
       bodyWeightKg = Value(bodyWeightKg),
       updatedAt = Value(updatedAt);
  static Insertable<AthleteProfile> custom({
    Expression<String>? id,
    Expression<String>? displayName,
    Expression<int>? age,
    Expression<int>? sex,
    Expression<double>? heightCm,
    Expression<double>? bodyWeightKg,
    Expression<int>? experience,
    Expression<double>? yearsTraining,
    Expression<int>? primaryGoal,
    Expression<int>? secondaryGoal,
    Expression<int>? trainingDaysPerWeek,
    Expression<int>? preferredSessionMinutes,
    Expression<int>? equipmentSetting,
    Expression<String>? injuryNotes,
    Expression<double>? baselineBenchKg,
    Expression<bool>? onboardingCompleted,
    Expression<String>? lastCompletedProgramDayId,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (displayName != null) 'display_name': displayName,
      if (age != null) 'age': age,
      if (sex != null) 'sex': sex,
      if (heightCm != null) 'height_cm': heightCm,
      if (bodyWeightKg != null) 'body_weight_kg': bodyWeightKg,
      if (experience != null) 'experience': experience,
      if (yearsTraining != null) 'years_training': yearsTraining,
      if (primaryGoal != null) 'primary_goal': primaryGoal,
      if (secondaryGoal != null) 'secondary_goal': secondaryGoal,
      if (trainingDaysPerWeek != null)
        'training_days_per_week': trainingDaysPerWeek,
      if (preferredSessionMinutes != null)
        'preferred_session_minutes': preferredSessionMinutes,
      if (equipmentSetting != null) 'equipment_setting': equipmentSetting,
      if (injuryNotes != null) 'injury_notes': injuryNotes,
      if (baselineBenchKg != null) 'baseline_bench_kg': baselineBenchKg,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (lastCompletedProgramDayId != null)
        'last_completed_program_day_id': lastCompletedProgramDayId,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AthleteProfilesCompanion copyWith({
    Value<String>? id,
    Value<String>? displayName,
    Value<int>? age,
    Value<int>? sex,
    Value<double>? heightCm,
    Value<double>? bodyWeightKg,
    Value<int>? experience,
    Value<double>? yearsTraining,
    Value<int>? primaryGoal,
    Value<int?>? secondaryGoal,
    Value<int>? trainingDaysPerWeek,
    Value<int>? preferredSessionMinutes,
    Value<int>? equipmentSetting,
    Value<String?>? injuryNotes,
    Value<double?>? baselineBenchKg,
    Value<bool>? onboardingCompleted,
    Value<String?>? lastCompletedProgramDayId,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AthleteProfilesCompanion(
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      heightCm: heightCm ?? this.heightCm,
      bodyWeightKg: bodyWeightKg ?? this.bodyWeightKg,
      experience: experience ?? this.experience,
      yearsTraining: yearsTraining ?? this.yearsTraining,
      primaryGoal: primaryGoal ?? this.primaryGoal,
      secondaryGoal: secondaryGoal ?? this.secondaryGoal,
      trainingDaysPerWeek: trainingDaysPerWeek ?? this.trainingDaysPerWeek,
      preferredSessionMinutes:
          preferredSessionMinutes ?? this.preferredSessionMinutes,
      equipmentSetting: equipmentSetting ?? this.equipmentSetting,
      injuryNotes: injuryNotes ?? this.injuryNotes,
      baselineBenchKg: baselineBenchKg ?? this.baselineBenchKg,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      lastCompletedProgramDayId:
          lastCompletedProgramDayId ?? this.lastCompletedProgramDayId,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (sex.present) {
      map['sex'] = Variable<int>(sex.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<double>(heightCm.value);
    }
    if (bodyWeightKg.present) {
      map['body_weight_kg'] = Variable<double>(bodyWeightKg.value);
    }
    if (experience.present) {
      map['experience'] = Variable<int>(experience.value);
    }
    if (yearsTraining.present) {
      map['years_training'] = Variable<double>(yearsTraining.value);
    }
    if (primaryGoal.present) {
      map['primary_goal'] = Variable<int>(primaryGoal.value);
    }
    if (secondaryGoal.present) {
      map['secondary_goal'] = Variable<int>(secondaryGoal.value);
    }
    if (trainingDaysPerWeek.present) {
      map['training_days_per_week'] = Variable<int>(trainingDaysPerWeek.value);
    }
    if (preferredSessionMinutes.present) {
      map['preferred_session_minutes'] = Variable<int>(
        preferredSessionMinutes.value,
      );
    }
    if (equipmentSetting.present) {
      map['equipment_setting'] = Variable<int>(equipmentSetting.value);
    }
    if (injuryNotes.present) {
      map['injury_notes'] = Variable<String>(injuryNotes.value);
    }
    if (baselineBenchKg.present) {
      map['baseline_bench_kg'] = Variable<double>(baselineBenchKg.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (lastCompletedProgramDayId.present) {
      map['last_completed_program_day_id'] = Variable<String>(
        lastCompletedProgramDayId.value,
      );
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AthleteProfilesCompanion(')
          ..write('id: $id, ')
          ..write('displayName: $displayName, ')
          ..write('age: $age, ')
          ..write('sex: $sex, ')
          ..write('heightCm: $heightCm, ')
          ..write('bodyWeightKg: $bodyWeightKg, ')
          ..write('experience: $experience, ')
          ..write('yearsTraining: $yearsTraining, ')
          ..write('primaryGoal: $primaryGoal, ')
          ..write('secondaryGoal: $secondaryGoal, ')
          ..write('trainingDaysPerWeek: $trainingDaysPerWeek, ')
          ..write('preferredSessionMinutes: $preferredSessionMinutes, ')
          ..write('equipmentSetting: $equipmentSetting, ')
          ..write('injuryNotes: $injuryNotes, ')
          ..write('baselineBenchKg: $baselineBenchKg, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('lastCompletedProgramDayId: $lastCompletedProgramDayId, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgramsTable extends Programs with TableInfo<$ProgramsTable, Program> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgramsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Active'),
  );
  static const VerificationMeta _startDateUtcMeta = const VerificationMeta(
    'startDateUtc',
  );
  @override
  late final GeneratedColumn<DateTime> startDateUtc = GeneratedColumn<DateTime>(
    'start_date_utc',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateUtcMeta = const VerificationMeta(
    'endDateUtc',
  );
  @override
  late final GeneratedColumn<DateTime> endDateUtc = GeneratedColumn<DateTime>(
    'end_date_utc',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentVersionNumberMeta =
      const VerificationMeta('currentVersionNumber');
  @override
  late final GeneratedColumn<int> currentVersionNumber = GeneratedColumn<int>(
    'current_version_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _reasonMeta = const VerificationMeta('reason');
  @override
  late final GeneratedColumn<String> reason = GeneratedColumn<String>(
    'reason',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    status,
    startDateUtc,
    endDateUtc,
    currentVersionNumber,
    reason,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'programs';
  @override
  VerificationContext validateIntegrity(
    Insertable<Program> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('start_date_utc')) {
      context.handle(
        _startDateUtcMeta,
        startDateUtc.isAcceptableOrUnknown(
          data['start_date_utc']!,
          _startDateUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_startDateUtcMeta);
    }
    if (data.containsKey('end_date_utc')) {
      context.handle(
        _endDateUtcMeta,
        endDateUtc.isAcceptableOrUnknown(
          data['end_date_utc']!,
          _endDateUtcMeta,
        ),
      );
    }
    if (data.containsKey('current_version_number')) {
      context.handle(
        _currentVersionNumberMeta,
        currentVersionNumber.isAcceptableOrUnknown(
          data['current_version_number']!,
          _currentVersionNumberMeta,
        ),
      );
    }
    if (data.containsKey('reason')) {
      context.handle(
        _reasonMeta,
        reason.isAcceptableOrUnknown(data['reason']!, _reasonMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Program map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Program(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      startDateUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date_utc'],
      )!,
      endDateUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date_utc'],
      ),
      currentVersionNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_version_number'],
      )!,
      reason: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reason'],
      ),
    );
  }

  @override
  $ProgramsTable createAlias(String alias) {
    return $ProgramsTable(attachedDatabase, alias);
  }
}

class Program extends DataClass implements Insertable<Program> {
  final String id;
  final String name;
  final String status;
  final DateTime startDateUtc;
  final DateTime? endDateUtc;
  final int currentVersionNumber;
  final String? reason;
  const Program({
    required this.id,
    required this.name,
    required this.status,
    required this.startDateUtc,
    this.endDateUtc,
    required this.currentVersionNumber,
    this.reason,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['status'] = Variable<String>(status);
    map['start_date_utc'] = Variable<DateTime>(startDateUtc);
    if (!nullToAbsent || endDateUtc != null) {
      map['end_date_utc'] = Variable<DateTime>(endDateUtc);
    }
    map['current_version_number'] = Variable<int>(currentVersionNumber);
    if (!nullToAbsent || reason != null) {
      map['reason'] = Variable<String>(reason);
    }
    return map;
  }

  ProgramsCompanion toCompanion(bool nullToAbsent) {
    return ProgramsCompanion(
      id: Value(id),
      name: Value(name),
      status: Value(status),
      startDateUtc: Value(startDateUtc),
      endDateUtc: endDateUtc == null && nullToAbsent
          ? const Value.absent()
          : Value(endDateUtc),
      currentVersionNumber: Value(currentVersionNumber),
      reason: reason == null && nullToAbsent
          ? const Value.absent()
          : Value(reason),
    );
  }

  factory Program.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Program(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      status: serializer.fromJson<String>(json['status']),
      startDateUtc: serializer.fromJson<DateTime>(json['startDateUtc']),
      endDateUtc: serializer.fromJson<DateTime?>(json['endDateUtc']),
      currentVersionNumber: serializer.fromJson<int>(
        json['currentVersionNumber'],
      ),
      reason: serializer.fromJson<String?>(json['reason']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'status': serializer.toJson<String>(status),
      'startDateUtc': serializer.toJson<DateTime>(startDateUtc),
      'endDateUtc': serializer.toJson<DateTime?>(endDateUtc),
      'currentVersionNumber': serializer.toJson<int>(currentVersionNumber),
      'reason': serializer.toJson<String?>(reason),
    };
  }

  Program copyWith({
    String? id,
    String? name,
    String? status,
    DateTime? startDateUtc,
    Value<DateTime?> endDateUtc = const Value.absent(),
    int? currentVersionNumber,
    Value<String?> reason = const Value.absent(),
  }) => Program(
    id: id ?? this.id,
    name: name ?? this.name,
    status: status ?? this.status,
    startDateUtc: startDateUtc ?? this.startDateUtc,
    endDateUtc: endDateUtc.present ? endDateUtc.value : this.endDateUtc,
    currentVersionNumber: currentVersionNumber ?? this.currentVersionNumber,
    reason: reason.present ? reason.value : this.reason,
  );
  Program copyWithCompanion(ProgramsCompanion data) {
    return Program(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      status: data.status.present ? data.status.value : this.status,
      startDateUtc: data.startDateUtc.present
          ? data.startDateUtc.value
          : this.startDateUtc,
      endDateUtc: data.endDateUtc.present
          ? data.endDateUtc.value
          : this.endDateUtc,
      currentVersionNumber: data.currentVersionNumber.present
          ? data.currentVersionNumber.value
          : this.currentVersionNumber,
      reason: data.reason.present ? data.reason.value : this.reason,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Program(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('startDateUtc: $startDateUtc, ')
          ..write('endDateUtc: $endDateUtc, ')
          ..write('currentVersionNumber: $currentVersionNumber, ')
          ..write('reason: $reason')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    status,
    startDateUtc,
    endDateUtc,
    currentVersionNumber,
    reason,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Program &&
          other.id == this.id &&
          other.name == this.name &&
          other.status == this.status &&
          other.startDateUtc == this.startDateUtc &&
          other.endDateUtc == this.endDateUtc &&
          other.currentVersionNumber == this.currentVersionNumber &&
          other.reason == this.reason);
}

class ProgramsCompanion extends UpdateCompanion<Program> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> status;
  final Value<DateTime> startDateUtc;
  final Value<DateTime?> endDateUtc;
  final Value<int> currentVersionNumber;
  final Value<String?> reason;
  final Value<int> rowid;
  const ProgramsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.status = const Value.absent(),
    this.startDateUtc = const Value.absent(),
    this.endDateUtc = const Value.absent(),
    this.currentVersionNumber = const Value.absent(),
    this.reason = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgramsCompanion.insert({
    required String id,
    required String name,
    this.status = const Value.absent(),
    required DateTime startDateUtc,
    this.endDateUtc = const Value.absent(),
    this.currentVersionNumber = const Value.absent(),
    this.reason = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       startDateUtc = Value(startDateUtc);
  static Insertable<Program> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? status,
    Expression<DateTime>? startDateUtc,
    Expression<DateTime>? endDateUtc,
    Expression<int>? currentVersionNumber,
    Expression<String>? reason,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (status != null) 'status': status,
      if (startDateUtc != null) 'start_date_utc': startDateUtc,
      if (endDateUtc != null) 'end_date_utc': endDateUtc,
      if (currentVersionNumber != null)
        'current_version_number': currentVersionNumber,
      if (reason != null) 'reason': reason,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgramsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String>? status,
    Value<DateTime>? startDateUtc,
    Value<DateTime?>? endDateUtc,
    Value<int>? currentVersionNumber,
    Value<String?>? reason,
    Value<int>? rowid,
  }) {
    return ProgramsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      startDateUtc: startDateUtc ?? this.startDateUtc,
      endDateUtc: endDateUtc ?? this.endDateUtc,
      currentVersionNumber: currentVersionNumber ?? this.currentVersionNumber,
      reason: reason ?? this.reason,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (startDateUtc.present) {
      map['start_date_utc'] = Variable<DateTime>(startDateUtc.value);
    }
    if (endDateUtc.present) {
      map['end_date_utc'] = Variable<DateTime>(endDateUtc.value);
    }
    if (currentVersionNumber.present) {
      map['current_version_number'] = Variable<int>(currentVersionNumber.value);
    }
    if (reason.present) {
      map['reason'] = Variable<String>(reason.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgramsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('status: $status, ')
          ..write('startDateUtc: $startDateUtc, ')
          ..write('endDateUtc: $endDateUtc, ')
          ..write('currentVersionNumber: $currentVersionNumber, ')
          ..write('reason: $reason, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgramDaysTable extends ProgramDays
    with TableInfo<$ProgramDaysTable, ProgramDay> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgramDaysTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _programIdMeta = const VerificationMeta(
    'programId',
  );
  @override
  late final GeneratedColumn<String> programId = GeneratedColumn<String>(
    'program_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayIndexMeta = const VerificationMeta(
    'dayIndex',
  );
  @override
  late final GeneratedColumn<int> dayIndex = GeneratedColumn<int>(
    'day_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _splitMeta = const VerificationMeta('split');
  @override
  late final GeneratedColumn<String> split = GeneratedColumn<String>(
    'split',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, programId, dayIndex, name, split];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'program_days';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgramDay> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('program_id')) {
      context.handle(
        _programIdMeta,
        programId.isAcceptableOrUnknown(data['program_id']!, _programIdMeta),
      );
    } else if (isInserting) {
      context.missing(_programIdMeta);
    }
    if (data.containsKey('day_index')) {
      context.handle(
        _dayIndexMeta,
        dayIndex.isAcceptableOrUnknown(data['day_index']!, _dayIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_dayIndexMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('split')) {
      context.handle(
        _splitMeta,
        split.isAcceptableOrUnknown(data['split']!, _splitMeta),
      );
    } else if (isInserting) {
      context.missing(_splitMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgramDay map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgramDay(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      programId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program_id'],
      )!,
      dayIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_index'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      split: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}split'],
      )!,
    );
  }

  @override
  $ProgramDaysTable createAlias(String alias) {
    return $ProgramDaysTable(attachedDatabase, alias);
  }
}

class ProgramDay extends DataClass implements Insertable<ProgramDay> {
  final String id;
  final String programId;
  final int dayIndex;
  final String name;
  final String split;
  const ProgramDay({
    required this.id,
    required this.programId,
    required this.dayIndex,
    required this.name,
    required this.split,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['program_id'] = Variable<String>(programId);
    map['day_index'] = Variable<int>(dayIndex);
    map['name'] = Variable<String>(name);
    map['split'] = Variable<String>(split);
    return map;
  }

  ProgramDaysCompanion toCompanion(bool nullToAbsent) {
    return ProgramDaysCompanion(
      id: Value(id),
      programId: Value(programId),
      dayIndex: Value(dayIndex),
      name: Value(name),
      split: Value(split),
    );
  }

  factory ProgramDay.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgramDay(
      id: serializer.fromJson<String>(json['id']),
      programId: serializer.fromJson<String>(json['programId']),
      dayIndex: serializer.fromJson<int>(json['dayIndex']),
      name: serializer.fromJson<String>(json['name']),
      split: serializer.fromJson<String>(json['split']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'programId': serializer.toJson<String>(programId),
      'dayIndex': serializer.toJson<int>(dayIndex),
      'name': serializer.toJson<String>(name),
      'split': serializer.toJson<String>(split),
    };
  }

  ProgramDay copyWith({
    String? id,
    String? programId,
    int? dayIndex,
    String? name,
    String? split,
  }) => ProgramDay(
    id: id ?? this.id,
    programId: programId ?? this.programId,
    dayIndex: dayIndex ?? this.dayIndex,
    name: name ?? this.name,
    split: split ?? this.split,
  );
  ProgramDay copyWithCompanion(ProgramDaysCompanion data) {
    return ProgramDay(
      id: data.id.present ? data.id.value : this.id,
      programId: data.programId.present ? data.programId.value : this.programId,
      dayIndex: data.dayIndex.present ? data.dayIndex.value : this.dayIndex,
      name: data.name.present ? data.name.value : this.name,
      split: data.split.present ? data.split.value : this.split,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgramDay(')
          ..write('id: $id, ')
          ..write('programId: $programId, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('name: $name, ')
          ..write('split: $split')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, programId, dayIndex, name, split);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgramDay &&
          other.id == this.id &&
          other.programId == this.programId &&
          other.dayIndex == this.dayIndex &&
          other.name == this.name &&
          other.split == this.split);
}

class ProgramDaysCompanion extends UpdateCompanion<ProgramDay> {
  final Value<String> id;
  final Value<String> programId;
  final Value<int> dayIndex;
  final Value<String> name;
  final Value<String> split;
  final Value<int> rowid;
  const ProgramDaysCompanion({
    this.id = const Value.absent(),
    this.programId = const Value.absent(),
    this.dayIndex = const Value.absent(),
    this.name = const Value.absent(),
    this.split = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgramDaysCompanion.insert({
    required String id,
    required String programId,
    required int dayIndex,
    required String name,
    required String split,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       programId = Value(programId),
       dayIndex = Value(dayIndex),
       name = Value(name),
       split = Value(split);
  static Insertable<ProgramDay> custom({
    Expression<String>? id,
    Expression<String>? programId,
    Expression<int>? dayIndex,
    Expression<String>? name,
    Expression<String>? split,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (programId != null) 'program_id': programId,
      if (dayIndex != null) 'day_index': dayIndex,
      if (name != null) 'name': name,
      if (split != null) 'split': split,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgramDaysCompanion copyWith({
    Value<String>? id,
    Value<String>? programId,
    Value<int>? dayIndex,
    Value<String>? name,
    Value<String>? split,
    Value<int>? rowid,
  }) {
    return ProgramDaysCompanion(
      id: id ?? this.id,
      programId: programId ?? this.programId,
      dayIndex: dayIndex ?? this.dayIndex,
      name: name ?? this.name,
      split: split ?? this.split,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (programId.present) {
      map['program_id'] = Variable<String>(programId.value);
    }
    if (dayIndex.present) {
      map['day_index'] = Variable<int>(dayIndex.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (split.present) {
      map['split'] = Variable<String>(split.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgramDaysCompanion(')
          ..write('id: $id, ')
          ..write('programId: $programId, ')
          ..write('dayIndex: $dayIndex, ')
          ..write('name: $name, ')
          ..write('split: $split, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProgramExercisesTable extends ProgramExercises
    with TableInfo<$ProgramExercisesTable, ProgramExercise> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProgramExercisesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _programDayIdMeta = const VerificationMeta(
    'programDayId',
  );
  @override
  late final GeneratedColumn<String> programDayId = GeneratedColumn<String>(
    'program_day_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catalogExerciseIdMeta = const VerificationMeta(
    'catalogExerciseId',
  );
  @override
  late final GeneratedColumn<String> catalogExerciseId =
      GeneratedColumn<String>(
        'catalog_exercise_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _exerciseNameMeta = const VerificationMeta(
    'exerciseName',
  );
  @override
  late final GeneratedColumn<String> exerciseName = GeneratedColumn<String>(
    'exercise_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _positionMeta = const VerificationMeta(
    'position',
  );
  @override
  late final GeneratedColumn<int> position = GeneratedColumn<int>(
    'position',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _setsMeta = const VerificationMeta('sets');
  @override
  late final GeneratedColumn<int> sets = GeneratedColumn<int>(
    'sets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minRepsMeta = const VerificationMeta(
    'minReps',
  );
  @override
  late final GeneratedColumn<int> minReps = GeneratedColumn<int>(
    'min_reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _maxRepsMeta = const VerificationMeta(
    'maxReps',
  );
  @override
  late final GeneratedColumn<int> maxReps = GeneratedColumn<int>(
    'max_reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startingLoadKgMeta = const VerificationMeta(
    'startingLoadKg',
  );
  @override
  late final GeneratedColumn<double> startingLoadKg = GeneratedColumn<double>(
    'starting_load_kg',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _restSecondsMeta = const VerificationMeta(
    'restSeconds',
  );
  @override
  late final GeneratedColumn<int> restSeconds = GeneratedColumn<int>(
    'rest_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(90),
  );
  static const VerificationMeta _targetRirMeta = const VerificationMeta(
    'targetRir',
  );
  @override
  late final GeneratedColumn<double> targetRir = GeneratedColumn<double>(
    'target_rir',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isCompoundMeta = const VerificationMeta(
    'isCompound',
  );
  @override
  late final GeneratedColumn<bool> isCompound = GeneratedColumn<bool>(
    'is_compound',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_compound" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _loadIncrementKgMeta = const VerificationMeta(
    'loadIncrementKg',
  );
  @override
  late final GeneratedColumn<double> loadIncrementKg = GeneratedColumn<double>(
    'load_increment_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.5),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    programDayId,
    catalogExerciseId,
    exerciseName,
    position,
    sets,
    minReps,
    maxReps,
    startingLoadKg,
    restSeconds,
    targetRir,
    isCompound,
    loadIncrementKg,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'program_exercises';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProgramExercise> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('program_day_id')) {
      context.handle(
        _programDayIdMeta,
        programDayId.isAcceptableOrUnknown(
          data['program_day_id']!,
          _programDayIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_programDayIdMeta);
    }
    if (data.containsKey('catalog_exercise_id')) {
      context.handle(
        _catalogExerciseIdMeta,
        catalogExerciseId.isAcceptableOrUnknown(
          data['catalog_exercise_id']!,
          _catalogExerciseIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_catalogExerciseIdMeta);
    }
    if (data.containsKey('exercise_name')) {
      context.handle(
        _exerciseNameMeta,
        exerciseName.isAcceptableOrUnknown(
          data['exercise_name']!,
          _exerciseNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseNameMeta);
    }
    if (data.containsKey('position')) {
      context.handle(
        _positionMeta,
        position.isAcceptableOrUnknown(data['position']!, _positionMeta),
      );
    } else if (isInserting) {
      context.missing(_positionMeta);
    }
    if (data.containsKey('sets')) {
      context.handle(
        _setsMeta,
        sets.isAcceptableOrUnknown(data['sets']!, _setsMeta),
      );
    } else if (isInserting) {
      context.missing(_setsMeta);
    }
    if (data.containsKey('min_reps')) {
      context.handle(
        _minRepsMeta,
        minReps.isAcceptableOrUnknown(data['min_reps']!, _minRepsMeta),
      );
    } else if (isInserting) {
      context.missing(_minRepsMeta);
    }
    if (data.containsKey('max_reps')) {
      context.handle(
        _maxRepsMeta,
        maxReps.isAcceptableOrUnknown(data['max_reps']!, _maxRepsMeta),
      );
    } else if (isInserting) {
      context.missing(_maxRepsMeta);
    }
    if (data.containsKey('starting_load_kg')) {
      context.handle(
        _startingLoadKgMeta,
        startingLoadKg.isAcceptableOrUnknown(
          data['starting_load_kg']!,
          _startingLoadKgMeta,
        ),
      );
    }
    if (data.containsKey('rest_seconds')) {
      context.handle(
        _restSecondsMeta,
        restSeconds.isAcceptableOrUnknown(
          data['rest_seconds']!,
          _restSecondsMeta,
        ),
      );
    }
    if (data.containsKey('target_rir')) {
      context.handle(
        _targetRirMeta,
        targetRir.isAcceptableOrUnknown(data['target_rir']!, _targetRirMeta),
      );
    }
    if (data.containsKey('is_compound')) {
      context.handle(
        _isCompoundMeta,
        isCompound.isAcceptableOrUnknown(data['is_compound']!, _isCompoundMeta),
      );
    }
    if (data.containsKey('load_increment_kg')) {
      context.handle(
        _loadIncrementKgMeta,
        loadIncrementKg.isAcceptableOrUnknown(
          data['load_increment_kg']!,
          _loadIncrementKgMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProgramExercise map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProgramExercise(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      programDayId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}program_day_id'],
      )!,
      catalogExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_exercise_id'],
      )!,
      exerciseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_name'],
      )!,
      position: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position'],
      )!,
      sets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sets'],
      )!,
      minReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}min_reps'],
      )!,
      maxReps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}max_reps'],
      )!,
      startingLoadKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}starting_load_kg'],
      ),
      restSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rest_seconds'],
      )!,
      targetRir: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_rir'],
      ),
      isCompound: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_compound'],
      )!,
      loadIncrementKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}load_increment_kg'],
      )!,
    );
  }

  @override
  $ProgramExercisesTable createAlias(String alias) {
    return $ProgramExercisesTable(attachedDatabase, alias);
  }
}

class ProgramExercise extends DataClass implements Insertable<ProgramExercise> {
  final String id;
  final String programDayId;
  final String catalogExerciseId;
  final String exerciseName;
  final int position;
  final int sets;
  final int minReps;
  final int maxReps;
  final double? startingLoadKg;
  final int restSeconds;
  final double? targetRir;
  final bool isCompound;
  final double loadIncrementKg;
  const ProgramExercise({
    required this.id,
    required this.programDayId,
    required this.catalogExerciseId,
    required this.exerciseName,
    required this.position,
    required this.sets,
    required this.minReps,
    required this.maxReps,
    this.startingLoadKg,
    required this.restSeconds,
    this.targetRir,
    required this.isCompound,
    required this.loadIncrementKg,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['program_day_id'] = Variable<String>(programDayId);
    map['catalog_exercise_id'] = Variable<String>(catalogExerciseId);
    map['exercise_name'] = Variable<String>(exerciseName);
    map['position'] = Variable<int>(position);
    map['sets'] = Variable<int>(sets);
    map['min_reps'] = Variable<int>(minReps);
    map['max_reps'] = Variable<int>(maxReps);
    if (!nullToAbsent || startingLoadKg != null) {
      map['starting_load_kg'] = Variable<double>(startingLoadKg);
    }
    map['rest_seconds'] = Variable<int>(restSeconds);
    if (!nullToAbsent || targetRir != null) {
      map['target_rir'] = Variable<double>(targetRir);
    }
    map['is_compound'] = Variable<bool>(isCompound);
    map['load_increment_kg'] = Variable<double>(loadIncrementKg);
    return map;
  }

  ProgramExercisesCompanion toCompanion(bool nullToAbsent) {
    return ProgramExercisesCompanion(
      id: Value(id),
      programDayId: Value(programDayId),
      catalogExerciseId: Value(catalogExerciseId),
      exerciseName: Value(exerciseName),
      position: Value(position),
      sets: Value(sets),
      minReps: Value(minReps),
      maxReps: Value(maxReps),
      startingLoadKg: startingLoadKg == null && nullToAbsent
          ? const Value.absent()
          : Value(startingLoadKg),
      restSeconds: Value(restSeconds),
      targetRir: targetRir == null && nullToAbsent
          ? const Value.absent()
          : Value(targetRir),
      isCompound: Value(isCompound),
      loadIncrementKg: Value(loadIncrementKg),
    );
  }

  factory ProgramExercise.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProgramExercise(
      id: serializer.fromJson<String>(json['id']),
      programDayId: serializer.fromJson<String>(json['programDayId']),
      catalogExerciseId: serializer.fromJson<String>(json['catalogExerciseId']),
      exerciseName: serializer.fromJson<String>(json['exerciseName']),
      position: serializer.fromJson<int>(json['position']),
      sets: serializer.fromJson<int>(json['sets']),
      minReps: serializer.fromJson<int>(json['minReps']),
      maxReps: serializer.fromJson<int>(json['maxReps']),
      startingLoadKg: serializer.fromJson<double?>(json['startingLoadKg']),
      restSeconds: serializer.fromJson<int>(json['restSeconds']),
      targetRir: serializer.fromJson<double?>(json['targetRir']),
      isCompound: serializer.fromJson<bool>(json['isCompound']),
      loadIncrementKg: serializer.fromJson<double>(json['loadIncrementKg']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'programDayId': serializer.toJson<String>(programDayId),
      'catalogExerciseId': serializer.toJson<String>(catalogExerciseId),
      'exerciseName': serializer.toJson<String>(exerciseName),
      'position': serializer.toJson<int>(position),
      'sets': serializer.toJson<int>(sets),
      'minReps': serializer.toJson<int>(minReps),
      'maxReps': serializer.toJson<int>(maxReps),
      'startingLoadKg': serializer.toJson<double?>(startingLoadKg),
      'restSeconds': serializer.toJson<int>(restSeconds),
      'targetRir': serializer.toJson<double?>(targetRir),
      'isCompound': serializer.toJson<bool>(isCompound),
      'loadIncrementKg': serializer.toJson<double>(loadIncrementKg),
    };
  }

  ProgramExercise copyWith({
    String? id,
    String? programDayId,
    String? catalogExerciseId,
    String? exerciseName,
    int? position,
    int? sets,
    int? minReps,
    int? maxReps,
    Value<double?> startingLoadKg = const Value.absent(),
    int? restSeconds,
    Value<double?> targetRir = const Value.absent(),
    bool? isCompound,
    double? loadIncrementKg,
  }) => ProgramExercise(
    id: id ?? this.id,
    programDayId: programDayId ?? this.programDayId,
    catalogExerciseId: catalogExerciseId ?? this.catalogExerciseId,
    exerciseName: exerciseName ?? this.exerciseName,
    position: position ?? this.position,
    sets: sets ?? this.sets,
    minReps: minReps ?? this.minReps,
    maxReps: maxReps ?? this.maxReps,
    startingLoadKg: startingLoadKg.present
        ? startingLoadKg.value
        : this.startingLoadKg,
    restSeconds: restSeconds ?? this.restSeconds,
    targetRir: targetRir.present ? targetRir.value : this.targetRir,
    isCompound: isCompound ?? this.isCompound,
    loadIncrementKg: loadIncrementKg ?? this.loadIncrementKg,
  );
  ProgramExercise copyWithCompanion(ProgramExercisesCompanion data) {
    return ProgramExercise(
      id: data.id.present ? data.id.value : this.id,
      programDayId: data.programDayId.present
          ? data.programDayId.value
          : this.programDayId,
      catalogExerciseId: data.catalogExerciseId.present
          ? data.catalogExerciseId.value
          : this.catalogExerciseId,
      exerciseName: data.exerciseName.present
          ? data.exerciseName.value
          : this.exerciseName,
      position: data.position.present ? data.position.value : this.position,
      sets: data.sets.present ? data.sets.value : this.sets,
      minReps: data.minReps.present ? data.minReps.value : this.minReps,
      maxReps: data.maxReps.present ? data.maxReps.value : this.maxReps,
      startingLoadKg: data.startingLoadKg.present
          ? data.startingLoadKg.value
          : this.startingLoadKg,
      restSeconds: data.restSeconds.present
          ? data.restSeconds.value
          : this.restSeconds,
      targetRir: data.targetRir.present ? data.targetRir.value : this.targetRir,
      isCompound: data.isCompound.present
          ? data.isCompound.value
          : this.isCompound,
      loadIncrementKg: data.loadIncrementKg.present
          ? data.loadIncrementKg.value
          : this.loadIncrementKg,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProgramExercise(')
          ..write('id: $id, ')
          ..write('programDayId: $programDayId, ')
          ..write('catalogExerciseId: $catalogExerciseId, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('position: $position, ')
          ..write('sets: $sets, ')
          ..write('minReps: $minReps, ')
          ..write('maxReps: $maxReps, ')
          ..write('startingLoadKg: $startingLoadKg, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('targetRir: $targetRir, ')
          ..write('isCompound: $isCompound, ')
          ..write('loadIncrementKg: $loadIncrementKg')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    programDayId,
    catalogExerciseId,
    exerciseName,
    position,
    sets,
    minReps,
    maxReps,
    startingLoadKg,
    restSeconds,
    targetRir,
    isCompound,
    loadIncrementKg,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProgramExercise &&
          other.id == this.id &&
          other.programDayId == this.programDayId &&
          other.catalogExerciseId == this.catalogExerciseId &&
          other.exerciseName == this.exerciseName &&
          other.position == this.position &&
          other.sets == this.sets &&
          other.minReps == this.minReps &&
          other.maxReps == this.maxReps &&
          other.startingLoadKg == this.startingLoadKg &&
          other.restSeconds == this.restSeconds &&
          other.targetRir == this.targetRir &&
          other.isCompound == this.isCompound &&
          other.loadIncrementKg == this.loadIncrementKg);
}

class ProgramExercisesCompanion extends UpdateCompanion<ProgramExercise> {
  final Value<String> id;
  final Value<String> programDayId;
  final Value<String> catalogExerciseId;
  final Value<String> exerciseName;
  final Value<int> position;
  final Value<int> sets;
  final Value<int> minReps;
  final Value<int> maxReps;
  final Value<double?> startingLoadKg;
  final Value<int> restSeconds;
  final Value<double?> targetRir;
  final Value<bool> isCompound;
  final Value<double> loadIncrementKg;
  final Value<int> rowid;
  const ProgramExercisesCompanion({
    this.id = const Value.absent(),
    this.programDayId = const Value.absent(),
    this.catalogExerciseId = const Value.absent(),
    this.exerciseName = const Value.absent(),
    this.position = const Value.absent(),
    this.sets = const Value.absent(),
    this.minReps = const Value.absent(),
    this.maxReps = const Value.absent(),
    this.startingLoadKg = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.targetRir = const Value.absent(),
    this.isCompound = const Value.absent(),
    this.loadIncrementKg = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProgramExercisesCompanion.insert({
    required String id,
    required String programDayId,
    required String catalogExerciseId,
    required String exerciseName,
    required int position,
    required int sets,
    required int minReps,
    required int maxReps,
    this.startingLoadKg = const Value.absent(),
    this.restSeconds = const Value.absent(),
    this.targetRir = const Value.absent(),
    this.isCompound = const Value.absent(),
    this.loadIncrementKg = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       programDayId = Value(programDayId),
       catalogExerciseId = Value(catalogExerciseId),
       exerciseName = Value(exerciseName),
       position = Value(position),
       sets = Value(sets),
       minReps = Value(minReps),
       maxReps = Value(maxReps);
  static Insertable<ProgramExercise> custom({
    Expression<String>? id,
    Expression<String>? programDayId,
    Expression<String>? catalogExerciseId,
    Expression<String>? exerciseName,
    Expression<int>? position,
    Expression<int>? sets,
    Expression<int>? minReps,
    Expression<int>? maxReps,
    Expression<double>? startingLoadKg,
    Expression<int>? restSeconds,
    Expression<double>? targetRir,
    Expression<bool>? isCompound,
    Expression<double>? loadIncrementKg,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (programDayId != null) 'program_day_id': programDayId,
      if (catalogExerciseId != null) 'catalog_exercise_id': catalogExerciseId,
      if (exerciseName != null) 'exercise_name': exerciseName,
      if (position != null) 'position': position,
      if (sets != null) 'sets': sets,
      if (minReps != null) 'min_reps': minReps,
      if (maxReps != null) 'max_reps': maxReps,
      if (startingLoadKg != null) 'starting_load_kg': startingLoadKg,
      if (restSeconds != null) 'rest_seconds': restSeconds,
      if (targetRir != null) 'target_rir': targetRir,
      if (isCompound != null) 'is_compound': isCompound,
      if (loadIncrementKg != null) 'load_increment_kg': loadIncrementKg,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProgramExercisesCompanion copyWith({
    Value<String>? id,
    Value<String>? programDayId,
    Value<String>? catalogExerciseId,
    Value<String>? exerciseName,
    Value<int>? position,
    Value<int>? sets,
    Value<int>? minReps,
    Value<int>? maxReps,
    Value<double?>? startingLoadKg,
    Value<int>? restSeconds,
    Value<double?>? targetRir,
    Value<bool>? isCompound,
    Value<double>? loadIncrementKg,
    Value<int>? rowid,
  }) {
    return ProgramExercisesCompanion(
      id: id ?? this.id,
      programDayId: programDayId ?? this.programDayId,
      catalogExerciseId: catalogExerciseId ?? this.catalogExerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      position: position ?? this.position,
      sets: sets ?? this.sets,
      minReps: minReps ?? this.minReps,
      maxReps: maxReps ?? this.maxReps,
      startingLoadKg: startingLoadKg ?? this.startingLoadKg,
      restSeconds: restSeconds ?? this.restSeconds,
      targetRir: targetRir ?? this.targetRir,
      isCompound: isCompound ?? this.isCompound,
      loadIncrementKg: loadIncrementKg ?? this.loadIncrementKg,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (programDayId.present) {
      map['program_day_id'] = Variable<String>(programDayId.value);
    }
    if (catalogExerciseId.present) {
      map['catalog_exercise_id'] = Variable<String>(catalogExerciseId.value);
    }
    if (exerciseName.present) {
      map['exercise_name'] = Variable<String>(exerciseName.value);
    }
    if (position.present) {
      map['position'] = Variable<int>(position.value);
    }
    if (sets.present) {
      map['sets'] = Variable<int>(sets.value);
    }
    if (minReps.present) {
      map['min_reps'] = Variable<int>(minReps.value);
    }
    if (maxReps.present) {
      map['max_reps'] = Variable<int>(maxReps.value);
    }
    if (startingLoadKg.present) {
      map['starting_load_kg'] = Variable<double>(startingLoadKg.value);
    }
    if (restSeconds.present) {
      map['rest_seconds'] = Variable<int>(restSeconds.value);
    }
    if (targetRir.present) {
      map['target_rir'] = Variable<double>(targetRir.value);
    }
    if (isCompound.present) {
      map['is_compound'] = Variable<bool>(isCompound.value);
    }
    if (loadIncrementKg.present) {
      map['load_increment_kg'] = Variable<double>(loadIncrementKg.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProgramExercisesCompanion(')
          ..write('id: $id, ')
          ..write('programDayId: $programDayId, ')
          ..write('catalogExerciseId: $catalogExerciseId, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('position: $position, ')
          ..write('sets: $sets, ')
          ..write('minReps: $minReps, ')
          ..write('maxReps: $maxReps, ')
          ..write('startingLoadKg: $startingLoadKg, ')
          ..write('restSeconds: $restSeconds, ')
          ..write('targetRir: $targetRir, ')
          ..write('isCompound: $isCompound, ')
          ..write('loadIncrementKg: $loadIncrementKg, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalPersonalRecordsTable extends LocalPersonalRecords
    with TableInfo<$LocalPersonalRecordsTable, LocalPersonalRecord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalPersonalRecordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseNameMeta = const VerificationMeta(
    'exerciseName',
  );
  @override
  late final GeneratedColumn<String> exerciseName = GeneratedColumn<String>(
    'exercise_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _catalogExerciseIdMeta = const VerificationMeta(
    'catalogExerciseId',
  );
  @override
  late final GeneratedColumn<String> catalogExerciseId =
      GeneratedColumn<String>(
        'catalog_exercise_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _recordTypeMeta = const VerificationMeta(
    'recordType',
  );
  @override
  late final GeneratedColumn<String> recordType = GeneratedColumn<String>(
    'record_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _achievedAtUtcMeta = const VerificationMeta(
    'achievedAtUtc',
  );
  @override
  late final GeneratedColumn<DateTime> achievedAtUtc =
      GeneratedColumn<DateTime>(
        'achieved_at_utc',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    exerciseName,
    catalogExerciseId,
    recordType,
    value,
    achievedAtUtc,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_personal_records';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalPersonalRecord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('exercise_name')) {
      context.handle(
        _exerciseNameMeta,
        exerciseName.isAcceptableOrUnknown(
          data['exercise_name']!,
          _exerciseNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_exerciseNameMeta);
    }
    if (data.containsKey('catalog_exercise_id')) {
      context.handle(
        _catalogExerciseIdMeta,
        catalogExerciseId.isAcceptableOrUnknown(
          data['catalog_exercise_id']!,
          _catalogExerciseIdMeta,
        ),
      );
    }
    if (data.containsKey('record_type')) {
      context.handle(
        _recordTypeMeta,
        recordType.isAcceptableOrUnknown(data['record_type']!, _recordTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_recordTypeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('achieved_at_utc')) {
      context.handle(
        _achievedAtUtcMeta,
        achievedAtUtc.isAcceptableOrUnknown(
          data['achieved_at_utc']!,
          _achievedAtUtcMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_achievedAtUtcMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalPersonalRecord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalPersonalRecord(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      exerciseName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_name'],
      )!,
      catalogExerciseId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}catalog_exercise_id'],
      ),
      recordType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_type'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      achievedAtUtc: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}achieved_at_utc'],
      )!,
    );
  }

  @override
  $LocalPersonalRecordsTable createAlias(String alias) {
    return $LocalPersonalRecordsTable(attachedDatabase, alias);
  }
}

class LocalPersonalRecord extends DataClass
    implements Insertable<LocalPersonalRecord> {
  final String id;
  final String exerciseName;
  final String? catalogExerciseId;
  final String recordType;
  final double value;
  final DateTime achievedAtUtc;
  const LocalPersonalRecord({
    required this.id,
    required this.exerciseName,
    this.catalogExerciseId,
    required this.recordType,
    required this.value,
    required this.achievedAtUtc,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['exercise_name'] = Variable<String>(exerciseName);
    if (!nullToAbsent || catalogExerciseId != null) {
      map['catalog_exercise_id'] = Variable<String>(catalogExerciseId);
    }
    map['record_type'] = Variable<String>(recordType);
    map['value'] = Variable<double>(value);
    map['achieved_at_utc'] = Variable<DateTime>(achievedAtUtc);
    return map;
  }

  LocalPersonalRecordsCompanion toCompanion(bool nullToAbsent) {
    return LocalPersonalRecordsCompanion(
      id: Value(id),
      exerciseName: Value(exerciseName),
      catalogExerciseId: catalogExerciseId == null && nullToAbsent
          ? const Value.absent()
          : Value(catalogExerciseId),
      recordType: Value(recordType),
      value: Value(value),
      achievedAtUtc: Value(achievedAtUtc),
    );
  }

  factory LocalPersonalRecord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalPersonalRecord(
      id: serializer.fromJson<String>(json['id']),
      exerciseName: serializer.fromJson<String>(json['exerciseName']),
      catalogExerciseId: serializer.fromJson<String?>(
        json['catalogExerciseId'],
      ),
      recordType: serializer.fromJson<String>(json['recordType']),
      value: serializer.fromJson<double>(json['value']),
      achievedAtUtc: serializer.fromJson<DateTime>(json['achievedAtUtc']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'exerciseName': serializer.toJson<String>(exerciseName),
      'catalogExerciseId': serializer.toJson<String?>(catalogExerciseId),
      'recordType': serializer.toJson<String>(recordType),
      'value': serializer.toJson<double>(value),
      'achievedAtUtc': serializer.toJson<DateTime>(achievedAtUtc),
    };
  }

  LocalPersonalRecord copyWith({
    String? id,
    String? exerciseName,
    Value<String?> catalogExerciseId = const Value.absent(),
    String? recordType,
    double? value,
    DateTime? achievedAtUtc,
  }) => LocalPersonalRecord(
    id: id ?? this.id,
    exerciseName: exerciseName ?? this.exerciseName,
    catalogExerciseId: catalogExerciseId.present
        ? catalogExerciseId.value
        : this.catalogExerciseId,
    recordType: recordType ?? this.recordType,
    value: value ?? this.value,
    achievedAtUtc: achievedAtUtc ?? this.achievedAtUtc,
  );
  LocalPersonalRecord copyWithCompanion(LocalPersonalRecordsCompanion data) {
    return LocalPersonalRecord(
      id: data.id.present ? data.id.value : this.id,
      exerciseName: data.exerciseName.present
          ? data.exerciseName.value
          : this.exerciseName,
      catalogExerciseId: data.catalogExerciseId.present
          ? data.catalogExerciseId.value
          : this.catalogExerciseId,
      recordType: data.recordType.present
          ? data.recordType.value
          : this.recordType,
      value: data.value.present ? data.value.value : this.value,
      achievedAtUtc: data.achievedAtUtc.present
          ? data.achievedAtUtc.value
          : this.achievedAtUtc,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalPersonalRecord(')
          ..write('id: $id, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('catalogExerciseId: $catalogExerciseId, ')
          ..write('recordType: $recordType, ')
          ..write('value: $value, ')
          ..write('achievedAtUtc: $achievedAtUtc')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    exerciseName,
    catalogExerciseId,
    recordType,
    value,
    achievedAtUtc,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalPersonalRecord &&
          other.id == this.id &&
          other.exerciseName == this.exerciseName &&
          other.catalogExerciseId == this.catalogExerciseId &&
          other.recordType == this.recordType &&
          other.value == this.value &&
          other.achievedAtUtc == this.achievedAtUtc);
}

class LocalPersonalRecordsCompanion
    extends UpdateCompanion<LocalPersonalRecord> {
  final Value<String> id;
  final Value<String> exerciseName;
  final Value<String?> catalogExerciseId;
  final Value<String> recordType;
  final Value<double> value;
  final Value<DateTime> achievedAtUtc;
  final Value<int> rowid;
  const LocalPersonalRecordsCompanion({
    this.id = const Value.absent(),
    this.exerciseName = const Value.absent(),
    this.catalogExerciseId = const Value.absent(),
    this.recordType = const Value.absent(),
    this.value = const Value.absent(),
    this.achievedAtUtc = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalPersonalRecordsCompanion.insert({
    required String id,
    required String exerciseName,
    this.catalogExerciseId = const Value.absent(),
    required String recordType,
    required double value,
    required DateTime achievedAtUtc,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       exerciseName = Value(exerciseName),
       recordType = Value(recordType),
       value = Value(value),
       achievedAtUtc = Value(achievedAtUtc);
  static Insertable<LocalPersonalRecord> custom({
    Expression<String>? id,
    Expression<String>? exerciseName,
    Expression<String>? catalogExerciseId,
    Expression<String>? recordType,
    Expression<double>? value,
    Expression<DateTime>? achievedAtUtc,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (exerciseName != null) 'exercise_name': exerciseName,
      if (catalogExerciseId != null) 'catalog_exercise_id': catalogExerciseId,
      if (recordType != null) 'record_type': recordType,
      if (value != null) 'value': value,
      if (achievedAtUtc != null) 'achieved_at_utc': achievedAtUtc,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalPersonalRecordsCompanion copyWith({
    Value<String>? id,
    Value<String>? exerciseName,
    Value<String?>? catalogExerciseId,
    Value<String>? recordType,
    Value<double>? value,
    Value<DateTime>? achievedAtUtc,
    Value<int>? rowid,
  }) {
    return LocalPersonalRecordsCompanion(
      id: id ?? this.id,
      exerciseName: exerciseName ?? this.exerciseName,
      catalogExerciseId: catalogExerciseId ?? this.catalogExerciseId,
      recordType: recordType ?? this.recordType,
      value: value ?? this.value,
      achievedAtUtc: achievedAtUtc ?? this.achievedAtUtc,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (exerciseName.present) {
      map['exercise_name'] = Variable<String>(exerciseName.value);
    }
    if (catalogExerciseId.present) {
      map['catalog_exercise_id'] = Variable<String>(catalogExerciseId.value);
    }
    if (recordType.present) {
      map['record_type'] = Variable<String>(recordType.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (achievedAtUtc.present) {
      map['achieved_at_utc'] = Variable<DateTime>(achievedAtUtc.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalPersonalRecordsCompanion(')
          ..write('id: $id, ')
          ..write('exerciseName: $exerciseName, ')
          ..write('catalogExerciseId: $catalogExerciseId, ')
          ..write('recordType: $recordType, ')
          ..write('value: $value, ')
          ..write('achievedAtUtc: $achievedAtUtc, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WorkoutSessionsTable workoutSessions = $WorkoutSessionsTable(
    this,
  );
  late final $WorkoutExercisesTable workoutExercises = $WorkoutExercisesTable(
    this,
  );
  late final $WorkoutSetsTable workoutSets = $WorkoutSetsTable(this);
  late final $SyncOperationsTable syncOperations = $SyncOperationsTable(this);
  late final $AthleteProfilesTable athleteProfiles = $AthleteProfilesTable(
    this,
  );
  late final $ProgramsTable programs = $ProgramsTable(this);
  late final $ProgramDaysTable programDays = $ProgramDaysTable(this);
  late final $ProgramExercisesTable programExercises = $ProgramExercisesTable(
    this,
  );
  late final $LocalPersonalRecordsTable localPersonalRecords =
      $LocalPersonalRecordsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    workoutSessions,
    workoutExercises,
    workoutSets,
    syncOperations,
    athleteProfiles,
    programs,
    programDays,
    programExercises,
    localPersonalRecords,
  ];
}

typedef $$WorkoutSessionsTableCreateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      required String id,
      required String name,
      Value<String?> programDayId,
      Value<String?> programName,
      required DateTime startedAt,
      Value<DateTime?> completedAt,
      Value<int?> difficulty,
      Value<bool> painReported,
      Value<String?> readinessJson,
      Value<int> rowid,
    });
typedef $$WorkoutSessionsTableUpdateCompanionBuilder =
    WorkoutSessionsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> programDayId,
      Value<String?> programName,
      Value<DateTime> startedAt,
      Value<DateTime?> completedAt,
      Value<int?> difficulty,
      Value<bool> painReported,
      Value<String?> readinessJson,
      Value<int> rowid,
    });

class $$WorkoutSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get programDayId => $composableBuilder(
    column: $table.programDayId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get programName => $composableBuilder(
    column: $table.programName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get painReported => $composableBuilder(
    column: $table.painReported,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get readinessJson => $composableBuilder(
    column: $table.readinessJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkoutSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get programDayId => $composableBuilder(
    column: $table.programDayId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get programName => $composableBuilder(
    column: $table.programName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get painReported => $composableBuilder(
    column: $table.painReported,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get readinessJson => $composableBuilder(
    column: $table.readinessJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSessionsTable> {
  $$WorkoutSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get programDayId => $composableBuilder(
    column: $table.programDayId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get programName => $composableBuilder(
    column: $table.programName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get completedAt => $composableBuilder(
    column: $table.completedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get painReported => $composableBuilder(
    column: $table.painReported,
    builder: (column) => column,
  );

  GeneratedColumn<String> get readinessJson => $composableBuilder(
    column: $table.readinessJson,
    builder: (column) => column,
  );
}

class $$WorkoutSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSessionsTable,
          WorkoutSession,
          $$WorkoutSessionsTableFilterComposer,
          $$WorkoutSessionsTableOrderingComposer,
          $$WorkoutSessionsTableAnnotationComposer,
          $$WorkoutSessionsTableCreateCompanionBuilder,
          $$WorkoutSessionsTableUpdateCompanionBuilder,
          (
            WorkoutSession,
            BaseReferences<
              _$AppDatabase,
              $WorkoutSessionsTable,
              WorkoutSession
            >,
          ),
          WorkoutSession,
          PrefetchHooks Function()
        > {
  $$WorkoutSessionsTableTableManager(
    _$AppDatabase db,
    $WorkoutSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> programDayId = const Value.absent(),
                Value<String?> programName = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> difficulty = const Value.absent(),
                Value<bool> painReported = const Value.absent(),
                Value<String?> readinessJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion(
                id: id,
                name: name,
                programDayId: programDayId,
                programName: programName,
                startedAt: startedAt,
                completedAt: completedAt,
                difficulty: difficulty,
                painReported: painReported,
                readinessJson: readinessJson,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> programDayId = const Value.absent(),
                Value<String?> programName = const Value.absent(),
                required DateTime startedAt,
                Value<DateTime?> completedAt = const Value.absent(),
                Value<int?> difficulty = const Value.absent(),
                Value<bool> painReported = const Value.absent(),
                Value<String?> readinessJson = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSessionsCompanion.insert(
                id: id,
                name: name,
                programDayId: programDayId,
                programName: programName,
                startedAt: startedAt,
                completedAt: completedAt,
                difficulty: difficulty,
                painReported: painReported,
                readinessJson: readinessJson,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkoutSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSessionsTable,
      WorkoutSession,
      $$WorkoutSessionsTableFilterComposer,
      $$WorkoutSessionsTableOrderingComposer,
      $$WorkoutSessionsTableAnnotationComposer,
      $$WorkoutSessionsTableCreateCompanionBuilder,
      $$WorkoutSessionsTableUpdateCompanionBuilder,
      (
        WorkoutSession,
        BaseReferences<_$AppDatabase, $WorkoutSessionsTable, WorkoutSession>,
      ),
      WorkoutSession,
      PrefetchHooks Function()
    >;
typedef $$WorkoutExercisesTableCreateCompanionBuilder =
    WorkoutExercisesCompanion Function({
      required String id,
      required String sessionId,
      Value<String?> serverExerciseId,
      required String exerciseName,
      required int position,
      Value<int> targetSets,
      Value<int> minReps,
      Value<int> maxReps,
      Value<double?> suggestedWeight,
      Value<int> restSeconds,
      Value<double> loadIncrement,
      Value<String?> previousPerformanceJson,
      Value<String?> substitutedFromName,
      Value<int> rowid,
    });
typedef $$WorkoutExercisesTableUpdateCompanionBuilder =
    WorkoutExercisesCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<String?> serverExerciseId,
      Value<String> exerciseName,
      Value<int> position,
      Value<int> targetSets,
      Value<int> minReps,
      Value<int> maxReps,
      Value<double?> suggestedWeight,
      Value<int> restSeconds,
      Value<double> loadIncrement,
      Value<String?> previousPerformanceJson,
      Value<String?> substitutedFromName,
      Value<int> rowid,
    });

class $$WorkoutExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverExerciseId => $composableBuilder(
    column: $table.serverExerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minReps => $composableBuilder(
    column: $table.minReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxReps => $composableBuilder(
    column: $table.maxReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get suggestedWeight => $composableBuilder(
    column: $table.suggestedWeight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get loadIncrement => $composableBuilder(
    column: $table.loadIncrement,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get previousPerformanceJson => $composableBuilder(
    column: $table.previousPerformanceJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get substitutedFromName => $composableBuilder(
    column: $table.substitutedFromName,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkoutExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverExerciseId => $composableBuilder(
    column: $table.serverExerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minReps => $composableBuilder(
    column: $table.minReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxReps => $composableBuilder(
    column: $table.maxReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get suggestedWeight => $composableBuilder(
    column: $table.suggestedWeight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get loadIncrement => $composableBuilder(
    column: $table.loadIncrement,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get previousPerformanceJson => $composableBuilder(
    column: $table.previousPerformanceJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get substitutedFromName => $composableBuilder(
    column: $table.substitutedFromName,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutExercisesTable> {
  $$WorkoutExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<String> get serverExerciseId => $composableBuilder(
    column: $table.serverExerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get targetSets => $composableBuilder(
    column: $table.targetSets,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minReps =>
      $composableBuilder(column: $table.minReps, builder: (column) => column);

  GeneratedColumn<int> get maxReps =>
      $composableBuilder(column: $table.maxReps, builder: (column) => column);

  GeneratedColumn<double> get suggestedWeight => $composableBuilder(
    column: $table.suggestedWeight,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get loadIncrement => $composableBuilder(
    column: $table.loadIncrement,
    builder: (column) => column,
  );

  GeneratedColumn<String> get previousPerformanceJson => $composableBuilder(
    column: $table.previousPerformanceJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get substitutedFromName => $composableBuilder(
    column: $table.substitutedFromName,
    builder: (column) => column,
  );
}

class $$WorkoutExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutExercisesTable,
          WorkoutExercise,
          $$WorkoutExercisesTableFilterComposer,
          $$WorkoutExercisesTableOrderingComposer,
          $$WorkoutExercisesTableAnnotationComposer,
          $$WorkoutExercisesTableCreateCompanionBuilder,
          $$WorkoutExercisesTableUpdateCompanionBuilder,
          (
            WorkoutExercise,
            BaseReferences<
              _$AppDatabase,
              $WorkoutExercisesTable,
              WorkoutExercise
            >,
          ),
          WorkoutExercise,
          PrefetchHooks Function()
        > {
  $$WorkoutExercisesTableTableManager(
    _$AppDatabase db,
    $WorkoutExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<String?> serverExerciseId = const Value.absent(),
                Value<String> exerciseName = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> targetSets = const Value.absent(),
                Value<int> minReps = const Value.absent(),
                Value<int> maxReps = const Value.absent(),
                Value<double?> suggestedWeight = const Value.absent(),
                Value<int> restSeconds = const Value.absent(),
                Value<double> loadIncrement = const Value.absent(),
                Value<String?> previousPerformanceJson = const Value.absent(),
                Value<String?> substitutedFromName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutExercisesCompanion(
                id: id,
                sessionId: sessionId,
                serverExerciseId: serverExerciseId,
                exerciseName: exerciseName,
                position: position,
                targetSets: targetSets,
                minReps: minReps,
                maxReps: maxReps,
                suggestedWeight: suggestedWeight,
                restSeconds: restSeconds,
                loadIncrement: loadIncrement,
                previousPerformanceJson: previousPerformanceJson,
                substitutedFromName: substitutedFromName,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                Value<String?> serverExerciseId = const Value.absent(),
                required String exerciseName,
                required int position,
                Value<int> targetSets = const Value.absent(),
                Value<int> minReps = const Value.absent(),
                Value<int> maxReps = const Value.absent(),
                Value<double?> suggestedWeight = const Value.absent(),
                Value<int> restSeconds = const Value.absent(),
                Value<double> loadIncrement = const Value.absent(),
                Value<String?> previousPerformanceJson = const Value.absent(),
                Value<String?> substitutedFromName = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutExercisesCompanion.insert(
                id: id,
                sessionId: sessionId,
                serverExerciseId: serverExerciseId,
                exerciseName: exerciseName,
                position: position,
                targetSets: targetSets,
                minReps: minReps,
                maxReps: maxReps,
                suggestedWeight: suggestedWeight,
                restSeconds: restSeconds,
                loadIncrement: loadIncrement,
                previousPerformanceJson: previousPerformanceJson,
                substitutedFromName: substitutedFromName,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkoutExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutExercisesTable,
      WorkoutExercise,
      $$WorkoutExercisesTableFilterComposer,
      $$WorkoutExercisesTableOrderingComposer,
      $$WorkoutExercisesTableAnnotationComposer,
      $$WorkoutExercisesTableCreateCompanionBuilder,
      $$WorkoutExercisesTableUpdateCompanionBuilder,
      (
        WorkoutExercise,
        BaseReferences<_$AppDatabase, $WorkoutExercisesTable, WorkoutExercise>,
      ),
      WorkoutExercise,
      PrefetchHooks Function()
    >;
typedef $$WorkoutSetsTableCreateCompanionBuilder =
    WorkoutSetsCompanion Function({
      required String id,
      required String exerciseId,
      Value<int> setNumber,
      required double weight,
      required int reps,
      Value<int?> rir,
      Value<bool> isWarmup,
      Value<String?> note,
      required DateTime loggedAt,
      Value<int> rowid,
    });
typedef $$WorkoutSetsTableUpdateCompanionBuilder =
    WorkoutSetsCompanion Function({
      Value<String> id,
      Value<String> exerciseId,
      Value<int> setNumber,
      Value<double> weight,
      Value<int> reps,
      Value<int?> rir,
      Value<bool> isWarmup,
      Value<String?> note,
      Value<DateTime> loggedAt,
      Value<int> rowid,
    });

class $$WorkoutSetsTableFilterComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rir => $composableBuilder(
    column: $table.rir,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isWarmup => $composableBuilder(
    column: $table.isWarmup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WorkoutSetsTableOrderingComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get setNumber => $composableBuilder(
    column: $table.setNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weight => $composableBuilder(
    column: $table.weight,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rir => $composableBuilder(
    column: $table.rir,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isWarmup => $composableBuilder(
    column: $table.isWarmup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get loggedAt => $composableBuilder(
    column: $table.loggedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WorkoutSetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WorkoutSetsTable> {
  $$WorkoutSetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseId => $composableBuilder(
    column: $table.exerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get setNumber =>
      $composableBuilder(column: $table.setNumber, builder: (column) => column);

  GeneratedColumn<double> get weight =>
      $composableBuilder(column: $table.weight, builder: (column) => column);

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get rir =>
      $composableBuilder(column: $table.rir, builder: (column) => column);

  GeneratedColumn<bool> get isWarmup =>
      $composableBuilder(column: $table.isWarmup, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get loggedAt =>
      $composableBuilder(column: $table.loggedAt, builder: (column) => column);
}

class $$WorkoutSetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WorkoutSetsTable,
          WorkoutSet,
          $$WorkoutSetsTableFilterComposer,
          $$WorkoutSetsTableOrderingComposer,
          $$WorkoutSetsTableAnnotationComposer,
          $$WorkoutSetsTableCreateCompanionBuilder,
          $$WorkoutSetsTableUpdateCompanionBuilder,
          (
            WorkoutSet,
            BaseReferences<_$AppDatabase, $WorkoutSetsTable, WorkoutSet>,
          ),
          WorkoutSet,
          PrefetchHooks Function()
        > {
  $$WorkoutSetsTableTableManager(_$AppDatabase db, $WorkoutSetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WorkoutSetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WorkoutSetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WorkoutSetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> exerciseId = const Value.absent(),
                Value<int> setNumber = const Value.absent(),
                Value<double> weight = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<int?> rir = const Value.absent(),
                Value<bool> isWarmup = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> loggedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSetsCompanion(
                id: id,
                exerciseId: exerciseId,
                setNumber: setNumber,
                weight: weight,
                reps: reps,
                rir: rir,
                isWarmup: isWarmup,
                note: note,
                loggedAt: loggedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String exerciseId,
                Value<int> setNumber = const Value.absent(),
                required double weight,
                required int reps,
                Value<int?> rir = const Value.absent(),
                Value<bool> isWarmup = const Value.absent(),
                Value<String?> note = const Value.absent(),
                required DateTime loggedAt,
                Value<int> rowid = const Value.absent(),
              }) => WorkoutSetsCompanion.insert(
                id: id,
                exerciseId: exerciseId,
                setNumber: setNumber,
                weight: weight,
                reps: reps,
                rir: rir,
                isWarmup: isWarmup,
                note: note,
                loggedAt: loggedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WorkoutSetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WorkoutSetsTable,
      WorkoutSet,
      $$WorkoutSetsTableFilterComposer,
      $$WorkoutSetsTableOrderingComposer,
      $$WorkoutSetsTableAnnotationComposer,
      $$WorkoutSetsTableCreateCompanionBuilder,
      $$WorkoutSetsTableUpdateCompanionBuilder,
      (
        WorkoutSet,
        BaseReferences<_$AppDatabase, $WorkoutSetsTable, WorkoutSet>,
      ),
      WorkoutSet,
      PrefetchHooks Function()
    >;
typedef $$SyncOperationsTableCreateCompanionBuilder =
    SyncOperationsCompanion Function({
      required String id,
      required String entityType,
      required String entityId,
      required String operation,
      required String payload,
      Value<int> attempts,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$SyncOperationsTableUpdateCompanionBuilder =
    SyncOperationsCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> operation,
      Value<String> payload,
      Value<int> attempts,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$SyncOperationsTableFilterComposer
    extends Composer<_$AppDatabase, $SyncOperationsTable> {
  $$SyncOperationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncOperationsTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncOperationsTable> {
  $$SyncOperationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get operation => $composableBuilder(
    column: $table.operation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncOperationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncOperationsTable> {
  $$SyncOperationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get operation =>
      $composableBuilder(column: $table.operation, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<int> get attempts =>
      $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SyncOperationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncOperationsTable,
          SyncOperation,
          $$SyncOperationsTableFilterComposer,
          $$SyncOperationsTableOrderingComposer,
          $$SyncOperationsTableAnnotationComposer,
          $$SyncOperationsTableCreateCompanionBuilder,
          $$SyncOperationsTableUpdateCompanionBuilder,
          (
            SyncOperation,
            BaseReferences<_$AppDatabase, $SyncOperationsTable, SyncOperation>,
          ),
          SyncOperation,
          PrefetchHooks Function()
        > {
  $$SyncOperationsTableTableManager(
    _$AppDatabase db,
    $SyncOperationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncOperationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncOperationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncOperationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> operation = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncOperationsCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payload: payload,
                attempts: attempts,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                required String entityId,
                required String operation,
                required String payload,
                Value<int> attempts = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncOperationsCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                operation: operation,
                payload: payload,
                attempts: attempts,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncOperationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncOperationsTable,
      SyncOperation,
      $$SyncOperationsTableFilterComposer,
      $$SyncOperationsTableOrderingComposer,
      $$SyncOperationsTableAnnotationComposer,
      $$SyncOperationsTableCreateCompanionBuilder,
      $$SyncOperationsTableUpdateCompanionBuilder,
      (
        SyncOperation,
        BaseReferences<_$AppDatabase, $SyncOperationsTable, SyncOperation>,
      ),
      SyncOperation,
      PrefetchHooks Function()
    >;
typedef $$AthleteProfilesTableCreateCompanionBuilder =
    AthleteProfilesCompanion Function({
      required String id,
      required String displayName,
      required int age,
      Value<int> sex,
      required double heightCm,
      required double bodyWeightKg,
      Value<int> experience,
      Value<double> yearsTraining,
      Value<int> primaryGoal,
      Value<int?> secondaryGoal,
      Value<int> trainingDaysPerWeek,
      Value<int> preferredSessionMinutes,
      Value<int> equipmentSetting,
      Value<String?> injuryNotes,
      Value<double?> baselineBenchKg,
      Value<bool> onboardingCompleted,
      Value<String?> lastCompletedProgramDayId,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AthleteProfilesTableUpdateCompanionBuilder =
    AthleteProfilesCompanion Function({
      Value<String> id,
      Value<String> displayName,
      Value<int> age,
      Value<int> sex,
      Value<double> heightCm,
      Value<double> bodyWeightKg,
      Value<int> experience,
      Value<double> yearsTraining,
      Value<int> primaryGoal,
      Value<int?> secondaryGoal,
      Value<int> trainingDaysPerWeek,
      Value<int> preferredSessionMinutes,
      Value<int> equipmentSetting,
      Value<String?> injuryNotes,
      Value<double?> baselineBenchKg,
      Value<bool> onboardingCompleted,
      Value<String?> lastCompletedProgramDayId,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AthleteProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $AthleteProfilesTable> {
  $$AthleteProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get bodyWeightKg => $composableBuilder(
    column: $table.bodyWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get experience => $composableBuilder(
    column: $table.experience,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get yearsTraining => $composableBuilder(
    column: $table.yearsTraining,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get primaryGoal => $composableBuilder(
    column: $table.primaryGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get secondaryGoal => $composableBuilder(
    column: $table.secondaryGoal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get trainingDaysPerWeek => $composableBuilder(
    column: $table.trainingDaysPerWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get preferredSessionMinutes => $composableBuilder(
    column: $table.preferredSessionMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get equipmentSetting => $composableBuilder(
    column: $table.equipmentSetting,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get injuryNotes => $composableBuilder(
    column: $table.injuryNotes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get baselineBenchKg => $composableBuilder(
    column: $table.baselineBenchKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastCompletedProgramDayId => $composableBuilder(
    column: $table.lastCompletedProgramDayId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AthleteProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $AthleteProfilesTable> {
  $$AthleteProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get bodyWeightKg => $composableBuilder(
    column: $table.bodyWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get experience => $composableBuilder(
    column: $table.experience,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get yearsTraining => $composableBuilder(
    column: $table.yearsTraining,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get primaryGoal => $composableBuilder(
    column: $table.primaryGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get secondaryGoal => $composableBuilder(
    column: $table.secondaryGoal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get trainingDaysPerWeek => $composableBuilder(
    column: $table.trainingDaysPerWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get preferredSessionMinutes => $composableBuilder(
    column: $table.preferredSessionMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get equipmentSetting => $composableBuilder(
    column: $table.equipmentSetting,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get injuryNotes => $composableBuilder(
    column: $table.injuryNotes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get baselineBenchKg => $composableBuilder(
    column: $table.baselineBenchKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastCompletedProgramDayId => $composableBuilder(
    column: $table.lastCompletedProgramDayId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AthleteProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AthleteProfilesTable> {
  $$AthleteProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<int> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<double> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get bodyWeightKg => $composableBuilder(
    column: $table.bodyWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<int> get experience => $composableBuilder(
    column: $table.experience,
    builder: (column) => column,
  );

  GeneratedColumn<double> get yearsTraining => $composableBuilder(
    column: $table.yearsTraining,
    builder: (column) => column,
  );

  GeneratedColumn<int> get primaryGoal => $composableBuilder(
    column: $table.primaryGoal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get secondaryGoal => $composableBuilder(
    column: $table.secondaryGoal,
    builder: (column) => column,
  );

  GeneratedColumn<int> get trainingDaysPerWeek => $composableBuilder(
    column: $table.trainingDaysPerWeek,
    builder: (column) => column,
  );

  GeneratedColumn<int> get preferredSessionMinutes => $composableBuilder(
    column: $table.preferredSessionMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get equipmentSetting => $composableBuilder(
    column: $table.equipmentSetting,
    builder: (column) => column,
  );

  GeneratedColumn<String> get injuryNotes => $composableBuilder(
    column: $table.injuryNotes,
    builder: (column) => column,
  );

  GeneratedColumn<double> get baselineBenchKg => $composableBuilder(
    column: $table.baselineBenchKg,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastCompletedProgramDayId => $composableBuilder(
    column: $table.lastCompletedProgramDayId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AthleteProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AthleteProfilesTable,
          AthleteProfile,
          $$AthleteProfilesTableFilterComposer,
          $$AthleteProfilesTableOrderingComposer,
          $$AthleteProfilesTableAnnotationComposer,
          $$AthleteProfilesTableCreateCompanionBuilder,
          $$AthleteProfilesTableUpdateCompanionBuilder,
          (
            AthleteProfile,
            BaseReferences<
              _$AppDatabase,
              $AthleteProfilesTable,
              AthleteProfile
            >,
          ),
          AthleteProfile,
          PrefetchHooks Function()
        > {
  $$AthleteProfilesTableTableManager(
    _$AppDatabase db,
    $AthleteProfilesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AthleteProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AthleteProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AthleteProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<int> sex = const Value.absent(),
                Value<double> heightCm = const Value.absent(),
                Value<double> bodyWeightKg = const Value.absent(),
                Value<int> experience = const Value.absent(),
                Value<double> yearsTraining = const Value.absent(),
                Value<int> primaryGoal = const Value.absent(),
                Value<int?> secondaryGoal = const Value.absent(),
                Value<int> trainingDaysPerWeek = const Value.absent(),
                Value<int> preferredSessionMinutes = const Value.absent(),
                Value<int> equipmentSetting = const Value.absent(),
                Value<String?> injuryNotes = const Value.absent(),
                Value<double?> baselineBenchKg = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<String?> lastCompletedProgramDayId = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AthleteProfilesCompanion(
                id: id,
                displayName: displayName,
                age: age,
                sex: sex,
                heightCm: heightCm,
                bodyWeightKg: bodyWeightKg,
                experience: experience,
                yearsTraining: yearsTraining,
                primaryGoal: primaryGoal,
                secondaryGoal: secondaryGoal,
                trainingDaysPerWeek: trainingDaysPerWeek,
                preferredSessionMinutes: preferredSessionMinutes,
                equipmentSetting: equipmentSetting,
                injuryNotes: injuryNotes,
                baselineBenchKg: baselineBenchKg,
                onboardingCompleted: onboardingCompleted,
                lastCompletedProgramDayId: lastCompletedProgramDayId,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String displayName,
                required int age,
                Value<int> sex = const Value.absent(),
                required double heightCm,
                required double bodyWeightKg,
                Value<int> experience = const Value.absent(),
                Value<double> yearsTraining = const Value.absent(),
                Value<int> primaryGoal = const Value.absent(),
                Value<int?> secondaryGoal = const Value.absent(),
                Value<int> trainingDaysPerWeek = const Value.absent(),
                Value<int> preferredSessionMinutes = const Value.absent(),
                Value<int> equipmentSetting = const Value.absent(),
                Value<String?> injuryNotes = const Value.absent(),
                Value<double?> baselineBenchKg = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<String?> lastCompletedProgramDayId = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AthleteProfilesCompanion.insert(
                id: id,
                displayName: displayName,
                age: age,
                sex: sex,
                heightCm: heightCm,
                bodyWeightKg: bodyWeightKg,
                experience: experience,
                yearsTraining: yearsTraining,
                primaryGoal: primaryGoal,
                secondaryGoal: secondaryGoal,
                trainingDaysPerWeek: trainingDaysPerWeek,
                preferredSessionMinutes: preferredSessionMinutes,
                equipmentSetting: equipmentSetting,
                injuryNotes: injuryNotes,
                baselineBenchKg: baselineBenchKg,
                onboardingCompleted: onboardingCompleted,
                lastCompletedProgramDayId: lastCompletedProgramDayId,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AthleteProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AthleteProfilesTable,
      AthleteProfile,
      $$AthleteProfilesTableFilterComposer,
      $$AthleteProfilesTableOrderingComposer,
      $$AthleteProfilesTableAnnotationComposer,
      $$AthleteProfilesTableCreateCompanionBuilder,
      $$AthleteProfilesTableUpdateCompanionBuilder,
      (
        AthleteProfile,
        BaseReferences<_$AppDatabase, $AthleteProfilesTable, AthleteProfile>,
      ),
      AthleteProfile,
      PrefetchHooks Function()
    >;
typedef $$ProgramsTableCreateCompanionBuilder =
    ProgramsCompanion Function({
      required String id,
      required String name,
      Value<String> status,
      required DateTime startDateUtc,
      Value<DateTime?> endDateUtc,
      Value<int> currentVersionNumber,
      Value<String?> reason,
      Value<int> rowid,
    });
typedef $$ProgramsTableUpdateCompanionBuilder =
    ProgramsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String> status,
      Value<DateTime> startDateUtc,
      Value<DateTime?> endDateUtc,
      Value<int> currentVersionNumber,
      Value<String?> reason,
      Value<int> rowid,
    });

class $$ProgramsTableFilterComposer
    extends Composer<_$AppDatabase, $ProgramsTable> {
  $$ProgramsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDateUtc => $composableBuilder(
    column: $table.startDateUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDateUtc => $composableBuilder(
    column: $table.endDateUtc,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentVersionNumber => $composableBuilder(
    column: $table.currentVersionNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProgramsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgramsTable> {
  $$ProgramsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDateUtc => $composableBuilder(
    column: $table.startDateUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDateUtc => $composableBuilder(
    column: $table.endDateUtc,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentVersionNumber => $composableBuilder(
    column: $table.currentVersionNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reason => $composableBuilder(
    column: $table.reason,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProgramsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgramsTable> {
  $$ProgramsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startDateUtc => $composableBuilder(
    column: $table.startDateUtc,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get endDateUtc => $composableBuilder(
    column: $table.endDateUtc,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentVersionNumber => $composableBuilder(
    column: $table.currentVersionNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reason =>
      $composableBuilder(column: $table.reason, builder: (column) => column);
}

class $$ProgramsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgramsTable,
          Program,
          $$ProgramsTableFilterComposer,
          $$ProgramsTableOrderingComposer,
          $$ProgramsTableAnnotationComposer,
          $$ProgramsTableCreateCompanionBuilder,
          $$ProgramsTableUpdateCompanionBuilder,
          (Program, BaseReferences<_$AppDatabase, $ProgramsTable, Program>),
          Program,
          PrefetchHooks Function()
        > {
  $$ProgramsTableTableManager(_$AppDatabase db, $ProgramsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgramsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgramsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgramsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> startDateUtc = const Value.absent(),
                Value<DateTime?> endDateUtc = const Value.absent(),
                Value<int> currentVersionNumber = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgramsCompanion(
                id: id,
                name: name,
                status: status,
                startDateUtc: startDateUtc,
                endDateUtc: endDateUtc,
                currentVersionNumber: currentVersionNumber,
                reason: reason,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String> status = const Value.absent(),
                required DateTime startDateUtc,
                Value<DateTime?> endDateUtc = const Value.absent(),
                Value<int> currentVersionNumber = const Value.absent(),
                Value<String?> reason = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgramsCompanion.insert(
                id: id,
                name: name,
                status: status,
                startDateUtc: startDateUtc,
                endDateUtc: endDateUtc,
                currentVersionNumber: currentVersionNumber,
                reason: reason,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProgramsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgramsTable,
      Program,
      $$ProgramsTableFilterComposer,
      $$ProgramsTableOrderingComposer,
      $$ProgramsTableAnnotationComposer,
      $$ProgramsTableCreateCompanionBuilder,
      $$ProgramsTableUpdateCompanionBuilder,
      (Program, BaseReferences<_$AppDatabase, $ProgramsTable, Program>),
      Program,
      PrefetchHooks Function()
    >;
typedef $$ProgramDaysTableCreateCompanionBuilder =
    ProgramDaysCompanion Function({
      required String id,
      required String programId,
      required int dayIndex,
      required String name,
      required String split,
      Value<int> rowid,
    });
typedef $$ProgramDaysTableUpdateCompanionBuilder =
    ProgramDaysCompanion Function({
      Value<String> id,
      Value<String> programId,
      Value<int> dayIndex,
      Value<String> name,
      Value<String> split,
      Value<int> rowid,
    });

class $$ProgramDaysTableFilterComposer
    extends Composer<_$AppDatabase, $ProgramDaysTable> {
  $$ProgramDaysTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get programId => $composableBuilder(
    column: $table.programId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get split => $composableBuilder(
    column: $table.split,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProgramDaysTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgramDaysTable> {
  $$ProgramDaysTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get programId => $composableBuilder(
    column: $table.programId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayIndex => $composableBuilder(
    column: $table.dayIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get split => $composableBuilder(
    column: $table.split,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProgramDaysTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgramDaysTable> {
  $$ProgramDaysTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get programId =>
      $composableBuilder(column: $table.programId, builder: (column) => column);

  GeneratedColumn<int> get dayIndex =>
      $composableBuilder(column: $table.dayIndex, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get split =>
      $composableBuilder(column: $table.split, builder: (column) => column);
}

class $$ProgramDaysTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgramDaysTable,
          ProgramDay,
          $$ProgramDaysTableFilterComposer,
          $$ProgramDaysTableOrderingComposer,
          $$ProgramDaysTableAnnotationComposer,
          $$ProgramDaysTableCreateCompanionBuilder,
          $$ProgramDaysTableUpdateCompanionBuilder,
          (
            ProgramDay,
            BaseReferences<_$AppDatabase, $ProgramDaysTable, ProgramDay>,
          ),
          ProgramDay,
          PrefetchHooks Function()
        > {
  $$ProgramDaysTableTableManager(_$AppDatabase db, $ProgramDaysTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgramDaysTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgramDaysTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgramDaysTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> programId = const Value.absent(),
                Value<int> dayIndex = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> split = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgramDaysCompanion(
                id: id,
                programId: programId,
                dayIndex: dayIndex,
                name: name,
                split: split,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String programId,
                required int dayIndex,
                required String name,
                required String split,
                Value<int> rowid = const Value.absent(),
              }) => ProgramDaysCompanion.insert(
                id: id,
                programId: programId,
                dayIndex: dayIndex,
                name: name,
                split: split,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProgramDaysTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgramDaysTable,
      ProgramDay,
      $$ProgramDaysTableFilterComposer,
      $$ProgramDaysTableOrderingComposer,
      $$ProgramDaysTableAnnotationComposer,
      $$ProgramDaysTableCreateCompanionBuilder,
      $$ProgramDaysTableUpdateCompanionBuilder,
      (
        ProgramDay,
        BaseReferences<_$AppDatabase, $ProgramDaysTable, ProgramDay>,
      ),
      ProgramDay,
      PrefetchHooks Function()
    >;
typedef $$ProgramExercisesTableCreateCompanionBuilder =
    ProgramExercisesCompanion Function({
      required String id,
      required String programDayId,
      required String catalogExerciseId,
      required String exerciseName,
      required int position,
      required int sets,
      required int minReps,
      required int maxReps,
      Value<double?> startingLoadKg,
      Value<int> restSeconds,
      Value<double?> targetRir,
      Value<bool> isCompound,
      Value<double> loadIncrementKg,
      Value<int> rowid,
    });
typedef $$ProgramExercisesTableUpdateCompanionBuilder =
    ProgramExercisesCompanion Function({
      Value<String> id,
      Value<String> programDayId,
      Value<String> catalogExerciseId,
      Value<String> exerciseName,
      Value<int> position,
      Value<int> sets,
      Value<int> minReps,
      Value<int> maxReps,
      Value<double?> startingLoadKg,
      Value<int> restSeconds,
      Value<double?> targetRir,
      Value<bool> isCompound,
      Value<double> loadIncrementKg,
      Value<int> rowid,
    });

class $$ProgramExercisesTableFilterComposer
    extends Composer<_$AppDatabase, $ProgramExercisesTable> {
  $$ProgramExercisesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get programDayId => $composableBuilder(
    column: $table.programDayId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catalogExerciseId => $composableBuilder(
    column: $table.catalogExerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sets => $composableBuilder(
    column: $table.sets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minReps => $composableBuilder(
    column: $table.minReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get maxReps => $composableBuilder(
    column: $table.maxReps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get startingLoadKg => $composableBuilder(
    column: $table.startingLoadKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetRir => $composableBuilder(
    column: $table.targetRir,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompound => $composableBuilder(
    column: $table.isCompound,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get loadIncrementKg => $composableBuilder(
    column: $table.loadIncrementKg,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ProgramExercisesTableOrderingComposer
    extends Composer<_$AppDatabase, $ProgramExercisesTable> {
  $$ProgramExercisesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get programDayId => $composableBuilder(
    column: $table.programDayId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catalogExerciseId => $composableBuilder(
    column: $table.catalogExerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get position => $composableBuilder(
    column: $table.position,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sets => $composableBuilder(
    column: $table.sets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minReps => $composableBuilder(
    column: $table.minReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maxReps => $composableBuilder(
    column: $table.maxReps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get startingLoadKg => $composableBuilder(
    column: $table.startingLoadKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetRir => $composableBuilder(
    column: $table.targetRir,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompound => $composableBuilder(
    column: $table.isCompound,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get loadIncrementKg => $composableBuilder(
    column: $table.loadIncrementKg,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProgramExercisesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProgramExercisesTable> {
  $$ProgramExercisesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get programDayId => $composableBuilder(
    column: $table.programDayId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get catalogExerciseId => $composableBuilder(
    column: $table.catalogExerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => column,
  );

  GeneratedColumn<int> get position =>
      $composableBuilder(column: $table.position, builder: (column) => column);

  GeneratedColumn<int> get sets =>
      $composableBuilder(column: $table.sets, builder: (column) => column);

  GeneratedColumn<int> get minReps =>
      $composableBuilder(column: $table.minReps, builder: (column) => column);

  GeneratedColumn<int> get maxReps =>
      $composableBuilder(column: $table.maxReps, builder: (column) => column);

  GeneratedColumn<double> get startingLoadKg => $composableBuilder(
    column: $table.startingLoadKg,
    builder: (column) => column,
  );

  GeneratedColumn<int> get restSeconds => $composableBuilder(
    column: $table.restSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<double> get targetRir =>
      $composableBuilder(column: $table.targetRir, builder: (column) => column);

  GeneratedColumn<bool> get isCompound => $composableBuilder(
    column: $table.isCompound,
    builder: (column) => column,
  );

  GeneratedColumn<double> get loadIncrementKg => $composableBuilder(
    column: $table.loadIncrementKg,
    builder: (column) => column,
  );
}

class $$ProgramExercisesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProgramExercisesTable,
          ProgramExercise,
          $$ProgramExercisesTableFilterComposer,
          $$ProgramExercisesTableOrderingComposer,
          $$ProgramExercisesTableAnnotationComposer,
          $$ProgramExercisesTableCreateCompanionBuilder,
          $$ProgramExercisesTableUpdateCompanionBuilder,
          (
            ProgramExercise,
            BaseReferences<
              _$AppDatabase,
              $ProgramExercisesTable,
              ProgramExercise
            >,
          ),
          ProgramExercise,
          PrefetchHooks Function()
        > {
  $$ProgramExercisesTableTableManager(
    _$AppDatabase db,
    $ProgramExercisesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProgramExercisesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProgramExercisesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProgramExercisesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> programDayId = const Value.absent(),
                Value<String> catalogExerciseId = const Value.absent(),
                Value<String> exerciseName = const Value.absent(),
                Value<int> position = const Value.absent(),
                Value<int> sets = const Value.absent(),
                Value<int> minReps = const Value.absent(),
                Value<int> maxReps = const Value.absent(),
                Value<double?> startingLoadKg = const Value.absent(),
                Value<int> restSeconds = const Value.absent(),
                Value<double?> targetRir = const Value.absent(),
                Value<bool> isCompound = const Value.absent(),
                Value<double> loadIncrementKg = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgramExercisesCompanion(
                id: id,
                programDayId: programDayId,
                catalogExerciseId: catalogExerciseId,
                exerciseName: exerciseName,
                position: position,
                sets: sets,
                minReps: minReps,
                maxReps: maxReps,
                startingLoadKg: startingLoadKg,
                restSeconds: restSeconds,
                targetRir: targetRir,
                isCompound: isCompound,
                loadIncrementKg: loadIncrementKg,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String programDayId,
                required String catalogExerciseId,
                required String exerciseName,
                required int position,
                required int sets,
                required int minReps,
                required int maxReps,
                Value<double?> startingLoadKg = const Value.absent(),
                Value<int> restSeconds = const Value.absent(),
                Value<double?> targetRir = const Value.absent(),
                Value<bool> isCompound = const Value.absent(),
                Value<double> loadIncrementKg = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProgramExercisesCompanion.insert(
                id: id,
                programDayId: programDayId,
                catalogExerciseId: catalogExerciseId,
                exerciseName: exerciseName,
                position: position,
                sets: sets,
                minReps: minReps,
                maxReps: maxReps,
                startingLoadKg: startingLoadKg,
                restSeconds: restSeconds,
                targetRir: targetRir,
                isCompound: isCompound,
                loadIncrementKg: loadIncrementKg,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ProgramExercisesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProgramExercisesTable,
      ProgramExercise,
      $$ProgramExercisesTableFilterComposer,
      $$ProgramExercisesTableOrderingComposer,
      $$ProgramExercisesTableAnnotationComposer,
      $$ProgramExercisesTableCreateCompanionBuilder,
      $$ProgramExercisesTableUpdateCompanionBuilder,
      (
        ProgramExercise,
        BaseReferences<_$AppDatabase, $ProgramExercisesTable, ProgramExercise>,
      ),
      ProgramExercise,
      PrefetchHooks Function()
    >;
typedef $$LocalPersonalRecordsTableCreateCompanionBuilder =
    LocalPersonalRecordsCompanion Function({
      required String id,
      required String exerciseName,
      Value<String?> catalogExerciseId,
      required String recordType,
      required double value,
      required DateTime achievedAtUtc,
      Value<int> rowid,
    });
typedef $$LocalPersonalRecordsTableUpdateCompanionBuilder =
    LocalPersonalRecordsCompanion Function({
      Value<String> id,
      Value<String> exerciseName,
      Value<String?> catalogExerciseId,
      Value<String> recordType,
      Value<double> value,
      Value<DateTime> achievedAtUtc,
      Value<int> rowid,
    });

class $$LocalPersonalRecordsTableFilterComposer
    extends Composer<_$AppDatabase, $LocalPersonalRecordsTable> {
  $$LocalPersonalRecordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get catalogExerciseId => $composableBuilder(
    column: $table.catalogExerciseId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get achievedAtUtc => $composableBuilder(
    column: $table.achievedAtUtc,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalPersonalRecordsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocalPersonalRecordsTable> {
  $$LocalPersonalRecordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get catalogExerciseId => $composableBuilder(
    column: $table.catalogExerciseId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get achievedAtUtc => $composableBuilder(
    column: $table.achievedAtUtc,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalPersonalRecordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocalPersonalRecordsTable> {
  $$LocalPersonalRecordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get exerciseName => $composableBuilder(
    column: $table.exerciseName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get catalogExerciseId => $composableBuilder(
    column: $table.catalogExerciseId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordType => $composableBuilder(
    column: $table.recordType,
    builder: (column) => column,
  );

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get achievedAtUtc => $composableBuilder(
    column: $table.achievedAtUtc,
    builder: (column) => column,
  );
}

class $$LocalPersonalRecordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocalPersonalRecordsTable,
          LocalPersonalRecord,
          $$LocalPersonalRecordsTableFilterComposer,
          $$LocalPersonalRecordsTableOrderingComposer,
          $$LocalPersonalRecordsTableAnnotationComposer,
          $$LocalPersonalRecordsTableCreateCompanionBuilder,
          $$LocalPersonalRecordsTableUpdateCompanionBuilder,
          (
            LocalPersonalRecord,
            BaseReferences<
              _$AppDatabase,
              $LocalPersonalRecordsTable,
              LocalPersonalRecord
            >,
          ),
          LocalPersonalRecord,
          PrefetchHooks Function()
        > {
  $$LocalPersonalRecordsTableTableManager(
    _$AppDatabase db,
    $LocalPersonalRecordsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocalPersonalRecordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocalPersonalRecordsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LocalPersonalRecordsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> exerciseName = const Value.absent(),
                Value<String?> catalogExerciseId = const Value.absent(),
                Value<String> recordType = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<DateTime> achievedAtUtc = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalPersonalRecordsCompanion(
                id: id,
                exerciseName: exerciseName,
                catalogExerciseId: catalogExerciseId,
                recordType: recordType,
                value: value,
                achievedAtUtc: achievedAtUtc,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String exerciseName,
                Value<String?> catalogExerciseId = const Value.absent(),
                required String recordType,
                required double value,
                required DateTime achievedAtUtc,
                Value<int> rowid = const Value.absent(),
              }) => LocalPersonalRecordsCompanion.insert(
                id: id,
                exerciseName: exerciseName,
                catalogExerciseId: catalogExerciseId,
                recordType: recordType,
                value: value,
                achievedAtUtc: achievedAtUtc,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalPersonalRecordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocalPersonalRecordsTable,
      LocalPersonalRecord,
      $$LocalPersonalRecordsTableFilterComposer,
      $$LocalPersonalRecordsTableOrderingComposer,
      $$LocalPersonalRecordsTableAnnotationComposer,
      $$LocalPersonalRecordsTableCreateCompanionBuilder,
      $$LocalPersonalRecordsTableUpdateCompanionBuilder,
      (
        LocalPersonalRecord,
        BaseReferences<
          _$AppDatabase,
          $LocalPersonalRecordsTable,
          LocalPersonalRecord
        >,
      ),
      LocalPersonalRecord,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WorkoutSessionsTableTableManager get workoutSessions =>
      $$WorkoutSessionsTableTableManager(_db, _db.workoutSessions);
  $$WorkoutExercisesTableTableManager get workoutExercises =>
      $$WorkoutExercisesTableTableManager(_db, _db.workoutExercises);
  $$WorkoutSetsTableTableManager get workoutSets =>
      $$WorkoutSetsTableTableManager(_db, _db.workoutSets);
  $$SyncOperationsTableTableManager get syncOperations =>
      $$SyncOperationsTableTableManager(_db, _db.syncOperations);
  $$AthleteProfilesTableTableManager get athleteProfiles =>
      $$AthleteProfilesTableTableManager(_db, _db.athleteProfiles);
  $$ProgramsTableTableManager get programs =>
      $$ProgramsTableTableManager(_db, _db.programs);
  $$ProgramDaysTableTableManager get programDays =>
      $$ProgramDaysTableTableManager(_db, _db.programDays);
  $$ProgramExercisesTableTableManager get programExercises =>
      $$ProgramExercisesTableTableManager(_db, _db.programExercises);
  $$LocalPersonalRecordsTableTableManager get localPersonalRecords =>
      $$LocalPersonalRecordsTableTableManager(_db, _db.localPersonalRecords);
}
