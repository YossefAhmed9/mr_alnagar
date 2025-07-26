import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_state.dart';
import 'package:mr_alnagar/features/courses_view/course_reservation_screen.dart';

import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';

class CourseCard extends StatelessWidget {
  const CourseCard({super.key, required this.data, required this.index});
  final data;
  final int index;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoursesCubit, CoursesState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0,vertical: 15),
      child: InkWell(
        splashColor: AppColors.primaryColor,
        onTap: ()async{
          CoursesCubit.get(context).changeIsCourseLoading();
          await CoursesCubit.get(context).getCourseByID(id: data['id']);
          Navigator.push(context, CupertinoPageRoute(builder: (context){
            return CourseReservationScreen(
              data:data
            );
          }));
          CoursesCubit.get(context).changeIsCourseLoading();

        },
        child: Container(
          // width: 240.w,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.r,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Course image
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                child: Image.network(
                  data['image'], // Replace with your actual course image
                  height: 130.h,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Image.asset(
                      'assets/images/error image.png',fit: BoxFit.fill,height: 130,width: double.infinity,
                    );
                  },
                ),
              ),

              // Course name
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: Text(
                  data['title'] ?? '',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Course duration
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  spacing: 3,
                  children: [
                    Icon(
                      Icons.access_time_filled_rounded,
                      size: 16.sp,
                      color: Colors.grey,
                    ),

                    Text(
                      '${data['started_at']} ساعة',
                      style: TextStyles.textStyle14w400(
                        context,
                      ).copyWith(color: Colors.grey),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(height: 3, color: Colors.grey.shade200),
              ),

              // Price and icon
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if ((data['discount_percentage'] ?? 0) > 0) ...[
                      Row(
                        children: [
                          Text(
                            '${data['original_price']} جنيه',
                            style: TextStyles.textStyle16w400(context).copyWith(
                              color: Colors.grey,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            '${data['price']} جنيه',
                            style: TextStyles.textStyle18w700(
                              context,
                            ).copyWith(color: AppColors.secondary),
                          ),
                        ],
                      ),
                    ] else ...[
                      Text(
                        '${data['price']} جنيه',
                        style: TextStyles.textStyle18w700(
                          context,
                        ).copyWith(color: AppColors.secondary),
                      ),
                    ],
                    // CoursesCubit.get(context).isCourseLoading ?
                    //     CircularProgressIndicator(color: AppColors.primaryColor,)
                    //     :
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 12.r,
                        backgroundColor: AppColors.primaryColor,
                        child: const Icon(
                          Icons.arrow_forward,
                          size: 22,
                          color: Colors.white,
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
    );
  },
);
  }
}
