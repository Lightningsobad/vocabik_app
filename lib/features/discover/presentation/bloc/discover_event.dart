import 'package:equatable/equatable.dart';

abstract class DiscoverEvent extends Equatable {
  const DiscoverEvent();

  @override
  List<Object?> get props => [];
}

class DiscoverVideosFetched extends DiscoverEvent {}

class DiscoverSearchQueryChanged extends DiscoverEvent {
  final String query;

  const DiscoverSearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class DiscoverFilterChanged extends DiscoverEvent {
  final String? cefr;
  final String? genre;
  final String? window;
  final String? duration;

  const DiscoverFilterChanged({
    this.cefr,
    this.genre,
    this.window,
    this.duration,
  });

  @override
  List<Object?> get props => [cefr, genre, window, duration];
}

class DiscoverRefreshRequested extends DiscoverEvent {}
