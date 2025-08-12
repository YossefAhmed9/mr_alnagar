import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mr_alnagar/core/cubits/books_cubit/books_cubit.dart';
import 'package:mr_alnagar/core/cubits/books_cubit/books_state.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/main.dart';
import '../../core/cubits/lessons_cubit/lessons_cubit.dart';
import '../../core/widgets/Courses widgets/books_tab_bar_view.dart';
import '../../core/widgets/Courses widgets/courses_tab_bar_view.dart';
import '../../../core/utils/app_loaders.dart';

class CoursesView extends StatefulWidget {
  const CoursesView({Key? key}) : super(key: key);

  @override
  State<CoursesView> createState() => _CoursesViewState();
}

class _CoursesViewState extends State<CoursesView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BooksCubit, BooksState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: SafeArea(
            child: InternetAwareWrapper(
              onInternetRestored: [
                
              ],
              child: DefaultTabController(
                animationDuration: Duration(milliseconds: 400),
                length: 2,
                initialIndex: 0,
                child: Column(
                  children: [
                    Container(
                      height: 70,
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: TabBar(
                        tabs: [
                          Tab(text: 'الكورسات'),

                          Tab(text: 'الكتب'),
                        ],
                        labelStyle: TextStyles.textStyle16w700(context),
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.black87,

                        indicatorAnimation: TabIndicatorAnimation.elastic,
                        indicator: BoxDecoration(
                          color: AppColors.primaryColor, // Deep blue
                          borderRadius: BorderRadius.circular(20),
                        ),
                        indicatorSize: TabBarIndicatorSize.tab,
                        dividerColor: Colors.transparent,
                      ),
                    ),
                    SizedBox(height: 20),
                    // Optional: TabBarView for switching content
                    BooksCubit.get(context).books.isEmpty ? Center(child: AppLoaderInkDrop(color: AppColors.primaryColor,),) :

                    Expanded(
                      child: TabBarView(
                        children: [
                          const CoursesTabBarView().animate().fade(duration: 1000.ms),
                          const BooksTabBarView(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
