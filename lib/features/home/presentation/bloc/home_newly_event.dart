import 'package:equatable/equatable.dart';

abstract class HomeNewlyEvent extends Equatable {
  const HomeNewlyEvent();

  @override
  List<Object?> get props => [];
}

class FetchNewlyVideos extends HomeNewlyEvent {
  const FetchNewlyVideos();
}

class RefreshNewlyVideos extends HomeNewlyEvent {
  const RefreshNewlyVideos();
}
