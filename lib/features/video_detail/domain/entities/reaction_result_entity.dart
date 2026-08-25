import 'package:equatable/equatable.dart';

class ReactionResultEntity extends Equatable {
  final bool created;
  final Map<String, int> counts;

  const ReactionResultEntity({
    required this.created,
    required this.counts,
  });

  @override
  List<Object?> get props => [created, counts];
}
