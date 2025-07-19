import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';
import 'package:mr_alnagar/core/network/remote/api_endPoints.dart';
import 'package:mr_alnagar/core/network/remote/dio_helper.dart';

part 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizInitial());

  static QuizCubit get(BuildContext context) => BlocProvider.of(context);

  // Quiz data
  Map<String, dynamic>? quizData;
  int? attemptId;
  List<Map<String, dynamic>> answers = [];

  // Fetch quiz details
  Future<void> fetchQuiz(int quizId) async {
    emit(QuizLoadingState());
    try {
      final response = await DioHelper.getData(
        url: 'quiz/$quizId',
        token: CacheHelper.getData(key: 'token'),
      );

      if (response.data['success']) {
        quizData = response.data['data'];
        answers = List.generate(
          quizData?['questions']?.length ?? 0,
          (index) => {
            'id': quizData?['questions'][index]['id'],
            'answer': null,
          },
        );
        emit(QuizLoadedState());
      } else {
        emit(QuizErrorState(response.data['message'] ?? 'Failed to load quiz'));
      }
    } catch (e) {
      emit(QuizErrorState(e.toString()));
    }
  }

  // Start quiz
  Future<void> startQuiz(int quizId) async {
    emit(QuizStartingState());
    try {
      final response = await DioHelper.getData(
        url: 'quizzes/$quizId/start',
        token: CacheHelper.getData(key: 'token'),
      );

      if (response.data['success']) {
        attemptId = response.data['data']['attempt']['attempt_id'];
        emit(QuizStartedState());
      } else {
        emit(
          QuizErrorState(response.data['message'] ?? 'Failed to start quiz'),
        );
      }
    } catch (e) {
      emit(QuizErrorState(e.toString()));
    }
  }

  // Update answer for a specific question
  void updateAnswer(int questionId, dynamic answer) {
    final index = answers.indexWhere((a) => a['id'] == questionId);
    if (index != -1) {
      answers[index]['answer'] = answer;
      emit(QuizAnswerUpdatedState());
    }
  }

  // Submit quiz
  Future<void> submitQuiz(int quizId) async {
    emit(QuizSubmittingState());
    try {
      final response = await DioHelper.postData(
        url: 'student-quizzes/$quizId/submit',
        token: CacheHelper.getData(key: 'token'),
        data: {'answers': answers},
      );

      if (response.data['success']) {
        emit(QuizSubmittedState());
      } else {
        emit(
          QuizErrorState(response.data['message'] ?? 'Failed to submit quiz'),
        );
      }
    } catch (e) {
      emit(QuizErrorState(e.toString()));
    }
  }

  // Fetch quiz results
  Future<void> fetchQuizResults(int quizId) async {
    emit(QuizResultLoadingState());
    try {
      final response = await DioHelper.getData(
        url: 'student-quizzes/$quizId/results',
        token: CacheHelper.getData(key: 'token'),
      );

      if (response.data['success']) {
        emit(QuizResultLoadedState(response.data['answers']));
      } else {
        emit(
          QuizErrorState(
            response.data['message'] ?? 'Failed to load quiz results',
          ),
        );
      }
    } catch (e) {
      emit(QuizErrorState(e.toString()));
    }
  }
}
