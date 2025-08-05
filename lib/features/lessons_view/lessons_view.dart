import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_cubit.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';
import 'package:mr_alnagar/core/widgets/lessons%20widgets/lessons_reservation_tab_bar.dart';
import 'package:mr_alnagar/core/widgets/lessons%20widgets/lessons_subscribtion_tab_bar.dart';
import 'package:mr_alnagar/core/widgets/lessons%20widgets/one_time_lessons_tab_bar.dart';
import '../../core/cubits/lessons_cubit/lessons_state.dart';
import '../../core/utils/app_colors.dart';
import '../../core/utils/text_styles.dart';

class LessonsView extends StatelessWidget {
  final List courses;
  final List classes;
  const LessonsView({
    super.key,
    this.courses = const [],
    this.classes = const [],
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LessonsCubit, LessonsState>(
      listener: (context, state) {
        // Handle state changes if necessary
      },
      builder: (context, state) {
        // Build the UI based on the state

        return RefreshIndicator(
          onRefresh:()async {
            await LessonsCubit.get(context).getCoursesByCategory(categoryID: CacheHelper.getData(key: CacheKeys.categoryId));
            return await LessonsCubit.get(context).getMyLessons(categoryID: CacheHelper.getData(key: CacheKeys.categoryId));
          },
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SafeArea(
              child: ModalProgressHUD(
                inAsyncCall: LessonsCubit.get(context).isLessonLoading,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: DefaultTabController(
                    animationDuration: Duration(milliseconds: 400),
                    length: 3,
                    initialIndex: 0,
                    child: Column(
                      children: [
                        Container(
                          // height: 70,
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: TabBar(
                            tabAlignment: TabAlignment.start,
                            onTap: (int index) async{
                               LessonsCubit.get(context).getAllOneTimeClasses();
                                await LessonsCubit.get(context).getCoursesByCategory(categoryID: CacheHelper.getData(key: CacheKeys.categoryId));
                                 await LessonsCubit.get(context).getMyLessons(categoryID: CacheHelper.getData(key: CacheKeys.categoryId));

                              LessonsCubit.get(
                                context,
                              ).changeTabBarIndex(index: index);
                            },
                            tabs: [
                              Tab(text: 'احجز الان'),
                              Tab(text: 'اشتراكاتي'),
                              Tab(text: 'حصص المرة الواحدة'),
                            ],
                            labelStyle: TextStyles.textStyle16w700(context),
                            labelPadding: EdgeInsets.symmetric(horizontal: 35),
                            labelColor: Colors.white,
                            indicatorAnimation: TabIndicatorAnimation.elastic,
                            unselectedLabelColor: AppColors.primaryColor,
                            isScrollable: true,
                            automaticIndicatorColorAdjustment: true,

                            indicator: BoxDecoration(
                              color: AppColors.primaryColor, // Deep blue
                              borderRadius: BorderRadius.circular(25),
                            ),
                            indicatorSize: TabBarIndicatorSize.tab,
                            dividerColor: Colors.transparent,
                            enableFeedback: true,
                          ),
                        ),
                        //SizedBox(height: 20),
                        // Optional: TabBarView for switching content
                        Expanded(
                          child: TabBarView(
                            children: [
                              LessonsReservationTabBar(
                                lessons: LessonsCubit.get(context).otherLessons,
                              ),
                              LessonsSubscribtionTabBar(),
                              OneTimeLessonsTabBar(lessons: LessonsCubit.get(context).oneTimeClassesAll)
                            ],
                          ),
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
