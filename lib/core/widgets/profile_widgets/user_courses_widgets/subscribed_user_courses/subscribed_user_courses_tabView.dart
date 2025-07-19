import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_state.dart';
import 'package:mr_alnagar/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:mr_alnagar/core/widgets/profile_widgets/user_courses_widgets/subscribed_user_courses/subscribed_course_card.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/text_styles.dart';

class SubscribedUserCoursesTabView extends StatelessWidget {
  final List inProgressCourses;

  const SubscribedUserCoursesTabView(
      {Key? key, required this.inProgressCourses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();

    return BlocConsumer<CoursesCubit, CoursesState>(
      listener: (context, state) {
        // TODO: implement listener
        //state is
      },
      builder: (context, state) {

        if(ProfileCubit.get(context).inProgressCourses.isEmpty){
          return RefreshIndicator(
            onRefresh: (){
              return ProfileCubit.get(context).getMyInProgressCourses();
            },
            child: Center(
              child: Text('No Courses available'),
            ),
          );
        }
        if (inProgressCourses.isNotEmpty) {
          return RefreshIndicator(
            onRefresh: (){
              return ProfileCubit.get(context).getMyInProgressCourses();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Scrollbar(
                controller: controller,
                thumbVisibility: true,
                radius: Radius.circular(40),
                interactive: true,
                thickness: 10,
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: inProgressCourses.length,
                  controller: controller,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final course = inProgressCourses[index];
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: SubscribedCourseCard(
                              course: course), // make sure your card accepts data
                        ),
                        Positioned(
                          top: 20,
                          left: 20,
                          child: Container(
                            width: 120.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Text(
                                'تم الاشتراك',
                                style: TextStyles.textStyle16w700(context).copyWith(
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        }
        else{
          return Center(child: CircularProgressIndicator(),);
        }

      },
    );
  }
}
