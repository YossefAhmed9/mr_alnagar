import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/books_cubit/books_cubit.dart';
import 'package:mr_alnagar/features/courses_view/book_reservation_screen.dart';
import 'package:mr_alnagar/features/courses_view/course_reservation_screen.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookCard extends StatefulWidget {
  const BookCard({super.key, required this.index});
  final int index;

  @override
  State<BookCard> createState() => _BookCardState();
}

class _BookCardState extends State<BookCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()async{
        setState(() {
          BooksCubit.get(context).changeIsBookLoading();

        });
        await BooksCubit.get(context).getBookByID(id: BooksCubit.get(context).books[widget.index]['id']);
        Navigator.push(context, CupertinoPageRoute(builder: (context){
          return BookReservationScreen(data: BooksCubit.get(context).book);
        }));
        setState(() {
          BooksCubit.get(context).changeIsBookLoading();

        });

      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          width: 250.w,
          height: 290,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.r,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Book image
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                child: CachedNetworkImage(
                  imageUrl: BooksCubit.get(context).books[widget.index]['image'],
                  height: 135.h,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Image.asset(
                    'assets/images/error image.png',
                    width: 50.w,
                    height: 50.h,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/error image.png',
                    width: 50.w,
                    height: 50.h,
                  ),
                )
              ),
              // Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                child: Text(
                  BooksCubit.get(context).books[widget.index]['title'],
                  style: TextStyles.textStyle14w400(
                    context,
                  ).copyWith(color: Colors.black),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),

              // Divider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(height: 3, color: Colors.grey.shade200),
              ),
              Spacer(),

              // Price & icon
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        '${BooksCubit.get(context).books[widget.index]['price']} جنيه',
                        style: TextStyles.textStyle18w700(
                          context,
                        ).copyWith(color: AppColors.secondary),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        radius: 12.r,
                        backgroundColor: AppColors.primaryColor,
                        child: const Icon(
                          Icons.arrow_forward,
                          size: 22,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
