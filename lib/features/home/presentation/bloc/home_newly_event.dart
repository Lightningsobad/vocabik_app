import 'dart:async';

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
  final Completer<void>? completer;

  const RefreshNewlyVideos({this.completer});

  @override
  List<Object?> get props => [completer];
}

class ChangeNewlyCefrFilter extends HomeNewlyEvent {
  final String? cefr;

  const ChangeNewlyCefrFilter(this.cefr);

  @override
  List<Object?> get props => [cefr];
}
