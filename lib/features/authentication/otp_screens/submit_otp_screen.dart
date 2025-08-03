import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_alnagar/core/cubits/auth_cubit/auth_cubit/auth_cubit.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/core/widgets/Auth%20widgets/register_widgets/register_password_formfield.dart';
import 'package:pinput/pinput.dart';

import '../../../core/cubits/auth_cubit/auth_cubit/auth_state.dart';

class SubmitOtpScreen extends StatefulWidget {
  final String email;
  final int remainingSeconds;

  const SubmitOtpScreen({
    Key? key,
    required this.email,
    required this.remainingSeconds,
  }) : super(key: key);

  @override
  State<SubmitOtpScreen> createState() => _SubmitOtpScreenState();
}

class _SubmitOtpScreenState extends State<SubmitOtpScreen> {
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController oldPassController = TextEditingController();
  TextEditingController pinController = TextEditingController();

  Timer? _timer;
  int _secondsRemaining = 60;
  bool _showResendButton = false;

  @override
  void initState() {
    super.initState();
    startTimer(widget.remainingSeconds);
  }

  void startTimer(int seconds) {
    setState(() {
      _secondsRemaining = seconds;
      _showResendButton = false;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        setState(() => _showResendButton = true);
        _timer?.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  void _verifyOTP() {
    final otp = pinController.text;
    if (otp.length == 4) {
      AuthCubit.get(
        context,
      ).verifyOTP(email: widget.email, otp: otp, context: context);
    }
  }

  void _resendOTP() async {
    await AuthCubit.get(
      context,
    ).resendOTP(email: widget.email, context: context);
    final newSeconds = AuthCubit.get(context).remainingSeconds ?? 60;
    startTimer(newSeconds);
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  @override
  void dispose() {
    _timer?.cancel();
    passController.dispose();
    confirmPassController.dispose();
    pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, dynamic>(
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
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Directionality(
                        textDirection: TextDirection.rtl,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 20.0,
                            horizontal: 5,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal: 5,
                                ),
                                child: Center(
                                  child: Image.asset('assets/images/Frame.png'),
                                ),
                              ),
                              Text(
                                'برجاء إدخال الكود المرسل إليكم عبر رقم الهاتف أو البريد الإلكتروني',
                                textAlign: TextAlign.center,
                                style: TextStyles.textStyle16w400(context),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                  vertical: 30,
                                ),
                                child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: Pinput(
                                    controller: pinController,
                                    length: 4,
                                    onCompleted: (pin) {
                                      pinController.text = pin;
                                      _verifyOTP();
                                    },
                                    onChanged:
                                        (pin) => pinController.text = pin,
                                    pinAnimationType: PinAnimationType.rotation,
                                    defaultPinTheme: PinTheme(
                                      width: 56,
                                      height: 56,
                                      textStyle: TextStyles.textStyle16w400(
                                        context,
                                      ).copyWith(color: AppColors.primaryColor),
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: Colors.grey,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                    focusedPinTheme: PinTheme(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            color: AppColors.primaryColor,
                                            width: 2,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              _showResendButton
                                  ? TextButton(
                                    onPressed: _resendOTP,
                                    child: Text(
                                      'إعادة الإرسال',
                                      style: TextStyles.textStyle16w400(
                                        context,
                                      ).copyWith(color: AppColors.primaryColor),
                                    ),
                                  )
                                  : Text(
                                    'اعادة الارسال خلال ${formatTime(_secondsRemaining)}',
                                    style: TextStyles.textStyle16w400(context),
                                  ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 18.0,
                                ),
                                child: RegisterPasswordFormField(
                                  controller: passController,
                                  hint: 'كلمة السر',
                                  validator: (value) {
                                    if (value == null || value.isEmpty)
                                      return 'يجب إدخال كلمة المرور';
                                    if (value.length < 8)
                                      return 'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل';
                                    final hasLetter = RegExp(r'[A-Za-z]');
                                    final hasNumber = RegExp(r'\d');
                                    if (!hasLetter.hasMatch(value) ||
                                        !hasNumber.hasMatch(value)) {
                                      return 'يجب أن تحتوي كلمة المرور على حروف وأرقام';
                                    }
                                    return null;
                                  },
                                  onChange: (_) {},
                                  onSubmit: (_) {},
                                ),
                              ),
                              RegisterPasswordFormField(
                                controller: confirmPassController,
                                hint: 'تأكيد كلمة السر',
                                validator: (value) {
                                  if (value.isEmpty ||
                                      passController.text !=
                                          confirmPassController.text) {
                                    return ' كلمة السر غير متطابقة';
                                  }
                                  return null;
                                },
                                onChange: (_) {},
                                onSubmit: (_) {},
                              ),
                              const Spacer(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                  vertical: 20,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor,
                                    borderRadius: BorderRadius.circular(35),
                                  ),
                                  width: double.infinity,
                                  height: 55.h,
                                  child: MaterialButton(
                                    onPressed: () async {
                                      if (passController.text ==
                                          confirmPassController.text) {
                                        AuthCubit.get(context).forgotPassword(
                                          email: widget.email,
                                          newPassword: passController.text,
                                          confirmPassword:
                                              confirmPassController.text,
                                          context: context,
                                        );
                                      }
                                    },
                                    child:
                                        state is UpdatePasswordLoading
                                            ? const CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                            : Text(
                                              'تأكيد',
                                              style: TextStyles.textStyle16w700(
                                                context,
                                              ).copyWith(color: Colors.white),
                                            ),
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
            ),
          ),
        );
      },
    );
  }
}
