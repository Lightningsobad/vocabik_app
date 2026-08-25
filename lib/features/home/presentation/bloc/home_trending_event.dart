import 'package:equatable/equatable.dart';

abstract class HomeTrendingEvent extends Equatable {
  const HomeTrendingEvent();

  @override
  List<Object?> get props => [];
}

class FetchTrendingVideos extends HomeTrendingEvent {
  const FetchTrendingVideos();
}

class RefreshTrendingVideos extends HomeTrendingEvent {
  const RefreshTrendingVideos();
}

class ChangeTrendingCefrFilter extends HomeTrendingEvent {
  final String? cefr;

  const ChangeTrendingCefrFilter(this.cefr);

  @override
  List<Object?> get props => [cefr];
}
