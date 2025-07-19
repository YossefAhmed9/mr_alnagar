part of 'quiz_results_cubit.dart';

abstract class QuizResultsState {}

class QuizResultsInitial extends QuizResultsState {}

class QuizResultsLoading extends QuizResultsState {}

class QuizResultsSuccess extends QuizResultsState {}

class QuizResultsError extends QuizResultsState {
  final String error;

  QuizResultsError(this.error);
}
