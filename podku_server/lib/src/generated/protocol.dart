/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'episodes/chapter.dart' as _i3;
import 'episodes/chapters.dart' as _i4;
import 'episodes/episode_file_type.dart' as _i5;
import 'episodes/episode_files.dart' as _i6;
import 'episodes/episode_progress.dart' as _i7;
import 'episodes/episode_transcript.dart' as _i8;
import 'episodes/person.dart' as _i9;
import 'podcast/episode.dart' as _i10;
import 'podcast/person.dart' as _i11;
import 'podcast/podcast.dart' as _i12;
import 'podcast/search_result.dart' as _i13;
import 'package:podku_server/src/generated/podcast/episode.dart' as _i14;
import 'package:podku_server/src/generated/podcast/podcast.dart' as _i15;
import 'package:podku_server/src/generated/podcast/search_result.dart' as _i16;
export 'episodes/chapter.dart';
export 'episodes/chapters.dart';
export 'episodes/episode_file_type.dart';
export 'episodes/episode_files.dart';
export 'episodes/episode_progress.dart';
export 'episodes/episode_transcript.dart';
export 'episodes/person.dart';
export 'podcast/episode.dart';
export 'podcast/person.dart';
export 'podcast/podcast.dart';
export 'podcast/search_result.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'episode_chapters',
      dartName: 'Chapter',
      schema: 'public',
      module: 'podku',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'startTime',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'img',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'toc',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'endTime',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'episodeId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'episode_chapters_fk_0',
          columns: ['episodeId'],
          referenceTable: 'episodes',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'episode_chapters_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'episode_files',
      dartName: 'EpisodeFile',
      schema: 'public',
      module: 'podku',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'type',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:EpisodeFileType',
        ),
        _i2.ColumnDefinition(
          name: 'mime',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'url',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'language',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'rel',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'episodeId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'episode_files_fk_0',
          columns: ['episodeId'],
          referenceTable: 'episodes',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'episode_files_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'episode_people',
      dartName: 'EpisodePerson',
      schema: 'public',
      module: 'podku',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'role',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'group',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'image',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'link',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'episodeId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'episode_people_fk_0',
          columns: ['episodeId'],
          referenceTable: 'episodes',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'episode_people_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'episode_transcripts',
      dartName: 'EpisodeTranscript',
      schema: 'public',
      module: 'podku',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'startTime',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'endTime',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'speaker',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'content',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'language',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'episodeId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'episode_transcripts_fk_0',
          columns: ['episodeId'],
          referenceTable: 'episodes',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'episode_transcripts_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'episode_language_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'language',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'episodeId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'episodes',
      dartName: 'Episode',
      schema: 'public',
      module: 'podku',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'audioUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'audioType',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'audioLengthBytes',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'pubDateMillis',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'durationSeconds',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'guid',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'imageUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'seasonNumber',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'episodeNumber',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'episodeType',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'explicit',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'link',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'podcastId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'progress',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '0.000',
        ),
        _i2.ColumnDefinition(
          name: 'processed',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'episodes_fk_0',
          columns: ['podcastId'],
          referenceTable: 'podcasts',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'episodes_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
        _i2.IndexDefinition(
          indexName: 'timeIndex',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'pubDateMillis',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'podcast_people',
      dartName: 'PodcastPerson',
      schema: 'public',
      module: 'podku',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'role',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'group',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'image',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'link',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'episodeId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'podcast_people_fk_0',
          columns: ['episodeId'],
          referenceTable: 'podcasts',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'podcast_people_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'podcasts',
      dartName: 'Podcast',
      schema: 'public',
      module: 'podku',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'url',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'artworkUrl',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'author',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'link',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'podcasts_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    ..._i2.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i3.Chapter) {
      return _i3.Chapter.fromJson(data) as T;
    }
    if (t == _i4.ChaptersJson) {
      return _i4.ChaptersJson.fromJson(data) as T;
    }
    if (t == _i5.EpisodeFileType) {
      return _i5.EpisodeFileType.fromJson(data) as T;
    }
    if (t == _i6.EpisodeFile) {
      return _i6.EpisodeFile.fromJson(data) as T;
    }
    if (t == _i7.EpisodeProgress) {
      return _i7.EpisodeProgress.fromJson(data) as T;
    }
    if (t == _i8.EpisodeTranscript) {
      return _i8.EpisodeTranscript.fromJson(data) as T;
    }
    if (t == _i9.EpisodePerson) {
      return _i9.EpisodePerson.fromJson(data) as T;
    }
    if (t == _i10.Episode) {
      return _i10.Episode.fromJson(data) as T;
    }
    if (t == _i11.PodcastPerson) {
      return _i11.PodcastPerson.fromJson(data) as T;
    }
    if (t == _i12.Podcast) {
      return _i12.Podcast.fromJson(data) as T;
    }
    if (t == _i13.SearchResult) {
      return _i13.SearchResult.fromJson(data) as T;
    }
    if (t == _i1.getType<_i3.Chapter?>()) {
      return (data != null ? _i3.Chapter.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.ChaptersJson?>()) {
      return (data != null ? _i4.ChaptersJson.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.EpisodeFileType?>()) {
      return (data != null ? _i5.EpisodeFileType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.EpisodeFile?>()) {
      return (data != null ? _i6.EpisodeFile.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.EpisodeProgress?>()) {
      return (data != null ? _i7.EpisodeProgress.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.EpisodeTranscript?>()) {
      return (data != null ? _i8.EpisodeTranscript.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.EpisodePerson?>()) {
      return (data != null ? _i9.EpisodePerson.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.Episode?>()) {
      return (data != null ? _i10.Episode.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.PodcastPerson?>()) {
      return (data != null ? _i11.PodcastPerson.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.Podcast?>()) {
      return (data != null ? _i12.Podcast.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.SearchResult?>()) {
      return (data != null ? _i13.SearchResult.fromJson(data) : null) as T;
    }
    if (t == List<_i3.Chapter>) {
      return (data as List).map((e) => deserialize<_i3.Chapter>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i3.Chapter>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i3.Chapter>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i9.EpisodePerson>) {
      return (data as List)
              .map((e) => deserialize<_i9.EpisodePerson>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i9.EpisodePerson>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i9.EpisodePerson>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i6.EpisodeFile>) {
      return (data as List).map((e) => deserialize<_i6.EpisodeFile>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i6.EpisodeFile>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i6.EpisodeFile>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i8.EpisodeTranscript>) {
      return (data as List)
              .map((e) => deserialize<_i8.EpisodeTranscript>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i8.EpisodeTranscript>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i8.EpisodeTranscript>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i10.Episode>) {
      return (data as List).map((e) => deserialize<_i10.Episode>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i10.Episode>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i10.Episode>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i11.PodcastPerson>) {
      return (data as List)
              .map((e) => deserialize<_i11.PodcastPerson>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i11.PodcastPerson>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i11.PodcastPerson>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i14.Episode>) {
      return (data as List).map((e) => deserialize<_i14.Episode>(e)).toList()
          as T;
    }
    if (t == List<_i15.Podcast>) {
      return (data as List).map((e) => deserialize<_i15.Podcast>(e)).toList()
          as T;
    }
    if (t == List<_i16.SearchResult>) {
      return (data as List)
              .map((e) => deserialize<_i16.SearchResult>(e))
              .toList()
          as T;
    }
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i3.Chapter => 'Chapter',
      _i4.ChaptersJson => 'ChaptersJson',
      _i5.EpisodeFileType => 'EpisodeFileType',
      _i6.EpisodeFile => 'EpisodeFile',
      _i7.EpisodeProgress => 'EpisodeProgress',
      _i8.EpisodeTranscript => 'EpisodeTranscript',
      _i9.EpisodePerson => 'EpisodePerson',
      _i10.Episode => 'Episode',
      _i11.PodcastPerson => 'PodcastPerson',
      _i12.Podcast => 'Podcast',
      _i13.SearchResult => 'SearchResult',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('podku.', '');
    }

    switch (data) {
      case _i3.Chapter():
        return 'Chapter';
      case _i4.ChaptersJson():
        return 'ChaptersJson';
      case _i5.EpisodeFileType():
        return 'EpisodeFileType';
      case _i6.EpisodeFile():
        return 'EpisodeFile';
      case _i7.EpisodeProgress():
        return 'EpisodeProgress';
      case _i8.EpisodeTranscript():
        return 'EpisodeTranscript';
      case _i9.EpisodePerson():
        return 'EpisodePerson';
      case _i10.Episode():
        return 'Episode';
      case _i11.PodcastPerson():
        return 'PodcastPerson';
      case _i12.Podcast():
        return 'Podcast';
      case _i13.SearchResult():
        return 'SearchResult';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Chapter') {
      return deserialize<_i3.Chapter>(data['data']);
    }
    if (dataClassName == 'ChaptersJson') {
      return deserialize<_i4.ChaptersJson>(data['data']);
    }
    if (dataClassName == 'EpisodeFileType') {
      return deserialize<_i5.EpisodeFileType>(data['data']);
    }
    if (dataClassName == 'EpisodeFile') {
      return deserialize<_i6.EpisodeFile>(data['data']);
    }
    if (dataClassName == 'EpisodeProgress') {
      return deserialize<_i7.EpisodeProgress>(data['data']);
    }
    if (dataClassName == 'EpisodeTranscript') {
      return deserialize<_i8.EpisodeTranscript>(data['data']);
    }
    if (dataClassName == 'EpisodePerson') {
      return deserialize<_i9.EpisodePerson>(data['data']);
    }
    if (dataClassName == 'Episode') {
      return deserialize<_i10.Episode>(data['data']);
    }
    if (dataClassName == 'PodcastPerson') {
      return deserialize<_i11.PodcastPerson>(data['data']);
    }
    if (dataClassName == 'Podcast') {
      return deserialize<_i12.Podcast>(data['data']);
    }
    if (dataClassName == 'SearchResult') {
      return deserialize<_i13.SearchResult>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i3.Chapter:
        return _i3.Chapter.t;
      case _i6.EpisodeFile:
        return _i6.EpisodeFile.t;
      case _i8.EpisodeTranscript:
        return _i8.EpisodeTranscript.t;
      case _i9.EpisodePerson:
        return _i9.EpisodePerson.t;
      case _i10.Episode:
        return _i10.Episode.t;
      case _i11.PodcastPerson:
        return _i11.PodcastPerson.t;
      case _i12.Podcast:
        return _i12.Podcast.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'podku';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _i2.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
