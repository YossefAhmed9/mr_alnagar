import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mr_alnagar/core/widgets/Courses%20widgets/book_card.dart';
import '../../cubits/books_cubit/books_cubit.dart';

class BooksTabBarView extends StatefulWidget {
  const BooksTabBarView({Key? key, }) : super(key: key);

  @override
  State<BooksTabBarView> createState() => _BooksTabBarViewState();
}

class _BooksTabBarViewState extends State<BooksTabBarView> {
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
