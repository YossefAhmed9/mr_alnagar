import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_state.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/features/home_screen/home_layout.dart';

class HomeworkResultView extends StatelessWidget {
  final int attemptID;

  const HomeworkResultView({super.key, required this.attemptID});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CoursesCubit, CoursesState>(
      builder: (context, state) {
        final cubit = CoursesCubit.get(context);

        final result = cubit.homeWorkResult;

        if (result == null) {
          // Ensure result is loaded
          cubit.getHomeWorkResult(attemptID: attemptID);
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final List results = result['results'] ?? [];

        return Scaffold(

          appBar: AppBar(
            title: Text(
              result['homework_title'] ?? 'Homework Result',
              style: TextStyles.textStyle16w700(context),
            ),
            centerTitle: true,
            backgroundColor: Colors.white,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(height: 150,),
                      Column(
                        children: results.map<Widget>((question) {
                          final String type = question['question_type'];
                          if (type == 'reading_passage') return Container();

                          final String questionText = HtmlUnescape().convert(
                            (question['question'] ?? '').replaceAll(RegExp(r'<[^>]*>'), ''),
                          );

                          final List answers = question['question_answers'] ?? [];
                          final dynamic studentAnswer = question['student_answer'];
                          final dynamic correctAnswer = question['correct_answers'];
                          final bool isCorrect = question['is_correct'] ?? false;

                          // Extract correct IDs for MCQ and TF
                          final List<int> correctIds = (correctAnswer is List)
                              ? correctAnswer.map<int>((e) => e['id'] as int).toList()
                              : [];

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text(
                                  questionText,
                                  style: TextStyles.textStyle16w700(context),
                                ),
                                const SizedBox(height: 8),
                                if (type == 'short_answer') ...[
                                  Text("Your answer:", style: TextStyles.textStyle14w700(context)),
                                  Text(
                                    studentAnswer?['answer']?.toString() ?? '-',
                                    style: TextStyles.textStyle14w400(context),
                                  ),
                                  const SizedBox(height: 4),
                                  Text("Correct answer:", style: TextStyles.textStyle14w700(context)),
                                  Text(
                                    correctAnswer?['answer']?.toString() ?? '-',
                                    style: TextStyles.textStyle14w400(context).copyWith(color: Colors.red),
                                  ),
                                ] else
                                  ListView.builder(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,

                                    itemCount: answers.length,
                                    itemBuilder: (context, index) {
                                      final answer = answers[index];
                                      final bool selected = answer['is_selected'] == true;
                                      final bool correct = answer['is_correct'] == true;
                                      final bool shouldHighlightRed = correct && !selected;

                                      Color bgColor = Colors.white;
                                      Color textColor = AppColors.primaryColor;

                                      if (selected && correct) {
                                        bgColor = AppColors.primaryColor;
                                        textColor = Colors.white;
                                      } else if (selected && !correct) {
                                        bgColor = Colors.red;
                                        textColor = Colors.white;
                                      } else if (shouldHighlightRed) {
                                        bgColor = AppColors.primaryColor;
                                        textColor = Colors.white;
                                      }

                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: bgColor,
                                            border: Border.all(color: bgColor == Colors.white ? AppColors.primaryColor : bgColor, width: 2),
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                HtmlUnescape().convert(answer['answer']?.toString() ?? ''),
                                                style: TextStyles.textStyle14w700(context).copyWith(color: textColor),
                                                maxLines: 5,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },

                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Container(
                      width: double.infinity,
                      height: 140.h,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                          image: AssetImage('assets/images/pattern 2.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(

                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing:5,
                            children: [
                              Text('النتيجة :',style: TextStyles.textStyle20w700(context).copyWith(color: AppColors.secondary),),

                              Text('${CoursesCubit.get(context).homeWorkResult['score_text']}',style: TextStyles.textStyle20w700(context).copyWith(color: AppColors.secondary)),

                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Container(decoration: BoxDecoration(color: Colors.red,borderRadius: BorderRadius.circular(25)),width: 20,height: 10,),
                              Flexible(
                                child: Text(
                                  maxLines: 2,overflow: TextOverflow.ellipsis,
                                  'الاجابات باللون الاحمر تدل علي اجابتك انها خطأ',style: TextStyles.textStyle14w700(context).copyWith(color: Colors.red),),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Container(decoration: BoxDecoration(color: AppColors.primaryColor,borderRadius: BorderRadius.circular(25)),width: 20,height: 10,),
                              Flexible(
                                child: Text(
                                  maxLines: 2,overflow: TextOverflow.ellipsis,

                                  'الاجابات باللون الارزق تدل على الاجابة صحيحة',style: TextStyles.textStyle14w700(context).copyWith(color: AppColors.primaryColor),),
                              ),
                            ],
                          ),
                          Row(
                            spacing: 10,
                            children: [
                              Container(decoration: BoxDecoration(border: Border.all(color: AppColors.primaryColor),borderRadius: BorderRadius.circular(25)),width: 20,height: 10,),
                              Flexible(
                                child: Text(
                                  maxLines: 2,overflow: TextOverflow.ellipsis,
                                  'ان لم تجد اجابتك باللون الاحمر يدل علي ان اجابتك صحيحة',style: TextStyles.textStyle14w700(context).copyWith(color: AppColors.primaryColor),),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
