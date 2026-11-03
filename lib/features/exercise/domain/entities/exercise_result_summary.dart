import 'package:equatable/equatable.dart';

class WrongAnswerDetail extends Equatable {
  final int blankIndex;
  final int blankStep; // e.g. 5 for Blank 5
  final String beforeText;
  final String correctWord;
  final String afterText;
  final String? userAnswer;

  const WrongAnswerDetail({
    required this.blankIndex,
    required this.blankStep,
    required this.beforeText,
    required this.correctWord,
    required this.afterText,
    this.userAnswer,
  });

  @override
  List<Object?> get props => [
        blankIndex,
        blankStep,
        beforeText,
        correctWord,
        afterText,
        userAnswer,
      ];
}

class BlankAnswerEntity extends Equatable {
  final int blankIndex;
  final bool isCorrect;

  const BlankAnswerEntity({
    required this.blankIndex,
    required this.isCorrect,
  });

  @override
  List<Object?> get props => [blankIndex, isCorrect];
}

class ExerciseResultSummary extends Equatable {
  final int totalQuestions;
  final int correctCount;
  final int wrongCount;
  final int accuracyScore; // 0 - 100
  final Duration duration;
  final List<WrongAnswerDetail> wrongAnswers;
  final List<String> correctUserAnswers;
  final List<BlankAnswerEntity> blankAnswers;

  const ExerciseResultSummary({
    required this.totalQuestions,
    required this.correctCount,
    required this.wrongCount,
    required this.accuracyScore,
    required this.duration,
    required this.wrongAnswers,
    this.correctUserAnswers = const [],
    this.blankAnswers = const [],
  });

  @override
  List<Object?> get props => [
        totalQuestions,
        correctCount,
        wrongCount,
        accuracyScore,
        duration,
        wrongAnswers,
        correctUserAnswers,
        blankAnswers,
      ];
}
