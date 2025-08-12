import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/auth_cubit/auth_cubit/auth_cubit.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';
import 'package:mr_alnagar/features/home_screen/home_layout.dart';

import '../../../../features/authentication/otp_screens/send_otp_screen.dart';
import '../../../../features/authentication/register_screen/register_screen.dart';
import '../../../cubits/auth_cubit/auth_cubit/auth_state.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_loaders.dart';
import '../../../utils/text_styles.dart';

class SignInWithEmailORPhone extends StatefulWidget {
  SignInWithEmailORPhone({
    Key? key,
    required TextEditingController passController,
    required TextEditingController emailController,
    required TextEditingController confirmCodeController,
  }) : super(key: key);

  @override
  State<SignInWithEmailORPhone> createState() => _SignInWithEmailORPhoneState();
}

class _SignInWithEmailORPhoneState extends State<SignInWithEmailORPhone> {
  final TextEditingController passController = TextEditingController();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController codeController = TextEditingController();

  final TextEditingController confirmCodeController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final GlobalKey codeFormKey = GlobalKey<FormState>();

  bool obsecure = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'تسجيل الدخول',
                        style: TextStyles.textStyle20w700(
                          context,
                        ).copyWith(color: Colors.black),
                      ),
                    ),
                  ),
                  Text('رقم الهاتف او البريد الالكتروني'),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return (' يجب كتابة رقم الهاتف او البريد الالكتروني');
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {},
                    onChanged: (value) {},
                    controller: emailController,
                    decoration: InputDecoration(
                      //label: Text('رقم الهاتف او البريد الالكتروني',style: TextStyles.textStyle16w400(context),),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      fillColor: Color(0XFFF5F5F5),
                      filled: true,
                    ),
                  ),
                  Text('كلمة المرور'),
                  TextFormField(
                    validator: (value) {
                      if (value!.isEmpty) {
                        return (' يجب كتابة كلمة السر');
                      }
                      return null;
                    },
                    onFieldSubmitted: (value) {},
                    onChanged: (value) {},
                    controller: passController,
                    obscureText: obsecure,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obsecure = !obsecure;
                          });
                        },
                        icon: Icon(
                          obsecure == false
                              ? FluentIcons.eye_20_filled
                              : FluentIcons.eye_off_20_filled,
                        ),
                      ),
                      //label: Text('كلمة المرور',style: TextStyles.textStyle16w400(context),),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                      ),
                      fillColor: Color(0XFFF5F5F5),
                      filled: true,
                    ),
                  ),

                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => SendOtpScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'نسيت كلمة المرور ؟',
                        style: TextStyles.textStyle14w400(context).copyWith(
                          color: AppColors.secondary,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.secondary,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      width: double.infinity,
                      height: 40.h,
                      child: MaterialButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            AuthCubit.get(context).listenAuthLoading();
                            AuthCubit.get(context)
                                .login(
                                  email: emailController.text,
                                  password: passController.text,
                                  context: context,
                                )
                                .then((value) {
                              // showDialog(context: context, builder: (context){
                              //   return Container(
                              //     width: 300,
                              //     height: 300,
                              //     decoration: BoxDecoration(color: Colors.white),
                              //     child: Text(value!.data['errors']['password'][0].toString(),style: TextStyles.textStyle16w700(context),),
                              //   );
                              // });
                              print(value?.statusCode);
                                  CacheHelper.setData(key: CacheKeys.loginDone, value: true);

                                  if (kDebugMode) {
                                    print(value);
                                  }
                                });
                            // AuthCubit.get(context).register(firstName: 'firstName', middleName: 'middleName', lastName: 'lastName', phone: 'phone', parentPhone: 'parentPhone', email: 'email', gender: 'gender', governmentID: 'governmentID', categoryID: 'categoryID', pass: 'pass', confirmPass: 'confirmPass');
                          }
                        },
                        child:
                            AuthCubit.get(context).loading == true
                                ? Center(
                                  child: AppLoaderInkDrop(
                                    color: Colors.white,size: 40,
                                  ),
                                )
                                : Text(
                                  'تسجيل الدخول',
                                  style: TextStyles.textStyle16w700(
                                    context,
                                  ).copyWith(color: Colors.white),
                                ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'ليس لديك حساب؟',
                        style: TextStyles.textStyle14w400(
                          context,
                        ).copyWith(color: Colors.black),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => RegisterScreen(),
                            ),
                          );
                        },
                        child: Text(
                          'انشاء حساب',
                          style: TextStyles.textStyle14w700(
                            context,
                          ).copyWith(color: AppColors.secondary),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
