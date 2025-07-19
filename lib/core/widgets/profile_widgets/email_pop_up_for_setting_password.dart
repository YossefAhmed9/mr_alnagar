import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/auth_cubit/auth_cubit/auth_cubit.dart';
import 'package:mr_alnagar/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/core/widgets/profile_widgets/pop_up_resetting_password_o_t_p.dart';

class EmailPopUpForSettingPassword extends StatelessWidget {
  const EmailPopUpForSettingPassword({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.lightBlue, // Light background color
          borderRadius: BorderRadius.circular(16),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 40,
                        child: IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.red,
                            size: 25,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ),
                    Spacer(),
                    Text(
                      "إعادة تعيين كلمة المرور",
                      style: TextStyles.textStyle16w700(
                        context,
                      ).copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.white, height: 1, thickness: 4),
              const SizedBox(height: 10),
              Image.asset(
                'assets/images/lock.png', // Replace with your image path
                height: 150,
              ),
              const SizedBox(height: 16),
              const Text(
                "رقم الهاتف أو البريد الإلكتروني",
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(border: OutlineInputBorder()),
                onChanged: (value){
                  print(value);
                },
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                  ),
                  onPressed: () async{
                    AuthCubit.get(context).sendOTP(email: '${emailController.text.toString()}', context: context);
                    print(emailController.text);
                    showDialog(
                      context: context,
                      builder:
                          (context) => PopUpResettingPasswordOTP(
                            email: emailController.text,
                             remainingSeconds:  AuthCubit.get(context).remainingSeconds ?? 180
                          ),
                    );
                  },
                  child: Text(
                    "التالي",
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
    );
  }
}
