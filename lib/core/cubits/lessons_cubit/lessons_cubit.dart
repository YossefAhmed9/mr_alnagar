import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';
import 'package:mr_alnagar/core/network/remote/api_endPoints.dart';
import 'package:mr_alnagar/core/network/remote/dio_helper.dart';

import '../../utils/text_styles.dart';
import 'lessons_state.dart';

class LessonsCubit extends Cubit<LessonsState> {
  LessonsCubit() : super(LessonsInitial());
  static LessonsCubit get(context) => BlocProvider.of(context);

  int tabBarIndex = 0;
  void changeTabBarIndex({required int index}) {
    tabBarIndex = index;
    emit(ChangeTabBarIndex());
  }

  // void selectAnswer({required int questionIndex, required int answerIndex}) {
  //   final updated = Map<int, int>.from(state);
  //   updated[questionIndex] = answerIndex;
  //   emit(AnswerUpdated());
  // }
  bool isLessonLoading = false;
  void changeIsLessonLoading() {
    isLessonLoading = !isLessonLoading;
    emit(ChangeIsLessonDone());
  }

  void showSnackBar(
    BuildContext context,
    String message,
    int duration,
    Color? color,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyles.textStyle16w700(context)),
        duration: Duration(seconds: duration),
        backgroundColor: color,
      ),
    );
  }

  Future<void> enrollInLesson({
    required int courseID,
    required String paymentType,
  }) async {
    emit(EnrollInLessonLoading());
    await DioHelper.postData(
          url: EndPoints.enrollCourse,
          data: {"course_id": courseID, "payment_type": paymentType},
          token: CacheHelper.getData(key: CacheKeys.token),
        )
        .then((value) {
          print(value.data);
          print(value.data["message"]);
          print(value.data["data"]);
          emit(EnrollInLessonDone());
        })
        .catchError((error) {
          emit(EnrollInLessonError(error));
        });
  }

  var quiz;
  List quizQuestions = [];

  Future<void> startQuiz({required int quizId}) async {
    emit(GetQuizLoading());

    await DioHelper.getData(
          url: "${EndPoints.startQuiz}/$quizId/start",
          token: CacheHelper.getData(key: CacheKeys.token),
        )
        .then((value) {
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
        })
        .catchError((error) {
          print(error);
          emit(GetQuizError(error));
        });
  }

  List oneTimeClassesAll=[];
  Future<void> getAllOneTimeClasses()async{
    emit(GetAllOneTimeLessonsLoading());
    await DioHelper.getData(url: EndPoints.allClasses,
    token: CacheHelper.getData(key: CacheKeys.token),
    ).then((value){
      oneTimeClassesAll=[];
      oneTimeClassesAll.addAll(value.data['data']);
      print(value.data);
      print("oneTimeClassesAll");
      print(oneTimeClassesAll);
      emit(GetAllOneTimeLessonsDone());

    }).catchError((error){
      emit(GetUserLessonsError(error));
    });
  }


Future<void> oneTimeLessonAccessClass({required int classID,required String code})async{
    emit(OneTimeLessonAccessClassLoading());
    await DioHelper.postData(url: EndPoints.accessClass,
        token: CacheHelper.getData(key: CacheKeys.token),
        data: {
      "class_id":classID,
      "code":code,
    }).then((value){
      print(value.data);
      emit(OneTimeLessonAccessClassDone());
    }).catchError((error){
      print(error);
      emit(OneTimeLessonAccessClassError(error));
    });
  }


  var videosByClassesWithCode;
  Future<void> getVideosByClassesWithCode({required int classID})async{
    emit(GetVideosByClassesWithCodeLoading());
await DioHelper.getData(url: "${EndPoints.videosByClassesWithCode}/$classID",
token: CacheHelper.getData(key: CacheKeys.token)
).then((value){
  print(value.data);
  emit(GetVideosByClassesWithCodeDone());
}).catchError((error){
  emit(GetVideosByClassesWithCodeError(error));

});

  }





  var quizResult;
  Future<void> getQuizResult({required int attemptID}) async {
    emit(GetCourseLoading());
    await DioHelper.getData(
          url: "${EndPoints.resultQuiz}/$attemptID/results",
          token: CacheHelper.getData(key: CacheKeys.token),
        )
        .then((value) {
          print(value.data);
          quizResult = value.data['data'];
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
          homeWorkResult = value.data['data'];
          emit(GetHomeWorkResultDone());
        })
        .catchError((error) {
          print(error);
          emit(GetHomeWorkResultError(error));
        });
  }

  bool isSubmissionLoading = false;
  void changeIsSubmissionLoading() {
    isSubmissionLoading = !isSubmissionLoading;
    emit(ChangeIsCourseDone());
  }

  var homewrokSubmission;
  Future<void> submitHomework({
    required int attemptID,
    required dynamic answers,
    required BuildContext context,
  }) async {
    emit(HomeWorkSubmissionLoading());

    try {
      final value = await DioHelper.postData(
        url: "${EndPoints.submitHomework}/$attemptID/submit",
        data: {"answers": answers},
        token: CacheHelper.getData(key: CacheKeys.token),
      );

      print(value.data);
      homewrokSubmission = value.data['data'];
      emit(HomeWorkSubmissionDone());

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

      print(
        "Submission DioError: $errorMessage ${dioError.response} ${dioError.message}",
      );
      emit(HomeWorkSubmissionError(errorMessage));

      showSnackBar(context, errorMessage, 3, Colors.red);
    } catch (e) {
      print("Submission Error: $e");
      emit(HomeWorkSubmissionError(e.toString()));

      showSnackBar(
        context,
        "An unexpected error occurred. Please try again.",
        3,
        Colors.red,
      );
    }
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
      quizSubmission = response.data['data'];
      emit(SubmitQuizDone());
    } on DioException catch (dioError) {
      String errorMessage = "Failed to submit quiz. Please try again.";

      if (dioError.type == DioExceptionType.connectionTimeout ||
          dioError.type == DioExceptionType.sendTimeout ||
          dioError.type == DioExceptionType.receiveTimeout) {
        errorMessage =
            "Connection timed out. Please check your internet connection.";
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

      print(
        "Submit Quiz DioError: $errorMessage ${dioError.response} ${dioError.message} ${dioError.error}",
      );
      emit(SubmitQuizError(errorMessage));
    } catch (e) {
      print("Submit Quiz Error: $e");
      emit(SubmitQuizError(e.toString()));
    }
  }

  List userLessons = [];
  Future<void> getUserLessons({required int id}) async {
    emit(GetUserLessonsLoading());
    await DioHelper.getData(
          url: '${EndPoints.getClassesByCoursesID}/$id',
          token: CacheHelper.getData(key: CacheKeys.token),
        )
        .then((value) {
          userLessons = [];
          userLessons.addAll(value.data['data']);
          if (kDebugMode) {
            print("userLessons");
            print(userLessons);
          }
          emit(GetUserLessonsDone());
        })
        .catchError((error) {
      print("userLessons");
print(error);
      emit(GetUserLessonsError(error));
        });
  }

  // var LessonsVideos;
  // Future<void> getVideosByLesson({
  //   required int id,
  //   required BuildContext context,
  // }) async {
  //   emit(GetVideosLoading());
  //
  //   try {
  //     final response = await DioHelper.getData(
  //       url: '${EndPoints.videosByCourse}/$id',
  //       token: CacheHelper.getData(key: CacheKeys.token),
  //     );
  //
  //     final statusCode = response.statusCode;
  //     // print('///////////////////////////////////');
  //     // print('Status Code: $statusCode');
  //     // print('Response Data: ${response.data}');
  //     // print('///////////////////////////////////');
  //
  //     if (statusCode == 200 &&
  //         response.data != null &&
  //         response.data['data'] != null) {
  //       LessonsVideos = response.data['data'];
  //       if (response.data['data']['sections_data'].isEmpty) {
  //         showSnackBar(context, 'لا توجد فيديوهات متاحة', 4, Colors.red);
  //       }
  //
  //       emit(GetVideosDone());
  //     } else {
  //       final message = response.data['message'] ?? 'فشل تحميل الفيديوهات';
  //       showSnackBar(context, message, 3, Colors.orange);
  //       emit(GetVideosError(message));
  //     }
  //   } on DioException catch (dioError) {
  //     final response = dioError.response;
  //
  //     print('///////////////////////////////////');
  //     print('DioError: ${response!.data}');
  //     print('DioError: ${response!.statusCode}');
  //     print('Status Code: ${response!.statusCode}');
  //     print('Error Data: ${response?.data}');
  //     print('///////////////////////////////////');
  //
  //     showSnackBar(context, response.data['message'].toString(), 5, Colors.red);
  //     emit(GetVideosError(response!.data['message']));
  //   } catch (e) {
  //     print('///////////////////////////////////');
  //     print('Unknown Error: $e');
  //     print('///////////////////////////////////');
  //
  //     showSnackBar(
  //       context,
  //       'حدث خطأ غير متوقع. الرجاء المحاولة لاحقًا.',
  //       3,
  //       Colors.red,
  //     );
  //     emit(GetVideosError(e.toString()));
  //   }
  // }

  var videoSeconds;
  Future<void> postVideoSeconds({
    required int videoId,
    required int lastWatchedSecond,
    required int watchSeconds,
  }) async {
    emit(GetVideosByCourseLoading());
    await DioHelper.postData(
          url: "${EndPoints.videos}/$videoId/watch",
          data: {
            "watch_seconds":
                watchSeconds, // Total number of seconds the student has just watched in this session
            "last_watched_second":
                lastWatchedSecond, // The exact second in the video where the student stopped watching (seek position)
          },
          token: CacheHelper.getData(key: CacheKeys.token),
        )
        .then((value) {
          print(value.data);
          videoSeconds = value.data['data'];
          emit(GetVideosByCourseSuccess(value.data));
        })
        .catchError((error) {
          print(error);
          emit(GetVideosByCourseError(error));
        });
  }

  bool isAnswerSelected = true;

  // New properties for classes and courses
  List courses = [];
  List myCourses = [];
  bool isLoading = false;

  List videos = [];
  // List homeworkResults = [];
  List lessonResult = [];
  Future<void> getClassesByCourseId({required int courseId}) async {
    isLoading = true;
    emit(ClassesLoading());

    try {
      final response = await DioHelper.getData(
        url: '${EndPoints.getClassesByCoursesID}/$courseId',
        token: CacheHelper.getData(key: CacheKeys.token),
      );

      // classes = response.data['data'];
      if (kDebugMode) {
        print(response.data);
        print(response.statusCode);
        print(response.realUri);
      }
      lessonResult = [];
      lessonResult.addAll(response.data['data']);
      print('lessonResult');
      print(lessonResult);

      isLoading = false;
      emit(ClassesFetched());
    } catch (error) {
      isLoading = false;
      if (kDebugMode) {
        print(error);
        print(error.hashCode);
        print(error.runtimeType);
      }

      emit(ClassesError(error.toString()));
    }
  }

  Future<void> getMyLessons({
    required int categoryID,
    String filter = 'my',
  }) async {
    isLoading = true;
    emit(CoursesLoading());

    try {
      final response = await DioHelper.getData(
        url: EndPoints.courses_by_category,
        query: {"category_id": categoryID, "filter": filter},
        token: CacheHelper.getData(key: CacheKeys.token),
      );

      // Check if the response is successful and contains data
      if (response.statusCode == 200) {
        myCourses=[];
        myCourses = response.data['data'];
        print("myCourses");
        print(myCourses);

        // Emit different states based on whether data is empty or not
        if (myCourses.isEmpty) {
          emit(CoursesEmpty());
        } else {
          emit(CoursesFetched(myCourses));
        }
      } else {
        emit(CoursesError('Failed to fetch lessons'));
      }

      isLoading = false;
    } catch (error) {
      isLoading = false;
      emit(CoursesError(error.toString()));
    }
  }

  List otherLessons=[];
  Future<void> getOtherLessons({
    required int categoryID,
    String filter = 'other',
  }) async {
    isLoading = true;
    emit(CoursesLoading());

    try {
      final response = await DioHelper.getData(
        url: EndPoints.courses_by_category,
        query: {"category_id": categoryID, "filter": filter},
        token: CacheHelper.getData(key: CacheKeys.token),
      );

      // Check if the response is successful and contains data
      if (response.statusCode == 200) {
        otherLessons=[];
        otherLessons = response.data['data'];
        print("otherLessons");
        print(otherLessons);

        // Emit different states based on whether data is empty or not
        if (otherLessons.isEmpty) {
          emit(CoursesEmpty());
        } else {
          emit(CoursesFetched(otherLessons));
        }
      } else {
        emit(CoursesError('Failed to fetch lessons'));
      }

      isLoading = false;
    } catch (error) {
      isLoading = false;
      emit(CoursesError(error.toString()));
    }
  }

  Future<void> getCoursesByCategory({required int categoryID}) async {
    isLoading = true;
    emit(CoursesLoading());

    try {
      final response = await DioHelper.getData(
        url: EndPoints.courses_by_category,
        query: {"category_id": categoryID},
        token: CacheHelper.getData(key: CacheKeys.token),
      );

      // Check if the response is successful and contains data
      if (response.statusCode == 200) {
        courses = response.data['data'];
        print('this is courses');
        print(courses);

        // Emit different states based on whether data is empty or not
        if (courses.isEmpty) {
          emit(CoursesEmpty());
        } else {
          emit(CoursesFetched(courses));
        }
      } else {
        emit(CoursesError('Failed to fetch courses'));
      }

      isLoading = false;
    } catch (error) {
      isLoading = false;
      emit(CoursesError(error.toString()));
    }
  }

  Future<void> getVideosByClass({required int classId}) async {
    //isLoading = true;
    emit(VideosLoading());

    await DioHelper.getData(
          url: 'videos_by_classes/$classId',
          token: CacheHelper.getData(key: CacheKeys.token),
        )
        .then((value) {
          if (kDebugMode) {
            // print('**************');
            print(value.data);
            // print(value.statusCode);
            // print(value.realUri);
            // print('**************');
          }
          videos = [];
          videos.add(value.data['data']);
          isLoading = false;
          emit(VideosFetched());
        })
        .catchError((error) {
          isLoading = false;
          if (kDebugMode) {
            print(error);
            print(error.hashCode);
            print(error.runtimeType);
          }
          emit(VideosError(error.toString()));
        });
  }

var nextClass;
  var classData;
  Future<void> getClassDataByID({
    required BuildContext context,
    required int classId,
  }) async {
    emit(GetClassDataByIDLoading());

    try {
      final response = await DioHelper.getData(
        url: "${EndPoints.classById}/$classId",
        token: CacheHelper.getData(key: CacheKeys.token),
      );

      classData = response.data['data'];
      nextClass = response.data['data']['next_class_id'];
      emit(GetClassDataByIDDone());

      print(classData);
      showSnackBar(context, 'تم تحميل بيانات الفصل بنجاح', 2, Colors.green);
    } on DioException catch (dioError) {
      String errorMessage = 'حدث خطأ أثناء تحميل بيانات الفصل';

      if (dioError.type == DioExceptionType.connectionTimeout) {
        errorMessage = 'انتهت مهلة الاتصال بالخادم';
      } else if (dioError.type == DioExceptionType.sendTimeout) {
        errorMessage = 'انتهت مهلة إرسال البيانات';
      } else if (dioError.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'انتهت مهلة استلام البيانات';
      } else if (dioError.type == DioExceptionType.badResponse) {
        final statusCode = dioError.response?.statusCode;
        final serverMessage = dioError.response?.data['message'] ?? dioError.response?.data['error'];

        if (statusCode == 400) {
          errorMessage = serverMessage ?? 'طلب غير صالح (400)';
        } else if (statusCode == 401) {
          errorMessage = serverMessage ?? 'غير مصرح (401)';
        } else if (statusCode == 403) {
          errorMessage = serverMessage ?? 'تم رفض الوصول (403)';
        } else if (statusCode == 404) {
          errorMessage = serverMessage ?? 'الفصل غير موجود (404)';
        } else if (statusCode == 500) {
          errorMessage = serverMessage ?? 'خطأ في الخادم (500)';
        } else {
          errorMessage = serverMessage ?? 'خطأ غير متوقع (${statusCode ?? "?"})';
        }
      } else if (dioError.type == DioExceptionType.cancel) {
        errorMessage = 'تم إلغاء الطلب';
      } else if (dioError.type == DioExceptionType.unknown) {
        errorMessage = 'تحقق من الاتصال بالإنترنت';
      }
      emit(GetClassDataByIDError(dioError));
      print("*******");

      print(dioError.response);
      //showSnackBar(context, errorMessage, 3, Colors.red);
    } catch (e) {
      emit(GetClassDataByIDError(e));
      print(e);
      showSnackBar(context, 'حدث خطأ غير متوقع أثناء تحميل بيانات الفصل', 3, Colors.red);
    }
  }

  List courseResult = [];
  Future<Response?> getCourseByID({required int id}) async {
    emit(GetCourseLoading());
    await DioHelper.getData(
          url: "${EndPoints.getCourseByID}/$id",
          token: CacheHelper.getData(key: CacheKeys.token),
        )
        .then((value) {
          //books.addAll(value.data['data']);
          courseResult = [];
          courseResult.add(value.data['data']);
          print(value.data['data']['description']);
          print(courseResult);
          emit(GetCourseDone());
          return value.data['data'];
          //print(value.data);
        })
        .catchError((error) {
          //print(error);
          print(error.toString());
          print(error.runtimeType);
          emit(GetCourseError(error));
        });
    return null;
  }

  var homework;
  List homeworkQuestions = [];
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
      homework = response.data['data'];
      homeworkQuestions = response.data['data']['homework']['questions'];
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

  // Future<void> submitHomework({
  //   required int homeworkId,
  //   required Map<String, dynamic> answers,
  // }) async {
  //   isLoading = true;
  //   emit(HomeworkResultsLoading());
  //   try {
  //     final response = await DioHelper.postData(
  //       url: "${EndPoints.submitHomework}/$homeworkId",
  //       data: answers,
  //       token: CacheHelper.getData(key: CacheKeys.token),
  //     );
  //     print(response.data);
  //     print(response.statusCode);
  //     print(response.realUri);
  //     isLoading = false;
  //     emit(HomeworkResultsFetched());
  //   } catch (error) {
  //     isLoading = false;
  //     print(error);
  //     emit(HomeworkResultsError(error.toString()));
  //   }
  // }

  Future<void> getHomeworkResult({required int homeworkId}) async {
    isLoading = true;
    emit(HomeworkResultsLoading());
    try {
      final response = await DioHelper.getData(
        url: "${EndPoints.resultHomework}/$homeworkId",
        token: CacheHelper.getData(key: CacheKeys.token),
      );
      print(response.data);
      print(response.statusCode);
      print(response.realUri);
      isLoading = false;
      emit(HomeworkResultsFetched());
    } catch (error) {
      isLoading = false;
      print(error);
      emit(HomeworkResultsError(error.toString()));
    }
  }

  Future<void> getVideosByClasses({required int classId}) async {
    isLoading = true;
    emit(VideosLoading());
    try {
      final response = await DioHelper.getData(
        url: "${EndPoints.videosByClasses}/$classId",
        token: CacheHelper.getData(key: CacheKeys.token),
      );
      print(response.data);
      print(response.statusCode);
      print(response.realUri);
      videos = response.data['data'];
      isLoading = false;
      emit(VideosFetched());
    } catch (error) {
      isLoading = false;
      print(error);
      emit(VideosError(error.toString()));
    }
  }

  Future<void> watchVideo({required int videoId}) async {
    isLoading = true;
    emit(VideosLoading());
    try {
      final response = await DioHelper.postData(
        url: "${EndPoints.videos}/$videoId",
        data: {},
        token: CacheHelper.getData(key: CacheKeys.token),
      );
      print(response.data);
      print(response.statusCode);
      print(response.realUri);
      isLoading = false;
      emit(VideosFetched());
    } catch (error) {
      isLoading = false;
      print(error);
      emit(VideosError(error.toString()));
    }
  }

  // Fetch enrollment status for a class
  Future<void> getEnrollmentStatus({required int classId}) async {
    emit(EnrollmentStatusLoading());
    try {
      final response = await DioHelper.getData(
        url: "${EndPoints.enrollmentStatus}/$classId",
        token: CacheHelper.getData(key: CacheKeys.token),
      );
      print(response.data);
      emit(EnrollmentStatusDone(response.data));
    } catch (error) {
      print(error);
      emit(EnrollmentStatusError(error.toString()));
    }
  }
}
