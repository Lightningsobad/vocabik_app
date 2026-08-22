import 'package:equatable/equatable.dart';

abstract class HomeVideosEvent extends Equatable {
  const HomeVideosEvent();

  @override
  List<Object?> get props => [];
}

class FetchVideos extends HomeVideosEvent {
  const FetchVideos();
}

class RefreshVideos extends HomeVideosEvent {
  const RefreshVideos();
}

class ChangeCefrFilter extends HomeVideosEvent {
  final String? cefr;

  const ChangeCefrFilter(this.cefr);

  @override
  List<Object?> get props => [cefr];
}
