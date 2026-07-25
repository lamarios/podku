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

abstract class EpisodePerson
    implements _i1.TableRow<_i1.UuidValue>, _i1.ProtocolSerialization {
  EpisodePerson._({
    _i1.UuidValue? id,
    required this.name,
    this.role,
    this.group,
    this.image,
    this.link,
    required this.episodeId,
    this.episode,
  }) : id = id ?? const _i1.Uuid().v4obj();

  factory EpisodePerson({
    _i1.UuidValue? id,
    required String name,
    String? role,
    String? group,
    String? image,
    String? link,
    required _i1.UuidValue episodeId,
    _i2.Episode? episode,
  }) = _EpisodePersonImpl;

  factory EpisodePerson.fromJson(Map<String, dynamic> jsonSerialization) {
    return EpisodePerson(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      role: jsonSerialization['role'] as String?,
      group: jsonSerialization['group'] as String?,
      image: jsonSerialization['image'] as String?,
      link: jsonSerialization['link'] as String?,
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

  static final t = EpisodePersonTable();

  static const db = EpisodePersonRepository._();

  @override
  _i1.UuidValue id;

  String name;

  String? role;

  String? group;

  String? image;

  String? link;

  _i1.UuidValue episodeId;

  _i2.Episode? episode;

  @override
  _i1.Table<_i1.UuidValue> get table => t;

  /// Returns a shallow copy of this [EpisodePerson]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  EpisodePerson copyWith({
    _i1.UuidValue? id,
    String? name,
    String? role,
    String? group,
    String? image,
    String? link,
    _i1.UuidValue? episodeId,
    _i2.Episode? episode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'EpisodePerson',
      'id': id.toJson(),
      'name': name,
      if (role != null) 'role': role,
      if (group != null) 'group': group,
      if (image != null) 'image': image,
      if (link != null) 'link': link,
      'episodeId': episodeId.toJson(),
      if (episode != null) 'episode': episode?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'EpisodePerson',
      'id': id.toJson(),
      'name': name,
      if (role != null) 'role': role,
      if (group != null) 'group': group,
      if (image != null) 'image': image,
      if (link != null) 'link': link,
      'episodeId': episodeId.toJson(),
      if (episode != null) 'episode': episode?.toJsonForProtocol(),
    };
  }

  static EpisodePersonInclude include({_i2.EpisodeInclude? episode}) {
    return EpisodePersonInclude._(episode: episode);
  }

  static EpisodePersonIncludeList includeList({
    _i1.WhereExpressionBuilder<EpisodePersonTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EpisodePersonTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EpisodePersonTable>? orderByList,
    EpisodePersonInclude? include,
  }) {
    return EpisodePersonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EpisodePerson.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(EpisodePerson.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EpisodePersonImpl extends EpisodePerson {
  _EpisodePersonImpl({
    _i1.UuidValue? id,
    required String name,
    String? role,
    String? group,
    String? image,
    String? link,
    required _i1.UuidValue episodeId,
    _i2.Episode? episode,
  }) : super._(
         id: id,
         name: name,
         role: role,
         group: group,
         image: image,
         link: link,
         episodeId: episodeId,
         episode: episode,
       );

  /// Returns a shallow copy of this [EpisodePerson]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  EpisodePerson copyWith({
    _i1.UuidValue? id,
    String? name,
    Object? role = _Undefined,
    Object? group = _Undefined,
    Object? image = _Undefined,
    Object? link = _Undefined,
    _i1.UuidValue? episodeId,
    Object? episode = _Undefined,
  }) {
    return EpisodePerson(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role is String? ? role : this.role,
      group: group is String? ? group : this.group,
      image: image is String? ? image : this.image,
      link: link is String? ? link : this.link,
      episodeId: episodeId ?? this.episodeId,
      episode: episode is _i2.Episode? ? episode : this.episode?.copyWith(),
    );
  }
}

class EpisodePersonUpdateTable extends _i1.UpdateTable<EpisodePersonTable> {
  EpisodePersonUpdateTable(super.table);

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> role(String? value) => _i1.ColumnValue(
    table.role,
    value,
  );

  _i1.ColumnValue<String, String> group(String? value) => _i1.ColumnValue(
    table.group,
    value,
  );

  _i1.ColumnValue<String, String> image(String? value) => _i1.ColumnValue(
    table.image,
    value,
  );

  _i1.ColumnValue<String, String> link(String? value) => _i1.ColumnValue(
    table.link,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> episodeId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.episodeId,
    value,
  );
}

class EpisodePersonTable extends _i1.Table<_i1.UuidValue> {
  EpisodePersonTable({super.tableRelation})
    : super(tableName: 'episode_people') {
    updateTable = EpisodePersonUpdateTable(this);
    name = _i1.ColumnString(
      'name',
      this,
    );
    role = _i1.ColumnString(
      'role',
      this,
    );
    group = _i1.ColumnString(
      'group',
      this,
    );
    image = _i1.ColumnString(
      'image',
      this,
    );
    link = _i1.ColumnString(
      'link',
      this,
    );
    episodeId = _i1.ColumnUuid(
      'episodeId',
      this,
    );
  }

  late final EpisodePersonUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString role;

  late final _i1.ColumnString group;

  late final _i1.ColumnString image;

  late final _i1.ColumnString link;

  late final _i1.ColumnUuid episodeId;

  _i2.EpisodeTable? _episode;

  _i2.EpisodeTable get episode {
    if (_episode != null) return _episode!;
    _episode = _i1.createRelationTable(
      relationFieldName: 'episode',
      field: EpisodePerson.t.episodeId,
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
    name,
    role,
    group,
    image,
    link,
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

class EpisodePersonInclude extends _i1.IncludeObject {
  EpisodePersonInclude._({_i2.EpisodeInclude? episode}) {
    _episode = episode;
  }

  _i2.EpisodeInclude? _episode;

  @override
  Map<String, _i1.Include?> get includes => {'episode': _episode};

  @override
  _i1.Table<_i1.UuidValue> get table => EpisodePerson.t;
}

class EpisodePersonIncludeList extends _i1.IncludeList {
  EpisodePersonIncludeList._({
    _i1.WhereExpressionBuilder<EpisodePersonTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(EpisodePerson.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue> get table => EpisodePerson.t;
}

class EpisodePersonRepository {
  const EpisodePersonRepository._();

  final attachRow = const EpisodePersonAttachRowRepository._();

  /// Returns a list of [EpisodePerson]s matching the given query parameters.
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
  Future<List<EpisodePerson>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<EpisodePersonTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EpisodePersonTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EpisodePersonTable>? orderByList,
    _i1.Transaction? transaction,
    EpisodePersonInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<EpisodePerson>(
      where: where?.call(EpisodePerson.t),
      orderBy: orderBy?.call(EpisodePerson.t),
      orderByList: orderByList?.call(EpisodePerson.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [EpisodePerson] matching the given query parameters.
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
  Future<EpisodePerson?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<EpisodePersonTable>? where,
    int? offset,
    _i1.OrderByBuilder<EpisodePersonTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EpisodePersonTable>? orderByList,
    _i1.Transaction? transaction,
    EpisodePersonInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<EpisodePerson>(
      where: where?.call(EpisodePerson.t),
      orderBy: orderBy?.call(EpisodePerson.t),
      orderByList: orderByList?.call(EpisodePerson.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [EpisodePerson] by its [id] or null if no such row exists.
  Future<EpisodePerson?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    EpisodePersonInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<EpisodePerson>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [EpisodePerson]s in the list and returns the inserted rows.
  ///
  /// The returned [EpisodePerson]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<EpisodePerson>> insert(
    _i1.DatabaseSession session,
    List<EpisodePerson> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<EpisodePerson>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [EpisodePerson] and returns the inserted row.
  ///
  /// The returned [EpisodePerson] will have its `id` field set.
  Future<EpisodePerson> insertRow(
    _i1.DatabaseSession session,
    EpisodePerson row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<EpisodePerson>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [EpisodePerson]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<EpisodePerson>> update(
    _i1.DatabaseSession session,
    List<EpisodePerson> rows, {
    _i1.ColumnSelections<EpisodePersonTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<EpisodePerson>(
      rows,
      columns: columns?.call(EpisodePerson.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EpisodePerson]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<EpisodePerson> updateRow(
    _i1.DatabaseSession session,
    EpisodePerson row, {
    _i1.ColumnSelections<EpisodePersonTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<EpisodePerson>(
      row,
      columns: columns?.call(EpisodePerson.t),
      transaction: transaction,
    );
  }

  /// Updates a single [EpisodePerson] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<EpisodePerson?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<EpisodePersonUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<EpisodePerson>(
      id,
      columnValues: columnValues(EpisodePerson.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [EpisodePerson]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<EpisodePerson>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<EpisodePersonUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<EpisodePersonTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EpisodePersonTable>? orderBy,
    _i1.OrderByListBuilder<EpisodePersonTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<EpisodePerson>(
      columnValues: columnValues(EpisodePerson.t.updateTable),
      where: where(EpisodePerson.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(EpisodePerson.t),
      orderByList: orderByList?.call(EpisodePerson.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [EpisodePerson]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<EpisodePerson>> delete(
    _i1.DatabaseSession session,
    List<EpisodePerson> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<EpisodePerson>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [EpisodePerson].
  Future<EpisodePerson> deleteRow(
    _i1.DatabaseSession session,
    EpisodePerson row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<EpisodePerson>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<EpisodePerson>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<EpisodePersonTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<EpisodePerson>(
      where: where(EpisodePerson.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<EpisodePersonTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<EpisodePerson>(
      where: where?.call(EpisodePerson.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [EpisodePerson] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<EpisodePersonTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<EpisodePerson>(
      where: where(EpisodePerson.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class EpisodePersonAttachRowRepository {
  const EpisodePersonAttachRowRepository._();

  /// Creates a relation between the given [EpisodePerson] and [Episode]
  /// by setting the [EpisodePerson]'s foreign key `episodeId` to refer to the [Episode].
  Future<void> episode(
    _i1.DatabaseSession session,
    EpisodePerson episodePerson,
    _i2.Episode episode, {
    _i1.Transaction? transaction,
  }) async {
    if (episodePerson.id == null) {
      throw ArgumentError.notNull('episodePerson.id');
    }
    if (episode.id == null) {
      throw ArgumentError.notNull('episode.id');
    }

    var $episodePerson = episodePerson.copyWith(episodeId: episode.id);
    await session.db.updateRow<EpisodePerson>(
      $episodePerson,
      columns: [EpisodePerson.t.episodeId],
      transaction: transaction,
    );
  }
}
