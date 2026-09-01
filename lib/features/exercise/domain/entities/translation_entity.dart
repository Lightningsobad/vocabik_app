import 'package:equatable/equatable.dart';

class TranslationEntity extends Equatable {
  final int lineIndex;
  final String language;
  final String text;

  const TranslationEntity({
    required this.lineIndex,
    required this.language,
    required this.text,
  });

  @override
  List<Object?> get props => [lineIndex, language, text];
}
