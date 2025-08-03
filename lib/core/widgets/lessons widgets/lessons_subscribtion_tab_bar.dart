import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_cubit.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';
import 'package:mr_alnagar/core/widgets/Courses%20widgets/course_card.dart';
import 'package:mr_alnagar/core/widgets/lessons%20widgets/lesson_card.dart';
import 'package:mr_alnagar/core/widgets/lessons%20widgets/lessons_subscreption_item.dart';

import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';

class LessonsSubscribtionTabBar extends StatelessWidget {
  const LessonsSubscribtionTabBar({Key? key,})
    : super(key: key);

  @override
  Widget build(BuildContext context) {


    return LessonsCubit.get(context).myCourses.length==0 ?
        RefreshIndicator(

            onRefresh: (){
              return LessonsCubit.get(context).getMyLessons(categoryID: CacheHelper.getData(key: CacheKeys.categoryId));

            },
            child: Center(child: Text('لا توجد حصص مشترك فيها',style: TextStyles.textStyle16w700(context).copyWith(color: AppColors.primaryColor),)))

      :  RefreshIndicator(
      onRefresh:(){
        return LessonsCubit.get(context).getMyLessons(categoryID: CacheHelper.getData(key: CacheKeys.categoryId));
      } ,
      child: ListView.builder(
        itemCount: LessonsCubit.get(context).myCourses.length,
        itemBuilder: (context, index) {
          return Stack(children:
          [

            LessonCard(data: LessonsCubit.get(context).myCourses[index], index: index),
            LessonsCubit.get(context).myCourses[index]['is_enrolled'] == true
                ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0,horizontal: 10),
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
                      style: TextStyles.textStyle16w700(context)
                          .copyWith(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ) : Container(),
          ]

          ); // Assuming LessonItem is a widget to display each lesson
        },
            ),
      );
  }
}
