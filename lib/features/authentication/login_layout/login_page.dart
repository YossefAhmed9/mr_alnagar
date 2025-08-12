import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/widgets/Auth%20widgets/login_widgets/sign_in_with_email_o_r_phone.dart';

import '../../../core/utils/text_styles.dart';
import '../../../main.dart';
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

      body: InternetAwareWrapper(
        onInternetRestored: [

        ],
        child: Directionality(
          textDirection: TextDirection.rtl,

          child: SafeArea(
            child:  SignInWithEmailORPhone(
              emailController: emailController,
              passController: passController,
              confirmCodeController: confirmCodeController,
            ),
          ),
        ),
      ),
    );
  }
}
