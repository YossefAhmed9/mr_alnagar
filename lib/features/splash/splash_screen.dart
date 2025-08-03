import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import '../../core/network/local/cashe_keys.dart';
import '../../core/network/local/shared_prefrence.dart';
import '../authentication/login_layout/login_page.dart';
import '../home_screen/home_layout.dart';
import '../onBoarding_view/onBoarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkForUpdate();
  }

  Future<void> _checkForUpdate() async {
    try {
      final updateInfo = await InAppUpdate.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable &&
          updateInfo.immediateUpdateAllowed) {
        await InAppUpdate.performImmediateUpdate();
      } else {
        _navigateToNextScreen();
      }
    } catch (e) {
      print("Update check failed: $e");
      _navigateToNextScreen(); // fallback navigation
    }
  }

  void _navigateToNextScreen() {
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
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
