part of 'quiz_cubit.dart';

@immutable
abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizLoadingState extends QuizState {}

class QuizLoadedState extends QuizState {}

class QuizStartingState extends QuizState {}

class QuizStartedState extends QuizState {}

class QuizAnswerUpdatedState extends QuizState {}

class QuizSubmittingState extends QuizState {}

class QuizSubmittedState extends QuizState {}

class QuizResultLoadingState extends QuizState {}

class QuizResultLoadedState extends QuizState {
  final Map<String, dynamic> results;

  QuizResultLoadedState(this.results);
}

class QuizErrorState extends QuizState {
  final String errorMessage;

  QuizErrorState(this.errorMessage);
}
