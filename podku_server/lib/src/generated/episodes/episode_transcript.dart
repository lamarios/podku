/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../podcast/episode.dart' as _i2;
import 'package:podku_server/src/generated/protocol.dart' as _i3;

abstract class EpisodeTranscript
    implements _i1.TableRow<_i1.UuidValue>, _i1.ProtocolSerialization {
  EpisodeTranscript._({
    _i1.UuidValue? id,
    required this.startTime,
    required this.endTime,
    this.speaker,
    required this.content,
    this.language,
    required this.episodeId,
    this.episode,
  }) : id = id ?? const _i1.Uuid().v4obj();

  factory EpisodeTranscript({
    _i1.UuidValue? id,
    required String startTime,
    required String endTime,
    String? speaker,
    required String content,
    String? language,
    required _i1.UuidValue episodeId,
    _i2.Episode? episode,
  }) = _EpisodeTranscriptImpl;

  factory EpisodeTranscript.fromJson(Map<String, dynamic> jsonSerialization) {
    return EpisodeTranscript(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      startTime: jsonSerialization['startTime'] as String,
      endTime: jsonSerialization['endTime'] as String,
      speaker: jsonSerialization['speaker'] as String?,
      content: jsonSerialization['content'] as String,
      language: jsonSerialization['language'] as String?,
      episodeId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['episodeId'],
      ),
      episode: jsonSerialization['episode'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Episode>(
              jsonSerialization['episode'],
            ),
    );
  }

  static final t = EpisodeTranscriptTable();

  static const db = EpisodeTranscriptRepository._();

  @override
  _i1.UuidValue id;

  String startTime;

  String endTime;

  String? speaker;

  String content;

  String? language;

  _i1.UuidValue episodeId;

  _i2.Episode? episode;

  @override
  _i1.Table<_i1.UuidValue> get table => t;

  /// Returns a shallow copy of this [EpisodeTranscript]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EpisodeTranscript copyWith({
    _i1.UuidValue? id,
    String? startTime,
    String? endTime,
    String? speaker,
    String? content,
    String? language,
    _i1.UuidValue? episodeId,
    _i2.Episode? episode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EpisodeTranscript',
      'id': id.toJson(),
      'startTime': startTime,
      'endTime': endTime,
      if (speaker != null) 'speaker': speaker,
      'content': content,
      if (language != null) 'language': language,
      'episodeId': episodeId.toJson(),
      if (episode != null) 'episode': episode?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EpisodeTranscript',
      'id': id.toJson(),
      'startTime': startTime,
      'endTime': endTime,
      if (speaker != null) 'speaker': speaker,
      'content': content,
      if (language != null) 'language': language,
      'episodeId': episodeId.toJson(),
      if (episode != null) 'episode': episode?.toJsonForProtocol(),
    };
  }

  static EpisodeTranscriptInclude include({_i2.EpisodeInclude? episode}) {
    return EpisodeTranscriptInclude._(episode: episode);
  }

  static EpisodeTranscriptIncludeList includeList({
    _i1.WhereExpressionBuilder<EpisodeTranscriptTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EpisodeTranscriptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EpisodeTranscriptTable>? orderByList,
    EpisodeTranscriptInclude? include,
  }) {
    return EpisodeTranscriptIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EpisodeTranscript.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EpisodeTranscript.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EpisodeTranscriptImpl extends EpisodeTranscript {
  _EpisodeTranscriptImpl({
    _i1.UuidValue? id,
    required String startTime,
    required String endTime,
    String? speaker,
    required String content,
    String? language,
    required _i1.UuidValue episodeId,
    _i2.Episode? episode,
  }) : super._(
         id: id,
         startTime: startTime,
         endTime: endTime,
         speaker: speaker,
         content: content,
         language: language,
         episodeId: episodeId,
         episode: episode,
       );

  /// Returns a shallow copy of this [EpisodeTranscript]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EpisodeTranscript copyWith({
    _i1.UuidValue? id,
    String? startTime,
    String? endTime,
    Object? speaker = _Undefined,
    String? content,
    Object? language = _Undefined,
    _i1.UuidValue? episodeId,
    Object? episode = _Undefined,
  }) {
    return EpisodeTranscript(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      speaker: speaker is String? ? speaker : this.speaker,
      content: content ?? this.content,
      language: language is String? ? language : this.language,
      episodeId: episodeId ?? this.episodeId,
      episode: episode is _i2.Episode? ? episode : this.episode?.copyWith(),
    );
  }
}

class EpisodeTranscriptUpdateTable
    extends _i1.UpdateTable<EpisodeTranscriptTable> {
  EpisodeTranscriptUpdateTable(super.table);

  _i1.ColumnValue<String, String> startTime(String value) => _i1.ColumnValue(
    table.startTime,
    value,
  );

  _i1.ColumnValue<String, String> endTime(String value) => _i1.ColumnValue(
    table.endTime,
    value,
  );

  _i1.ColumnValue<String, String> speaker(String? value) => _i1.ColumnValue(
    table.speaker,
    value,
  );

  _i1.ColumnValue<String, String> content(String value) => _i1.ColumnValue(
    table.content,
    value,
  );

  _i1.ColumnValue<String, String> language(String? value) => _i1.ColumnValue(
    table.language,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> episodeId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.episodeId,
    value,
  );
}

class EpisodeTranscriptTable extends _i1.Table<_i1.UuidValue> {
  EpisodeTranscriptTable({super.tableRelation})
    : super(tableName: 'episode_transcripts') {
    updateTable = EpisodeTranscriptUpdateTable(this);
    startTime = _i1.ColumnString(
      'startTime',
      this,
    );
    endTime = _i1.ColumnString(
      'endTime',
      this,
    );
    speaker = _i1.ColumnString(
      'speaker',
      this,
    );
    content = _i1.ColumnString(
      'content',
      this,
    );
    language = _i1.ColumnString(
      'language',
      this,
    );
    episodeId = _i1.ColumnUuid(
      'episodeId',
      this,
    );
  }

  late final EpisodeTranscriptUpdateTable updateTable;

  late final _i1.ColumnString startTime;

  late final _i1.ColumnString endTime;

  late final _i1.ColumnString speaker;

  late final _i1.ColumnString content;

  late final _i1.ColumnString language;

  late final _i1.ColumnUuid episodeId;

  _i2.EpisodeTable? _episode;

  _i2.EpisodeTable get episode {
    if (_episode != null) return _episode!;
    _episode = _i1.createRelationTable(
      relationFieldName: 'episode',
      field: EpisodeTranscript.t.episodeId,
      foreignField: _i2.Episode.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.EpisodeTable(tableRelation: foreignTableRelation),
    );
    return _episode!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    startTime,
    endTime,
    speaker,
    content,
    language,
    episodeId,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'episode') {
      return episode;
    }
    return null;
  }
}

class EpisodeTranscriptInclude extends _i1.IncludeObject {
  EpisodeTranscriptInclude._({_i2.EpisodeInclude? episode}) {
    _episode = episode;
  }

  _i2.EpisodeInclude? _episode;

  @override
  Map<String, _i1.Include?> get includes => {'episode': _episode};

  @override
  _i1.Table<_i1.UuidValue> get table => EpisodeTranscript.t;
}

class EpisodeTranscriptIncludeList extends _i1.IncludeList {
  EpisodeTranscriptIncludeList._({
    _i1.WhereExpressionBuilder<EpisodeTranscriptTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EpisodeTranscript.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue> get table => EpisodeTranscript.t;
}

class EpisodeTranscriptRepository {
  const EpisodeTranscriptRepository._();

  final attachRow = const EpisodeTranscriptAttachRowRepository._();

  /// Returns a list of [EpisodeTranscript]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<EpisodeTranscript>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<EpisodeTranscriptTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EpisodeTranscriptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EpisodeTranscriptTable>? orderByList,
    _i1.Transaction? transaction,
    EpisodeTranscriptInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EpisodeTranscript>(
      where: where?.call(EpisodeTranscript.t),
      orderBy: orderBy?.call(EpisodeTranscript.t),
      orderByList: orderByList?.call(EpisodeTranscript.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EpisodeTranscript] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<EpisodeTranscript?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<EpisodeTranscriptTable>? where,
    int? offset,
    _i1.OrderByBuilder<EpisodeTranscriptTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EpisodeTranscriptTable>? orderByList,
    _i1.Transaction? transaction,
    EpisodeTranscriptInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EpisodeTranscript>(
      where: where?.call(EpisodeTranscript.t),
      orderBy: orderBy?.call(EpisodeTranscript.t),
      orderByList: orderByList?.call(EpisodeTranscript.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EpisodeTranscript] by its [id] or null if no such row exists.
  Future<EpisodeTranscript?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    EpisodeTranscriptInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EpisodeTranscript>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EpisodeTranscript]s in the list and returns the inserted rows.
  ///
  /// The returned [EpisodeTranscript]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<EpisodeTranscript>> insert(
    _i1.DatabaseSession session,
    List<EpisodeTranscript> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<EpisodeTranscript>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [EpisodeTranscript] and returns the inserted row.
  ///
  /// The returned [EpisodeTranscript] will have its `id` field set.
  Future<EpisodeTranscript> insertRow(
    _i1.DatabaseSession session,
    EpisodeTranscript row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EpisodeTranscript>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EpisodeTranscript]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EpisodeTranscript>> update(
    _i1.DatabaseSession session,
    List<EpisodeTranscript> rows, {
    _i1.ColumnSelections<EpisodeTranscriptTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EpisodeTranscript>(
      rows,
      columns: columns?.call(EpisodeTranscript.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EpisodeTranscript]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EpisodeTranscript> updateRow(
    _i1.DatabaseSession session,
    EpisodeTranscript row, {
    _i1.ColumnSelections<EpisodeTranscriptTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EpisodeTranscript>(
      row,
      columns: columns?.call(EpisodeTranscript.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EpisodeTranscript] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EpisodeTranscript?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<EpisodeTranscriptUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<EpisodeTranscript>(
      id,
      columnValues: columnValues(EpisodeTranscript.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EpisodeTranscript]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<EpisodeTranscript>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<EpisodeTranscriptUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<EpisodeTranscriptTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EpisodeTranscriptTable>? orderBy,
    _i1.OrderByListBuilder<EpisodeTranscriptTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<EpisodeTranscript>(
      columnValues: columnValues(EpisodeTranscript.t.updateTable),
      where: where(EpisodeTranscript.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EpisodeTranscript.t),
      orderByList: orderByList?.call(EpisodeTranscript.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [EpisodeTranscript]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EpisodeTranscript>> delete(
    _i1.DatabaseSession session,
    List<EpisodeTranscript> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EpisodeTranscript>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EpisodeTranscript].
  Future<EpisodeTranscript> deleteRow(
    _i1.DatabaseSession session,
    EpisodeTranscript row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EpisodeTranscript>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EpisodeTranscript>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<EpisodeTranscriptTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EpisodeTranscript>(
      where: where(EpisodeTranscript.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<EpisodeTranscriptTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EpisodeTranscript>(
      where: where?.call(EpisodeTranscript.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EpisodeTranscript] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<EpisodeTranscriptTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EpisodeTranscript>(
      where: where(EpisodeTranscript.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class EpisodeTranscriptAttachRowRepository {
  const EpisodeTranscriptAttachRowRepository._();

  /// Creates a relation between the given [EpisodeTranscript] and [Episode]
  /// by setting the [EpisodeTranscript]'s foreign key `episodeId` to refer to the [Episode].
  Future<void> episode(
    _i1.DatabaseSession session,
    EpisodeTranscript episodeTranscript,
    _i2.Episode episode, {
    _i1.Transaction? transaction,
  }) async {
    if (episodeTranscript.id == null) {
      throw ArgumentError.notNull('episodeTranscript.id');
    }
    if (episode.id == null) {
      throw ArgumentError.notNull('episode.id');
    }

    var $episodeTranscript = episodeTranscript.copyWith(episodeId: episode.id);
    await session.db.updateRow<EpisodeTranscript>(
      $episodeTranscript,
      columns: [EpisodeTranscript.t.episodeId],
      transaction: transaction,
    );
  }
}
