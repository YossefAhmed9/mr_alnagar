import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/auth_cubit/auth_cubit/auth_state.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/widgets/Auth%20widgets/register_widgets/register_text_field.dart';
import 'package:mr_alnagar/features/authentication/otp_screens/submit_otp_screen.dart';
import '../../../core/cubits/auth_cubit/auth_cubit/auth_cubit.dart';
import '../../../core/utils/app_loaders.dart';
import '../../../core/utils/text_styles.dart';

class SendOtpScreen extends StatelessWidget {
  const SendOtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'اعادة تعيين كلمة المرور',
              style: TextStyles.textStyle16w700(context),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios, color: AppColors.primaryColor),
            ),
          ),
          body: SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 0.0,
                    horizontal: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/Frame.png',
                          //width: 250,
                          height: 250.h,
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Text(
                          'الرجاء إدخال عنوان بريدك الإلكتروني أو رقم الهاتف لتلقي رمز التحقق.',
                          textAlign: TextAlign.center,
                          style: TextStyles.textStyle16w400(context),
                        ),
                      ),
                      SizedBox(height: 20),
                      RegisterTextField(
                        hint: 'رقم الهاتف او البريد الالكتروني',
                        controller: emailController,
                        keyboard: TextInputType.emailAddress,
                        validator: (value) {
                          // if (value == null || value.isEmpty) {
                          //   return 'يجب كتابة رقم الهاتف أو البريد الإلكتروني';
                          // }
                          //
                          // final emailRegex = RegExp(
                          //   r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$",
                          // );
                          //
                          // final phoneRegex = RegExp(
                          //   r"^01[0125][0-9]{8}$", // Egyptian phone number
                          // );
                          //
                          // if (!emailRegex.hasMatch(value) && !phoneRegex.hasMatch(value)) {
                          //   return 'أدخل بريدًا إلكترونيًا صحيحًا أو رقم هاتف مصري صحيح';
                          // }
                          //
                          // return null;
                        },

                        onSubmit: (_) {},
                        onChange: (_) {},
                      ),
                      SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(35),
                        ),
                        width: double.infinity,
                        height: 55.h,
                        child: MaterialButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              AuthCubit.get(context).loading = true;
                              final cubit = AuthCubit.get(context);
                              await cubit.sendOTP(
                                email: emailController.text,
                                context: context,
                              );
                              AuthCubit.get(context).loading = false;

                              if (cubit.remainingSeconds != null &&
                                  cubit.otpVia != null) {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder:
                                        (_) => SubmitOtpScreen(
                                          email: emailController.text,
                                          remainingSeconds:
                                              cubit.remainingSeconds!,
                                        ),
                                  ),
                                );
                              }
                            }
                          },
                          child:
                              AuthCubit.get(context).loading
                                  ? Center(
                                    child: AppLoaderInkDrop(
                                      color: Colors.white,
                                    ),
                                  )
                                  : Text(
                                    'ارسال',
                                    style: TextStyles.textStyle16w700(
                                      context,
                                    ).copyWith(color: Colors.white),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
