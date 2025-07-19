import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:mr_alnagar/core/cubits/home_cubit/home_cubit.dart';

import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';

class AboutUsRecords extends StatelessWidget {
  const AboutUsRecords({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        spacing: 8,
        children: [
          Expanded(child: Container(
            width: 164,
            height: 100.h,
            decoration: BoxDecoration(color: AppColors.secondary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${HomeCubit.get(context).homeData['experince_year']}",style: TextStyles.textStyle16w700(context).copyWith(fontSize: 24,color: Colors.white),),
                  Spacer(),
                  Text('عاما من الخبرة',style: TextStyles.textStyle18w400(context).copyWith(color: Colors.white),),
                ],
              ),
            ),
          ),
          ),
          Expanded(child: Container(
            width: 164,
            height: 100.h,
            decoration: BoxDecoration(color: AppColors.secondary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(HtmlUnescape().convert("${HomeCubit.get(context).homeData['lecture_count']}"),style: TextStyles.textStyle16w700(context).copyWith(fontSize: 24,color: Colors.white),),
                  Spacer(),
                  Text('عدد المحاضرات',style: TextStyles.textStyle18w400(context).copyWith(color: Colors.white),),
                ],
              ),
            ),
          ),
          ),

        ],
      ),
    );
  }
}
