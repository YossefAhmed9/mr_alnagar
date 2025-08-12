import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/home_cubit/home_cubit.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/utils/app_loaders.dart';

class LeaderBoard extends StatefulWidget {
  const LeaderBoard({Key? key, required this.categoryID}) : super(key: key);
  final categoryID;
  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard> {
  @override
  void initState() {
    // TODO: implement initState
    HomeCubit.get(context).getLeaderBoard(categoryID: widget.categoryID);
  }

  Widget buildNetworkImage(String url) {
    final lowerUrl = url.toLowerCase();

    if (lowerUrl.endsWith('.svg')) {
      return SvgPicture.network(
        url,
        placeholderBuilder:
            (context) => Center(child: AppLoaderInkDrop()),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading image: $error');
          return Image.asset(
            'assets/images/error image.png',
            fit: BoxFit.cover,
          );
        },
      );
    } else {
      return Image.network(
        url,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          print('Error loading image: $error');
          return Image.asset(
            'assets/images/error image.png',
            fit: BoxFit.cover,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final topStudents = HomeCubit.get(context).topStudents;

    return topStudents.isEmpty
        ? Center(child: Container())
        : Container(

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColors.lightBlue,
          ),
          width: double.infinity,
          height:250,
          child: ListView.builder(
            physics:const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: topStudents.length,
            itemBuilder: (context, index) {
              final student = topStudents[index];
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      spacing: 8,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.transparent,
                          child: ClipOval(
                            child: AspectRatio(
                              aspectRatio: 1, // Forces a 1:1 ratio
                              child: buildNetworkImage(student['image']),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            student['name'] ?? '',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyles.textStyle16w400(context),
                          ),
                        ),

                        Text(
                          '${student['average_score']} / ${student['full_score']}',
                          style: TextStyles.textStyle18w700(context),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
  }
}
