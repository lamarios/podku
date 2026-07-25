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
import '../podcast/podcast.dart' as _i2;
import 'package:podku_server/src/generated/protocol.dart' as _i3;

abstract class PodcastPerson
    implements _i1.TableRow<_i1.UuidValue>, _i1.ProtocolSerialization {
  PodcastPerson._({
    _i1.UuidValue? id,
    required this.name,
    this.role,
    this.group,
    this.image,
    this.link,
    required this.episodeId,
    this.episode,
  }) : id = id ?? const _i1.Uuid().v4obj();

  factory PodcastPerson({
    _i1.UuidValue? id,
    required String name,
    String? role,
    String? group,
    String? image,
    String? link,
    required _i1.UuidValue episodeId,
    _i2.Podcast? episode,
  }) = _PodcastPersonImpl;

  factory PodcastPerson.fromJson(Map<String, dynamic> jsonSerialization) {
    return PodcastPerson(
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
          : _i3.Protocol().deserialize<_i2.Podcast>(
              jsonSerialization['episode'],
            ),
    );
  }

  static final t = PodcastPersonTable();

  static const db = PodcastPersonRepository._();

  @override
  _i1.UuidValue id;

  String name;

  String? role;

  String? group;

  String? image;

  String? link;

  _i1.UuidValue episodeId;

  _i2.Podcast? episode;

  @override
  _i1.Table<_i1.UuidValue> get table => t;

  /// Returns a shallow copy of this [PodcastPerson]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PodcastPerson copyWith({
    _i1.UuidValue? id,
    String? name,
    String? role,
    String? group,
    String? image,
    String? link,
    _i1.UuidValue? episodeId,
    _i2.Podcast? episode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PodcastPerson',
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
      '__className__': 'PodcastPerson',
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

  static PodcastPersonInclude include({_i2.PodcastInclude? episode}) {
    return PodcastPersonInclude._(episode: episode);
  }

  static PodcastPersonIncludeList includeList({
    _i1.WhereExpressionBuilder<PodcastPersonTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PodcastPersonTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PodcastPersonTable>? orderByList,
    PodcastPersonInclude? include,
  }) {
    return PodcastPersonIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PodcastPerson.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(PodcastPerson.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PodcastPersonImpl extends PodcastPerson {
  _PodcastPersonImpl({
    _i1.UuidValue? id,
    required String name,
    String? role,
    String? group,
    String? image,
    String? link,
    required _i1.UuidValue episodeId,
    _i2.Podcast? episode,
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

  /// Returns a shallow copy of this [PodcastPerson]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PodcastPerson copyWith({
    _i1.UuidValue? id,
    String? name,
    Object? role = _Undefined,
    Object? group = _Undefined,
    Object? image = _Undefined,
    Object? link = _Undefined,
    _i1.UuidValue? episodeId,
    Object? episode = _Undefined,
  }) {
    return PodcastPerson(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role is String? ? role : this.role,
      group: group is String? ? group : this.group,
      image: image is String? ? image : this.image,
      link: link is String? ? link : this.link,
      episodeId: episodeId ?? this.episodeId,
      episode: episode is _i2.Podcast? ? episode : this.episode?.copyWith(),
    );
  }
}

class PodcastPersonUpdateTable extends _i1.UpdateTable<PodcastPersonTable> {
  PodcastPersonUpdateTable(super.table);

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

class PodcastPersonTable extends _i1.Table<_i1.UuidValue> {
  PodcastPersonTable({super.tableRelation})
    : super(tableName: 'podcast_people') {
    updateTable = PodcastPersonUpdateTable(this);
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

  late final PodcastPersonUpdateTable updateTable;

  late final _i1.ColumnString name;

  late final _i1.ColumnString role;

  late final _i1.ColumnString group;

  late final _i1.ColumnString image;

  late final _i1.ColumnString link;

  late final _i1.ColumnUuid episodeId;

  _i2.PodcastTable? _episode;

  _i2.PodcastTable get episode {
    if (_episode != null) return _episode!;
    _episode = _i1.createRelationTable(
      relationFieldName: 'episode',
      field: PodcastPerson.t.episodeId,
      foreignField: _i2.Podcast.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.PodcastTable(tableRelation: foreignTableRelation),
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

class PodcastPersonInclude extends _i1.IncludeObject {
  PodcastPersonInclude._({_i2.PodcastInclude? episode}) {
    _episode = episode;
  }

  _i2.PodcastInclude? _episode;

  @override
  Map<String, _i1.Include?> get includes => {'episode': _episode};

  @override
  _i1.Table<_i1.UuidValue> get table => PodcastPerson.t;
}

class PodcastPersonIncludeList extends _i1.IncludeList {
  PodcastPersonIncludeList._({
    _i1.WhereExpressionBuilder<PodcastPersonTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PodcastPerson.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue> get table => PodcastPerson.t;
}

class PodcastPersonRepository {
  const PodcastPersonRepository._();

  final attachRow = const PodcastPersonAttachRowRepository._();

  /// Returns a list of [PodcastPerson]s matching the given query parameters.
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
  Future<List<PodcastPerson>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PodcastPersonTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PodcastPersonTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PodcastPersonTable>? orderByList,
    _i1.Transaction? transaction,
    PodcastPersonInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PodcastPerson>(
      where: where?.call(PodcastPerson.t),
      orderBy: orderBy?.call(PodcastPerson.t),
      orderByList: orderByList?.call(PodcastPerson.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PodcastPerson] matching the given query parameters.
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
  Future<PodcastPerson?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PodcastPersonTable>? where,
    int? offset,
    _i1.OrderByBuilder<PodcastPersonTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PodcastPersonTable>? orderByList,
    _i1.Transaction? transaction,
    PodcastPersonInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PodcastPerson>(
      where: where?.call(PodcastPerson.t),
      orderBy: orderBy?.call(PodcastPerson.t),
      orderByList: orderByList?.call(PodcastPerson.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PodcastPerson] by its [id] or null if no such row exists.
  Future<PodcastPerson?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    PodcastPersonInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PodcastPerson>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PodcastPerson]s in the list and returns the inserted rows.
  ///
  /// The returned [PodcastPerson]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<PodcastPerson>> insert(
    _i1.DatabaseSession session,
    List<PodcastPerson> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<PodcastPerson>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [PodcastPerson] and returns the inserted row.
  ///
  /// The returned [PodcastPerson] will have its `id` field set.
  Future<PodcastPerson> insertRow(
    _i1.DatabaseSession session,
    PodcastPerson row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<PodcastPerson>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [PodcastPerson]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<PodcastPerson>> update(
    _i1.DatabaseSession session,
    List<PodcastPerson> rows, {
    _i1.ColumnSelections<PodcastPersonTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<PodcastPerson>(
      rows,
      columns: columns?.call(PodcastPerson.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PodcastPerson]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PodcastPerson> updateRow(
    _i1.DatabaseSession session,
    PodcastPerson row, {
    _i1.ColumnSelections<PodcastPersonTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<PodcastPerson>(
      row,
      columns: columns?.call(PodcastPerson.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PodcastPerson] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PodcastPerson?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<PodcastPersonUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<PodcastPerson>(
      id,
      columnValues: columnValues(PodcastPerson.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PodcastPerson]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<PodcastPerson>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<PodcastPersonUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<PodcastPersonTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PodcastPersonTable>? orderBy,
    _i1.OrderByListBuilder<PodcastPersonTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<PodcastPerson>(
      columnValues: columnValues(PodcastPerson.t.updateTable),
      where: where(PodcastPerson.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PodcastPerson.t),
      orderByList: orderByList?.call(PodcastPerson.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [PodcastPerson]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<PodcastPerson>> delete(
    _i1.DatabaseSession session,
    List<PodcastPerson> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<PodcastPerson>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [PodcastPerson].
  Future<PodcastPerson> deleteRow(
    _i1.DatabaseSession session,
    PodcastPerson row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PodcastPerson>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<PodcastPerson>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PodcastPersonTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<PodcastPerson>(
      where: where(PodcastPerson.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PodcastPersonTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<PodcastPerson>(
      where: where?.call(PodcastPerson.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PodcastPerson] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PodcastPersonTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PodcastPerson>(
      where: where(PodcastPerson.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class PodcastPersonAttachRowRepository {
  const PodcastPersonAttachRowRepository._();

  /// Creates a relation between the given [PodcastPerson] and [Podcast]
  /// by setting the [PodcastPerson]'s foreign key `episodeId` to refer to the [Podcast].
  Future<void> episode(
    _i1.DatabaseSession session,
    PodcastPerson podcastPerson,
    _i2.Podcast episode, {
    _i1.Transaction? transaction,
  }) async {
    if (podcastPerson.id == null) {
      throw ArgumentError.notNull('podcastPerson.id');
    }
    if (episode.id == null) {
      throw ArgumentError.notNull('episode.id');
    }

    var $podcastPerson = podcastPerson.copyWith(episodeId: episode.id);
    await session.db.updateRow<PodcastPerson>(
      $podcastPerson,
      columns: [PodcastPerson.t.episodeId],
      transaction: transaction,
    );
  }
}
