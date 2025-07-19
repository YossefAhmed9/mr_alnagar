import 'package:flutter/material.dart';
import 'package:mr_alnagar/core/widgets/profile_widgets/user_statistics_widgets/best_and_worst_grade.dart';
import 'package:mr_alnagar/core/widgets/profile_widgets/user_statistics_widgets/total_pass_percentage_container.dart';
import 'package:mr_alnagar/core/widgets/profile_widgets/user_statistics_widgets/user_chart.dart';
import 'package:mr_alnagar/features/profile_view/profile_view.dart';

import '../../../core/cubits/profile_cubit/profile_cubit.dart';
import '../../../core/widgets/profile_widgets/user_statistics_widgets/average_and_compare/average_and_compare.dart';

class UserStatistics extends StatelessWidget {
  const UserStatistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TotalPassPercentageContainer(
                passedExams: ProfileCubit.get(context).successRate['success_quizzes'],
                totalExams: ProfileCubit.get(context).successRate['total_quizzes']),
             BestAndWorstGrade(
              highestScore: ProfileCubit.get(context).highestScore,
               lowestScore: ProfileCubit.get(context).lowestScore,
            ),
             UserChart(chartData: ProfileCubit.get(context).chartData,),

             AverageAndCompare(
              performanceData: ProfileCubit.get(context).performanceComparison,
            ),
          ],
        ),
      ),
    );
  }
}
