import 'dart:async';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:pinput/pinput.dart';

import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';

class PopUpResettingPasswordOTP extends StatefulWidget {
  final String email;
  final int remainingSeconds;

  const PopUpResettingPasswordOTP({
    super.key,
    required this.email,
    required this.remainingSeconds,
  });

  @override
  State<PopUpResettingPasswordOTP> createState() =>
      _PopUpResettingPasswordOTPState();
}

class _PopUpResettingPasswordOTPState
    extends State<PopUpResettingPasswordOTP> {
  final TextEditingController pinController = TextEditingController();
  final TextEditingController oldPassController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  Timer? _timer;
  int _secondsRemaining = 60;
  bool _showResendButton = false;
  bool obsecureOldPass = true;
  bool obsecurePass = true;
  bool obsecureConfirm = true;

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
      ProfileCubit.get(context).verifyOTP(
        email: widget.email,
        otp: otp,
        context: context,
      );
    }
  }



  Future<void> _resendOTP() async {
    await ProfileCubit.get(context).resendOTP(
      email: widget.email,
      context: context,
    );
    final newSeconds = ProfileCubit.get(context).remainingSeconds ?? 60;
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
    pinController.dispose();
    passController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is UpdateProfilePasswordSuccess) {
          Navigator.pop(context);
        } else if (state is SendOtpError ||
            state is ResendOtpError ||
            state is VerifyOtpError ||
            state is UpdateProfilePasswordError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('حدث خطأ أثناء تنفيذ الطلب')),
          );
        }
      },
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "إعادة تعيين كلمة المرور",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.red),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Image.asset('assets/images/lock.png', height: 150),
                    const SizedBox(height: 16),
                    const Text(
                      "يرجى إدخال الكود المرسل إليكم عبر رقم الهاتف أو البريد الإلكتروني",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Directionality(
                        textDirection: TextDirection.ltr,
                        child: Pinput(
                          controller: pinController,
                          length: 4,
                          onCompleted: (pin) {
                            pinController.text = pin;
                            _verifyOTP();
                          },
                          pinAnimationType: PinAnimationType.rotation,
                          defaultPinTheme: PinTheme(
                            width: 50.w,
                            height: 56.h,
                            textStyle: const TextStyle(fontSize: 20),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.black, width: 1),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: _showResendButton
                          ? TextButton(
                        onPressed: _resendOTP,
                        child: Text(
                          'إعادة الإرسال',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 14,
                          ),
                        ),
                      )
                          : Text(
                        'إعادة الإرسال خلال ${formatTime(_secondsRemaining)}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),Text("كلمة السر القديمة", style: TextStyles.textStyle12w400(context)),
                    TextFormField(
                      controller: oldPassController,
                      obscureText: obsecureOldPass,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            obsecureOldPass ? FluentIcons.eye_off_20_filled : FluentIcons.eye_20_filled,
                            color: Colors.grey,
                          ),
                          onPressed: () => setState(() => obsecureOldPass = !obsecureOldPass),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text("كلمة السر الجديدة", style: TextStyles.textStyle12w400(context)),
                    TextFormField(
                      controller: passController,
                      obscureText: obsecurePass,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            obsecurePass ? FluentIcons.eye_off_20_filled : FluentIcons.eye_20_filled,
                            color: Colors.grey,
                          ),
                          onPressed: () => setState(() => obsecurePass = !obsecurePass),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text("تأكيد كلمة السر", style: TextStyles.textStyle12w400(context)),
                    TextFormField(
                      controller: confirmPassController,
                      obscureText: obsecureConfirm,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            obsecureConfirm ? FluentIcons.eye_off_20_filled : FluentIcons.eye_20_filled,
                            color: Colors.grey,
                          ),
                          onPressed: () => setState(() => obsecureConfirm = !obsecureConfirm),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: const OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        onPressed: () {
                          //_verifyOTP();
                          print(
                              '${widget.email}'
                              '${passController.text}'
                              '${confirmPassController.text}'
                              '${oldPassController.text}'

                          );
                          if (passController.text == confirmPassController.text && oldPassController.text.isNotEmpty) {
                            ProfileCubit.get(context).updateProfilePassword(
                              oldPassword: oldPassController.text,
                              newPassword: passController.text,
                              confirmPassword: confirmPassController.text,
                              context: context,
                            );
                          }

                        },
                        child: state is UpdateProfilePasswordLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text("التالي", style: TextStyles.textStyle16w700(context).copyWith(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
