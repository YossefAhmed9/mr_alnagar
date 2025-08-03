import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';

import '../../network/remote/api_endPoints.dart';
import '../../network/remote/dio_helper.dart';
import '../../utils/text_styles.dart';
import 'courses_state.dart';

class CoursesCubit extends Cubit<CoursesState> {
  CoursesCubit() : super(CoursesInitial());

  static CoursesCubit get(context) => BlocProvider.of(context);

  bool isCourseLoading=false;
  void changeIsCourseLoading(){
    isCourseLoading=!isCourseLoading;
    emit(ChangeIsCourseDone());
  }




  bool isSubmissionLoading=false;
  void changeIsSubmissionLoading(){
    isSubmissionLoading=!isSubmissionLoading;
    emit(ChangeIsCourseDone());
  }






  List coursesCategory = [];
  Future<void> getCoursesByCategory({
    required int categoryID,
    required String filter,
  }) async {
    emit(GetCoursesByCategoryLoading());
    await DioHelper.getData(
          url: EndPoints.courses_by_category,
          query: {'category_id': categoryID, 'filer': filter},
      token: CacheHelper.getData(key: CacheKeys.token),
        )
        .then((value) {
          coursesCategory.addAll(value.data['data']);
          print(coursesCategory);
          print(value.data);
          emit(GetCoursesByCategoryDone());
        })
        .catchError((error) {
          print(error);
          print(error.toString());
          print(error.runtimeType);
          emit(GetCoursesByCategoryError(error));
        });
  }

void showLoadOnRefresh({required int id ,required BuildContext context}){
    emit(GetVideosLoading());
    getVideosByCourse(id: id, context: context);
    emit(GetVideosDone());
}

  var coursesVideos;
  Future<void> getVideosByCourse({required int id, required BuildContext context}) async {
    emit(GetVideosLoading());

    try {
      final response = await DioHelper.getData(
        url: '${EndPoints.videosByCourse}/$id',
        token: CacheHelper.getData(key: CacheKeys.token),
      );

      final statusCode = response.statusCode;
      // print('///////////////////////////////////');
      // print('Status Code: $statusCode');
      // print('Response Data: ${response.data}');
      // print('///////////////////////////////////');

      if (statusCode == 200 && response.data != null && response.data['data'] != null) {
        coursesVideos = response.data['data'];
        if (response.data['data']['sections_data'].isEmpty) {
          showSnackBar(context, 'لا توجد فيديوهات متاحة', 4, Colors.red);
        }  
        emit(GetVideosDone());
      } else {
        final message = response.data['message'] ?? 'فشل تحميل الفيديوهات';
        showSnackBar(context, message, 3, Colors.orange);
        emit(GetVideosError(message));
      }

    } on DioException catch (dioError) {
      final response = dioError.response;
      final statusCode = response?.statusCode;
      final errorMessage = response?.data['message'] ??
          dioError.message ??
          'حدث خطأ أثناء تحميل الفيديوهات';

      print('///////////////////////////////////');
      print('DioError: $errorMessage');
      print('Status Code: $statusCode');
      print('Error Data: ${response?.data}');
      print('///////////////////////////////////');

      showSnackBar(context, errorMessage, 3, Colors.red);
      emit(GetVideosError(errorMessage));

    } catch (e) {
      print('///////////////////////////////////');
      print('Unknown Error: $e');
      print('///////////////////////////////////');

      showSnackBar(context, 'حدث خطأ غير متوقع. الرجاء المحاولة لاحقًا.', 3, Colors.red);
      emit(GetVideosError(e.toString()));
    }
  }





  List courses = [];
  Future<void> getCourses() async {
    emit(GetCoursesByCategoryLoading());
    await DioHelper.getData(url: EndPoints.courses,token: CacheHelper.getData(key: CacheKeys.token))
        .then((value) {
          courses = [];
          courses.addAll(value.data['data']);
          //print(coursesCategory);
          print(value.data);
          //print(value.data['data'][0]['title'].toString());
          emit(GetCoursesByCategoryDone());
        })
        .catchError((error) {
          print(error);
          print(error.toString());
          print(error.runtimeType);
          emit(GetCoursesByCategoryError(error));
        });
  }


  List courseResult=[];
  Future<Response?> getCourseByID({required int id}) async {
    emit(GetCourseLoading());
    await DioHelper.getData(url: "${EndPoints.getCourseByID}/$id",
        token: CacheHelper.getData(key: CacheKeys.token))
        .then((value) {
          //books.addAll(value.data['data']);
      courseResult=[];
      courseResult.add(value.data['data']);
          print(value.data['data']['description']);
          print(courseResult);
          emit(GetCourseDone());
          return value.data['data'];
          //print(value.data);
        })
        .catchError((error) {
          print(error);
          print(error.toString());
          print(error.runtimeType);
          emit(GetCourseError(error));
        });
    return null;
  }

  Response? result;
  Future<Response?> getClassesByCoursesID({required int id}) async {
    emit(GetClassesByCoursesIDLoading());
    await DioHelper.getData(
          url: "${EndPoints.getClassesByCoursesID}/$id",
          token: CacheHelper.getData(key: CacheKeys.token),
        )
        .then((value) {
          result = value.data;
          if (kDebugMode) {
            print(value.data['success']);
            print(value.realUri);
            print(value.statusCode);
          }

          emit(GetClassesByCoursesIDDone());
          return value.data['data'];
          //print(value.data);
        })
        .catchError((error) {
          print(result?.statusCode);
          print(result?.realUri);
          print(error.toString());
          print(error.runtimeType);
          emit(GetClassesByCoursesIDError(error));
        });
    return null;
  }
  Future<void> enrollInCourse({required int courseID,required String paymentType})async{
    emit(EnrollInCourseLoading());
    await DioHelper.postData(url: EndPoints.enrollCourse, data: {
      "course_id": courseID,
      "payment_type": paymentType
    },token: CacheHelper.getData(key: CacheKeys.token),

    ).then((value){

      print(value.data);
      print(value.data["message"]);
      print(value.data["data"]);
    emit(EnrollInCourseDone());
    }).catchError((error){
      print('error from enrollment');
      print(error);
      emit(EnrollInCourseError(error));
    });
  }


  Future<void> enrollInClass() async {
    emit(EnrollInClassLoading());

    await DioHelper.postData(
          url: EndPoints.enrollClass,
          data: {"class_id": 1},
          token: CacheHelper.getData(key: CacheKeys.token),
        )
        .then((value) {
          print(value.data);
          print(value.data["message"]);
          print(value.data["data"]);
          emit(EnrollInClassDone());
        })
        .catchError((error) {
          emit(EnrollInClassError(error));
        });
  }

  // Get class by ID
  Future<void> getClassById({required int classId}) async {
    emit(GetCourseLoading());
    await DioHelper.getData(
          url: "${EndPoints.classById}/$classId",
          token: CacheHelper.getData(key: CacheKeys.token),
        )
        .then((value) {
          print(value.data);
          emit(GetCourseDone());
        })
        .catchError((error) {
          print(error);
          emit(GetCourseError(error));
        });
  }

  // Get quiz by ID
  Future<void> getQuizById({required int quizId}) async {
    emit(GetCourseLoading());
    await DioHelper.getData(
          url: "${EndPoints.quizById}/$quizId",
          token: CacheHelper.getData(key: CacheKeys.token),
        )
        .then((value) {
          print(value.data);
          emit(GetCourseDone());
        })
        .catchError((error) {
          print(error);
          emit(GetCourseError(error));
        });
  }

  // Start quiz
  var quiz;
  List quizQuestions = [];
  List quizAnswers = [];

  Future<void> startQuiz({required int quizId}) async {
    emit(GetQuizLoading());

    await DioHelper.getData(
      url: "${EndPoints.startQuiz}/$quizId/start",
      token: CacheHelper.getData(key: CacheKeys.token),
    ).then((value) {
      //print(value.data['data']);
      quiz = value.data['data'];
      quizQuestions.clear();

      // Save list of questions
      quizQuestions.addAll((quiz['quiz']['questions']));
      print('//////////////////');
      // Save all answers for each question
      //quizAnswers.addAll((quiz['quiz']['questions'][0]['questions'][0]['answers']));
      //print(value.data);
      // print(quizQuestions.length);
      // print(quizAnswers);

      emit(GetQuizDone());
    }).catchError((error) {
      print(error);
      emit(GetQuizError(error));
    });
  }

  List<dynamic> studentQuizAnswers = [];

  void updateStudentQuizAnswer({
    required int questionIndex,
    required int answerId,
    required dynamic selectedAnswer, // this can be int or null
  }) {
    // Ensure the list is long enough
    if (studentQuizAnswers.length <= questionIndex) {
      studentQuizAnswers.length = questionIndex + 1;
    }

    // Store the object with id and answer index
    studentQuizAnswers[questionIndex] = {
      "id": answerId,
      "answer": selectedAnswer,
    };

    print(studentQuizAnswers);
    emit(StudentAnswerStored());
  }

  List<dynamic> studentHomeWorkAnswers = [];

  void updateStudentHomeWorkAnswer({
    required int questionIndex,
    required int answerId,
    required dynamic selectedAnswer, // this can be int or null
  }) {
    // Ensure the list is long enough
    if (studentHomeWorkAnswers.length <= questionIndex) {
      studentHomeWorkAnswers.length = questionIndex + 1;
    }

    // Store the object with id and answer index
    studentHomeWorkAnswers[questionIndex] = {
      "id": answerId,
      "answer": selectedAnswer,
    };

    print(studentHomeWorkAnswers);
    emit(StudentAnswerStored());
  }

  // Submit quiz
  var quizSubmission;
  Future<void> submitQuiz({
    required int attemptID,
    required dynamic answers,
  }) async {
    emit(SubmitQuizLoading());

    try {
      final response = await DioHelper.postData(
        url: "${EndPoints.submitQuiz}/$attemptID/submit",
        data: {"answers": answers},
        token: CacheHelper.getData(key: CacheKeys.token),
      );

      print(response.data);
      quizSubmission=response.data['data'];
      emit(SubmitQuizDone());

    } on DioException catch (dioError) {
      String errorMessage = "Failed to submit quiz. Please try again.";

      if (dioError.type == DioExceptionType.connectionTimeout ||
          dioError.type == DioExceptionType.sendTimeout ||
          dioError.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Connection timed out. Please check your internet connection.";
      } else if (dioError.type == DioExceptionType.badResponse) {
        final response = dioError.response;
        if (response != null && response.data != null) {
          if (response.data is Map<String, dynamic> &&
              response.data['message'] != null) {
            errorMessage = response.data['message'];
          } else {
            errorMessage = "Server error: ${response.statusCode}";
          }
        }
      } else if (dioError.type == DioExceptionType.unknown) {
        errorMessage = "Unexpected error occurred. Please try again.";
      }

      print("Submit Quiz DioError: $errorMessage ${dioError.response} ${dioError.message} ${dioError.error}");
      emit(SubmitQuizError(errorMessage));

    } catch (e) {
      print("Submit Quiz Error: $e");
      emit(SubmitQuizError(e.toString()));
    }
  }


  // Get quiz result
  var quizResult;
  Future<void> getQuizResult({required int attemptID}) async {
    emit(GetCourseLoading());
    await DioHelper.getData(
          url: "${EndPoints.resultQuiz}/$attemptID/results",
          token: CacheHelper.getData(key: CacheKeys.token),
        )
        .then((value) {
          print(value.data);
          quizResult=value.data['data'];
          emit(GetCourseDone());
        })
        .catchError((error) {
          print(error);
          emit(GetCourseError(error));
        });
  }

  var homeWorkResult;
  Future<void> getHomeWorkResult({required int attemptID}) async {
    emit(GetHomeWorkResultLoading());
    await DioHelper.getData(
      url: "${EndPoints.resultHomework}/$attemptID/results",
      token: CacheHelper.getData(key: CacheKeys.token),
    )
        .then((value) {
      print(value.data);
      homeWorkResult=value.data['data'];
      emit(GetHomeWorkResultDone());
    })
        .catchError((error) {
      print(error);
      emit(GetHomeWorkResultError(error));
    });
  }



  // Start homework
  var homework;
  List homeworkQuestions=[];
  Future<void> startHomework({
   // required BuildContext context,
    required int homeworkId,
  }) async {
    emit(GetCourseLoading());

    try {
      final response = await DioHelper.getData(
        url: "${EndPoints.startHomework}/$homeworkId/start",
        token: CacheHelper.getData(key: CacheKeys.token),
      );

      print(response.data);
      homework=response.data['data'];
      homeworkQuestions=response.data['data']['homework']['questions'];
      emit(GetCourseDone());

      // showSnackBar(
      //   context,
      //   'تم بدء الواجب بنجاح',
      //   2,
      //   Colors.green,
      // );
    } on DioException catch (dioError) {
      String errorMessage = 'حدث خطأ أثناء الاتصال بالخادم';

      if (dioError.type == DioExceptionType.connectionTimeout ||
          dioError.type == DioExceptionType.sendTimeout ||
          dioError.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'انتهت مهلة الاتصال. حاول مرة أخرى.';
      } else if (dioError.type == DioExceptionType.badResponse) {
        final statusCode = dioError.response?.statusCode;
        if (statusCode != null) {
          if (statusCode >= 400 && statusCode < 500) {
            errorMessage = 'طلب غير صالح أو مرفوض (${statusCode})';
          } else if (statusCode >= 500) {
            errorMessage = 'خطأ في الخادم (${statusCode})';
          }
        }
      } else if (dioError.type == DioExceptionType.unknown) {
        errorMessage = 'حدث خطأ غير معروف. تحقق من اتصالك بالإنترنت.';
      }

      emit(GetCourseError(errorMessage));
      //showSnackBar(context, errorMessage, 3, Colors.red);
    } catch (error) {
      final fallbackError = 'حدث خطأ غير متوقع.';
      emit(GetCourseError(fallbackError));
      //showSnackBar(context, fallbackError, 3, Colors.red);
      print(error);
    }
  }


  // Submit homework
  var homewrokSubmission;
  Future<void> submitHomework({
    required int attemptID,
    required dynamic answers,
    required BuildContext context,
  }) async {
    emit(EnrollInCourseLoading());

    try {
      final value = await DioHelper.postData(
        url: "${EndPoints.submitHomework}/$attemptID/submit",
        data: {"answers": answers},
        token: CacheHelper.getData(key: CacheKeys.token),
      );

      print(value.data);
      homewrokSubmission=value.data['data'];
      emit(EnrollInCourseDone());

      showSnackBar(
        context,
        "Homework submitted successfully!",
        3,
        Colors.green,
      );

    } on DioException catch (dioError) {
      String errorMessage = "Failed to submit homework. Please try again.";

      if (dioError.type == DioExceptionType.connectionTimeout ||
          dioError.type == DioExceptionType.sendTimeout ||
          dioError.type == DioExceptionType.receiveTimeout) {
        errorMessage = "Connection timed out. Please check your internet.";
      } else if (dioError.type == DioExceptionType.badResponse) {
        final response = dioError.response;
        if (response != null && response.data != null) {
          // Try to extract a readable error message from response
          if (response.data is Map<String, dynamic> &&
              response.data['message'] != null) {
            errorMessage = response.data['message'];
          } else {
            errorMessage = "Server error: ${response.statusCode}";
          }
        }
      } else if (dioError.type == DioExceptionType.unknown) {
        errorMessage = "Unexpected error occurred. Please try again.";
      }

      print("Submission DioError: $errorMessage ${dioError.response} ${dioError.message}");
      emit(EnrollInCourseError(errorMessage));

      showSnackBar(
        context,
        errorMessage,
        3,
        Colors.red,
      );

    } catch (e) {
      print("Submission Error: $e");
      emit(EnrollInCourseError(e.toString()));

      showSnackBar(
        context,
        "An unexpected error occurred. Please try again.",
        3,
        Colors.red,
      );
    }
  }


  // Get homework result
  // Future<void> getHomeworkResult({required int homeworkId}) async {
  //   emit(GetCourseLoading());
  //   await DioHelper.getData(
  //         url: "${EndPoints.resultHomework}/$homeworkId",
  //         token: CacheHelper.getData(key: CacheKeys.token),
  //       )
  //       .then((value) {
  //         print(value.data);
  //         emit(GetCourseDone());
  //       })
  //       .catchError((error) {
  //         print(error);
  //         emit(GetCourseError(error));
  //       });
  // }

  // Get videos by classes
  Future<void> getVideosByClasses({required int classId}) async {
    emit(GetVideosByCourseLoading());
    await DioHelper.getData(
          url: "${EndPoints.videosByClasses}/$classId",
          token: CacheHelper.getData(key: CacheKeys.token),
        )
        .then((value) {
          print(value.data);
          emit(GetVideosByCourseSuccess(value.data));
        })
        .catchError((error) {
          print(error);
          emit(GetCourseError(error));
        });
  }

  // Watch video
  var videoData;
  Future<void> watchVideo({required int videoId}) async {
    emit(GetVideosByCourseLoading());
    await DioHelper.getData(
          url: "${EndPoints.videosByCourse}/$videoId",
          data: {},
          token: CacheHelper.getData(key: CacheKeys.token),
        )
        .then((value) {
          print(value.data);
          videoData=value.data['data'];
          emit(GetVideosByCourseSuccess(value.data));
        })
        .catchError((error) {
          print(error);
          emit(GetCourseError(error));
        });
  }


  var videoSeconds;
  Future<void> postVideoSeconds({required int videoId,required int lastWatchedSecond,required int watchSeconds}) async {
    emit(GetVideosByCourseLoading());
    await DioHelper.postData(
          url: "${EndPoints.videos}/$videoId/watch",
          data: {
            "watch_seconds": watchSeconds,          // Total number of seconds the student has just watched in this session
            "last_watched_second": lastWatchedSecond     // The exact second in the video where the student stopped watching (seek position)
          },
          token: CacheHelper.getData(key: CacheKeys.token),
        )
        .then((value) {
          print(value.data);
          videoSeconds=value.data['data'];
          emit(GetVideosByCourseSuccess(value.data));
        })
        .catchError((error) {
          print(error);
          emit(GetCourseError(error));
        });
  }


  void showSnackBar(BuildContext context, String message, int duration, Color? color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,style: TextStyles.textStyle16w700(context),),
        duration: Duration(seconds: duration),
        backgroundColor: color,
      ),
    );
  }
  // Get certificate
  Future<void> getCertificate({required int courseId}) async {
    emit(GetCourseLoading());
    await DioHelper.getData(
          url: "${EndPoints.certificate}/$courseId",
          token: CacheHelper.getData(key: CacheKeys.token),
        )
        .then((value) {
          print(value.data);
          emit(GetCourseDone());
        })
        .catchError((error) {
          print(error);
          emit(GetCourseError(error));
        });
  }
}
