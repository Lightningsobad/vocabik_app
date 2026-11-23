import 'dart:async';

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
  final Completer<void>? completer;

  const RefreshVideos({this.completer});

  @override
  List<Object?> get props => [completer];
}

class ChangeCefrFilter extends HomeVideosEvent {
  final String? cefr;

  const ChangeCefrFilter(this.cefr);

  @override
  List<Object?> get props => [cefr];
}
