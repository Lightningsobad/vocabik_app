import 'package:equatable/equatable.dart';
import 'package:vocabik_app/shared/domain/entities/video_entity.dart';

abstract class HomeNewlyState extends Equatable {
  final String? currentCefr;

  const HomeNewlyState({this.currentCefr});

  @override
  List<Object?> get props => [currentCefr];
}

class HomeNewlyInitial extends HomeNewlyState {
  const HomeNewlyInitial({super.currentCefr});
}

class HomeNewlyLoading extends HomeNewlyState {
  const HomeNewlyLoading({super.currentCefr});
}

class HomeNewlyLoaded extends HomeNewlyState {
  final List<VideoEntity> videos;

  const HomeNewlyLoaded({
    required this.videos,
    super.currentCefr,
  });

  HomeNewlyLoaded copyWith({
    List<VideoEntity>? videos,
    String? currentCefr,
    bool clearCefr = false,
  }) {
    return HomeNewlyLoaded(
      videos: videos ?? this.videos,
      currentCefr: clearCefr ? null : (currentCefr ?? this.currentCefr),
    );
  }

  @override
  List<Object?> get props => [videos, currentCefr];
}

class HomeNewlyError extends HomeNewlyState {
  final String message;

  const HomeNewlyError(this.message, {super.currentCefr});

  @override
  List<Object?> get props => [message, currentCefr];
}
