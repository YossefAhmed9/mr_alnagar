import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/widgets/Courses%20widgets/book_card.dart';

import '../../cubits/books_cubit/books_cubit.dart';
import '../../cubits/courses_cubit/courses_cubit.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';

class BooksTabBarView extends StatelessWidget {
  const BooksTabBarView({Key? key, }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ScrollController controller=ScrollController();

    return  RefreshIndicator(
      onRefresh: (){
        return BooksCubit.get(context).getAllBooks();
      },
      child: Padding(
        padding: const EdgeInsets.only(left:  5.0),
        child: Scrollbar(
          controller: controller,
          thumbVisibility: true,
          radius: Radius.circular(40),
          interactive: true,
          thickness: 10,
          child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: BooksCubit.get(context).books.length,
              controller: controller,
              shrinkWrap: true,
              itemBuilder: (context,index){
                return  Padding(
                  padding: const EdgeInsets.only(left:  8.0),
                  child: BookCard(index: index,),
                );

              }),
        ),
      ),
    );

  }
}
