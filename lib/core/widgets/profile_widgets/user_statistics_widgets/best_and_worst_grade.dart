import 'package:flutter/material.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';

class BestAndWorstGrade extends StatelessWidget {
  final Map<String, dynamic> highestScore;
  final Map<String, dynamic> lowestScore;

  const BestAndWorstGrade({
    Key? key,
    this.highestScore = const {'quiz_title': null, 'score': null},
    this.lowestScore = const {'quiz_title': null, 'score': null},
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
                            'اعلى درجة',
                            style: TextStyles.textStyle16w700(context),
                          ),
                          Spacer(),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Icon(
                              Icons.trending_up,
                              color: AppColors.secondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        highestScore['quiz_title'] != null &&
                                highestScore['score'] != null
                            ? '${highestScore['score']} في ${highestScore['quiz_title']}'
                            : 'لا توجد نتائج',
                        style: TextStyles.textStyle12w400(context),
                      ),
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
                            'اضعف نتيجة',
                            style: TextStyles.textStyle16w700(context),
                          ),
                          Spacer(),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Icon(Icons.trending_down, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Text(
                        lowestScore['quiz_title'] != null &&
                                lowestScore['score'] != null
                            ? '${lowestScore['score']} في امتحان ${lowestScore['quiz_title']}'
                            : 'لا توجد نتائج',
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
