import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mr_alnagar/features/lessons_view/quiz_view/exam_view.dart';
import 'package:mr_alnagar/features/lessons_view/videos_view/videos_view.dart';

import '../../core/cubits/lessons_cubit/lessons_cubit.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/text_styles.dart';
import 'package:mr_alnagar/features/lessons_view/homework_view/home_work_view.dart';

class SubscriptionsListView extends StatefulWidget {
  const SubscriptionsListView({Key? key}) : super(key: key);

  @override
  State<SubscriptionsListView> createState() => _SubscriptionsListViewState();
}

class _SubscriptionsListViewState extends State<SubscriptionsListView> {
  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          LessonsCubit.get(context).courseResult[0]['title'],
          style: TextStyles.textStyle16w700(context),
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: ModalProgressHUD(
          inAsyncCall: LessonsCubit.get(context).isLessonLoading,
          child: Scrollbar(
            controller: controller,
            thumbVisibility: true,
            radius: Radius.circular(40),
            interactive: true,
            thickness: 10,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: LessonsCubit.get(context).userLessons.length,
                controller: controller,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          Container(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                              ),

                              // image: DecorationImage(
                              //   image: AssetImage('assets/images/pattern 1.png'),
                              //   fit: BoxFit.fill,
                              // ),
                            ),
                            child: Image.network(
                              LessonsCubit.get(
                                context,
                              ).userLessons[index]['image'],
                              fit: BoxFit.fill,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/error image.png',
                                  fit: BoxFit.cover,
                                  width: 100,
                                  height: 150,
                                );
                              },
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 20,
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10.0,
                                    ),
                                    child: Row(
                                      spacing: 5,
                                      children: [
                                        Icon(
                                          FeatherIcons.calendar,
                                          size: 20,
                                          color: Colors.black,
                                        ),
                                        Text(
                                          LessonsCubit.get(
                                            context,
                                          ).userLessons[index]['started_at'],
                                          style: TextStyles.textStyle14w400(
                                            context,
                                          ).copyWith(
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        LessonsCubit.get(
                                          context,
                                        ).userLessons[index]['title'],
                                        style: TextStyles.textStyle16w700(
                                          context,
                                        ).copyWith(color: Colors.black),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15.0,
                                    ),
                                    child: Container(
                                      color: Colors.grey.shade400,
                                      width: double.infinity,
                                      height: 2,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    height: 45.h,
                                    width: double.infinity,
                                    child: MaterialButton(
                                      onPressed: () async {
                                        setState(() {
                                          LessonsCubit.get(context)
                                              .isLessonLoading = true;
                                        });
                                        await LessonsCubit.get(
                                          context,
                                        ).getClassDataByID(
                                          classId:
                                              LessonsCubit.get(
                                                context,
                                              ).userLessons[index]['id'],
                                          context: context,
                                        );
                                        final classData =
                                            LessonsCubit.get(context).classData;
                                        if (classData['has_quizzes'] == true &&
                                            classData['quiz_required'] == 1) {
                                          setState(() {
                                            LessonsCubit.get(context)
                                                .isLessonLoading = false;
                                          });
                                          showDialog(
                                            context: context,
                                            barrierDismissible: true,
                                            builder:
                                                (context) => WillPopScope(
                                                  onWillPop: () async => false,
                                                  child: Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    child: AlertDialog(
                                                      backgroundColor:
                                                          Colors.white,
                                                      title: Text(
                                                        'تنبيهات مهمة',
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      titleTextStyle:
                                                          TextStyles.textStyle16w700(
                                                            context,
                                                          ).copyWith(
                                                            color:
                                                                AppColors
                                                                    .secondary,
                                                          ),

                                                      content: SingleChildScrollView(
                                                        child: Column(
                                                          children: [
                                                            Image.asset(
                                                              'assets/images/pic2.png',
                                                            ),
                                                            Text(
                                                              'يجب حل الامتحان اولا',
                                                              style: TextStyles.textStyle16w700(
                                                                context,
                                                              ).copyWith(
                                                                color:
                                                                    AppColors
                                                                        .secondary,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),

                                                      actions: [
                                                        InkWell(
                                                          onTap: () async {
                                                            await LessonsCubit.get(
                                                              context,
                                                            ).startQuiz(
                                                              quizId:
                                                                  classData['quiz_id'],
                                                            );
                                                            showDialog(
                                                              context: context,
                                                              barrierDismissible:
                                                                  true,
                                                              builder:
                                                                  (
                                                                    context,
                                                                  ) => WillPopScope(
                                                                    onWillPop:
                                                                        () async =>
                                                                            false,
                                                                    child: Directionality(
                                                                      textDirection:
                                                                          TextDirection
                                                                              .rtl,
                                                                      child: AlertDialog(
                                                                        backgroundColor:
                                                                            Colors.white,
                                                                        title: Text(
                                                                          'تنبيهات مهمة',
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                        ),
                                                                        titleTextStyle: TextStyles.textStyle16w700(
                                                                          context,
                                                                        ).copyWith(
                                                                          color:
                                                                              AppColors.secondary,
                                                                        ),
                                                                        content: SingleChildScrollView(
                                                                          child: Column(
                                                                            children: [
                                                                              Image.asset(
                                                                                'assets/images/pic2.png',
                                                                              ),
                                                                              Container(
                                                                                decoration: BoxDecoration(
                                                                                  color: const Color(
                                                                                    0xFFFDF3D0,
                                                                                  ),
                                                                                  borderRadius: BorderRadius.circular(
                                                                                    15,
                                                                                  ),
                                                                                ),
                                                                                child: Column(
                                                                                  children: [
                                                                                    LessonsCubit.get(
                                                                                              context,
                                                                                            ).quiz ==
                                                                                            null
                                                                                        ? const Center(
                                                                                          child:
                                                                                              CircularProgressIndicator(),
                                                                                        )
                                                                                        : Padding(
                                                                                          padding: const EdgeInsets.all(
                                                                                            8.0,
                                                                                          ),
                                                                                          child: Text(
                                                                                            HtmlUnescape().convert(
                                                                                              LessonsCubit.get(
                                                                                                    context,
                                                                                                  ).quiz['quiz']['description']
                                                                                                  .replaceAll(
                                                                                                    RegExp(
                                                                                                      r'<style[^>]*>[\s\S]*?</style>',
                                                                                                      caseSensitive:
                                                                                                          false,
                                                                                                    ),
                                                                                                    '',
                                                                                                  )
                                                                                                  .replaceAll(
                                                                                                    RegExp(
                                                                                                      r'<[^>]+>',
                                                                                                    ),
                                                                                                    '',
                                                                                                  )
                                                                                                  .replaceAll(
                                                                                                    RegExp(
                                                                                                      r'\s+',
                                                                                                    ),
                                                                                                    ' ',
                                                                                                  )
                                                                                                  .trim(),
                                                                                            ),
                                                                                            style: TextStyles.textStyle16w700(
                                                                                              context,
                                                                                            ).copyWith(
                                                                                              color:
                                                                                                  AppColors.secondary,
                                                                                            ),
                                                                                            textDirection:
                                                                                                TextDirection.rtl,
                                                                                            textAlign:
                                                                                                TextAlign.right,
                                                                                          ),
                                                                                        ),

                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                        actions: [
                                                                          Padding(
                                                                            padding: const EdgeInsets.symmetric(
                                                                              horizontal:
                                                                              16.0,
                                                                              vertical:
                                                                              16,
                                                                            ),
                                                                            child: Container(
                                                                              decoration: BoxDecoration(
                                                                                color:
                                                                                AppColors.primaryColor,
                                                                                borderRadius: BorderRadius.circular(
                                                                                  25,
                                                                                ),
                                                                              ),
                                                                              width:
                                                                              double.infinity,
                                                                              height:
                                                                              44,
                                                                              child: MaterialButton(
                                                                                onPressed: () async {
                                                                                  await LessonsCubit.get(
                                                                                    context,
                                                                                  ).startQuiz(
                                                                                    quizId:
                                                                                    LessonsCubit.get(
                                                                                      context,
                                                                                    ).classData['quiz_id'],
                                                                                  );
                                                                                  Navigator.pop(
                                                                                    context,
                                                                                  );
                                                                                  Navigator.pushAndRemoveUntil(
                                                                                    context,
                                                                                    CupertinoPageRoute(
                                                                                      builder:
                                                                                          (
                                                                                          context,
                                                                                          ) => LessonsExamView(
                                                                                        quizID:
                                                                                        LessonsCubit.get(
                                                                                          context,
                                                                                        ).classData['quiz_id'],
                                                                                      ),
                                                                                    ),
                                                                                        (
                                                                                        route,
                                                                                        ) =>
                                                                                    false,
                                                                                  );
                                                                                },
                                                                                child: Container(
                                                                                  width:
                                                                                  double.infinity,
                                                                                  decoration: BoxDecoration(
                                                                                    color:
                                                                                    AppColors.primaryColor,
                                                                                  ),
                                                                                  child: Center(
                                                                                    child: Text(
                                                                                      'ابدا الامتحان',
                                                                                      style: TextStyles.textStyle16w700(
                                                                                        context,
                                                                                      ).copyWith(
                                                                                        color:
                                                                                        Colors.white,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                            );
                                                          },

                                                          child: Container(
                                                            width:
                                                                double.infinity,
                                                            height: 50,
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  AppColors
                                                                      .primaryColor,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    25,
                                                                  ),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                'الانتقال للامتحان',
                                                                style: TextStyle(
                                                                  color:
                                                                      Colors
                                                                          .white,
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        InkWell(
                                                          onTap: () {
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                              border: Border.all(
                                                                color:
                                                                    AppColors
                                                                        .primaryColor,
                                                                width: 2,
                                                              ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    25,
                                                                  ),
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                            width:
                                                                double.infinity,
                                                            height: 50,
                                                            child: Center(
                                                              child: Text(
                                                                'الغاء',
                                                                style: TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                          );
                                          return;
                                        }
                                        // If neither is required, navigate as usual
                                        setState(() {
                                          LessonsCubit.get(context)
                                              .isLessonLoading = false;
                                        });
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder:
                                                (context) => LessonVideoScreen(
                                                  videoIndex:
                                                      LessonsCubit.get(
                                                        context,
                                                      ).classData['id'],
                                                ),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'الدخول للحصة',
                                        style: TextStyles.textStyle16w700(
                                          context,
                                        ).copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/*
* showDialog(
                                        context: context,
                                        builder:
                                            (context) => AlertDialog(
                                              backgroundColor:
                                                  AppColors.secondary8,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              content: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: IconButton(
                                                      icon: const Icon(
                                                        Icons.close,
                                                        color: Colors.red,
                                                      ),
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            context,
                                                          ),
                                                    ),
                                                  ),
                                                  const Text(
                                                    'يرجى إدخال الكود للدخول للحصة',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 16,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Image.asset(
                                                    'assets/images/Frame1.png',
                                                    height: 150,
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Text(
                                                    ' يجب عليك حل الامتحان الاول حتى تتمكن من الدخول للحصة',
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        TextStyles.textStyle12w400(
                                                          context,
                                                        ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          AppColors
                                                              .primaryColor,
                                                      minimumSize: const Size(
                                                        double.infinity,
                                                        45,
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              10,
                                                            ),
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      // Navigator.push(
                                                      //   context,
                                                      //   CupertinoPageRoute(
                                                      //     builder:
                                                      //         (context) =>
                                                      //             ExamView(
                                                      //               //quizId: 1,
                                                      //             ),
                                                      //   ),
                                                      // );
                                                    },
                                                    child: Text(
                                                      'ابدأ ياللا',
                                                      style:
                                                          TextStyles.textStyle16w700(
                                                            context,
                                                          ).copyWith(
                                                            color: Colors.white,
                                                          ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                      );*/

/*
*                             Padding(
                              padding: const EdgeInsets.symmetric(vertical:  10.0),
                              child: Row(
                                spacing: 10,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(color: AppColors.secondary70,borderRadius: BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal:  8.0,vertical: 5),
                                      child: Text('الترم الاول',style: TextStyles.textStyle14w700(context),),
                                    ),
                                  ),

                                  Container(
                                    decoration: BoxDecoration(color: AppColors.secondary70,borderRadius: BorderRadius.circular(10)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal:  8.0,vertical: 5),
                                      child: Text('الوحدة الاولى',style: TextStyles.textStyle14w700(context),),
                                    ),
                                  ),
                                ],
                              ),
                            ),

* */
