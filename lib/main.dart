import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mr_alnagar/core/cubits/auth_cubit/auth_cubit/auth_cubit.dart';
import 'package:mr_alnagar/core/cubits/books_cubit/books_cubit.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/cubits/home_cubit/home_cubit.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_cubit.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/quiz_cubit.dart';
import 'package:mr_alnagar/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:mr_alnagar/core/cubits/quiz_results_cubit/quiz_results_cubit.dart';
import 'package:mr_alnagar/core/cubits/splash_cubit/splash_cubit.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/features/authentication/login_layout/login_page.dart';
import 'package:mr_alnagar/features/home_screen/home_layout.dart';
import 'package:mr_alnagar/features/courses_view/videos_view/videos_view.dart';
import 'package:mr_alnagar/features/profile_view/profile_view.dart';
import 'package:mr_alnagar/features/splash/splash_screen.dart';
import 'package:mr_alnagar/firebase_options.dart';
import 'package:screen_protector/screen_protector.dart';
import 'core/network/local/shared_prefrence.dart';
import 'core/network/remote/dio_helper.dart';
import 'features/error_screen.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await DioHelper.init();
  Bloc.observer;
  await CacheHelper.init();
  await ScreenProtector.preventScreenshotOn();



  // Custom error screen
  ErrorWidget.builder = (FlutterErrorDetails details) => ErrorScreen();

  runApp(
    DevicePreview(
      enabled: !kDebugMode,
      builder: (context) => ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SplashCubit(), lazy: true),
        BlocProvider(create: (context) => AuthCubit()
          ..getLevelsForAuthCategories()
          ..getGovernments()),
        BlocProvider(create: (context) => HomeCubit()
          ..getLeaderBoard(categoryID: CacheHelper.getData(key: CacheKeys.categoryId))..getAboutUsData()
          ..getHomeData(context: context), lazy: true),
        BlocProvider(create: (context) => LessonsCubit()..getCoursesByCategory(categoryID: CacheHelper.getData(key: CacheKeys.categoryId)), lazy: true),
        BlocProvider(create: (context) => QuizCubit(), lazy: true),
        BlocProvider(create: (context) => CoursesCubit()
          ..getCoursesByCategory(
            categoryID: CacheHelper.getData(key: CacheKeys.id),
            filter: 'my',
          )
          ..getCourses(), lazy: true),
        BlocProvider(create: (context) => ProfileCubit()..getHomeWorksResultsForProfile()
          ..getProfileInfo()
          ..getUserStats()..getPrivacyPolicy()
          ..getMyCompletedCourses()..getMyInProgressCourses(), lazy: true),
        BlocProvider(create: (context) => QuizResultsCubit()
          ..fetchQuizResults(), lazy: true),
        BlocProvider(create: (context) => BooksCubit()
          ..getAllBooks(), lazy: true),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: kDebugMode,
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: 'cairo',
          scaffoldBackgroundColor: Colors.white,
          scrollbarTheme: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.all(AppColors.primaryColor),
          ),
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
        ),
        home: HomeLayout(),
      ),
    );
  }
}
