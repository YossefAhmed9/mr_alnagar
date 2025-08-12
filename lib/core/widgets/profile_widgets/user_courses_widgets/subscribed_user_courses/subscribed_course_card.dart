import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../features/courses_view/videos_view/videos_view.dart';
import '../../../../cubits/courses_cubit/courses_cubit.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/text_styles.dart';

class SubscribedCourseCard extends StatelessWidget {
  final Map course;

  const SubscribedCourseCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
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
                child: CachedNetworkImage(
                  imageUrl: course['image'] ?? '',
                  height: 130.h,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Image.asset(
                    'assets/images/error image.png',
                    height: 130.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/error image.png',
                    height: 130.h,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              ),

              // Course name
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                child: Text(
                  course['title'] ?? 'اسم الكورس',
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
                    Icon(Icons.access_time_filled_rounded, size: 16.sp, color: Colors.grey),
                    Text(
                      '${course['count_video'] ?? 0} فيديو',
                      style: TextStyles.textStyle14w400(context).copyWith(color: Colors.grey),
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
                    Text(
                      course['price'].toString().contains('Free') ? 'مجاناً' : '${course['price']} جنيه',
                      style: TextStyles.textStyle18w700(context).copyWith(color: AppColors.secondary),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 12.r,
                        backgroundColor: AppColors.primaryColor,
                        child: const Icon(Icons.arrow_forward, size: 22, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
    );
  }
}
