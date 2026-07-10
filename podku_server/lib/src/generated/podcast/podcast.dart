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

abstract class Podcast
    implements _i1.TableRow<_i1.UuidValue>, _i1.ProtocolSerialization {
  Podcast._({
    _i1.UuidValue? id,
    required this.url,
    required this.name,
    this.artworkUrl,
    this.description,
    this.author,
    this.link,
    this.episodes,
  }) : id = id ?? const _i1.Uuid().v4obj();

  factory Podcast({
    _i1.UuidValue? id,
    required String url,
    required String name,
    String? artworkUrl,
    String? description,
    String? author,
    String? link,
    List<_i2.Episode>? episodes,
  }) = _PodcastImpl;

  factory Podcast.fromJson(Map<String, dynamic> jsonSerialization) {
    return Podcast(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      url: jsonSerialization['url'] as String,
      name: jsonSerialization['name'] as String,
      artworkUrl: jsonSerialization['artworkUrl'] as String?,
      description: jsonSerialization['description'] as String?,
      author: jsonSerialization['author'] as String?,
      link: jsonSerialization['link'] as String?,
      episodes: jsonSerialization['episodes'] == null
          ? null
          : _i3.Protocol().deserialize<List<_i2.Episode>>(
              jsonSerialization['episodes'],
            ),
    );
  }

  static final t = PodcastTable();

  static const db = PodcastRepository._();

  @override
  _i1.UuidValue id;

  String url;

  String name;

  String? artworkUrl;

  String? description;

  String? author;

  String? link;

  List<_i2.Episode>? episodes;

  @override
  _i1.Table<_i1.UuidValue> get table => t;

  /// Returns a shallow copy of this [Podcast]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Podcast copyWith({
    _i1.UuidValue? id,
    String? url,
    String? name,
    String? artworkUrl,
    String? description,
    String? author,
    String? link,
    List<_i2.Episode>? episodes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Podcast',
      'id': id.toJson(),
      'url': url,
      'name': name,
      if (artworkUrl != null) 'artworkUrl': artworkUrl,
      if (description != null) 'description': description,
      if (author != null) 'author': author,
      if (link != null) 'link': link,
      if (episodes != null)
        'episodes': episodes?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Podcast',
      'id': id.toJson(),
      'url': url,
      'name': name,
      if (artworkUrl != null) 'artworkUrl': artworkUrl,
      if (description != null) 'description': description,
      if (author != null) 'author': author,
      if (link != null) 'link': link,
      if (episodes != null)
        'episodes': episodes?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static PodcastInclude include({_i2.EpisodeIncludeList? episodes}) {
    return PodcastInclude._(episodes: episodes);
  }

  static PodcastIncludeList includeList({
    _i1.WhereExpressionBuilder<PodcastTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PodcastTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PodcastTable>? orderByList,
    PodcastInclude? include,
  }) {
    return PodcastIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Podcast.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Podcast.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PodcastImpl extends Podcast {
  _PodcastImpl({
    _i1.UuidValue? id,
    required String url,
    required String name,
    String? artworkUrl,
    String? description,
    String? author,
    String? link,
    List<_i2.Episode>? episodes,
  }) : super._(
         id: id,
         url: url,
         name: name,
         artworkUrl: artworkUrl,
         description: description,
         author: author,
         link: link,
         episodes: episodes,
       );

  /// Returns a shallow copy of this [Podcast]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Podcast copyWith({
    _i1.UuidValue? id,
    String? url,
    String? name,
    Object? artworkUrl = _Undefined,
    Object? description = _Undefined,
    Object? author = _Undefined,
    Object? link = _Undefined,
    Object? episodes = _Undefined,
  }) {
    return Podcast(
      id: id ?? this.id,
      url: url ?? this.url,
      name: name ?? this.name,
      artworkUrl: artworkUrl is String? ? artworkUrl : this.artworkUrl,
      description: description is String? ? description : this.description,
      author: author is String? ? author : this.author,
      link: link is String? ? link : this.link,
      episodes: episodes is List<_i2.Episode>?
          ? episodes
          : this.episodes?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class PodcastUpdateTable extends _i1.UpdateTable<PodcastTable> {
  PodcastUpdateTable(super.table);

  _i1.ColumnValue<String, String> url(String value) => _i1.ColumnValue(
    table.url,
    value,
  );

  _i1.ColumnValue<String, String> name(String value) => _i1.ColumnValue(
    table.name,
    value,
  );

  _i1.ColumnValue<String, String> artworkUrl(String? value) => _i1.ColumnValue(
    table.artworkUrl,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> author(String? value) => _i1.ColumnValue(
    table.author,
    value,
  );

  _i1.ColumnValue<String, String> link(String? value) => _i1.ColumnValue(
    table.link,
    value,
  );
}

class PodcastTable extends _i1.Table<_i1.UuidValue> {
  PodcastTable({super.tableRelation}) : super(tableName: 'podcasts') {
    updateTable = PodcastUpdateTable(this);
    url = _i1.ColumnString(
      'url',
      this,
    );
    name = _i1.ColumnString(
      'name',
      this,
    );
    artworkUrl = _i1.ColumnString(
      'artworkUrl',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    author = _i1.ColumnString(
      'author',
      this,
    );
    link = _i1.ColumnString(
      'link',
      this,
    );
  }

  late final PodcastUpdateTable updateTable;

  late final _i1.ColumnString url;

  late final _i1.ColumnString name;

  late final _i1.ColumnString artworkUrl;

  late final _i1.ColumnString description;

  late final _i1.ColumnString author;

  late final _i1.ColumnString link;

  _i2.EpisodeTable? ___episodes;

  _i1.ManyRelation<_i2.EpisodeTable>? _episodes;

  _i2.EpisodeTable get __episodes {
    if (___episodes != null) return ___episodes!;
    ___episodes = _i1.createRelationTable(
      relationFieldName: '__episodes',
      field: Podcast.t.id,
      foreignField: _i2.Episode.t.podcastId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.EpisodeTable(tableRelation: foreignTableRelation),
    );
    return ___episodes!;
  }

  _i1.ManyRelation<_i2.EpisodeTable> get episodes {
    if (_episodes != null) return _episodes!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'episodes',
      field: Podcast.t.id,
      foreignField: _i2.Episode.t.podcastId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.EpisodeTable(tableRelation: foreignTableRelation),
    );
    _episodes = _i1.ManyRelation<_i2.EpisodeTable>(
      tableWithRelations: relationTable,
      table: _i2.EpisodeTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _episodes!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    url,
    name,
    artworkUrl,
    description,
    author,
    link,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'episodes') {
      return __episodes;
    }
    return null;
  }
}

class PodcastInclude extends _i1.IncludeObject {
  PodcastInclude._({_i2.EpisodeIncludeList? episodes}) {
    _episodes = episodes;
  }

  _i2.EpisodeIncludeList? _episodes;

  @override
  Map<String, _i1.Include?> get includes => {'episodes': _episodes};

  @override
  _i1.Table<_i1.UuidValue> get table => Podcast.t;
}

class PodcastIncludeList extends _i1.IncludeList {
  PodcastIncludeList._({
    _i1.WhereExpressionBuilder<PodcastTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Podcast.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue> get table => Podcast.t;
}

class PodcastRepository {
  const PodcastRepository._();

  final attach = const PodcastAttachRepository._();

  final attachRow = const PodcastAttachRowRepository._();

  /// Returns a list of [Podcast]s matching the given query parameters.
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
  Future<List<Podcast>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PodcastTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PodcastTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PodcastTable>? orderByList,
    _i1.Transaction? transaction,
    PodcastInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Podcast>(
      where: where?.call(Podcast.t),
      orderBy: orderBy?.call(Podcast.t),
      orderByList: orderByList?.call(Podcast.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Podcast] matching the given query parameters.
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
  Future<Podcast?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PodcastTable>? where,
    int? offset,
    _i1.OrderByBuilder<PodcastTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<PodcastTable>? orderByList,
    _i1.Transaction? transaction,
    PodcastInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Podcast>(
      where: where?.call(Podcast.t),
      orderBy: orderBy?.call(Podcast.t),
      orderByList: orderByList?.call(Podcast.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Podcast] by its [id] or null if no such row exists.
  Future<Podcast?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    PodcastInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Podcast>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Podcast]s in the list and returns the inserted rows.
  ///
  /// The returned [Podcast]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Podcast>> insert(
    _i1.DatabaseSession session,
    List<Podcast> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Podcast>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Podcast] and returns the inserted row.
  ///
  /// The returned [Podcast] will have its `id` field set.
  Future<Podcast> insertRow(
    _i1.DatabaseSession session,
    Podcast row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Podcast>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Podcast]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Podcast>> update(
    _i1.DatabaseSession session,
    List<Podcast> rows, {
    _i1.ColumnSelections<PodcastTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Podcast>(
      rows,
      columns: columns?.call(Podcast.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Podcast]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Podcast> updateRow(
    _i1.DatabaseSession session,
    Podcast row, {
    _i1.ColumnSelections<PodcastTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Podcast>(
      row,
      columns: columns?.call(Podcast.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Podcast] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Podcast?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<PodcastUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Podcast>(
      id,
      columnValues: columnValues(Podcast.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Podcast]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Podcast>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<PodcastUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<PodcastTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<PodcastTable>? orderBy,
    _i1.OrderByListBuilder<PodcastTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Podcast>(
      columnValues: columnValues(Podcast.t.updateTable),
      where: where(Podcast.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Podcast.t),
      orderByList: orderByList?.call(Podcast.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Podcast]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Podcast>> delete(
    _i1.DatabaseSession session,
    List<Podcast> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Podcast>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Podcast].
  Future<Podcast> deleteRow(
    _i1.DatabaseSession session,
    Podcast row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Podcast>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Podcast>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PodcastTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Podcast>(
      where: where(Podcast.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<PodcastTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Podcast>(
      where: where?.call(Podcast.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Podcast] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<PodcastTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Podcast>(
      where: where(Podcast.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class PodcastAttachRepository {
  const PodcastAttachRepository._();

  /// Creates a relation between this [Podcast] and the given [Episode]s
  /// by setting each [Episode]'s foreign key `podcastId` to refer to this [Podcast].
  Future<void> episodes(
    _i1.DatabaseSession session,
    Podcast podcast,
    List<_i2.Episode> episode, {
    _i1.Transaction? transaction,
  }) async {
    if (episode.any((e) => e.id == null)) {
      throw ArgumentError.notNull('episode.id');
    }
    if (podcast.id == null) {
      throw ArgumentError.notNull('podcast.id');
    }

    var $episode = episode
        .map((e) => e.copyWith(podcastId: podcast.id))
        .toList();
    await session.db.update<_i2.Episode>(
      $episode,
      columns: [_i2.Episode.t.podcastId],
      transaction: transaction,
    );
  }
}

class PodcastAttachRowRepository {
  const PodcastAttachRowRepository._();

  /// Creates a relation between this [Podcast] and the given [Episode]
  /// by setting the [Episode]'s foreign key `podcastId` to refer to this [Podcast].
  Future<void> episodes(
    _i1.DatabaseSession session,
    Podcast podcast,
    _i2.Episode episode, {
    _i1.Transaction? transaction,
  }) async {
    if (episode.id == null) {
      throw ArgumentError.notNull('episode.id');
    }
    if (podcast.id == null) {
      throw ArgumentError.notNull('podcast.id');
    }

    var $episode = episode.copyWith(podcastId: podcast.id);
    await session.db.updateRow<_i2.Episode>(
      $episode,
      columns: [_i2.Episode.t.podcastId],
      transaction: transaction,
    );
  }
}
