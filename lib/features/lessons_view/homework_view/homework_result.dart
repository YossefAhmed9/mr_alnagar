import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/features/home_screen/home_layout.dart';

import '../../../core/cubits/lessons_cubit/lessons_cubit.dart';
import '../../../core/cubits/lessons_cubit/lessons_state.dart';

class LessonsHomeworkResultView extends StatelessWidget {
  final int attemptID;

  const LessonsHomeworkResultView({super.key, required this.attemptID});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LessonsCubit, LessonsState>(
      builder: (context, state) {
        final cubit = LessonsCubit.get(context);

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
            child: SingleChildScrollView(
              child: Column(
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
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 1,
                              childAspectRatio: 3.5,
                            ),
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
                                bgColor = AppColors.primaryColor;
                                textColor = Colors.white;
                              } else if (shouldHighlightRed) {
                                bgColor = Colors.red;
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
                        TextButton(onPressed: (){
                          Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context)=>HomeLayout()), (context)=>false);
                        }, child: Text('Go to Home Screen',style: TextStyles.textStyle16w700(context),),),


                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}
