import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_state.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/features/courses_view/course_reservation_screen.dart';

class CourseReservationItem extends StatelessWidget {
  final String courseName;
  final VoidCallback? onTap;

  const CourseReservationItem({
    Key? key,
    this.courseName = 'شهر يناير',
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoursesCubit, CoursesState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
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
                      spacing: 50.w,
                      children: [
                        Image.asset('assets/images/elnagar.png'),
                        Text(
                          courseName,
                          style: TextStyles.textStyle20w700(context),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, bottom: 20),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.grey.shade200),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
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
                              'اشتراك شهر يناير',
                              style: TextStyles.textStyle18w700(context),
                            ),
                            Spacer(),
                            Text(
                              '8 حصص',
                              style: TextStyles.textStyle16w400(
                                context,
                              ).copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            color: Colors.grey.shade400,
                            width: double.infinity,
                            height: 2,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            children: [
                              Text(
                                '200 جنيه',
                                style: TextStyles.textStyle20w700(
                                  context,
                                ).copyWith(color: Colors.red),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    height: 45.h,
                                    child: MaterialButton(
                                      onPressed:
                                      onTap ??
                                              () {
                                            // Navigator.push(
                                            //   context,
                                            //   CupertinoPageRoute(
                                            //     builder:
                                            //         (context) =>
                                            //             CourseReservationScreen(),
                                            //   ),
                                            // );
                                          },
                                      child: Text(
                                        'احجز الان',
                                        style: TextStyles.textStyle16w700(
                                          context,
                                        ).copyWith(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
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
    );
  }
}


/*
*                     Padding(
                      padding: const EdgeInsets.symmetric(vertical:  10.0),
                      child: Row(
                        spacing: 10,
                        children: [
                          Container(
                            decoration: BoxDecoration(color: AppColors.secondary70,borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal:  8.0,vertical: 5),
                              child: Text('الصف الاول الثانوي',style: TextStyles.textStyle14w700(context),),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(color: AppColors.secondary70,borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal:  8.0,vertical: 5),
                              child: Text('الترم الاول',style: TextStyles.textStyle14w700(context),),
                            ),
                          ),
                        ],
                      ),
                    ),
*/