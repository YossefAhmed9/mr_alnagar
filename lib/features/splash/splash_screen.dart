import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';
import 'package:mr_alnagar/features/authentication/login_layout/login_page.dart';
import 'package:mr_alnagar/features/home_screen/home_layout.dart';
import 'package:mr_alnagar/features/onBoarding_view/onBoarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  void navigateToNextScreen(BuildContext context) {
    final bool? onboardingDone = CacheHelper.getData(key: CacheKeys.onBoardingDone);
    final bool? loginDone = CacheHelper.getData(key: CacheKeys.loginDone);

    Widget nextPage;

    if (onboardingDone != true) {
      nextPage = const OnBoarding();
    } else if (loginDone == true) {
      nextPage = const HomeLayout();
    } else {
      nextPage = const LoginPage();
    }

    Navigator.pushAndRemoveUntil(
      context,
      CupertinoPageRoute(builder: (context) => nextPage),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      navigateToNextScreen(context);
    });

    return Scaffold(
      body: Center(child: Image.asset('assets/images/logo light.png')),
    );
  }
}
