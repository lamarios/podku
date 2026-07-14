import 'package:background_downloader/background_downloader.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_progress.freezed.dart';

@freezed
sealed class DownloadProgress with _$DownloadProgress {
  const factory DownloadProgress({
    required String id,
    required TaskStatus status,
    required double progress
  }) = _DownloadProgress;

}