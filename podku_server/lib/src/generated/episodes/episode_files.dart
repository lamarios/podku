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
import '../episodes/episode_file_type.dart' as _i2;
import '../podcast/episode.dart' as _i3;
import 'package:podku_server/src/generated/protocol.dart' as _i4;

abstract class EpisodeFile
    implements _i1.TableRow<_i1.UuidValue>, _i1.ProtocolSerialization {
  EpisodeFile._({
    _i1.UuidValue? id,
    required this.type,
    this.mime,
    required this.url,
    this.language,
    this.rel,
    required this.episodeId,
    this.episode,
  }) : id = id ?? const _i1.Uuid().v4obj();

  factory EpisodeFile({
    _i1.UuidValue? id,
    required _i2.EpisodeFileType type,
    String? mime,
    required String url,
    String? language,
    String? rel,
    required _i1.UuidValue episodeId,
    _i3.Episode? episode,
  }) = _EpisodeFileImpl;

  factory EpisodeFile.fromJson(Map<String, dynamic> jsonSerialization) {
    return EpisodeFile(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      type: _i2.EpisodeFileType.fromJson((jsonSerialization['type'] as String)),
      mime: jsonSerialization['mime'] as String?,
      url: jsonSerialization['url'] as String,
      language: jsonSerialization['language'] as String?,
      rel: jsonSerialization['rel'] as String?,
      episodeId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['episodeId'],
      ),
      episode: jsonSerialization['episode'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.Episode>(
              jsonSerialization['episode'],
            ),
    );
  }

  static final t = EpisodeFileTable();

  static const db = EpisodeFileRepository._();

  @override
  _i1.UuidValue id;

  _i2.EpisodeFileType type;

  String? mime;

  String url;

  String? language;

  String? rel;

  _i1.UuidValue episodeId;

  _i3.Episode? episode;

  @override
  _i1.Table<_i1.UuidValue> get table => t;

  /// Returns a shallow copy of this [EpisodeFile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EpisodeFile copyWith({
    _i1.UuidValue? id,
    _i2.EpisodeFileType? type,
    String? mime,
    String? url,
    String? language,
    String? rel,
    _i1.UuidValue? episodeId,
    _i3.Episode? episode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EpisodeFile',
      'id': id.toJson(),
      'type': type.toJson(),
      if (mime != null) 'mime': mime,
      'url': url,
      if (language != null) 'language': language,
      if (rel != null) 'rel': rel,
      'episodeId': episodeId.toJson(),
      if (episode != null) 'episode': episode?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EpisodeFile',
      'id': id.toJson(),
      'type': type.toJson(),
      if (mime != null) 'mime': mime,
      'url': url,
      if (language != null) 'language': language,
      if (rel != null) 'rel': rel,
      'episodeId': episodeId.toJson(),
      if (episode != null) 'episode': episode?.toJsonForProtocol(),
    };
  }

  static EpisodeFileInclude include({_i3.EpisodeInclude? episode}) {
    return EpisodeFileInclude._(episode: episode);
  }

  static EpisodeFileIncludeList includeList({
    _i1.WhereExpressionBuilder<EpisodeFileTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EpisodeFileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EpisodeFileTable>? orderByList,
    EpisodeFileInclude? include,
  }) {
    return EpisodeFileIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EpisodeFile.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EpisodeFile.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EpisodeFileImpl extends EpisodeFile {
  _EpisodeFileImpl({
    _i1.UuidValue? id,
    required _i2.EpisodeFileType type,
    String? mime,
    required String url,
    String? language,
    String? rel,
    required _i1.UuidValue episodeId,
    _i3.Episode? episode,
  }) : super._(
         id: id,
         type: type,
         mime: mime,
         url: url,
         language: language,
         rel: rel,
         episodeId: episodeId,
         episode: episode,
       );

  /// Returns a shallow copy of this [EpisodeFile]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EpisodeFile copyWith({
    _i1.UuidValue? id,
    _i2.EpisodeFileType? type,
    Object? mime = _Undefined,
    String? url,
    Object? language = _Undefined,
    Object? rel = _Undefined,
    _i1.UuidValue? episodeId,
    Object? episode = _Undefined,
  }) {
    return EpisodeFile(
      id: id ?? this.id,
      type: type ?? this.type,
      mime: mime is String? ? mime : this.mime,
      url: url ?? this.url,
      language: language is String? ? language : this.language,
      rel: rel is String? ? rel : this.rel,
      episodeId: episodeId ?? this.episodeId,
      episode: episode is _i3.Episode? ? episode : this.episode?.copyWith(),
    );
  }
}

class EpisodeFileUpdateTable extends _i1.UpdateTable<EpisodeFileTable> {
  EpisodeFileUpdateTable(super.table);

  _i1.ColumnValue<_i2.EpisodeFileType, _i2.EpisodeFileType> type(
    _i2.EpisodeFileType value,
  ) => _i1.ColumnValue(
    table.type,
    value,
  );

  _i1.ColumnValue<String, String> mime(String? value) => _i1.ColumnValue(
    table.mime,
    value,
  );

  _i1.ColumnValue<String, String> url(String value) => _i1.ColumnValue(
    table.url,
    value,
  );

  _i1.ColumnValue<String, String> language(String? value) => _i1.ColumnValue(
    table.language,
    value,
  );

  _i1.ColumnValue<String, String> rel(String? value) => _i1.ColumnValue(
    table.rel,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> episodeId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.episodeId,
    value,
  );
}

class EpisodeFileTable extends _i1.Table<_i1.UuidValue> {
  EpisodeFileTable({super.tableRelation}) : super(tableName: 'episode_files') {
    updateTable = EpisodeFileUpdateTable(this);
    type = _i1.ColumnEnum(
      'type',
      this,
      _i1.EnumSerialization.byName,
    );
    mime = _i1.ColumnString(
      'mime',
      this,
    );
    url = _i1.ColumnString(
      'url',
      this,
    );
    language = _i1.ColumnString(
      'language',
      this,
    );
    rel = _i1.ColumnString(
      'rel',
      this,
    );
    episodeId = _i1.ColumnUuid(
      'episodeId',
      this,
    );
  }

  late final EpisodeFileUpdateTable updateTable;

  late final _i1.ColumnEnum<_i2.EpisodeFileType> type;

  late final _i1.ColumnString mime;

  late final _i1.ColumnString url;

  late final _i1.ColumnString language;

  late final _i1.ColumnString rel;

  late final _i1.ColumnUuid episodeId;

  _i3.EpisodeTable? _episode;

  _i3.EpisodeTable get episode {
    if (_episode != null) return _episode!;
    _episode = _i1.createRelationTable(
      relationFieldName: 'episode',
      field: EpisodeFile.t.episodeId,
      foreignField: _i3.Episode.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.EpisodeTable(tableRelation: foreignTableRelation),
    );
    return _episode!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    type,
    mime,
    url,
    language,
    rel,
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

class EpisodeFileInclude extends _i1.IncludeObject {
  EpisodeFileInclude._({_i3.EpisodeInclude? episode}) {
    _episode = episode;
  }

  _i3.EpisodeInclude? _episode;

  @override
  Map<String, _i1.Include?> get includes => {'episode': _episode};

  @override
  _i1.Table<_i1.UuidValue> get table => EpisodeFile.t;
}

class EpisodeFileIncludeList extends _i1.IncludeList {
  EpisodeFileIncludeList._({
    _i1.WhereExpressionBuilder<EpisodeFileTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EpisodeFile.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue> get table => EpisodeFile.t;
}

class EpisodeFileRepository {
  const EpisodeFileRepository._();

  final attachRow = const EpisodeFileAttachRowRepository._();

  /// Returns a list of [EpisodeFile]s matching the given query parameters.
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
  Future<List<EpisodeFile>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<EpisodeFileTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EpisodeFileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EpisodeFileTable>? orderByList,
    _i1.Transaction? transaction,
    EpisodeFileInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EpisodeFile>(
      where: where?.call(EpisodeFile.t),
      orderBy: orderBy?.call(EpisodeFile.t),
      orderByList: orderByList?.call(EpisodeFile.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EpisodeFile] matching the given query parameters.
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
  Future<EpisodeFile?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<EpisodeFileTable>? where,
    int? offset,
    _i1.OrderByBuilder<EpisodeFileTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EpisodeFileTable>? orderByList,
    _i1.Transaction? transaction,
    EpisodeFileInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EpisodeFile>(
      where: where?.call(EpisodeFile.t),
      orderBy: orderBy?.call(EpisodeFile.t),
      orderByList: orderByList?.call(EpisodeFile.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EpisodeFile] by its [id] or null if no such row exists.
  Future<EpisodeFile?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    EpisodeFileInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EpisodeFile>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EpisodeFile]s in the list and returns the inserted rows.
  ///
  /// The returned [EpisodeFile]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<EpisodeFile>> insert(
    _i1.DatabaseSession session,
    List<EpisodeFile> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<EpisodeFile>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [EpisodeFile] and returns the inserted row.
  ///
  /// The returned [EpisodeFile] will have its `id` field set.
  Future<EpisodeFile> insertRow(
    _i1.DatabaseSession session,
    EpisodeFile row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EpisodeFile>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EpisodeFile]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EpisodeFile>> update(
    _i1.DatabaseSession session,
    List<EpisodeFile> rows, {
    _i1.ColumnSelections<EpisodeFileTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EpisodeFile>(
      rows,
      columns: columns?.call(EpisodeFile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EpisodeFile]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EpisodeFile> updateRow(
    _i1.DatabaseSession session,
    EpisodeFile row, {
    _i1.ColumnSelections<EpisodeFileTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EpisodeFile>(
      row,
      columns: columns?.call(EpisodeFile.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EpisodeFile] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EpisodeFile?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<EpisodeFileUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<EpisodeFile>(
      id,
      columnValues: columnValues(EpisodeFile.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EpisodeFile]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<EpisodeFile>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<EpisodeFileUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<EpisodeFileTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EpisodeFileTable>? orderBy,
    _i1.OrderByListBuilder<EpisodeFileTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<EpisodeFile>(
      columnValues: columnValues(EpisodeFile.t.updateTable),
      where: where(EpisodeFile.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EpisodeFile.t),
      orderByList: orderByList?.call(EpisodeFile.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [EpisodeFile]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EpisodeFile>> delete(
    _i1.DatabaseSession session,
    List<EpisodeFile> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EpisodeFile>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EpisodeFile].
  Future<EpisodeFile> deleteRow(
    _i1.DatabaseSession session,
    EpisodeFile row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EpisodeFile>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EpisodeFile>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<EpisodeFileTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EpisodeFile>(
      where: where(EpisodeFile.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<EpisodeFileTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EpisodeFile>(
      where: where?.call(EpisodeFile.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EpisodeFile] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<EpisodeFileTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EpisodeFile>(
      where: where(EpisodeFile.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class EpisodeFileAttachRowRepository {
  const EpisodeFileAttachRowRepository._();

  /// Creates a relation between the given [EpisodeFile] and [Episode]
  /// by setting the [EpisodeFile]'s foreign key `episodeId` to refer to the [Episode].
  Future<void> episode(
    _i1.DatabaseSession session,
    EpisodeFile episodeFile,
    _i3.Episode episode, {
    _i1.Transaction? transaction,
  }) async {
    if (episodeFile.id == null) {
      throw ArgumentError.notNull('episodeFile.id');
    }
    if (episode.id == null) {
      throw ArgumentError.notNull('episode.id');
    }

    var $episodeFile = episodeFile.copyWith(episodeId: episode.id);
    await session.db.updateRow<EpisodeFile>(
      $episodeFile,
      columns: [EpisodeFile.t.episodeId],
      transaction: transaction,
    );
  }
}
