import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_state.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';

import '../../home_screen/home_layout.dart';

class QuizResultView extends StatelessWidget {
  const QuizResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final quizData = CoursesCubit.get(context).quizResult;
    final List results = quizData['results'] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          quizData['quiz_title'] ?? 'Quiz Result',
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
              if (type == 'reading_passage') return Container(); // handle separately if needed

              final String questionText = HtmlUnescape().convert(
                (question['question'] ?? '').replaceAll(RegExp(r'<[^>]*>'), ''),
              );

              final List answers = question['question_answers'] ?? [];
              final dynamic studentAnswer = question['student_answer'];
              final dynamic correctAnswer = question['correct_answers'];
              final bool isCorrect = question['is_correct'] ?? false;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          questionText,
                          style: TextStyles.textStyle16w700(context),
                        ),
                        const SizedBox(height: 8),
                        if (type == 'short_answer') ...[
                          Text("Your answer:", style: TextStyles.textStyle14w700(context)),
                          Text(studentAnswer?.toString() ?? '-', style: TextStyles.textStyle14w400(context)),
                          const SizedBox(height: 4),
                          Text("Correct answer:", style: TextStyles.textStyle14w700(context)),
                          Text(correctAnswer?.toString() ?? '-', style: TextStyles.textStyle14w400(context).copyWith(color: Colors.red)),
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

                              Color bgColor = Colors.white;
                              Color textColor = AppColors.primaryColor;

                              if (selected && correct) {
                                bgColor = AppColors.primaryColor;
                                textColor = Colors.white;
                              } else if (selected && !correct) {
                                bgColor = AppColors.primaryColor;
                                textColor = Colors.white;
                              } else if (!selected && correct) {
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
                                        answer['answer'].toString(),
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
  }
}
