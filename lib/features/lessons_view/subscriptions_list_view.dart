import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/features/courses_view/quiz_view/exam_view.dart';

import '../../core/utils/app_colors.dart';
import '../../core/utils/text_styles.dart';

class SubscriptionsListView extends StatelessWidget {
  const SubscriptionsListView({Key? key}) : super(key: key);

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
          'اشتراك شهر يناير',
          style: TextStyles.textStyle16w700(context),
        ),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,

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
              itemCount: 10,
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
                          decoration: BoxDecoration(
                            color: AppColors.lightBlue,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                            image: DecorationImage(
                              image: AssetImage('assets/images/pattern 1.png'),
                              fit: BoxFit.fill,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              children: [
                                Image.asset('assets/images/elnagar.png'),
                                Text(
                                  'Vocabulary & Reading',
                                  style: TextStyles.textStyle18w700(context),
                                ),
                              ],
                            ),
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
                                        '20 ابريل 2025',
                                        style: TextStyles.textStyle14w400(
                                          context,
                                        ).copyWith(color: Colors.grey.shade700),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'الحصة الاولى',
                                      style: TextStyles.textStyle16w400(
                                        context,
                                      ).copyWith(color: Colors.grey),
                                    ),
                                    Spacer(),
                                    Text(
                                      'Vocabulary & Reading',
                                      style: TextStyles.textStyle18w700(
                                        context,
                                      ),
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
                                    onPressed: () {
                                      showDialog(
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
    );
  }
}

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
