part of 'main_shell_cubit.dart';

class MainShellState extends Equatable {
  final bool isLoading;
  final ProgressSummary? summary;
  final String? errorMessage;

  const MainShellState({
    this.isLoading = false,
    this.summary,
    this.errorMessage,
  });

  MainShellState copyWith({
    bool? isLoading,
    ProgressSummary? summary,
    String? errorMessage,
  }) {
    return MainShellState(
      isLoading: isLoading ?? this.isLoading,
      summary: summary ?? this.summary,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isLoading, summary, errorMessage];
}
