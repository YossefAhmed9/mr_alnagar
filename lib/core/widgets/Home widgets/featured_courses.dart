import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/app_loaders.dart';

import '../../cubits/courses_cubit/courses_cubit.dart';
import '../../cubits/courses_cubit/courses_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_state.dart';

import '../../cubits/home_cubit/home_cubit.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';
import '../Courses widgets/course_card.dart';

class FeaturedCourses extends StatelessWidget {
  const FeaturedCourses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoursesCubit, CoursesState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('الكورسات المميزة', style: TextStyles.textStyle16w700(context)),
                  InkWell(
                    onTap: () {
                      HomeCubit.get(context).changeBottomNavBarIndex(index: 2);
                    },
                    child: Text(
                      'عرض الكل',
                      style: TextStyles.textStyle16w700(
                        context,
                      ).copyWith(color: AppColors.secondary),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Courses List
              // SizedBox(
              //   height: 220.h,
              //   child: ListView.separated(
              //     separatorBuilder: (context,index){
              //       return SizedBox(width: 8.w,);
              //     },
              //     scrollDirection: Axis.horizontal,
              //     physics: ClampingScrollPhysics(),
              //     itemCount: 2,
              //     shrinkWrap: true,
              //     itemBuilder: (context, index) {
              //       return CourseCard();
              //     },
              //   ),
              // ),
              CoursesCubit.get(context).courses.isEmpty
                  ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: AppLoaderInkDrop(
                    color: AppColors.primaryColor,
                  ),
                ),
              )
                  : SizedBox(
                height: 260.h,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: HomeCubit.get(context).home['featured_courses'].length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return SizedBox(
                      width: 280,
                      height: 140.h,
                      child: CourseCard(
                        data: HomeCubit.get(context).home['featured_courses'][index],
                        index: index,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
