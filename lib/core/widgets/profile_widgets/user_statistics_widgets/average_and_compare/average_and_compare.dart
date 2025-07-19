import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/text_styles.dart';

class AverageAndCompare extends StatelessWidget {
  final Map<String, dynamic> performanceData;

  const AverageAndCompare({
    Key? key,
    this.performanceData = const {
      'student_average_score': 0,
      'overall_average_score_in_courses': 0,
      'performance_percentage': null,
    },
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        spacing: 10,
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondary8,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'متوسط درجاتك',
                            style: TextStyles.textStyle12w700(context),
                          ),
                          Spacer(),
                          Icon(
                            FontAwesomeIcons.clockRotateLeft,
                            color: AppColors.secondary,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        'متوسط درجاتك: ${performanceData['student_average_score']?.toStringAsFixed(2) ?? '0'}',
                        style: TextStyles.textStyle12w400(context),
                      ),
                    ),
                    Text(
                      'المتوسط العام للدورات: ${performanceData['overall_average_score_in_courses']?.toStringAsFixed(2) ?? '0'}',
                      style: TextStyles.textStyle12w400(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.secondary8,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Text(
                            'ادائك مقارنة بزملائك',
                            style: TextStyles.textStyle12w700(context),
                          ),
                          Spacer(),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Icon(
                              FontAwesomeIcons.chartLine,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        performanceData['performance_percentage'] != null
                            ? 'انت أعلى من ${performanceData['performance_percentage']?.toStringAsFixed(0)}% من باقي الطلاب'
                            : 'لا توجد بيانات للمقارنة',
                        style: TextStyles.textStyle12w400(context),
                      ),
                    ),
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
