import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';

import '../../../../cubits/courses_cubit/courses_state.dart';
import '../../../../utils/app_loaders.dart';
import 'done_user_course_card.dart';

class DoneUserCoursesTabView extends StatelessWidget {
  final List completedCourses;

  const DoneUserCoursesTabView({Key? key, required this.completedCourses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        if(ProfileCubit.get(context).completedCourses.isEmpty){
          return RefreshIndicator(
            triggerMode: RefreshIndicatorTriggerMode.anywhere,

            onRefresh: ()async{


              return await ProfileCubit.get(context).getMyCompletedCourses();
            },
            child: Center(
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Text('No Courses Completed',
                      style: TextStyles.textStyle20w700(context).copyWith(
                          color: AppColors.primaryColor
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        if (completedCourses.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Scrollbar(
              controller: controller,
              thumbVisibility: true,
              radius: Radius.circular(40),
              interactive: true,
              thickness: 10,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: completedCourses.length,
                controller: controller,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final course = completedCourses[index];
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: DoneUserCourseCard(
                            course: course), // also make this accept data
                      ),
                      Positioned(
                        top: 20,
                        right: 20,
                        child: Container(
                          width: 120.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Center(
                            child: Text(
                              'تم الانتهاء',
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
          );
        }
        else{
          return Center(child: AppLoaderInkDrop(),);
        }

      },
    );
  }
}
