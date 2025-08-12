import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_cubit.dart';
import 'package:mr_alnagar/core/cubits/home_cubit/home_cubit.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:mr_alnagar/core/cubits/auth_cubit/auth_cubit/auth_cubit.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';

class HomeLayout extends StatelessWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
//             floatingActionButton: FloatingActionButton(onPressed: (){
//               print('''
// onBoarding: ${CacheHelper.getData(key: CacheKeys.onBoardingDone)}
// login: ${CacheHelper.getData(key: CacheKeys.loginDone)}
// userName: ${CacheHelper.getData(key: CacheKeys.fullName)}
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
//             }),

            bottomNavigationBar: Container(
              decoration: BoxDecoration(color: Colors.grey.shade100),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: GNav(
                  selectedIndex: HomeCubit.get(context).currentIndex,
                  curve: Curves.decelerate,
                  tabBackgroundColor: AppColors.primaryColor,
                  color: Colors.grey,
                  activeColor: Colors.white,
                  backgroundColor: Colors.grey.shade100,
                  gap: 8,
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 12.h,
                  ),
                  tabBorderRadius: 24,
                  onTabChange: (index) {
                    HomeCubit.get(
                      context,
                    ).changeBottomNavBarIndex(index: index);
                    LessonsCubit.get(context).isOneTimeLessonShowAll=false;
                    // Auto-refresh HomePage when navigating to it
                    // if (index == 0) {
                    //   // Call the refresh logic directly on the cubit
                    //   HomeCubit.get(context).getHomeData(context: context);
                    //   // Optionally, refresh other home-related data as needed
                    //   AuthCubit.get(context).getLevelsForAuthCategories();
                    //   CoursesCubit.get(context).getCoursesByCategory(
                    //     categoryID: CacheHelper.getBoolean(key: CacheKeys.id),
                    //     filter: 'my',
                    //   );
                    //   CoursesCubit.get(context).getCourses();
                    //   HomeCubit.get(context).getLeaderBoard(categoryID: 1);
                    // }
                  },
                  textStyle: TextStyle(fontSize: 13.sp, color: Colors.white),
                  tabs: [
                    GButton(
                      icon: Icons.home,
                      text: 'الرئيسية',
                      rippleColor: AppColors.primaryColor,
                      textStyle: TextStyles.textStyle12w400(context).copyWith(color: Colors.white),
                      iconSize: 24.sp,
                    ),
                    GButton(
                      icon: Icons.menu_book_outlined,
                      text: 'الحصص',
                      rippleColor: AppColors.primaryColor,
                      textStyle: TextStyles.textStyle12w400(
                        context,
                      ).copyWith(color: Colors.white),
                      iconSize: 24.sp,
                    ),
                    GButton(
                      icon: Icons.play_lesson_rounded,
                      text: 'الكورسات',
                      rippleColor: AppColors.primaryColor,
                      textStyle: TextStyles.textStyle12w400(
                        context,
                      ).copyWith(color: Colors.white),
                      iconSize: 24.sp,
                    ),
                    GButton(
                      icon: FontAwesomeIcons.solidCircleUser,
                      text: 'حسابي',
                      rippleColor: AppColors.primaryColor,
                      textStyle: TextStyles.textStyle12w400(
                        context,
                      ).copyWith(color: Colors.white),
                      iconSize: 24.sp,
                    ),
                    GButton(
                      icon: CarbonIcons.notification_filled,
                      text: 'الاشعارات',
                      rippleColor: AppColors.primaryColor,
                      textStyle: TextStyles.textStyle12w400(
                        context,
                      ).copyWith(color: Colors.white),
                      iconSize: 24.sp,
                    ),
                  ],
                ),
              ),
            ),
            body:
                HomeCubit.get(context).screens[HomeCubit.get(
                  context,
                ).currentIndex],
          ),
        );
      },
    );
  }
}
