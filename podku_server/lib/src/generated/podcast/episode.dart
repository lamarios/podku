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

abstract class Episode
    implements _i1.TableRow<_i1.UuidValue>, _i1.ProtocolSerialization {
  Episode._({
    _i1.UuidValue? id,
    required this.title,
    this.description,
    this.audioUrl,
    this.audioType,
    this.audioLengthBytes,
    this.pubDateMillis,
    this.durationSeconds,
    this.guid,
    this.imageUrl,
    this.seasonNumber,
    this.episodeNumber,
    this.episodeType,
    required this.explicit,
    this.link,
    required this.podcastId,
    this.podcast,
    double? progress,
  }) : id = id ?? const _i1.Uuid().v4obj(),
       progress = progress ?? 0.0,
       _podcastsEpisodesPodcastsId = null;

  factory Episode({
    _i1.UuidValue? id,
    required String title,
    String? description,
    String? audioUrl,
    String? audioType,
    int? audioLengthBytes,
    int? pubDateMillis,
    int? durationSeconds,
    String? guid,
    String? imageUrl,
    int? seasonNumber,
    int? episodeNumber,
    String? episodeType,
    required bool explicit,
    String? link,
    required _i1.UuidValue podcastId,
    _i2.Podcast? podcast,
    double? progress,
  }) = _EpisodeImpl;

  factory Episode.fromJson(Map<String, dynamic> jsonSerialization) {
    return EpisodeImplicit._(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String?,
      audioUrl: jsonSerialization['audioUrl'] as String?,
      audioType: jsonSerialization['audioType'] as String?,
      audioLengthBytes: jsonSerialization['audioLengthBytes'] as int?,
      pubDateMillis: jsonSerialization['pubDateMillis'] as int?,
      durationSeconds: jsonSerialization['durationSeconds'] as int?,
      guid: jsonSerialization['guid'] as String?,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      seasonNumber: jsonSerialization['seasonNumber'] as int?,
      episodeNumber: jsonSerialization['episodeNumber'] as int?,
      episodeType: jsonSerialization['episodeType'] as String?,
      explicit: _i1.BoolJsonExtension.fromJson(jsonSerialization['explicit']),
      link: jsonSerialization['link'] as String?,
      podcastId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['podcastId'],
      ),
      podcast: jsonSerialization['podcast'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.Podcast>(
              jsonSerialization['podcast'],
            ),
      progress: (jsonSerialization['progress'] as num?)?.toDouble(),
      $_podcastsEpisodesPodcastsId:
          jsonSerialization['_podcastsEpisodesPodcastsId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['_podcastsEpisodesPodcastsId'],
            ),
    );
  }

  static final t = EpisodeTable();

  static const db = EpisodeRepository._();

  @override
  _i1.UuidValue id;

  String title;

  String? description;

  String? audioUrl;

  String? audioType;

  int? audioLengthBytes;

  int? pubDateMillis;

  int? durationSeconds;

  String? guid;

  String? imageUrl;

  int? seasonNumber;

  int? episodeNumber;

  String? episodeType;

  bool explicit;

  String? link;

  _i1.UuidValue podcastId;

  _i2.Podcast? podcast;

  double progress;

  final _i1.UuidValue? _podcastsEpisodesPodcastsId;

  @override
  _i1.Table<_i1.UuidValue> get table => t;

  /// Returns a shallow copy of this [Episode]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Episode copyWith({
    _i1.UuidValue? id,
    String? title,
    String? description,
    String? audioUrl,
    String? audioType,
    int? audioLengthBytes,
    int? pubDateMillis,
    int? durationSeconds,
    String? guid,
    String? imageUrl,
    int? seasonNumber,
    int? episodeNumber,
    String? episodeType,
    bool? explicit,
    String? link,
    _i1.UuidValue? podcastId,
    _i2.Podcast? podcast,
    double? progress,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Episode',
      'id': id.toJson(),
      'title': title,
      if (description != null) 'description': description,
      if (audioUrl != null) 'audioUrl': audioUrl,
      if (audioType != null) 'audioType': audioType,
      if (audioLengthBytes != null) 'audioLengthBytes': audioLengthBytes,
      if (pubDateMillis != null) 'pubDateMillis': pubDateMillis,
      if (durationSeconds != null) 'durationSeconds': durationSeconds,
      if (guid != null) 'guid': guid,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (seasonNumber != null) 'seasonNumber': seasonNumber,
      if (episodeNumber != null) 'episodeNumber': episodeNumber,
      if (episodeType != null) 'episodeType': episodeType,
      'explicit': explicit,
      if (link != null) 'link': link,
      'podcastId': podcastId.toJson(),
      if (podcast != null) 'podcast': podcast?.toJson(),
      'progress': progress,
      if (_podcastsEpisodesPodcastsId != null)
        '_podcastsEpisodesPodcastsId': _podcastsEpisodesPodcastsId.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Episode',
      'id': id.toJson(),
      'title': title,
      if (description != null) 'description': description,
      if (audioUrl != null) 'audioUrl': audioUrl,
      if (audioType != null) 'audioType': audioType,
      if (audioLengthBytes != null) 'audioLengthBytes': audioLengthBytes,
      if (pubDateMillis != null) 'pubDateMillis': pubDateMillis,
      if (durationSeconds != null) 'durationSeconds': durationSeconds,
      if (guid != null) 'guid': guid,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (seasonNumber != null) 'seasonNumber': seasonNumber,
      if (episodeNumber != null) 'episodeNumber': episodeNumber,
      if (episodeType != null) 'episodeType': episodeType,
      'explicit': explicit,
      if (link != null) 'link': link,
      'podcastId': podcastId.toJson(),
      if (podcast != null) 'podcast': podcast?.toJsonForProtocol(),
      'progress': progress,
    };
  }

  static EpisodeInclude include({_i2.PodcastInclude? podcast}) {
    return EpisodeInclude._(podcast: podcast);
  }

  static EpisodeIncludeList includeList({
    _i1.WhereExpressionBuilder<EpisodeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EpisodeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EpisodeTable>? orderByList,
    EpisodeInclude? include,
  }) {
    return EpisodeIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Episode.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Episode.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _EpisodeImpl extends Episode {
  _EpisodeImpl({
    _i1.UuidValue? id,
    required String title,
    String? description,
    String? audioUrl,
    String? audioType,
    int? audioLengthBytes,
    int? pubDateMillis,
    int? durationSeconds,
    String? guid,
    String? imageUrl,
    int? seasonNumber,
    int? episodeNumber,
    String? episodeType,
    required bool explicit,
    String? link,
    required _i1.UuidValue podcastId,
    _i2.Podcast? podcast,
    double? progress,
  }) : super._(
         id: id,
         title: title,
         description: description,
         audioUrl: audioUrl,
         audioType: audioType,
         audioLengthBytes: audioLengthBytes,
         pubDateMillis: pubDateMillis,
         durationSeconds: durationSeconds,
         guid: guid,
         imageUrl: imageUrl,
         seasonNumber: seasonNumber,
         episodeNumber: episodeNumber,
         episodeType: episodeType,
         explicit: explicit,
         link: link,
         podcastId: podcastId,
         podcast: podcast,
         progress: progress,
       );

  /// Returns a shallow copy of this [Episode]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Episode copyWith({
    _i1.UuidValue? id,
    String? title,
    Object? description = _Undefined,
    Object? audioUrl = _Undefined,
    Object? audioType = _Undefined,
    Object? audioLengthBytes = _Undefined,
    Object? pubDateMillis = _Undefined,
    Object? durationSeconds = _Undefined,
    Object? guid = _Undefined,
    Object? imageUrl = _Undefined,
    Object? seasonNumber = _Undefined,
    Object? episodeNumber = _Undefined,
    Object? episodeType = _Undefined,
    bool? explicit,
    Object? link = _Undefined,
    _i1.UuidValue? podcastId,
    Object? podcast = _Undefined,
    double? progress,
  }) {
    return EpisodeImplicit._(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description is String? ? description : this.description,
      audioUrl: audioUrl is String? ? audioUrl : this.audioUrl,
      audioType: audioType is String? ? audioType : this.audioType,
      audioLengthBytes: audioLengthBytes is int?
          ? audioLengthBytes
          : this.audioLengthBytes,
      pubDateMillis: pubDateMillis is int? ? pubDateMillis : this.pubDateMillis,
      durationSeconds: durationSeconds is int?
          ? durationSeconds
          : this.durationSeconds,
      guid: guid is String? ? guid : this.guid,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      seasonNumber: seasonNumber is int? ? seasonNumber : this.seasonNumber,
      episodeNumber: episodeNumber is int? ? episodeNumber : this.episodeNumber,
      episodeType: episodeType is String? ? episodeType : this.episodeType,
      explicit: explicit ?? this.explicit,
      link: link is String? ? link : this.link,
      podcastId: podcastId ?? this.podcastId,
      podcast: podcast is _i2.Podcast? ? podcast : this.podcast?.copyWith(),
      progress: progress ?? this.progress,
      $_podcastsEpisodesPodcastsId: this._podcastsEpisodesPodcastsId,
    );
  }
}

class EpisodeImplicit extends _EpisodeImpl {
  EpisodeImplicit._({
    _i1.UuidValue? id,
    required String title,
    String? description,
    String? audioUrl,
    String? audioType,
    int? audioLengthBytes,
    int? pubDateMillis,
    int? durationSeconds,
    String? guid,
    String? imageUrl,
    int? seasonNumber,
    int? episodeNumber,
    String? episodeType,
    required bool explicit,
    String? link,
    required _i1.UuidValue podcastId,
    _i2.Podcast? podcast,
    double? progress,
    _i1.UuidValue? $_podcastsEpisodesPodcastsId,
  }) : _podcastsEpisodesPodcastsId = $_podcastsEpisodesPodcastsId,
       super(
         id: id,
         title: title,
         description: description,
         audioUrl: audioUrl,
         audioType: audioType,
         audioLengthBytes: audioLengthBytes,
         pubDateMillis: pubDateMillis,
         durationSeconds: durationSeconds,
         guid: guid,
         imageUrl: imageUrl,
         seasonNumber: seasonNumber,
         episodeNumber: episodeNumber,
         episodeType: episodeType,
         explicit: explicit,
         link: link,
         podcastId: podcastId,
         podcast: podcast,
         progress: progress,
       );

  factory EpisodeImplicit(
    Episode episode, {
    _i1.UuidValue? $_podcastsEpisodesPodcastsId,
  }) {
    return EpisodeImplicit._(
      id: episode.id,
      title: episode.title,
      description: episode.description,
      audioUrl: episode.audioUrl,
      audioType: episode.audioType,
      audioLengthBytes: episode.audioLengthBytes,
      pubDateMillis: episode.pubDateMillis,
      durationSeconds: episode.durationSeconds,
      guid: episode.guid,
      imageUrl: episode.imageUrl,
      seasonNumber: episode.seasonNumber,
      episodeNumber: episode.episodeNumber,
      episodeType: episode.episodeType,
      explicit: episode.explicit,
      link: episode.link,
      podcastId: episode.podcastId,
      podcast: episode.podcast,
      progress: episode.progress,
      $_podcastsEpisodesPodcastsId: $_podcastsEpisodesPodcastsId,
    );
  }

  @override
  final _i1.UuidValue? _podcastsEpisodesPodcastsId;
}

class EpisodeUpdateTable extends _i1.UpdateTable<EpisodeTable> {
  EpisodeUpdateTable(super.table);

  _i1.ColumnValue<String, String> title(String value) => _i1.ColumnValue(
    table.title,
    value,
  );

  _i1.ColumnValue<String, String> description(String? value) => _i1.ColumnValue(
    table.description,
    value,
  );

  _i1.ColumnValue<String, String> audioUrl(String? value) => _i1.ColumnValue(
    table.audioUrl,
    value,
  );

  _i1.ColumnValue<String, String> audioType(String? value) => _i1.ColumnValue(
    table.audioType,
    value,
  );

  _i1.ColumnValue<int, int> audioLengthBytes(int? value) => _i1.ColumnValue(
    table.audioLengthBytes,
    value,
  );

  _i1.ColumnValue<int, int> pubDateMillis(int? value) => _i1.ColumnValue(
    table.pubDateMillis,
    value,
  );

  _i1.ColumnValue<int, int> durationSeconds(int? value) => _i1.ColumnValue(
    table.durationSeconds,
    value,
  );

  _i1.ColumnValue<String, String> guid(String? value) => _i1.ColumnValue(
    table.guid,
    value,
  );

  _i1.ColumnValue<String, String> imageUrl(String? value) => _i1.ColumnValue(
    table.imageUrl,
    value,
  );

  _i1.ColumnValue<int, int> seasonNumber(int? value) => _i1.ColumnValue(
    table.seasonNumber,
    value,
  );

  _i1.ColumnValue<int, int> episodeNumber(int? value) => _i1.ColumnValue(
    table.episodeNumber,
    value,
  );

  _i1.ColumnValue<String, String> episodeType(String? value) => _i1.ColumnValue(
    table.episodeType,
    value,
  );

  _i1.ColumnValue<bool, bool> explicit(bool value) => _i1.ColumnValue(
    table.explicit,
    value,
  );

  _i1.ColumnValue<String, String> link(String? value) => _i1.ColumnValue(
    table.link,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> podcastId(
    _i1.UuidValue value,
  ) => _i1.ColumnValue(
    table.podcastId,
    value,
  );

  _i1.ColumnValue<double, double> progress(double value) => _i1.ColumnValue(
    table.progress,
    value,
  );

  _i1.ColumnValue<_i1.UuidValue, _i1.UuidValue> $_podcastsEpisodesPodcastsId(
    _i1.UuidValue? value,
  ) => _i1.ColumnValue(
    table.$_podcastsEpisodesPodcastsId,
    value,
  );
}

class EpisodeTable extends _i1.Table<_i1.UuidValue> {
  EpisodeTable({super.tableRelation}) : super(tableName: 'episodes') {
    updateTable = EpisodeUpdateTable(this);
    title = _i1.ColumnString(
      'title',
      this,
    );
    description = _i1.ColumnString(
      'description',
      this,
    );
    audioUrl = _i1.ColumnString(
      'audioUrl',
      this,
    );
    audioType = _i1.ColumnString(
      'audioType',
      this,
    );
    audioLengthBytes = _i1.ColumnInt(
      'audioLengthBytes',
      this,
    );
    pubDateMillis = _i1.ColumnInt(
      'pubDateMillis',
      this,
    );
    durationSeconds = _i1.ColumnInt(
      'durationSeconds',
      this,
    );
    guid = _i1.ColumnString(
      'guid',
      this,
    );
    imageUrl = _i1.ColumnString(
      'imageUrl',
      this,
    );
    seasonNumber = _i1.ColumnInt(
      'seasonNumber',
      this,
    );
    episodeNumber = _i1.ColumnInt(
      'episodeNumber',
      this,
    );
    episodeType = _i1.ColumnString(
      'episodeType',
      this,
    );
    explicit = _i1.ColumnBool(
      'explicit',
      this,
    );
    link = _i1.ColumnString(
      'link',
      this,
    );
    podcastId = _i1.ColumnUuid(
      'podcastId',
      this,
    );
    progress = _i1.ColumnDouble(
      'progress',
      this,
      hasDefault: true,
    );
    $_podcastsEpisodesPodcastsId = _i1.ColumnUuid(
      '_podcastsEpisodesPodcastsId',
      this,
    );
  }

  late final EpisodeUpdateTable updateTable;

  late final _i1.ColumnString title;

  late final _i1.ColumnString description;

  late final _i1.ColumnString audioUrl;

  late final _i1.ColumnString audioType;

  late final _i1.ColumnInt audioLengthBytes;

  late final _i1.ColumnInt pubDateMillis;

  late final _i1.ColumnInt durationSeconds;

  late final _i1.ColumnString guid;

  late final _i1.ColumnString imageUrl;

  late final _i1.ColumnInt seasonNumber;

  late final _i1.ColumnInt episodeNumber;

  late final _i1.ColumnString episodeType;

  late final _i1.ColumnBool explicit;

  late final _i1.ColumnString link;

  late final _i1.ColumnUuid podcastId;

  _i2.PodcastTable? _podcast;

  late final _i1.ColumnDouble progress;

  late final _i1.ColumnUuid $_podcastsEpisodesPodcastsId;

  _i2.PodcastTable get podcast {
    if (_podcast != null) return _podcast!;
    _podcast = _i1.createRelationTable(
      relationFieldName: 'podcast',
      field: Episode.t.podcastId,
      foreignField: _i2.Podcast.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.PodcastTable(tableRelation: foreignTableRelation),
    );
    return _podcast!;
  }

  @override
  List<_i1.Column> get columns => [
    id,
    title,
    description,
    audioUrl,
    audioType,
    audioLengthBytes,
    pubDateMillis,
    durationSeconds,
    guid,
    imageUrl,
    seasonNumber,
    episodeNumber,
    episodeType,
    explicit,
    link,
    podcastId,
    progress,
    $_podcastsEpisodesPodcastsId,
  ];

  @override
  List<_i1.Column> get managedColumns => [
    id,
    title,
    description,
    audioUrl,
    audioType,
    audioLengthBytes,
    pubDateMillis,
    durationSeconds,
    guid,
    imageUrl,
    seasonNumber,
    episodeNumber,
    episodeType,
    explicit,
    link,
    podcastId,
    progress,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'podcast') {
      return podcast;
    }
    return null;
  }
}

class EpisodeInclude extends _i1.IncludeObject {
  EpisodeInclude._({_i2.PodcastInclude? podcast}) {
    _podcast = podcast;
  }

  _i2.PodcastInclude? _podcast;

  @override
  Map<String, _i1.Include?> get includes => {'podcast': _podcast};

  @override
  _i1.Table<_i1.UuidValue> get table => Episode.t;
}

class EpisodeIncludeList extends _i1.IncludeList {
  EpisodeIncludeList._({
    _i1.WhereExpressionBuilder<EpisodeTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Episode.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<_i1.UuidValue> get table => Episode.t;
}

class EpisodeRepository {
  const EpisodeRepository._();

  final attachRow = const EpisodeAttachRowRepository._();

  /// Returns a list of [Episode]s matching the given query parameters.
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
  Future<List<Episode>> find(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<EpisodeTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EpisodeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EpisodeTable>? orderByList,
    _i1.Transaction? transaction,
    EpisodeInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Episode>(
      where: where?.call(Episode.t),
      orderBy: orderBy?.call(Episode.t),
      orderByList: orderByList?.call(Episode.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [Episode] matching the given query parameters.
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
  Future<Episode?> findFirstRow(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<EpisodeTable>? where,
    int? offset,
    _i1.OrderByBuilder<EpisodeTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<EpisodeTable>? orderByList,
    _i1.Transaction? transaction,
    EpisodeInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Episode>(
      where: where?.call(Episode.t),
      orderBy: orderBy?.call(Episode.t),
      orderByList: orderByList?.call(Episode.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Episode] by its [id] or null if no such row exists.
  Future<Episode?> findById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    _i1.Transaction? transaction,
    EpisodeInclude? include,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Episode>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Episode]s in the list and returns the inserted rows.
  ///
  /// The returned [Episode]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<Episode>> insert(
    _i1.DatabaseSession session,
    List<Episode> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<Episode>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [Episode] and returns the inserted row.
  ///
  /// The returned [Episode] will have its `id` field set.
  Future<Episode> insertRow(
    _i1.DatabaseSession session,
    Episode row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Episode>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Episode]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Episode>> update(
    _i1.DatabaseSession session,
    List<Episode> rows, {
    _i1.ColumnSelections<EpisodeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Episode>(
      rows,
      columns: columns?.call(Episode.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Episode]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Episode> updateRow(
    _i1.DatabaseSession session,
    Episode row, {
    _i1.ColumnSelections<EpisodeTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Episode>(
      row,
      columns: columns?.call(Episode.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Episode] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Episode?> updateById(
    _i1.DatabaseSession session,
    _i1.UuidValue id, {
    required _i1.ColumnValueListBuilder<EpisodeUpdateTable> columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<Episode>(
      id,
      columnValues: columnValues(Episode.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Episode]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<Episode>> updateWhere(
    _i1.DatabaseSession session, {
    required _i1.ColumnValueListBuilder<EpisodeUpdateTable> columnValues,
    required _i1.WhereExpressionBuilder<EpisodeTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<EpisodeTable>? orderBy,
    _i1.OrderByListBuilder<EpisodeTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<Episode>(
      columnValues: columnValues(Episode.t.updateTable),
      where: where(Episode.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Episode.t),
      orderByList: orderByList?.call(Episode.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [Episode]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Episode>> delete(
    _i1.DatabaseSession session,
    List<Episode> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Episode>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Episode].
  Future<Episode> deleteRow(
    _i1.DatabaseSession session,
    Episode row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Episode>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Episode>> deleteWhere(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<EpisodeTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Episode>(
      where: where(Episode.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.DatabaseSession session, {
    _i1.WhereExpressionBuilder<EpisodeTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Episode>(
      where: where?.call(Episode.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Episode] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.DatabaseSession session, {
    required _i1.WhereExpressionBuilder<EpisodeTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Episode>(
      where: where(Episode.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class EpisodeAttachRowRepository {
  const EpisodeAttachRowRepository._();

  /// Creates a relation between the given [Episode] and [Podcast]
  /// by setting the [Episode]'s foreign key `podcastId` to refer to the [Podcast].
  Future<void> podcast(
    _i1.DatabaseSession session,
    Episode episode,
    _i2.Podcast podcast, {
    _i1.Transaction? transaction,
  }) async {
    if (episode.id == null) {
      throw ArgumentError.notNull('episode.id');
    }
    if (podcast.id == null) {
      throw ArgumentError.notNull('podcast.id');
    }

    var $episode = episode.copyWith(podcastId: podcast.id);
    await session.db.updateRow<Episode>(
      $episode,
      columns: [Episode.t.podcastId],
      transaction: transaction,
    );
  }
}
