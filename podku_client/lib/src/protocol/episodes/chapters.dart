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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../episodes/chapter.dart' as _i2;
import 'package:podku_client/src/protocol/protocol.dart' as _i3;

abstract class ChaptersJson implements _i1.SerializableModel {
  ChaptersJson._({
    this.version,
    required this.chapters,
  });

  factory ChaptersJson({
    String? version,
    required List<_i2.Chapter> chapters,
  }) = _ChaptersJsonImpl;

  factory ChaptersJson.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChaptersJson(
      version: jsonSerialization['version'] as String?,
      chapters: _i3.Protocol().deserialize<List<_i2.Chapter>>(
        jsonSerialization['chapters'],
      ),
    );
  }

  String? version;

  List<_i2.Chapter> chapters;

  /// Returns a shallow copy of this [ChaptersJson]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChaptersJson copyWith({
    String? version,
    List<_i2.Chapter>? chapters,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChaptersJson',
      if (version != null) 'version': version,
      'chapters': chapters.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChaptersJsonImpl extends ChaptersJson {
  _ChaptersJsonImpl({
    String? version,
    required List<_i2.Chapter> chapters,
  }) : super._(
         version: version,
         chapters: chapters,
       );

  /// Returns a shallow copy of this [ChaptersJson]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChaptersJson copyWith({
    Object? version = _Undefined,
    List<_i2.Chapter>? chapters,
  }) {
    return ChaptersJson(
      version: version is String? ? version : this.version,
      chapters: chapters ?? this.chapters.map((e0) => e0.copyWith()).toList(),
    );
  }
}
