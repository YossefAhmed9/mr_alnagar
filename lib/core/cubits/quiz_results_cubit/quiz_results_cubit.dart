import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_alnagar/core/models/quiz_result_model.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';
import 'package:mr_alnagar/core/network/remote/api_endPoints.dart';
import 'package:mr_alnagar/core/network/remote/dio_helper.dart';
import 'package:mr_alnagar/core/network/remote/network_interceptor.dart';

part 'quiz_results_state.dart';

class QuizResultsCubit extends Cubit<QuizResultsState> {
  QuizResultsCubit() : super(QuizResultsInitial());

  static QuizResultsCubit get(context) => BlocProvider.of(context);

  List quizResults = [];

  Future<void> fetchQuizResults() async {
    emit(QuizResultsLoading());

    await DioHelper.getData(
          url: EndPoints.quizzesResults,
          token: await CacheHelper.getData(key: CacheKeys.token),
        )
        .then((value) {
          quizResults = value.data['data'];
          emit(QuizResultsSuccess());
        })
        .catchError((error) {
          emit(QuizResultsError(error));
        });
  }

  Future<void> refreshQuizResults() async {
    await fetchQuizResults();
  }
}
