import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'download_manager.freezed.dart';

class DownloadManagerCubit extends Cubit<DownloadManagerState>{
  DownloadManagerCubit(super.initialState);

}

@freezed
sealed class DownloadManagerState with _$DownloadManagerState {
  const factory DownloadManagerState({
    /// bool: false queing
    @Default({}) Map<String, DownloadStatus> ongoingDownloads,
  }) = _DownloadManagerState;
}

enum DownloadStatus { noDownload, queuing, downloading, downloaded }
