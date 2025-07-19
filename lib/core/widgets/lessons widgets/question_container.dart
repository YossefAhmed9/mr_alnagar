import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_cubit.dart';

import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';

class QuestionContainer extends StatelessWidget {
  const QuestionContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List answers=[
      'A. cultural',
      'B. culture',
      'C. culturally',
      'D. historically',
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Surely it is wrong to try to impose western __________ on those people.',
              style: TextStyles.textStyle16w700(context),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3.4,
              ),
              itemCount: answers.length,
              itemBuilder: (context, answerIndex) {

                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {

                      //LessonsCubit.get(context).getSelectedAnswer(questionIndex: index);

                      },
                    child: Container(
                      height: 20.h,
                      decoration: BoxDecoration(
                        color: LessonsCubit.get(context).isAnswerSelected
                            ? AppColors.primaryColor
                            : Colors.white,
                        border: Border.all(
                          color: AppColors.primaryColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          answers[answerIndex],
                          style: TextStyles.textStyle16w700(context)
                              .copyWith(
                            // color: isSelected
                            //     ? Colors.white
                            //     : AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );;
  }
}
