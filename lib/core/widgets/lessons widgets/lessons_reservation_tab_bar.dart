import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_cubit.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/core/widgets/Courses%20widgets/course_card.dart';
import 'package:mr_alnagar/core/widgets/lessons%20widgets/lessons_subscreption_item.dart';

import '../../cubits/lessons_cubit/lessons_state.dart';
import '../../network/local/cashe_keys.dart';
import '../../network/local/shared_prefrence.dart';
import 'lesson_card.dart';

class LessonsReservationTabBar extends StatelessWidget {
  const LessonsReservationTabBar({Key? key, required this.lessons})
    : super(key: key);
  final List lessons;

  @override
  Widget build(BuildContext context) {
    if (lessons.isEmpty) {
      return RefreshIndicator(
        onRefresh:()async {
          await LessonsCubit.get(context).getCoursesByCategory(categoryID: CacheHelper.getData(key: CacheKeys.categoryId));
          return await LessonsCubit.get(context).getMyLessons(categoryID: CacheHelper.getData(key: CacheKeys.categoryId));
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text('لا توجد بيانات',style: TextStyles.textStyle16w700(context).copyWith(color: AppColors.primaryColor),),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: lessons.length,
      itemBuilder: (context, index) {
        final course = lessons[index];
        return Stack(children:
        [
          LessonCard(data: course, index: index),

        ]
        ); // Assuming LessonItem is a widget to display each lesson
      },
    );
  }
}
