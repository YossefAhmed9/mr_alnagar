import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/books_cubit/books_cubit.dart';
import 'package:mr_alnagar/core/cubits/books_cubit/books_state.dart';
import 'package:mr_alnagar/core/cubits/home_cubit/home_cubit.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_cubit.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import '../../../core/utils/app_loaders.dart';

import '../../utils/text_styles.dart';
import '../Courses widgets/book_card.dart';

class ShowingBooksInHome extends StatelessWidget {
  const ShowingBooksInHome({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BooksCubit, BooksState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Section header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('الكتب', style: TextStyles.textStyle16w700(context)),
                    InkWell(
                      onTap: () {
                        HomeCubit.get(
                          context,
                        ).changeBottomNavBarIndex(index: 2);
                        LessonsCubit.get(context).changeTabBarIndex(index: 1);
                        print(HomeCubit.get(context).currentIndex);
                        print(LessonsCubit.get(context).tabBarIndex);
                      },
                      child: Text(
                        'عرض الكل',
                        style: TextStyles.textStyle16w700(
                          context,
                        ).copyWith(color: AppColors.secondary),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16.h),

                // Book cards list
                // SizedBox(
                //   height: 220.h,
                //   child: ListView.separated(
                //     separatorBuilder: (context,index){
                //       return SizedBox(width: 8.w,);
                //     },
                //     scrollDirection: Axis.horizontal,
                //     physics: ClampingScrollPhysics(),
                //     itemCount: 2,
                //     shrinkWrap: true,
                //     itemBuilder: (context, index) {
                //       return BookCard();
                //     },
                //   ),
                // ),
                BooksCubit.get(context).books.isEmpty
                    ? Center(
                      child: AppLoaderInkDrop(
                        color: AppColors.primaryColor,
                      ),
                    )
                    : SizedBox(
                      height: 260.h,
                      //width: 140.w,
                      child: ListView.separated(
                        separatorBuilder: (context, index) {
                          return SizedBox(width: 8.w);
                        },
                        scrollDirection: Axis.horizontal,
                        physics: ClampingScrollPhysics(),
                        itemCount: 2,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return BookCard(index: index);
                        },
                      ),
                    ),
              ],
            ),
          ),
        );
      },
    );
  }
}
