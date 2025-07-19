import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/home_cubit/home_cubit.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';

class LeaderBoard extends StatelessWidget {
  const LeaderBoard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topStudents = HomeCubit.get(context).topStudents;

    return topStudents.isEmpty
        ? Center(
      child: CircularProgressIndicator(color: AppColors.primaryColor),
    )
        : Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.lightBlue,
      ),
      width: double.infinity,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: topStudents.length,
        itemBuilder: (context, index) {
          final student = topStudents[index];
          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  spacing: 8,
                  children: [
                    CircleAvatar(
                      child: Image.network(
                        student['image'],
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/error image.png',
                          );
                        },
                      ),
                    ),
                    Text(
                      student['name'],
                      style: TextStyles.textStyle16w400(context),
                    ),
                    Spacer(),
                    Text(
                      '${student['average_score']} / ${student['full_score']}',
                      style: TextStyles.textStyle18w700(context),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
