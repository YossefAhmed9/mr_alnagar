import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/widgets/Auth%20widgets/login_widgets/sign_in_with_email_o_r_phone.dart';

import '../../../core/utils/text_styles.dart';
import '../otp_screens/send_otp_screen.dart';
import '../register_screen/register_screen.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController passController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController codeController = TextEditingController();
    TextEditingController confirmCodeController = TextEditingController();
    var formKey = GlobalKey<FormState>();
    var codeFormKey = GlobalKey<FormState>();

    return Scaffold(
//       floatingActionButton: FloatingActionButton(onPressed: (){
//         print('''
// onBoarding: ${CacheHelper.getData(key: CacheKeys.onBoardingDone)}
// login: ${CacheHelper.getData(key: CacheKeys.loginDone)}
// userName: ${CacheHelper.getData(key: CacheKeys.userName)}
// token: ${CacheHelper.getData(key: CacheKeys.token)}
// id: ${CacheHelper.getData(key: CacheKeys.id)}
// levelId: ${CacheHelper.getData(key: CacheKeys.levelID)}
// level: ${CacheHelper.getData(key: CacheKeys.level)}
// govID: ${CacheHelper.getData(key: CacheKeys.govID)}
// gov: ${CacheHelper.getData(key: CacheKeys.gov)}
// firstName: ${CacheHelper.getData(key: CacheKeys.firstName)}
// middleName: ${CacheHelper.getData(key: CacheKeys.middleName)}
// lastName: ${CacheHelper.getData(key: CacheKeys.lastName)}
// phone: ${CacheHelper.getData(key: CacheKeys.phone)}
// email: ${CacheHelper.getData(key: CacheKeys.email)}
// image: ${CacheHelper.getData(key: CacheKeys.image)}
// fullName: ${CacheHelper.getData(key: CacheKeys.fullName)}
// parentPhone: ${CacheHelper.getData(key: CacheKeys.parentPhone)}
// parentJob: ${CacheHelper.getData(key: CacheKeys.parentJob)}
// gender: ${CacheHelper.getData(key: CacheKeys.gender)}
// governmentId: ${CacheHelper.getData(key: CacheKeys.governmentId)}
// governmentName: ${CacheHelper.getData(key: CacheKeys.governmentName)}
// categoryId: ${CacheHelper.getData(key: CacheKeys.categoryId)}
// categoryName: ${CacheHelper.getData(key: CacheKeys.categoryName)}
// ''');
//       }),
      body: Directionality(
        textDirection: TextDirection.rtl,

        child: SafeArea(
          child: DefaultTabController(
            animationDuration: Duration(milliseconds: 500),
            initialIndex: 0,
            length: 2,
            child: Column(
              children: [
                TabBar(
                  unselectedLabelColor: Colors.grey,
                  automaticIndicatorColorAdjustment: true,
                  dragStartBehavior: DragStartBehavior.down,
                  labelStyle: TextStyles.textStyle12w700(context),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelPadding: EdgeInsets.all(15),
                  tabs: [
                    Text(
                      ' رقم الهاتف او البريد الالكتروني',
                      style: TextStyles.textStyle12w700(context),
                    ),

                    Text(
                      'عن طريق الكود',
                      style: TextStyles.textStyle12w700(context),
                    ),
                  ],
                ),

                Expanded(
                  child: TabBarView(
                    children: [
                      SignInWithEmailORPhone(
                        emailController: emailController,
                        passController: passController,
                        confirmCodeController: confirmCodeController,
                      ),

                      Form(
                        key: codeFormKey,
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
                              Text('ادخل الكود'),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    print("validate");
                                    return (' يجب كتابة الكود');
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) {},
                                onChanged: (value) {},
                                controller: codeController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
                                  ),
                                  fillColor: Color(0XFFF5F5F5),
                                  filled: true,
                                ),
                              ),
                              Text('اعد كتابة الكود'),
                              TextFormField(
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return (' اعد كتابة الكود');
                                  }
                                  return null;
                                },
                                onFieldSubmitted: (value) {},
                                onChanged: (value) {},
                                controller: confirmCodeController,
                                decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.transparent,
                                    ),
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
                                    style: TextStyles.textStyle14w400(
                                      context,
                                    ).copyWith(
                                      color: AppColors.secondary,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppColors.secondary,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  width: double.infinity,
                                  height: 40.h,
                                  child: MaterialButton(
                                    onPressed: () {
                                      if (codeFormKey.currentState!
                                          .validate()) {}
                                    },
                                    child: Text(
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
                                          builder:
                                              (context) => RegisterScreen(),
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
