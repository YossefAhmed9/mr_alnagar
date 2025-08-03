import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';
import 'package:mr_alnagar/core/cubits/home_cubit/home_cubit.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';
import 'package:mr_alnagar/core/network/remote/api_endPoints.dart';
import 'package:mr_alnagar/core/network/remote/dio_helper.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/features/home_screen/home_layout.dart';
import 'package:mr_alnagar/features/profile_view/test_Results/test_results.dart';
import 'package:mr_alnagar/features/profile_view/user_courses/user_courses.dart';
import 'package:mr_alnagar/features/profile_view/user_statistics/user_statistics.dart';
import '../../../features/authentication/login_layout/login_page.dart';
import '../../../features/profile_view/homework_results/home_work_results.dart';
import '../../../features/profile_view/profile_view.dart';
import '../../../core/models/quiz_result_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitial());

  static ProfileCubit get(context) => BlocProvider.of(context);

  TextEditingController profileFormController = TextEditingController();

  List titles = [
    'الملف الشخصي',
    'نتائج الواجب',
    'نتائج الامتحانات',
    'الكورسات',
    'احصائياتك',
  ];
  List profileViews = [
    ProfileView(),
    HomeWorkResults(),
    TestResults(),
    UserCourses(),
    UserStatistics(),
  ];

  bool enabled = false;
  void enableChanges() {
    enabled = !enabled;
    emit(EnableChanges());
  }

  int currentIndex = 0;
  void ChangeProfileView({required int index}) {
    currentIndex = index;
    emit(ProfileViewChanged());
  }

  var privacyPolicy;
  Future<void> getPrivacyPolicy() async {
    emit(ProfilePrivacyPolicyLoading());
    await DioHelper.getData(url: EndPoints.privacyPolicy)
        .then((value) {
          print(value.data);
          privacyPolicy = value.data['data'];
          emit(ProfilePrivacyPolicyDone());
        })
        .catchError((error) {
          emit(ProfilePrivacyPolicyError(error));
        });
  }

  // Profile Information
  var profileInfo;
  Future<void> getProfileInfo() async {
    emit(ProfileInfoLoading());
    try {
      final response = await DioHelper.getData(
        url: EndPoints.profileInfo,
        token: CacheHelper.getData(key: CacheKeys.token),
      );

      if (response.statusCode.toString().startsWith('2')) {
        profileInfo = response.data['data'];

        final user = profileInfo;
        print(response.data['data']);
        // Saving all profile data using setBoolean for each CacheKey
        CacheHelper.setData(key: CacheKeys.id, value: user['id']);
        CacheHelper.setData(key: CacheKeys.fullName, value: user['full_name']);
        CacheHelper.setData(
          key: CacheKeys.firstName,
          value: user['first_name'],
        );
        CacheHelper.setData(
          key: CacheKeys.middleName,
          value: user['middle_name'],
        );
        CacheHelper.setData(key: CacheKeys.lastName, value: user['last_name']);
        CacheHelper.setData(key: CacheKeys.phone, value: user['phone']);
        CacheHelper.setData(key: CacheKeys.gender, value: user['gender']);

        CacheHelper.setData(
          key: CacheKeys.parentPhone,
          value: user['parent_phone'],
        );
        CacheHelper.setData(
          key: CacheKeys.parentJob,
          value: user['parent_job'],
        );
        CacheHelper.setData(key: CacheKeys.gender, value: user['gender']);
        CacheHelper.setData(key: CacheKeys.email, value: user['email']);
        CacheHelper.setData(key: CacheKeys.image, value: user['image']);

        // Government info
        CacheHelper.setData(
          key: CacheKeys.governmentId,
          value: user['government']['id'],
        );
        CacheHelper.setData(
          key: CacheKeys.governmentName,
          value: user['government']['name'],
        );

        // Category/level info
        CacheHelper.setData(
          key: CacheKeys.categoryId,
          value: user['category']['id'],
        );
        CacheHelper.setData(
          key: CacheKeys.categoryName,
          value: user['category']['name'],
        );

        // Legacy (for compatibility)
        CacheHelper.setData(
          key: CacheKeys.levelID,
          value: user['category']['id'],
        );
        CacheHelper.setData(
          key: CacheKeys.level,
          value: user['category']['name'],
        );
        CacheHelper.setData(
          key: CacheKeys.govID,
          value: user['government']['id'],
        );
        CacheHelper.setData(
          key: CacheKeys.gov,
          value: user['government']['name'],
        );

        emit(ProfileInfoDone());
      } else {
        emit(ProfileInfoError('Failed to fetch profile information'));
      }
    } catch (error) {
      print(error.toString());
      print(error.runtimeType);
      emit(ProfileInfoError(error.toString()));
    }
  }

  List homeWorksResultsForProfile = [];
  Future<void> getHomeWorksResultsForProfile() async {
    await DioHelper.getData(
          url: EndPoints.homeWorksResultsForProfile,
          token: CacheHelper.getData(key: CacheKeys.token),
        )
        .then((value) {
          // print(value.data['data']);
          homeWorksResultsForProfile = [];
          homeWorksResultsForProfile.addAll(value.data['data']);
        })
        .catchError((error) {});
  }

  // List homeWorksResults = [];
  // Future<void> getHomeworks() async {
  //   await DioHelper.getData(url: EndPoints.resultHomework)
  //       .then((value) {
  //         print(value);
  //         homeWorksResults = value.data['data'];
  //       })
  //       .catchError((error) {});
  // }

  ImagePicker picker = ImagePicker();
  File? image;
  Uint8List? bytes;
  String? userImage;
  File? selectedImage;
  int? selectedGovernmentId;
  int? selectedLevelId;

  void pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      selectedImage = File(picked.path);
      emit(registerImageChoose());
    }
  }

  void setSelectedGovernment(String? id) {
    if (id != null) selectedGovernmentId = int.parse(id);
  }

  void setSelectedLevel(String? id) {
    if (id != null) selectedLevelId = int.parse(id);
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

  Future<void> updateProfileInfo({
    required BuildContext context,
    String? email,
    String? phone,
    int? governmentId,
    int? categoryId,
    File? image,
    String? parentPhone,
    String? parentJob,
  }) async {
    emit(UpdateProfileInfoLoading());

    // Optional: if pickImage() isn't needed here, remove it

    final token = CacheHelper.getData(key: CacheKeys.token);

    final formFields = {
      "email": email ?? CacheHelper.getData(key: CacheKeys.email),
      "phone": phone ?? CacheHelper.getData(key: CacheKeys.phone),
      "parent_phone":
          parentPhone ?? CacheHelper.getData(key: CacheKeys.parentPhone),
      "parent_job": parentJob ?? CacheHelper.getData(key: CacheKeys.parentJob),
      "government_id":
          (governmentId ?? CacheHelper.getData(key: CacheKeys.governmentId))
              .toString(),
      "category_id":
          (categoryId ?? CacheHelper.getData(key: CacheKeys.categoryId))
              .toString(),
      if (image != null) "image": await MultipartFile.fromFile(image.path),
    };

    await DioHelper.postFormData(
          url: EndPoints.updateProfileInfo,
          data: formFields,
          token: token,
        )
        .then((response) async {
          await getProfileInfo();
          print(response);
          print(response.statusCode);
          print(response.data);
          print(response.requestOptions);
          print(response.realUri);
          final status = response.statusCode ?? 0;
          final message = response.data['message'] ?? 'حدث خطأ غير متوقع';

          if (status.toString().startsWith('2') ||
              status.toString().startsWith('3')) {
            emit(UpdateProfileInfoDone());
            await getProfileInfo(); // refresh profile info if needed
            showSnackBar(context, message, 3, Colors.green);
          } else if (status.toString().startsWith('4')) {
            emit(UpdateProfileInfoError(message));
            showSnackBar(context, message, 3, Colors.red);
          } else {
            emit(UpdateProfileInfoError('حدث خطأ غير متوقع'));
            showSnackBar(context, 'حدث خطأ غير متوقع', 3, Colors.red);
          }
        })
        .catchError((error) {
          if (kDebugMode) {
            print('Update Profile Info Error: $error');
          }
          emit(UpdateProfileInfoError(error.toString()));
          showSnackBar(context, 'فشل الاتصال بالخادم', 3, Colors.red);
        });
  }

  // OTP State Variables
  int? remainingSeconds;
  String? otpVia;

  /// Send OTP
  Future<void> sendOTP({
    required String email,
    required BuildContext context,
  }) async {
    emit(SendOtpLoading());
    try {
      final response = await DioHelper.postFormUrlEncoded(
        url: EndPoints.otpSend,
        data: {"login": email},
        token: CacheHelper.getData(key: CacheKeys.token),
      );

      if (response.statusCode.toString().startsWith('2')) {
        remainingSeconds = response.data['data']['remaining_seconds'] ?? 60;
        otpVia = response.data['data']['via'];

        showSnackBar(context, 'تم إرسال الكود بنجاح', 4, Colors.green);
        if (kDebugMode) {
          print(response.data);
        }
        emit(
          SendOtpSuccess(
            otp: response.data['data']['otp'],
            remainingSeconds: remainingSeconds!,
            via: otpVia!,
          ),
        );
      } else {
        showSnackBar(
          context,
          response.data['message'] ?? 'فشل في إرسال الكود',
          4,
          Colors.red,
        );
        emit(SendOtpError(response.data['message'] ?? 'فشل في إرسال الكود'));
      }
    } catch (error) {
      showSnackBar(context, 'حدث خطأ أثناء إرسال الكود', 4, Colors.red);
      if (kDebugMode) {
        print(error);
      }
      emit(SendOtpError(error.toString()));
    }
  }

  /// Resend OTP
  Future<void> resendOTP({
    required String email,
    required BuildContext context,
  }) async {
    emit(ResendOtpLoading());
    try {
      final response = await DioHelper.postFormUrlEncoded(
        url: EndPoints.otpResend,
        data: {"login": email},
      );

      if (response.statusCode.toString().startsWith('2')) {
        remainingSeconds = response.data['data']['remaining_seconds'] ?? 60;
        otpVia = response.data['data']['via'];

        showSnackBar(context, 'تم إعادة إرسال الكود', 4, Colors.green);
        if (kDebugMode) {
          print(response);
        }
        emit(
          ResendOtpSuccess(
            otp: response.data['data']['otp'],
            remainingSeconds: remainingSeconds!,
            via: otpVia!,
          ),
        );
      } else {
        showSnackBar(
          context,
          response.data['message'] ?? 'فشل في إعادة الإرسال',
          4,
          Colors.red,
        );
        emit(
          ResendOtpError(response.data['message'] ?? 'فشل في إعادة الإرسال'),
        );
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      showSnackBar(context, 'حدث خطأ أثناء إعادة الإرسال', 4, Colors.red);
      emit(ResendOtpError(error.toString()));
    }
  }

  /// Verify OTP
  Future<void> verifyOTP({
    required String email,
    required String otp,
    required BuildContext context,
  }) async {
    emit(VerifyOtpLoading());
    try {
      final response = await DioHelper.postData(
        url: EndPoints.otpVerify,
        data: {"otp": otp, "login": email},
      );

      if (response.statusCode.toString().startsWith('2')) {
        showSnackBar(context, 'تم التحقق من الكود بنجاح', 4, Colors.green);

        emit(VerifyOtpSuccess());
      } else {
        showSnackBar(
          context,
          response.data['message'] ?? 'كود غير صحيح',
          4,
          Colors.red,
        );
        emit(VerifyOtpError(response.data['message'] ?? 'كود غير صحيح'));
      }
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      showSnackBar(context, 'حدث خطأ أثناء التحقق من الكود', 4, Colors.red);
      emit(VerifyOtpError(error.toString()));
    }
  }

  Future<void> updateProfilePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    emit(UpdateProfilePasswordLoading());

    await DioHelper.putData(
          url: EndPoints.updateProfilePassword,
          data: {
            "old_password": oldPassword,
            "password": newPassword,
            "password_confirmation": confirmPassword,
          },
          token: CacheHelper.getData(key: CacheKeys.token),
        )
        .then((response) {
          final status = response.statusCode ?? 0;
          final String message =
              response.data['message'] ?? 'حدث خطأ غير متوقع';

          if (status.toString().startsWith('2') ||
              status.toString().startsWith('3')) {
            if (kDebugMode) print('Password updated or redirected: $message');

            showSnackBar(context, message, 3, Colors.green);

            Navigator.pushAndRemoveUntil(
              context,
              CupertinoPageRoute(
                builder: (context) {
                  return HomeLayout();
                },
              ),
              (context) {
                return false;
              },
            );
            emit(UpdateProfilePasswordSuccess());
          } else if (status.toString().startsWith('4')) {
            if (kDebugMode) print('Client error: ${response.data}');

            showSnackBar(context, message, 4, Colors.red);
            emit(UpdateProfilePasswordError(message));
          } else {
            showSnackBar(context, 'حدث خطأ غير متوقع', 4, Colors.red);
            emit(UpdateProfilePasswordError('حدث خطأ غير متوقع'));
          }
        })
        .catchError((error) {
          if (kDebugMode) {
            print(state);

            print(error);
          }
          showSnackBar(context, 'فشل الاتصال بالخادم', 4, Colors.red);
          emit(UpdateProfilePasswordError(error.toString()));
        });
  }

  Future<void> logout({required BuildContext context}) async {
    emit(LogoutLoading());
    try {
      final response = await DioHelper.postData(
        url: EndPoints.logout,
        data: {},
        token: CacheHelper.getData(key: CacheKeys.token),
      );

      if (response.statusCode == 200) {
        emit(LogoutDone());

        // Immediately navigate to login page (new context)
        HomeCubit.get(context).changeBottomNavBarIndex(index: 0);
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );

        // Clear cache safely after navigation using a microtask
        Future.microtask(() async {
          final keysToRemove = [
            CacheKeys.token,
            CacheKeys.id,
            CacheKeys.levelID,
            CacheKeys.level,
            CacheKeys.govID,
            CacheKeys.gov,
            CacheKeys.firstName,
            CacheKeys.middleName,
            CacheKeys.lastName,
            CacheKeys.phone,
            CacheKeys.email,
            CacheKeys.image,
            CacheKeys.fullName,
            CacheKeys.parentPhone,
            CacheKeys.parentJob,
            CacheKeys.gender,
            CacheKeys.governmentId,
            CacheKeys.governmentName,
            CacheKeys.categoryId,
            CacheKeys.categoryName,
            CacheKeys.loginDone,
          ];

          for (final key in keysToRemove) {
            await CacheHelper.deleteData(key: key);
          }
        });
      } else {
        emit(LogoutError('فشل تسجيل الخروج من الخادم'));
      }
    } catch (error) {
      emit(LogoutError('حدث خطأ أثناء تسجيل الخروج: ${error.toString()}'));
    }
  }

  Future<void> logoutFromAllDevices() async {
    emit(LogoutFromAllDevicesLoading());
    try {
      final response = await DioHelper.postData(
        url: EndPoints.logoutFromAllDevices,
        data: {},
        token: CacheHelper.getData(key: CacheKeys.token),
      );

      if (response.statusCode == 200) {
        // Clear local storage
        await CacheHelper.deleteData(key: CacheKeys.token);
        await CacheHelper.deleteData(key: CacheKeys.id);
        emit(LogoutFromAllDevicesDone());
      } else {
        emit(LogoutFromAllDevicesError('Failed to logout from all devices'));
      }
    } catch (error) {
      emit(LogoutFromAllDevicesError(error.toString()));
    }
  }

  // Stats Information
  var successRate;
  var highestScore;
  var lowestScore;
  var performanceComparison;
  var chartData;
  Future<void> getUserStats() async {
    emit(StatsLoading());

    await DioHelper.getData(
          url: EndPoints.stats,
          token: CacheHelper.getData(key: CacheKeys.token),
        )
        .then((value) {
          if (value.statusCode == 200) {
            successRate = value.data['success_rate'];
            highestScore = value.data['highest_score'];
            lowestScore = value.data['lowest_score'];

            performanceComparison = value.data['performance_comparison'];
            chartData = value.data['chart_data'];
          } else {
            print(state);
            print(value.data);
            emit(StatsError(value.data));
          }
        })
        .catchError((error) {
          if (kDebugMode) {
            print(state);
            print(error);
            print(error.toString());
            print(error.runtimeType);
          }
          emit(StatsError(error));
        });
  }

  List inProgressCourses = [];
  List completedCourses = [];

  Future<void> getMyInProgressCourses() async {
    emit(GetMyCoursesLoading());
    await DioHelper.getData(
          url: EndPoints.myCourses,
          query: {"status": "in_progress"},
          token: CacheHelper.getData(key: CacheKeys.token),
        )
        .then((value) {
          inProgressCourses = value.data['data'];
          emit(GetMyCoursesDone());
        })
        .catchError((error) {
          print(error);
          emit(GetMyCoursesError(error));
        });
  }

  Future<void> getMyCompletedCourses() async {
    emit(GetMyCompletedCoursesLoading());
    await DioHelper.getData(
          url: EndPoints.myCourses,
          query: {"status": "completed"},
          token: CacheHelper.getData(key: CacheKeys.token),
        )
        .then((value) {
          completedCourses = value.data['data'];
          emit(GetMyCompletedCoursesDone());
        })
        .catchError((error) {
          print(error);
          emit(GetMyCompletedCoursesError(error));
        });
  }
}
