import 'package:equatable/equatable.dart';

abstract class HomeVideosEvent extends Equatable {
  const HomeVideosEvent();

  @override
  List<Object> get props => [];
}

class FetchVideos extends HomeVideosEvent {
  const FetchVideos();
}

class RefreshVideos extends HomeVideosEvent {
  const RefreshVideos();
}
