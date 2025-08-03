import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mr_alnagar/core/network/remote/api_endPoints.dart';
import 'package:mr_alnagar/core/network/remote/dio_helper.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/features/home_screen/home_page.dart';
import 'package:mr_alnagar/features/lessons_view/lessons_view.dart';
import 'package:mr_alnagar/features/profile_view/ProfileLayout/profile_layout.dart';

import '../../../features/courses_view/courses_view.dart';
import '../../../features/notification_view/notification_view.dart';
import '../../../features/profile_view/profile_view.dart';
import '../../network/local/cashe_keys.dart';
import '../../network/local/shared_prefrence.dart';
import '../auth_cubit/auth_cubit/auth_cubit.dart';
import '../courses_cubit/courses_cubit.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  static HomeCubit get(context) => BlocProvider.of(context);

  List screens = [
    HomePage(),
    LessonsView(),
    CoursesView(),
    ProfileLayout(),
    NotificationView(),
  ];

  int currentIndex = 0;
  void changeBottomNavBarIndex({required int index}) {
    currentIndex = index;
    emit(ChangeNavBarIndex());
  }

  var aboutUs;
  Future<void> getAboutUsData() async {
    emit(GetAboutUsDataLoading());
    await DioHelper.getData(url: EndPoints.aboutUs)
        .then((value) {
          aboutUs = value.data['data'];
          emit(GetAboutUsDataDone());
          if (kDebugMode) {
            print(value.data);
          }
        })
        .catchError((error) {
          if (kDebugMode) {
            print(error);
          }
          emit(GetAboutUsDataError(error));
        });
  }

  Future<void> POSTaskUS({
    required String name,
    required String phone,
    required String email,
    required String message,
    required int id,
    required BuildContext context,
  }) async {
    emit(POSTAskUsLoading());

    try {
      final response = await DioHelper.postData(
        url: EndPoints.AskUs,
        data: {
          "name": name,
          "phone": phone,
          "email": email,
          "message": message,
          "category_id": id,
        },
      );

      emit(POSTAskUsDone());

      showSnackBar(
        context,
        response.data['message'] ?? 'تم الإرسال بنجاح',
        5,
        AppColors.primaryColor,
      );

      if (kDebugMode) {
        print(response.data);
        print(response.realUri);
      }
    } catch (error) {
      emit(POSTAskUsError(error));

      if (kDebugMode) {
        print(error);
        print(error.toString());
        print(error.runtimeType);
      }

      showSnackBar(
        context,
        'فشل في إرسال الرسالة: ${error.toString()}',
        4,
        Colors.red,
      );
    }
  }

  var home;
  var homeData;
  List homeSliders = [];
  List commonQuestion = [];
  var faqQuestion;
  List rates = [];
  var contactUsData;
  var howToUse;
  Future<void> getHomeData({required BuildContext context}) async {
    emit(GETHomeDataLoading());

    // Trigger other dependent Cubits
    AuthCubit.get(context).getLevelsForAuthCategories();
    CoursesCubit.get(context).getCoursesByCategory(
      categoryID: CacheHelper.getData(key: CacheKeys.id),
      filter: 'my',
    );

    await DioHelper.getData(url: EndPoints.home)
        .then((value) {
          var data = value.data['data'];

          // Save all parts of the response
          home = value.data['data'];
          homeData = data['ask_us'];
          homeSliders = data['sliders'];
          faqQuestion = data['CommonQuestion'];
          commonQuestion = data['CommonQuestion']['question_and_answer'];
          rates = data['rates'];
          contactUsData = data['contact_us_data'];
          howToUse = data['HowUse'];

          books = data['Books'];
          featuredCourses = data['featured_courses'];
          courses = data['courses'];
          categories = data['categories'];
          heroesByCategory = data['heroes_by_category'];

          emit(GETHomeDataDone());
        })
        .catchError((error) {
          print('Home Data Error: $error');

          emit(GETHomeDataError(error));
        });
  }

  List books = [];
  List featuredCourses = [];
  List courses = [];
  List categories = [];
  List heroesByCategory = [];

  Future<void> GETaskUS(BuildContext context) async {
    emit(GETAskUsLoading());

    try {
      final response = await DioHelper.getData(url: EndPoints.AskUs);
      emit(GETAskUsDone());

      if (kDebugMode) {
        print(response.data);
      }

      showSnackBar(
        context,
        'تم تحميل البيانات بنجاح',
        3,
        AppColors.primaryColor,
      );
    } catch (error) {
      emit(GETAskUsError(error));

      if (kDebugMode) {
        print(error);
        print(error.toString());
        print(error.runtimeType);
      }

      showSnackBar(
        context,
        'حدث خطأ أثناء تحميل البيانات: ${error.toString()}',
        4,
        Colors.red,
      );
    }
  }

  List topStudents = [];
  Future<void> getLeaderBoard({required int categoryID}) async {
    emit(GETLeaderBoardLoading());
    await DioHelper.getData(
          url: EndPoints.leaderBoard,
          query: {"category_id": categoryID},
        )
        .then((value) {
          topStudents = [];
          topStudents = value.data['data']['topStudents'];
          print(value.data);
          emit(GETLeaderBoardDone());
        })
        .catchError((error) {
          print(error);
          emit(GETLeaderBoardError(error));
        });
  }

  void showSnackBar(
    BuildContext context,
    String message,
    int duration,
    Color? color,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: duration),
        backgroundColor: color,
      ),
    );
  }
}
