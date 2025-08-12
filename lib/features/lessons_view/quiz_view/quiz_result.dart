import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_cubit.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';

import '../../../core/utils/app_loaders.dart';
import '../../home_screen/home_layout.dart';
import '../lesson_reservation_screen.dart';
import '../subscriptions_list_view.dart';
import '../videos_view/videos_view.dart';

class LessonsQuizResultView extends StatelessWidget {
  const LessonsQuizResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final quizData = LessonsCubit.get(context).quizResult;
    final List results = quizData['results'] ?? [];

    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () async {
          CoursesCubit.get(context).isCourseLoading = true;
          await LessonsCubit.get(
            context,
          ).getCourseByID(id: quizData['course_id']);
          await LessonsCubit.get(
            context,
          ).getClassDataByID(classId: quizData['class_id'], context: context);
          print(quizData['course_id']);
          //Navigator.push(context, CupertinoPageRoute(builder: (context)=>HomeLayout()));
          // Navigator.push(context, CupertinoPageRoute(builder: (context)=>LessonReservationScreen(data: LessonsCubit.get(context).courseResult[0])));
          //Navigator.push(context, CupertinoPageRoute(builder: (context) => SubscriptionsListView()),);
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder:
                  (context) =>
                      LessonVideoScreen(videoIndex: quizData['class_id'],),
            ),
          );
          CoursesCubit.get(context).isCourseLoading = false;
        },
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            width: double.infinity,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.secondary80,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                'ابدا الحصة',
                style: TextStyles.textStyle16w700(
                  context,
                ).copyWith(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
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
        child: ModalProgressHUD(
          progressIndicator: AppLoaderHourglass(),

          inAsyncCall: CoursesCubit.get(context).isCourseLoading,

          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: [
                    Container(height: 150),

                    Column(
                      children:
                          results.map<Widget>((question) {
                            final String type = question['question_type'];
                            if (type == 'reading_passage')
                              return Container(); // handle separately if needed

                            final String questionText = HtmlUnescape().convert(
                              (question['question'] ?? '').replaceAll(
                                RegExp(r'<[^>]*>'),
                                '',
                              ),
                            );

                            final List answers =
                                question['question_answers'] ?? [];
                            final dynamic studentAnswer =
                                question['student_answer'];
                            final dynamic correctAnswer =
                                question['correct_answers'];
                            final bool isCorrect =
                                question['is_correct'] ?? false;

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        questionText,
                                        style: TextStyles.textStyle16w700(
                                          context,
                                        ),
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
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,

                                          itemCount: answers.length,
                                          itemBuilder: (context, index) {
                                            final answer = answers[index];
                                            final bool selected =
                                                answer['is_selected'] == true;
                                            final bool correct =
                                                answer['is_correct'] == true;

                                            Color bgColor = Colors.white;
                                            Color textColor =
                                                AppColors.primaryColor;

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
                                              padding: const EdgeInsets.all(
                                                8.0,
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: bgColor,
                                                  border: Border.all(
                                                    color:
                                                        bgColor == Colors.white
                                                            ? AppColors
                                                                .primaryColor
                                                            : bgColor,
                                                    width: 2,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: Text(
                                                      answer['answer']
                                                          .toString(),
                                                      style:
                                                          TextStyles.textStyle14w700(
                                                            context,
                                                          ).copyWith(
                                                            color: textColor,
                                                          ),
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
                    child: Column(spacing: 5,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 5,
                          children: [
                            Text(
                              'النتيجة :',
                              style: TextStyles.textStyle20w700(
                                context,
                              ).copyWith(color: AppColors.secondary),
                            ),

                            Text(
                              '${LessonsCubit.get(context).quizResult['score']}/${LessonsCubit.get(context).quizResult['full_score']}',
                              style: TextStyles.textStyle20w700(
                                context,
                              ).copyWith(color: AppColors.secondary),
                            ),
                          ],
                        ),
                        SizedBox(height: 5,),
                        Row(
                          spacing: 10,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              width: 20,
                              height: 10,
                            ),
                            Flexible(
                              child: Text(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                'الاجابات باللون الاحمر تدل علي اجابتك انها خطأ',
                                style: TextStyles.textStyle14w700(
                                  context,
                                ).copyWith(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 10,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              width: 20,
                              height: 10,
                            ),
                            Flexible(
                              child: Text(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,

                                'الاجابات باللون الارزق تدل على الاجابة صحيحة',
                                style: TextStyles.textStyle14w700(
                                  context,
                                ).copyWith(color: AppColors.primaryColor),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 10,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              width: 20,
                              height: 10,
                            ),
                            Flexible(
                              child: Text(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                'ان لم تجد اجابتك باللون الاحمر يدل علي ان اجابتك صحيحة',
                                style: TextStyles.textStyle14w700(
                                  context,
                                ).copyWith(color: AppColors.primaryColor),
                              ),
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
      ),
    );
  }
}
