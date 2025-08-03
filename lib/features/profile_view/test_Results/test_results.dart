import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_cubit.dart';
import 'package:mr_alnagar/core/cubits/quiz_results_cubit/quiz_results_cubit.dart';
import 'package:mr_alnagar/features/courses_view/quiz_view/quiz_result.dart';
import 'package:mr_alnagar/features/lessons_view/quiz_view/quiz_result.dart';

import '../../../core/cubits/courses_cubit/courses_cubit.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/text_styles.dart';

class TestResults extends StatefulWidget {
  const TestResults({Key? key}) : super(key: key);

  @override
  State<TestResults> createState() => _TestResultsState();
}

class _TestResultsState extends State<TestResults> {
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    return BlocConsumer<QuizResultsCubit, QuizResultsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return
          QuizResultsCubit.get(context).quizResults.isEmpty ?
              Center(child: Text('لا توجد امتحانات',
                style: TextStyles.textStyle16w700(context).copyWith(color: AppColors.primaryColor),),) :
          Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: ModalProgressHUD(
              inAsyncCall: isLoading,
              child: SafeArea(
                child: Scrollbar(
                  thumbVisibility: true,
                  radius: Radius.circular(40),
                  interactive: true,
                  thickness: 10,
                  controller: controller,
                  child:
                  QuizResultsCubit.get(context).quizResults.isEmpty
                      ? Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                    controller: controller,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.secondary30,
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15.0,
                                    horizontal: 5,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          'الدرس',
                                          style:
                                          TextStyles.textStyle14w700(
                                            context,
                                          ).copyWith(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          'الدرجة',
                                          style:
                                          TextStyles.textStyle14w700(
                                            context,
                                          ).copyWith(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ListView.separated(
                                controller: controller,
                                physics:
                                const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: QuizResultsCubit.get(context).quizResults.length,
                                separatorBuilder: (context, index) {
                                  return const Divider(
                                    color: Colors.grey,
                                    thickness: 1,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: ()async{
                                      if (QuizResultsCubit.get(context).quizResults[index]['is_class']==0) {
                                        setState(() {
                                          isLoading=true;
                                        });
                                      print('not class');
                                         await CoursesCubit.get(context).getQuizResult(attemptID: QuizResultsCubit.get(context).quizResults[index]['attempt_id']);
                                        // await CoursesCubit.get(context).getCourseByID(id: course['id']);
                                        //
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) => QuizResultView(),
                                          ),);
                                        setState(() {
                                          isLoading=false;
                                        });
                                      }
                                      if (QuizResultsCubit.get(context).quizResults[index]['is_class']==1) {
                                        setState(() {
                                          isLoading=true;
                                        });
                                        print('is class');
                                        await LessonsCubit.get(context).getQuizResult(attemptID: QuizResultsCubit.get(context).quizResults[index]['attempt_id']);
                                         await LessonsCubit.get(context).getCourseByID(id:LessonsCubit.get(context).quizResult['course_id']);
                                        // print(LessonsCubit.get(context).quizResult['course_id']);
                                        //
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) => LessonsQuizResultView(),
                                          ),);

                                        setState(() {
                                          isLoading=false;
                                        });
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        spacing: 10,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(maxLines: 3,
                                              QuizResultsCubit.get(context)
                                                  .quizResults[index]['quiz_title']
                                                  .toString(),
                                              style:
                                              TextStyles.textStyle14w400(
                                                context,
                                              ).copyWith(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${QuizResultsCubit.get(context).quizResults[index]['score'].toString()}',
                                            style:
                                            TextStyles.textStyle16w700(
                                              context,
                                            ).copyWith(
                                              color: Colors.black,
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: AppColors.primaryColor,
                                                width: 2,
                                              ),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              spacing: 5,
                                              children: [
                                                SizedBox(width: 2,),
                                                Text(
                                                  'عرض الامتحان',
                                                  style: TextStyles.textStyle14w700(
                                                    context,
                                                  ).copyWith(
                                                    color: AppColors.primaryColor,fontSize: 14,
                                                  ),
                                                ),
                                                const SizedBox(width: 5),
                                                Icon(Icons.keyboard_double_arrow_left_outlined,
                                                  color: AppColors.primaryColor,
                                                  size: 25,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}