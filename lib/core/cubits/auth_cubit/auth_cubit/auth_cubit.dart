import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';
import 'package:mr_alnagar/features/authentication/login_layout/login_page.dart';

import '../../../../features/home_screen/home_layout.dart';
import '../../../network/remote/api_endPoints.dart';
import '../../../network/remote/dio_helper.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';
import '../../home_cubit/home_cubit.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  bool loading = false;
  void listenAuthLoading() {
    loading = !loading;
    emit(LoadingChanged());
  }

  List levelsForAuthCategories = [];
  Future<void> getLevelsForAuthCategories() async {
    emit(LevelsForAuthCategoriesLoading());
    try {
      final response = await DioHelper.getData(
        url: EndPoints.levelsForAuthCategories,
      );
      levelsForAuthCategories = response.data['data'];
      if (kDebugMode) {
        print(levelsForAuthCategories);
      }
      emit(LevelsForAuthCategoriesDone());
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
        print(error.runtimeType);
        print(error);
      }
      emit(LevelsForAuthCategoriesError(error));
    }
  }

  List governments = [];
  Future<void> getGovernments() async {
    emit(GovernmentsLoading());
    try {
      final response = await DioHelper.getData(url: EndPoints.governments);
      governments = response.data['data'];
      if (kDebugMode) {
        print(governments);
      }
      emit(GovernmentsDone());
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
        print(error.runtimeType);
        print(error);
      }

      emit(GovernmentsError(error));
    }
  }

  Future<Response?> register({
    required BuildContext context,
    required String firstName,
    required String middleName,
    required String lastName,
    required String phone,
    required String parentPhone,
    required String email,
    String? parentJob,
    required String gender,
    required int governmentID,
    required int categoryID,
    required String pass,
    required String confirmPass,
  }) async {
    emit(RegisterLoading());
    try {
      final response = await DioHelper.postData(
        url: EndPoints.register,
        data: {
          "first_name": firstName,
          "middle_name": middleName,
          "last_name": lastName,
          "phone": phone,
          "parent_phone": parentPhone,
          "email": email,
          "parent_job": parentJob,
          "gender": gender,
          "government_id": governmentID,
          "category_id": categoryID,
          "password": pass,
          "confirm_password": confirmPass,
          "privacy_flag": true,
          "image": null,
        },
      );

      final statusCode = response.statusCode ?? 0;

      if ((statusCode ~/ 100) == 2) {
        // Success (200, 201, etc.)
        CacheHelper.setData(key: CacheKeys.categoryId, value: categoryID);

        showSnackBar(context, ' تم انشاء الحساب بنجاح', 4, Colors.green);
        Navigator.pop(context);
        emit(RegisterDone());
      } else if ((statusCode ~/ 100) == 4) {
        // Client error (400–499)
        final errorData = response.data;
        String firstError = errorData['message'] ?? 'حدث خطأ ما';

        if (errorData['errors'] is Map<String, dynamic>) {
          final errorMap = errorData['errors'] as Map<String, dynamic>;
          if (errorMap.isNotEmpty) {
            final firstField = errorMap.values.first;
            if (firstField is List && firstField.isNotEmpty) {
              firstError = firstField.first;
            }
          }
        }

        showSnackBar(context, firstError, 4, Colors.red);
        emit(RegisterError(firstError));
      }

      return response;
    } on DioException catch (dioError) {
      final statusCode = dioError.response?.statusCode ?? 0;

      if ((statusCode ~/ 100) == 4) {
        final errorData = dioError.response?.data;
        String firstError = 'حدث خطأ ما';

        if (errorData is Map<String, dynamic>) {
          if (errorData['errors'] is Map<String, dynamic>) {
            final errorMap = errorData['errors'];
            if (errorMap.isNotEmpty) {
              final firstField = errorMap.values.first;
              if (firstField is List && firstField.isNotEmpty) {
                firstError = firstField.first;
              }
            }
          } else if (errorData['message'] != null) {
            firstError = errorData['message'];
          }
        }

        showSnackBar(context, firstError, 4, Colors.red);
        emit(RegisterError(firstError));
      } else {
        showSnackBar(context, 'فشل في الاتصال بالخادم', 4, Colors.red);
        emit(RegisterError(dioError.toString()));
      }

      if (kDebugMode) {
        print(dioError);
      }
      return null;
    } catch (error) {
      showSnackBar(context, 'حدث خطأ غير متوقع', 4, Colors.red);
      emit(RegisterError(error.toString()));
      if (kDebugMode) {
        print(error);
      }
      return null;
    }
  }



var loginResponse;
  Future login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    emit(LoginLoading());
    try {
       loginResponse = await DioHelper.postData(
        url: EndPoints.login,
        data: {
          "login": email, // insert phone or email
          "password": password,
        },
      );

      // Cache user details
      final userData = loginResponse.data['data']['user'];
      final userDetails = {
        CacheKeys.token: loginResponse.data['data']['token'],
        CacheKeys.id: userData['id'],
        CacheKeys.fullName: userData['full_name'],
        CacheKeys.firstName: userData['first_name'],
        CacheKeys.middleName: userData['middle_name'],
        CacheKeys.lastName: userData['last_name'],
        CacheKeys.phone: userData['phone'],
        CacheKeys.parentPhone: userData['parent_phone'],
        CacheKeys.parentJob: userData['parent_job'],
        CacheKeys.gender: userData['gender'],
        CacheKeys.email: userData['email'],
        CacheKeys.image: userData['image'],
        CacheKeys.governmentId: userData['government']['id'],
        CacheKeys.governmentName: userData['government']['name'],
        CacheKeys.categoryId: userData['category']['id'],
        CacheKeys.categoryName: userData['category']['name'],
      };

      // Save all user details
      userDetails.forEach((key, value) {
        CacheHelper.setData(key: key, value: value);
      });

      if (kDebugMode) {
        print(state);
        print(loginResponse.data);

      }

      emit(LoginDone());
      loading = false;
      CacheHelper.setData(key: CacheKeys.loginDone, value: true);

      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(builder: (context) => HomeLayout()),
        (context) => false,
      );

      return loginResponse;
    }  on DioException catch (dioError) {
  loading = false;

  if (dioError.response != null &&
  dioError.response?.statusCode == 422 &&
  dioError.response?.data is Map<String, dynamic>) {
  final errorData = dioError.response!.data;
  final firstErrorMessage = (errorData['errors'] as Map<String, dynamic>)
      .values
      .first[0];

  showSnackBar(context, firstErrorMessage, 4, Colors.red);
  if (kDebugMode) {
    print(dioError.response?.statusCode);
  }
  } else {
  showSnackBar(context, 'حدث خطأ ما. حاول مرة أخرى.', 4, Colors.red);
  }

  if (kDebugMode) {
    print('Dio error: ${dioError.response}');
  }
  emit(LoginError(dioError.toString()));
  return null;
  } catch (error) {
  loading = false;
  if (kDebugMode) {
    print('Unexpected error: $error');
  }
  showSnackBar(context, 'حدث خطأ غير متوقع', 3, Colors.red);
  emit(LoginError(error.toString()));
  return null;
  }

}

// OTP State Variables
  int? remainingSeconds;
  String? otpVia;

  /// Send OTP
  Future<void> sendOTP({required String email, required BuildContext context}) async {
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
        emit(SendOtpSuccess(
          otp: response.data['data']['otp'],
          remainingSeconds: remainingSeconds!,
          via: otpVia!,
        ));
      } else {

        showSnackBar(context, response.data['message'] ?? 'فشل في إرسال الكود', 4, Colors.red);
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
  Future<void> resendOTP({required String email, required BuildContext context}) async {
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
        emit(ResendOtpSuccess(
          otp: response.data['data']['otp'],
          remainingSeconds: remainingSeconds!,
          via: otpVia!,
        ));
      } else {
        showSnackBar(context, response.data['message'] ?? 'فشل في إعادة الإرسال', 4, Colors.red);
        emit(ResendOtpError(response.data['message'] ?? 'فشل في إعادة الإرسال'));
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
  Future<void> verifyOTP({required String email, required String otp, required BuildContext context}) async {
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
        showSnackBar(context, response.data['message'] ?? 'كود غير صحيح', 4, Colors.red);
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


  Future<void> forgotPassword({
    required String email,
    required String newPassword,
    required String confirmPassword,
    required BuildContext context,
  }) async {
    emit(UpdatePasswordLoading());

        await DioHelper.postFormUrlEncoded(
        url: EndPoints.resetPassword,
        data: {
          "login": email,
          "password": newPassword,
          "password_confirmation": confirmPassword,
        },
       // token: CacheHelper.getData(key: CacheKeys.token),
      ).then((value){

          final status = value.statusCode ?? 0;
          final String message = value.data['message'] ?? 'حدث خطأ غير متوقع';

          if (status.toString().startsWith('2')) {
            // ✅ Success
            if (kDebugMode) print('Password updated: $message');

            showSnackBar(context, 'تم تغيير كلمة المرور', 3, Colors.green);

            Navigator.pushAndRemoveUntil(context,
                CupertinoPageRoute(builder: (context){
                  return LoginPage();
                }),(context){
                  return false;
                });
            emit(UpdatePasswordSuccess());
          } else if (status.toString().startsWith('4')) {

            if (kDebugMode) print('Update error response: ${value.data}');

            showSnackBar(context, message, 4, Colors.red);
            emit(UpdatePasswordError(message));
          } else {

            showSnackBar(context, 'حدث خطأ غير متوقع', 4, Colors.red);
            emit(UpdatePasswordError('حدث خطأ غير متوقع'));
          }
    }).catchError((error){
    if (kDebugMode) {
    print(state);
    print(error);
    }
    showSnackBar(context, 'فشل الاتصال بالخادم', 4, Colors.red);
    emit(UpdatePasswordError(error.toString()));

    });


  }



  void showSnackBar(
      BuildContext context, String message, int duration, Color? color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message,style: TextStyles.textStyle16w700(context),),
        duration: Duration(seconds: duration),
        backgroundColor: color,
      ),
    );
  }


  Future<void> logoutUser() async {
    emit(LogoutLoading());

      await DioHelper.postData(url: EndPoints.logout, data: {}).then((value){

        CacheHelper.deleteData(key: CacheKeys.token);


        emit(LogoutDone());
      }).catchError((error){
        if (kDebugMode) {
          print(error);
        }
        emit(LogoutError(error));
      });

  }

}
