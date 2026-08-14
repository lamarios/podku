//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'offline_progress.g.dart';


@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class OfflineProgress {
  /// Returns a new [OfflineProgress] instance.
  OfflineProgress({

     this.timeOfProgress,

     this.progress,
  });

  @JsonKey(
    
    name: r'timeOfProgress',
    required: false,
    includeIfNull: false,
  )


  final int? timeOfProgress;



  @JsonKey(
    
    name: r'progress',
    required: false,
    includeIfNull: false,
  )


  final int? progress;





    @override
    bool operator ==(Object other) => identical(this, other) || other is OfflineProgress &&
      other.timeOfProgress == timeOfProgress &&
      other.progress == progress;

    @override
    int get hashCode =>
        timeOfProgress.hashCode +
        progress.hashCode;

  factory OfflineProgress.fromJson(Map<String, dynamic> json) => _$OfflineProgressFromJson(json);

  Map<String, dynamic> toJson() => _$OfflineProgressToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

