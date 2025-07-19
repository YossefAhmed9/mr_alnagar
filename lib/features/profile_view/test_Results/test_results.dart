import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mr_alnagar/core/cubits/quiz_results_cubit/quiz_results_cubit.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/text_styles.dart';

class TestResults extends StatelessWidget {
  const TestResults({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    return BlocConsumer<QuizResultsCubit, QuizResultsState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: SafeArea(
              child: Scrollbar(
                thumbVisibility: true,
                radius: Radius.circular(40),
                interactive: true,
                thickness: 10,
                controller: controller,
                child:
                QuizResultsCubit.get(context).quizResults.isEmpty
                    ? Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                  controller: controller,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.secondary30,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 15.0,
                                  horizontal: 5,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'الدرس',
                                        style:
                                        TextStyles.textStyle14w700(
                                          context,
                                        ).copyWith(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        'الدرجة',
                                        style:
                                        TextStyles.textStyle14w700(
                                          context,
                                        ).copyWith(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ListView.separated(
                              controller: controller,
                              physics:
                              const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: QuizResultsCubit.get(context).quizResults.length,
                              separatorBuilder: (context, index) {
                                return const Divider(
                                  color: Colors.grey,
                                  thickness: 1,
                                );
                              },
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          QuizResultsCubit.get(context)
                                              .quizResults[index]['quiz_title']
                                              .toString(),
                                          style:
                                          TextStyles.textStyle14w400(
                                            context,
                                          ).copyWith(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          '${QuizResultsCubit.get(context).quizResults[index]['score'].toString()}',
                                          style:
                                          TextStyles.textStyle16w700(
                                            context,
                                          ).copyWith(
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}