import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_state.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/features/courses_view/videos_view/videos_view.dart';

import '../../home_screen/home_layout.dart';

class QuizResultView extends StatelessWidget {
  const QuizResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final quizData = CoursesCubit.get(context).quizResult;
    final List results = quizData['results'] ?? [];

    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: ()async{
          await CoursesCubit.get(context).getVideosByCourse(id: quizData['course_id'], context: context);
          await CoursesCubit.get(context).getCourseByID(id: quizData['course_id'],);
          Navigator.push(context, CupertinoPageRoute(builder: (context){
            return CourseVideoScreen(videoIndex: quizData['course_id']);
          }));
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: AppColors.primaryColor
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('ابدا الكورس',style: TextStyles.textStyle16w700(context).copyWith(color: Colors.white),),
                ),
              )),
        ),
      ),
      appBar: AppBar(
        title: Text(
          quizData['quiz_title'] ?? 'Quiz Result',
          style: TextStyles.textStyle16w700(context),
        ),
        actions: [
          IconButton(onPressed: (){

            Navigator.pushAndRemoveUntil(context,
                CupertinoPageRoute(builder: (context){
                  return HomeLayout();
                }), (context){
                  return false;
                });

          }, icon: Icon(Icons.home_outlined,color: AppColors.secondary,size: 30,)),

        ],
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Stack(
          children:[

            SingleChildScrollView(
              child: Column(



                children: [
                  Container(
                    height: 150,
                  ),

                  Column(
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


                                  Row(
                                    spacing: 10,
                                    mainAxisAlignment:MainAxisAlignment.end,
                                    children: [

                                      Text(
                                        studentAnswer['answer']?.toString() ?? '-',
                                        style: TextStyles.textStyle20w700(
                                          context,
                                        ).copyWith(color:question['is_correct'] ?AppColors.primaryColor : Colors.red  ),
                                      ),
                                      Text(
                                        " : اجابتك ",
                                        style: TextStyles.textStyle20w700(
                                          context,
                                        ).copyWith(color:question['is_correct'] ?AppColors.primaryColor : Colors.red  ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    spacing: 10,
                                    mainAxisAlignment:MainAxisAlignment.end,
                                    children: [

                                      Text(
                                        question['answer_percent']?.toString() ?? '-',
                                        style: TextStyle(color:AppColors.secondary80,fontWeight: FontWeight.w600),
                                      ),
                                      Text(': نسبة اجابتك للاجابة الصحيحة ')

                                    ],
                                  ),
                                  const SizedBox(height: 20),

                                  Row(
                                    spacing: 10,
                                    mainAxisAlignment:MainAxisAlignment.end,
                                    children: [


                                      Text(
                                        correctAnswer['answer']?.toString() ?? '-',
                                        style: TextStyles.textStyle20w700(
                                          context,
                                        ).copyWith(
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                      Text(
                                        " : الاجابة الصحيحة",
                                        style: TextStyles.textStyle20w700(
                                          context,
                                        ).copyWith(color:AppColors.primaryColor),
                                      ),
                                    ],
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

                                      Color bgColor = Colors.white;
                                      Color textColor = AppColors.primaryColor;

                                      if (selected && correct) {
                                        bgColor = AppColors.primaryColor;
                                        textColor = Colors.white;
                                      } else if (selected && !correct) {
                                        bgColor = Colors.red;
                                        textColor = Colors.white;
                                      } else if (!selected && correct) {
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
                        spacing:5,
                        children: [
                          Text('النتيجة :',style: TextStyles.textStyle20w700(context).copyWith(color: AppColors.secondary),),

                          Text('${CoursesCubit.get(context).quizResult['score']}/${CoursesCubit.get(context).quizResult['full_score']}' ?? '',style: TextStyles.textStyle20w700(context).copyWith(color: AppColors.secondary)),

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

          ] ,
        ),
      ),
    );
  }
}
