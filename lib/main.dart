import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
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
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/features/home_screen/home_layout.dart';
import 'package:mr_alnagar/features/splash/splash_screen.dart';
import 'package:mr_alnagar/firebase_options.dart';
import 'package:screen_protector/screen_protector.dart';
import 'core/network/local/shared_prefrence.dart';
import 'core/network/remote/dio_helper.dart';
import 'features/error_screen.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';


class InternetAwareWrapper extends StatefulWidget {
  final Widget child;
  final List<Function()> onInternetRestored;

  const InternetAwareWrapper({
    Key? key,
    required this.child,
    required this.onInternetRestored,
  }) : super(key: key);

  @override
  State<InternetAwareWrapper> createState() => _InternetAwareWrapperState();
}

class _InternetAwareWrapperState extends State<InternetAwareWrapper> {
  late StreamSubscription<ConnectivityResult> _subscription;
  bool _isConnected = true;
  bool _wasDisconnected = false;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  void _startMonitoring() {
    _subscription = Connectivity().onConnectivityChanged.listen((_) {
      _checkInternetAccess();
    });

    _checkInternetAccess();
  }

  Future<void> _checkInternetAccess() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));

      final isConnected = response.statusCode == 200;

      setState(() {
        _isConnected = isConnected;
      });

      _handleConnectionChange(isConnected);
    } catch (_) {
      setState(() {
        _isConnected = false;
      });

      _handleConnectionChange(false);
    }
  }

  void _handleConnectionChange(bool isConnected) {
    if (!isConnected) {
      _wasDisconnected = true;
    } else if (_wasDisconnected) {
      // Internet restored
      _wasDisconnected = false;
      for (var callback in widget.onInternetRestored) {
        callback();
      }
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        widget.child,
        if (!_isConnected)
          Container(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height * 1,
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Replace with your asset path
                Image.asset(
                  'assets/images/no internet.jpg',
                  height: 200,
                  width: 200,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.wifi_off,
                      size: 100,
                      color: Colors.grey[400],
                    );
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'لا يوجد اتصال بالانترنت',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: MaterialButton(
                      onPressed: _checkInternetAccess,
                      child: const Text(
                        'اعادة المحاولة',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
// 🔹 MainAppWrapper with UniqueKey refresh trick
// class MainAppWrapper extends StatefulWidget {
//   const MainAppWrapper({Key? key}) : super(key: key);
//
//   @override
//   State<MainAppWrapper> createState() => _MainAppWrapperState();
// }
//
// class _MainAppWrapperState extends State<MainAppWrapper> {
//   Key refreshKey = UniqueKey();
//   late StreamSubscription connectivitySubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     connectivitySubscription =
//         Connectivity().onConnectivityChanged.listen((status) {
//           if (status != ConnectivityResult.none) {
//             // 🔹 Internet restored → rebuild the visible screen
//             setState(() {
//               refreshKey = UniqueKey();
//             });
//           }
//         });
//   }
//
//   @override
//   void dispose() {
//     connectivitySubscription.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return KeyedSubtree(
//       key: refreshKey, // This forces rebuild but keeps Navigator stack intact
//       child: const MyApp(),
//     );
//   }
// }

class ConnectivityWrapper extends StatefulWidget {
  final Widget child;

  const ConnectivityWrapper({required this.child, Key? key}) : super(key: key);

  @override
  State<ConnectivityWrapper> createState() => _ConnectivityWrapperState();
}

class _ConnectivityWrapperState extends State<ConnectivityWrapper> {
  late StreamSubscription<ConnectivityResult> _subscription;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _startMonitoring();
  }

  void _startMonitoring() {
    _subscription = Connectivity().onConnectivityChanged.listen((_) {
      _checkInternetAccess();
    });

    _checkInternetAccess();
  }

  Future<void> _checkInternetAccess() async {
    try {
      final response = await http
          .get(Uri.parse('https://www.google.com'))
          .timeout(const Duration(seconds: 5));
      setState(() {
        _isConnected = response.statusCode == 200;
      });
    } catch (_) {
      setState(() {
        _isConnected = false;
      });
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (!_isConnected)
          Container(
            width: double.infinity,
            height: MediaQuery.sizeOf(context).height * 1,
            color: Colors.white,
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                Image.asset('assets/images/no internet.jpg'),
                Text(
                  'لا يوجد اتصال بالانترنت',
                  style: TextStyle(
                      color: AppColors.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w900),
                ),
                Center(
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(35)),
                    child: MaterialButton(
                      onPressed: _checkInternetAccess,
                      child: Text(
                        'اعادة المحاولة',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

// Firebase Messaging background handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("🔔 Background Message Received: ${message.messageId}");
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await DioHelper.init();
  await CacheHelper.init();
  await ScreenProtector.preventScreenshotOn();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  ErrorWidget.builder = (FlutterErrorDetails details) => ErrorScreen();

  runApp(
    DevicePreview(
      enabled: kDebugMode,
      builder: (context) => ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => const MyApp(), // ⬅️ Wrapped here
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    _initFirebaseMessaging();
  }

  void _initFirebaseMessaging() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ User granted permission');
      String? token = await _firebaseMessaging.getToken();
      print('📲 FCM Token: $token');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('📥 Foreground message: ${message.notification?.title}');
      });

      FirebaseMessaging.instance.getInitialMessage().then((message) {
        if (message != null) {
          print(
              '🚀 App launched by tapping notification: ${message.messageId}');
        }
      });

      FirebaseMessaging.onMessageOpenedApp
          .listen((RemoteMessage message) {
        print(
            '📬 Notification tapped in background: ${message.messageId}');
      });
    } else {
      print('❌ User declined or has not accepted permission');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SplashCubit(), lazy: true),
        BlocProvider(
          create: (context) => AuthCubit()
            ..getLevelsForAuthCategories()
            ..getGovernments(),
        ),
        BlocProvider(
          create: (context) => HomeCubit()
            ..getLeaderBoard(
              categoryID: CacheHelper.getData(
                key: CacheKeys.categoryId,
              ),
            )
            ..getAboutUsData()
            ..getHomeData(context: context),
          lazy: true,
        ),
        BlocProvider(
          create: (context) => LessonsCubit()
            ..getCoursesByCategory(
              categoryID: CacheHelper.getData(
                key: CacheKeys.categoryId,
              ),
            )
            ..getLessonsListForOneTimeClasses(
                category_id: CacheHelper.getData(key: CacheKeys.categoryId))
            ..getMyLessons(
              categoryID: CacheHelper.getData(
                key: CacheKeys.categoryId,
              ),
            )
            ..getOtherLessons(
              categoryID: CacheHelper.getData(
                key: CacheKeys.categoryId,
              ),
            )
            ..getAllOneTimeClasses()
            ..getFilterationAllOneTimeClasses(
                categoryID: null, courseID: null),
          lazy: true,
        ),
        BlocProvider(create: (context) => QuizCubit(), lazy: true),
        BlocProvider(
          create: (context) => CoursesCubit()
            ..getCoursesByCategory(
              categoryID: CacheHelper.getData(key: CacheKeys.id),
              filter: 'my',
            )
            ..getCourses(),
          lazy: true,
        ),
        BlocProvider(
          create: (context) => ProfileCubit()
            ..getHomeWorksResultsForProfile()
            ..getProfileInfo(context: context)
            ..getUserStats()
            ..getPrivacyPolicy()
            ..getMyCompletedCourses()
            ..getMyInProgressCourses(),
          lazy: true,
        ),
        BlocProvider(
          create: (context) => QuizResultsCubit()..fetchQuizResults(),
          lazy: true,
        ),
        BlocProvider(
          create: (context) => BooksCubit()..getAllBooks(),
          lazy: true,
        ),
      ],
      child: InternetAwareWrapper(
        onInternetRestored: [

        ],
        child: MaterialApp(
          navigatorKey: navigatorKey,
        //showPerformanceOverlay: true,
          //debugShowMaterialGrid: true,
          //showSemanticsDebugger: true,
          //debugShowCheckedModeBanner: kDebugMode,
          theme: ThemeData(
            fontFamily: 'cairo',
            scaffoldBackgroundColor: Colors.white,
            scrollbarTheme: ScrollbarThemeData(
              thumbColor: WidgetStateProperty.all(AppColors.primaryColor),
            ),
            colorScheme: ColorScheme.fromSeed(
              seedColor: AppColors.primaryColor,
            ),
          ),
          home: SplashScreen(),
        ),
      ),
    );
  }
}
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
