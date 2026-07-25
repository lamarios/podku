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
import '../episodes/chapter.dart' as _i3;
import '../episodes/person.dart' as _i4;
import '../episodes/episode_files.dart' as _i5;
import '../episodes/episode_transcript.dart' as _i6;
import 'package:podku_server/src/generated/protocol.dart' as _i7;

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
    this.chapters,
    this.people,
    this.files,
    this.transcript,
    bool? processed,
  }) : id = id ?? const _i1.Uuid().v4obj(),
       progress = progress ?? 0.0,
       processed = processed ?? false;

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
    List<_i3.Chapter>? chapters,
    List<_i4.EpisodePerson>? people,
    List<_i5.EpisodeFile>? files,
    List<_i6.EpisodeTranscript>? transcript,
    bool? processed,
  }) = _EpisodeImpl;

  factory Episode.fromJson(Map<String, dynamic> jsonSerialization) {
    return Episode(
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
          : _i7.Protocol().deserialize<_i2.Podcast>(
              jsonSerialization['podcast'],
            ),
      progress: (jsonSerialization['progress'] as num?)?.toDouble(),
      chapters: jsonSerialization['chapters'] == null
          ? null
          : _i7.Protocol().deserialize<List<_i3.Chapter>>(
              jsonSerialization['chapters'],
            ),
      people: jsonSerialization['people'] == null
          ? null
          : _i7.Protocol().deserialize<List<_i4.EpisodePerson>>(
              jsonSerialization['people'],
            ),
      files: jsonSerialization['files'] == null
          ? null
          : _i7.Protocol().deserialize<List<_i5.EpisodeFile>>(
              jsonSerialization['files'],
            ),
      transcript: jsonSerialization['transcript'] == null
          ? null
          : _i7.Protocol().deserialize<List<_i6.EpisodeTranscript>>(
              jsonSerialization['transcript'],
            ),
      processed: jsonSerialization['processed'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['processed']),
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

  List<_i3.Chapter>? chapters;

  List<_i4.EpisodePerson>? people;

  List<_i5.EpisodeFile>? files;

  List<_i6.EpisodeTranscript>? transcript;

  bool processed;

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
    List<_i3.Chapter>? chapters,
    List<_i4.EpisodePerson>? people,
    List<_i5.EpisodeFile>? files,
    List<_i6.EpisodeTranscript>? transcript,
    bool? processed,
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
      if (chapters != null)
        'chapters': chapters?.toJson(valueToJson: (v) => v.toJson()),
      if (people != null)
        'people': people?.toJson(valueToJson: (v) => v.toJson()),
      if (files != null) 'files': files?.toJson(valueToJson: (v) => v.toJson()),
      if (transcript != null)
        'transcript': transcript?.toJson(valueToJson: (v) => v.toJson()),
      'processed': processed,
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
      if (chapters != null)
        'chapters': chapters?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (people != null)
        'people': people?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (files != null)
        'files': files?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (transcript != null)
        'transcript': transcript?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      'processed': processed,
    };
  }

  static EpisodeInclude include({
    _i2.PodcastInclude? podcast,
    _i3.ChapterIncludeList? chapters,
    _i4.EpisodePersonIncludeList? people,
    _i5.EpisodeFileIncludeList? files,
    _i6.EpisodeTranscriptIncludeList? transcript,
  }) {
    return EpisodeInclude._(
      podcast: podcast,
      chapters: chapters,
      people: people,
      files: files,
      transcript: transcript,
    );
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
    List<_i3.Chapter>? chapters,
    List<_i4.EpisodePerson>? people,
    List<_i5.EpisodeFile>? files,
    List<_i6.EpisodeTranscript>? transcript,
    bool? processed,
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
         chapters: chapters,
         people: people,
         files: files,
         transcript: transcript,
         processed: processed,
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
    Object? chapters = _Undefined,
    Object? people = _Undefined,
    Object? files = _Undefined,
    Object? transcript = _Undefined,
    bool? processed,
  }) {
    return Episode(
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
      chapters: chapters is List<_i3.Chapter>?
          ? chapters
          : this.chapters?.map((e0) => e0.copyWith()).toList(),
      people: people is List<_i4.EpisodePerson>?
          ? people
          : this.people?.map((e0) => e0.copyWith()).toList(),
      files: files is List<_i5.EpisodeFile>?
          ? files
          : this.files?.map((e0) => e0.copyWith()).toList(),
      transcript: transcript is List<_i6.EpisodeTranscript>?
          ? transcript
          : this.transcript?.map((e0) => e0.copyWith()).toList(),
      processed: processed ?? this.processed,
    );
  }
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

  _i1.ColumnValue<bool, bool> processed(bool value) => _i1.ColumnValue(
    table.processed,
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
    processed = _i1.ColumnBool(
      'processed',
      this,
      hasDefault: true,
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

  _i3.ChapterTable? ___chapters;

  _i1.ManyRelation<_i3.ChapterTable>? _chapters;

  _i4.EpisodePersonTable? ___people;

  _i1.ManyRelation<_i4.EpisodePersonTable>? _people;

  _i5.EpisodeFileTable? ___files;

  _i1.ManyRelation<_i5.EpisodeFileTable>? _files;

  _i6.EpisodeTranscriptTable? ___transcript;

  _i1.ManyRelation<_i6.EpisodeTranscriptTable>? _transcript;

  late final _i1.ColumnBool processed;

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

  _i3.ChapterTable get __chapters {
    if (___chapters != null) return ___chapters!;
    ___chapters = _i1.createRelationTable(
      relationFieldName: '__chapters',
      field: Episode.t.id,
      foreignField: _i3.Chapter.t.episodeId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.ChapterTable(tableRelation: foreignTableRelation),
    );
    return ___chapters!;
  }

  _i4.EpisodePersonTable get __people {
    if (___people != null) return ___people!;
    ___people = _i1.createRelationTable(
      relationFieldName: '__people',
      field: Episode.t.id,
      foreignField: _i4.EpisodePerson.t.episodeId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.EpisodePersonTable(tableRelation: foreignTableRelation),
    );
    return ___people!;
  }

  _i5.EpisodeFileTable get __files {
    if (___files != null) return ___files!;
    ___files = _i1.createRelationTable(
      relationFieldName: '__files',
      field: Episode.t.id,
      foreignField: _i5.EpisodeFile.t.episodeId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5.EpisodeFileTable(tableRelation: foreignTableRelation),
    );
    return ___files!;
  }

  _i6.EpisodeTranscriptTable get __transcript {
    if (___transcript != null) return ___transcript!;
    ___transcript = _i1.createRelationTable(
      relationFieldName: '__transcript',
      field: Episode.t.id,
      foreignField: _i6.EpisodeTranscript.t.episodeId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i6.EpisodeTranscriptTable(tableRelation: foreignTableRelation),
    );
    return ___transcript!;
  }

  _i1.ManyRelation<_i3.ChapterTable> get chapters {
    if (_chapters != null) return _chapters!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'chapters',
      field: Episode.t.id,
      foreignField: _i3.Chapter.t.episodeId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.ChapterTable(tableRelation: foreignTableRelation),
    );
    _chapters = _i1.ManyRelation<_i3.ChapterTable>(
      tableWithRelations: relationTable,
      table: _i3.ChapterTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _chapters!;
  }

  _i1.ManyRelation<_i4.EpisodePersonTable> get people {
    if (_people != null) return _people!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'people',
      field: Episode.t.id,
      foreignField: _i4.EpisodePerson.t.episodeId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i4.EpisodePersonTable(tableRelation: foreignTableRelation),
    );
    _people = _i1.ManyRelation<_i4.EpisodePersonTable>(
      tableWithRelations: relationTable,
      table: _i4.EpisodePersonTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _people!;
  }

  _i1.ManyRelation<_i5.EpisodeFileTable> get files {
    if (_files != null) return _files!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'files',
      field: Episode.t.id,
      foreignField: _i5.EpisodeFile.t.episodeId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i5.EpisodeFileTable(tableRelation: foreignTableRelation),
    );
    _files = _i1.ManyRelation<_i5.EpisodeFileTable>(
      tableWithRelations: relationTable,
      table: _i5.EpisodeFileTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _files!;
  }

  _i1.ManyRelation<_i6.EpisodeTranscriptTable> get transcript {
    if (_transcript != null) return _transcript!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'transcript',
      field: Episode.t.id,
      foreignField: _i6.EpisodeTranscript.t.episodeId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i6.EpisodeTranscriptTable(tableRelation: foreignTableRelation),
    );
    _transcript = _i1.ManyRelation<_i6.EpisodeTranscriptTable>(
      tableWithRelations: relationTable,
      table: _i6.EpisodeTranscriptTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _transcript!;
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
    processed,
  ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'podcast') {
      return podcast;
    }
    if (relationField == 'chapters') {
      return __chapters;
    }
    if (relationField == 'people') {
      return __people;
    }
    if (relationField == 'files') {
      return __files;
    }
    if (relationField == 'transcript') {
      return __transcript;
    }
    return null;
  }
}

class EpisodeInclude extends _i1.IncludeObject {
  EpisodeInclude._({
    _i2.PodcastInclude? podcast,
    _i3.ChapterIncludeList? chapters,
    _i4.EpisodePersonIncludeList? people,
    _i5.EpisodeFileIncludeList? files,
    _i6.EpisodeTranscriptIncludeList? transcript,
  }) {
    _podcast = podcast;
    _chapters = chapters;
    _people = people;
    _files = files;
    _transcript = transcript;
  }

  _i2.PodcastInclude? _podcast;

  _i3.ChapterIncludeList? _chapters;

  _i4.EpisodePersonIncludeList? _people;

  _i5.EpisodeFileIncludeList? _files;

  _i6.EpisodeTranscriptIncludeList? _transcript;

  @override
  Map<String, _i1.Include?> get includes => {
    'podcast': _podcast,
    'chapters': _chapters,
    'people': _people,
    'files': _files,
    'transcript': _transcript,
  };

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

  final attach = const EpisodeAttachRepository._();

  final attachRow = const EpisodeAttachRowRepository._();

  final detach = const EpisodeDetachRepository._();

  final detachRow = const EpisodeDetachRowRepository._();

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

class EpisodeAttachRepository {
  const EpisodeAttachRepository._();

  /// Creates a relation between this [Episode] and the given [Chapter]s
  /// by setting each [Chapter]'s foreign key `episodeId` to refer to this [Episode].
  Future<void> chapters(
    _i1.DatabaseSession session,
    Episode episode,
    List<_i3.Chapter> chapter, {
    _i1.Transaction? transaction,
  }) async {
    if (chapter.any((e) => e.id == null)) {
      throw ArgumentError.notNull('chapter.id');
    }
    if (episode.id == null) {
      throw ArgumentError.notNull('episode.id');
    }

    var $chapter = chapter
        .map((e) => e.copyWith(episodeId: episode.id))
        .toList();
    await session.db.update<_i3.Chapter>(
      $chapter,
      columns: [_i3.Chapter.t.episodeId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Episode] and the given [EpisodePerson]s
  /// by setting each [EpisodePerson]'s foreign key `episodeId` to refer to this [Episode].
  Future<void> people(
    _i1.DatabaseSession session,
    Episode episode,
    List<_i4.EpisodePerson> episodePerson, {
    _i1.Transaction? transaction,
  }) async {
    if (episodePerson.any((e) => e.id == null)) {
      throw ArgumentError.notNull('episodePerson.id');
    }
    if (episode.id == null) {
      throw ArgumentError.notNull('episode.id');
    }

    var $episodePerson = episodePerson
        .map((e) => e.copyWith(episodeId: episode.id))
        .toList();
    await session.db.update<_i4.EpisodePerson>(
      $episodePerson,
      columns: [_i4.EpisodePerson.t.episodeId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Episode] and the given [EpisodeFile]s
  /// by setting each [EpisodeFile]'s foreign key `episodeId` to refer to this [Episode].
  Future<void> files(
    _i1.DatabaseSession session,
    Episode episode,
    List<_i5.EpisodeFile> episodeFile, {
    _i1.Transaction? transaction,
  }) async {
    if (episodeFile.any((e) => e.id == null)) {
      throw ArgumentError.notNull('episodeFile.id');
    }
    if (episode.id == null) {
      throw ArgumentError.notNull('episode.id');
    }

    var $episodeFile = episodeFile
        .map((e) => e.copyWith(episodeId: episode.id))
        .toList();
    await session.db.update<_i5.EpisodeFile>(
      $episodeFile,
      columns: [_i5.EpisodeFile.t.episodeId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Episode] and the given [EpisodeTranscript]s
  /// by setting each [EpisodeTranscript]'s foreign key `episodeId` to refer to this [Episode].
  Future<void> transcript(
    _i1.DatabaseSession session,
    Episode episode,
    List<_i6.EpisodeTranscript> episodeTranscript, {
    _i1.Transaction? transaction,
  }) async {
    if (episodeTranscript.any((e) => e.id == null)) {
      throw ArgumentError.notNull('episodeTranscript.id');
    }
    if (episode.id == null) {
      throw ArgumentError.notNull('episode.id');
    }

    var $episodeTranscript = episodeTranscript
        .map((e) => e.copyWith(episodeId: episode.id))
        .toList();
    await session.db.update<_i6.EpisodeTranscript>(
      $episodeTranscript,
      columns: [_i6.EpisodeTranscript.t.episodeId],
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

  /// Creates a relation between this [Episode] and the given [Chapter]
  /// by setting the [Chapter]'s foreign key `episodeId` to refer to this [Episode].
  Future<void> chapters(
    _i1.DatabaseSession session,
    Episode episode,
    _i3.Chapter chapter, {
    _i1.Transaction? transaction,
  }) async {
    if (chapter.id == null) {
      throw ArgumentError.notNull('chapter.id');
    }
    if (episode.id == null) {
      throw ArgumentError.notNull('episode.id');
    }

    var $chapter = chapter.copyWith(episodeId: episode.id);
    await session.db.updateRow<_i3.Chapter>(
      $chapter,
      columns: [_i3.Chapter.t.episodeId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Episode] and the given [EpisodePerson]
  /// by setting the [EpisodePerson]'s foreign key `episodeId` to refer to this [Episode].
  Future<void> people(
    _i1.DatabaseSession session,
    Episode episode,
    _i4.EpisodePerson episodePerson, {
    _i1.Transaction? transaction,
  }) async {
    if (episodePerson.id == null) {
      throw ArgumentError.notNull('episodePerson.id');
    }
    if (episode.id == null) {
      throw ArgumentError.notNull('episode.id');
    }

    var $episodePerson = episodePerson.copyWith(episodeId: episode.id);
    await session.db.updateRow<_i4.EpisodePerson>(
      $episodePerson,
      columns: [_i4.EpisodePerson.t.episodeId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Episode] and the given [EpisodeFile]
  /// by setting the [EpisodeFile]'s foreign key `episodeId` to refer to this [Episode].
  Future<void> files(
    _i1.DatabaseSession session,
    Episode episode,
    _i5.EpisodeFile episodeFile, {
    _i1.Transaction? transaction,
  }) async {
    if (episodeFile.id == null) {
      throw ArgumentError.notNull('episodeFile.id');
    }
    if (episode.id == null) {
      throw ArgumentError.notNull('episode.id');
    }

    var $episodeFile = episodeFile.copyWith(episodeId: episode.id);
    await session.db.updateRow<_i5.EpisodeFile>(
      $episodeFile,
      columns: [_i5.EpisodeFile.t.episodeId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [Episode] and the given [EpisodeTranscript]
  /// by setting the [EpisodeTranscript]'s foreign key `episodeId` to refer to this [Episode].
  Future<void> transcript(
    _i1.DatabaseSession session,
    Episode episode,
    _i6.EpisodeTranscript episodeTranscript, {
    _i1.Transaction? transaction,
  }) async {
    if (episodeTranscript.id == null) {
      throw ArgumentError.notNull('episodeTranscript.id');
    }
    if (episode.id == null) {
      throw ArgumentError.notNull('episode.id');
    }

    var $episodeTranscript = episodeTranscript.copyWith(episodeId: episode.id);
    await session.db.updateRow<_i6.EpisodeTranscript>(
      $episodeTranscript,
      columns: [_i6.EpisodeTranscript.t.episodeId],
      transaction: transaction,
    );
  }
}

class EpisodeDetachRepository {
  const EpisodeDetachRepository._();

  /// Detaches the relation between this [Episode] and the given [Chapter]
  /// by setting the [Chapter]'s foreign key `episodeId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> chapters(
    _i1.DatabaseSession session,
    List<_i3.Chapter> chapter, {
    _i1.Transaction? transaction,
  }) async {
    if (chapter.any((e) => e.id == null)) {
      throw ArgumentError.notNull('chapter.id');
    }

    var $chapter = chapter.map((e) => e.copyWith(episodeId: null)).toList();
    await session.db.update<_i3.Chapter>(
      $chapter,
      columns: [_i3.Chapter.t.episodeId],
      transaction: transaction,
    );
  }
}

class EpisodeDetachRowRepository {
  const EpisodeDetachRowRepository._();

  /// Detaches the relation between this [Episode] and the given [Chapter]
  /// by setting the [Chapter]'s foreign key `episodeId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> chapters(
    _i1.DatabaseSession session,
    _i3.Chapter chapter, {
    _i1.Transaction? transaction,
  }) async {
    if (chapter.id == null) {
      throw ArgumentError.notNull('chapter.id');
    }

    var $chapter = chapter.copyWith(episodeId: null);
    await session.db.updateRow<_i3.Chapter>(
      $chapter,
      columns: [_i3.Chapter.t.episodeId],
      transaction: transaction,
    );
  }
}
