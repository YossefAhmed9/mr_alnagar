import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_state.dart';

import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';
import 'course_card.dart';

class CoursesTabBarView extends StatelessWidget {
  const CoursesTabBarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();

    return BlocConsumer<CoursesCubit, CoursesState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return CoursesCubit.get(context).courses.isEmpty
            ? Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            )
            : RefreshIndicator(
          onRefresh: (){
            return CoursesCubit.get(context).getCourses();
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
                    //physics: BouncingScrollPhysics(),
                    itemCount: CoursesCubit.get(context).courses.length,
                    controller: controller,

                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: CourseCard(
                              data: CoursesCubit.get(context).courses[index],
                              index: index,
                            ),
                          ),
                          CoursesCubit.get(context).courses[index]['is_enrolled']==true ?
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Align(
                              alignment: AlignmentDirectional.topEnd,
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
                                    style: TextStyles.textStyle16w700(
                                      context,
                                    ).copyWith(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ),
                          ) : Container(),
                        ],
                      );
                    },
                  ),
                ),
              ),
            );
      },
    );
  }
}
