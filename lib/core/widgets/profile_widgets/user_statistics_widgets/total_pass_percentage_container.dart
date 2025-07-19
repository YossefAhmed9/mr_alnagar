import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/app_colors.dart';
import '../../../utils/text_styles.dart';

class TotalPassPercentageContainer extends StatelessWidget {
  final int passedExams;
  final int totalExams;

  const TotalPassPercentageContainer({
    super.key,
    required this.passedExams,
    required this.totalExams,
  });

  @override
  Widget build(BuildContext context) {
    final double successRatio =
        totalExams == 0 ? 0.0 : passedExams / totalExams;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary8,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'نسبة النجاح الكلية',
                style: TextStyles.textStyle16w700(context),
              ),
              Spacer(),
              Image.asset('assets/images/Icon.png', scale: 0.8),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'نجحت في $passedExams من $totalExams امتحانات',
            style: TextStyles.textStyle14w400(
              context,
            ).copyWith(color: Colors.black),
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: successRatio,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
