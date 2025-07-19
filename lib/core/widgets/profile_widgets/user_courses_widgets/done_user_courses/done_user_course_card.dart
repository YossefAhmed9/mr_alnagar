import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';

class DoneUserCourseCard extends StatelessWidget {
  final Map course;

  const DoneUserCourseCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              child: Image.network(
                course['image'] ?? '',
                height: 130.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset('assets/images/error image.png', height: 130.h, fit: BoxFit.cover);
                },
              ),
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

            // Certificate Button
            if (course['certificate_url'] != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  width: double.infinity,
                  height: 50,
                  child: MaterialButton(
                    onPressed: () {
                      // TODO: open certificate URL in browser or WebView
                      print('Certificate URL: ${course['certificate_url']}');
                    },
                    child: Text(
                      'اظهر الشهادة',
                      style: TextStyles.textStyle16w700(context).copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
