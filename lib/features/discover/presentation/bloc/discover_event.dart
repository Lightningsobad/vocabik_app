import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:vocabik_app/shared/domain/entities/video_category_entity.dart';

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
  final String? exerciseType;
  final String? duration;

  const DiscoverFilterChanged({
    this.cefr,
    this.genre,
    this.exerciseType,
    this.duration,
  });

  @override
  List<Object?> get props => [cefr, genre, exerciseType, duration];
}

class DiscoverRefreshRequested extends DiscoverEvent {
  final Completer<void>? completer;

  const DiscoverRefreshRequested({this.completer});

  @override
  List<Object?> get props => [completer];
}

class DiscoverCategoriesUpdated extends DiscoverEvent {
  final List<VideoCategoryEntity>? categories;

  const DiscoverCategoriesUpdated(this.categories);

  @override
  List<Object?> get props => [categories];
}
