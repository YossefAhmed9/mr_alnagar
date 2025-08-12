import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_state.dart';
import '../../../core/utils/app_loaders.dart';

import '../../cubits/lessons_cubit/lessons_cubit.dart';
import '../../cubits/profile_cubit/profile_cubit.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';
import 'course_card.dart';

class CoursesTabBarView extends StatelessWidget {
  const CoursesTabBarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelStyle: TextStyles.textStyle16w700(context),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black87,

            indicatorAnimation: TabIndicatorAnimation.elastic,
            indicator: BoxDecoration(
              color: AppColors.primaryColor, // Deep blue
              borderRadius: BorderRadius.circular(20),
            ),
            indicatorSize: TabBarIndicatorSize.tab,
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: 'احجز الان'),
              Tab(text: 'اشتراكاتي'),
            ],
          ),
          Expanded(
            child: TabBarView(

              children: [
                AllCoursesListView(controller: controller),
                MyCoursesListView(controller: controller),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyCoursesListView extends StatelessWidget {
  final ScrollController controller;

  const MyCoursesListView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoursesCubit, CoursesState>(
      listener: (context, state) {},
      builder: (context, state) {
        final courses = ProfileCubit.get(context).inProgressCourses;
        return courses.isEmpty
            ?  RefreshIndicator(
          color: AppColors.primaryColor,
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          onRefresh: () async {
            return ProfileCubit.get(context).getMyInProgressCourses();
          },
          child: Center(child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Text('لا توجد اشتراكات',style:TextStyles.textStyle20w700(context).copyWith(color: AppColors.primaryColor))),),
            )
            : RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: () => CoursesCubit.get(context).getCourses(),
              child: ModalProgressHUD(
                progressIndicator: AppLoaderHourglass(),

                inAsyncCall: CoursesCubit.get(context).isCourseLoading,
                child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Scrollbar(
                controller: controller,
                thumbVisibility: true,
                radius: const Radius.circular(40),
                interactive: true,
                thickness: 10,
                child: ListView.builder(
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: courses.length,
                  controller: controller,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CourseCard(data: course, index: index),
                        ),
                        course['is_enrolled'] == true
                            ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 25),
                          child: Align(
                            alignment: AlignmentDirectional.topEnd,
                            child: Container(
                              width: 80.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Center(
                                child: Text(
                                  'تم الاشتراك',
                                  style: TextStyles.textStyle16w700(context)
                                      .copyWith(color: Colors.white,fontSize: 14),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        )
                            : const SizedBox(),
                      ],
                    );
                  },
                ),
              ),
                        ),
              ),
            );
      },
    );
  }
}
class AllCoursesListView extends StatelessWidget {
  final ScrollController controller;

  const AllCoursesListView({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoursesCubit, CoursesState>(
      listener: (context, state) {},
      builder: (context, state) {
        final courses = CoursesCubit.get(context).courses;
        return courses.isEmpty
            ? Center(child: AppLoaderInkDrop(color: AppColors.primaryColor))
            : RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: () => CoursesCubit.get(context).getCourses(),
              child: ModalProgressHUD(
                progressIndicator: AppLoaderHourglass(),

                inAsyncCall: CoursesCubit.get(context).isCourseLoading,
                child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Scrollbar(
                controller: controller,
                thumbVisibility: true,
                radius: const Radius.circular(40),
                interactive: true,
                thickness: 10,
                child: ListView.builder(
                  itemCount: courses.length,
                  controller: controller,physics: AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: CourseCard(data: course, index: index),
                        ),
                      ],
                    );
                  },
                ),
              ),
                ),
              ),
            );
      },
    );
  }
}
