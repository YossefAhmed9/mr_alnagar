import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/features/splash/splash_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../core/network/local/cashe_keys.dart';
import '../../core/network/local/shared_prefrence.dart';
import '../../core/cubits/splash_cubit/splash_cubit.dart';
import '../../core/utils/text_styles.dart';
import '../authentication/login_layout/login_page.dart';
import 'onBoarding_model.dart';
import '../../../core/utils/app_loaders.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

int pageIndex = 1;
double progress = pageIndex / 3;
String next = 'التالي';
final pageViewController = PageController(initialPage: 0);

class _OnBoardingState extends State<OnBoarding> {
  @override
  Widget build(BuildContext context) {
    List<OnBoardingModel> onboardingList = [
      OnBoardingModel(
        title: 'ابدا التحدي',
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.15,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              textAlign: TextAlign.center,

              'سجل دخولك واكتشف أقوى حصص ومراجعات مع مستر محمد النجار.',
              style: TextStyles.textStyle18w400(context),
            ),
          ),
        ),

        image: 'assets/images/pic.png',
      ),

      OnBoardingModel(
        title: 'اتمرّن وامتحن',
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.15,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              textAlign: TextAlign.center,

              'حل واجباتك وادخل امتحانات تفاعلية تجهزك للتفوق في الثانوية العامة. ',
              style: TextStyles.textStyle18w400(context),
            ),
          ),
        ),
        image: 'assets/images/pic2.png',
      ),

      OnBoardingModel(
        title: 'تابع نجاحك',
        body: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.15,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 15.0, top: 15),
                child: Text(
                  textAlign: TextAlign.center,

                  ' شوف مستواك بيتطور خطوة بخطوة، وخليك دايمًا في طريق الأوائل.',
                  style: TextStyles.textStyle18w400(context),
                ),
              ),
            ],
          ),
        ),
        image: 'assets/images/pic3.png',
      ),
    ];

    return BlocConsumer<SplashCubit, SplashStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SplashCubit cubit = SplashCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.75,

                  child: PageView.builder(
                    controller: pageViewController,
                    itemBuilder:
                        (context, index) =>
                            onBoardBuildingItem(onboardingList[index], context),
                    itemCount: onboardingList.length,
                    scrollDirection: Axis.horizontal,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (int index) {
                      setState(() {
                        pageIndex = index + 1;
                        progress = pageIndex / 3;
                      });
                      if (onboardingList.length == index + 1) {
                      } else {}
                    },
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
                    height: 44,
                    child: MaterialButton(
                      onPressed: () {
                        setState(() {
                          if (pageIndex == 2) {
                            next = 'ابدا يلا';
                          }
                          if (pageIndex == 3) {
                            CacheHelper.setData(key: CacheKeys.onBoardingDone, value: true);
                            Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => LoginPage(),
                              ),
                              (context) {
                                return false;
                              },
                            );

                            CacheHelper.setData(
                              key: CacheKeys.onBoardingDone,
                              value: true,
                            );
                          }
                          pageViewController.nextPage(
                            duration: Duration(seconds: 1),
                            curve: FlippedCurve(Curves.ease),
                          );
                        });
                      },
                      child: Text(
                        '$next',
                        style: TextStyles.textStyle16w700(
                          context,
                        ).copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          SmoothPageIndicator(
                            controller: pageViewController,
                            count: onboardingList.length,
                            effect: ExpandingDotsEffect(
                              dotHeight: 8,
                              radius: 16,
                              dotWidth: 8,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              CacheHelper.setData(key: CacheKeys.onBoardingDone, value: true);

                              Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                                (context) {
                                  return false;
                                },
                              );
                            },
                            child: Text(
                              'تخطي',
                              style: TextStyles.textStyle16w400(
                                context,
                              ).copyWith(color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.arrow_forward,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          CircularProgressIndicator(
                            value: progress,
                            color: AppColors.secondary,
                            strokeWidth: 3,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
