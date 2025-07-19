import 'package:flutter/material.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_cubit.dart';
import 'package:mr_alnagar/core/widgets/Courses%20widgets/course_card.dart';
import 'package:mr_alnagar/core/widgets/lessons%20widgets/lessons_subscreption_item.dart';

import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';

class LessonsSubscribtionTabBar extends StatelessWidget {
  const LessonsSubscribtionTabBar({Key? key,})
    : super(key: key);

  @override
  Widget build(BuildContext context) {


    return LessonsCubit.get(context).myCourses.length==0 ?
        Text('لا توجد حصص مشترك فيها')

      :  ListView.builder(
      itemCount: LessonsCubit.get(context).myCourses.length,
      itemBuilder: (context, index) {
        return CourseCard(data: LessonsCubit.get(context).myCourses[index], index: index); // Assuming LessonItem is a widget to display each lesson
      },
    );
  }
}
