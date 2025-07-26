import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_cubit.dart';
import 'package:mr_alnagar/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/features/courses_view/homework_view/homework_result.dart';

class HomeWorkResults extends StatelessWidget {
  const HomeWorkResults({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();
    return ProfileCubit.get(context).homeWorksResultsForProfile.isEmpty ?
        Center(child: CircularProgressIndicator(),)

     : Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Scrollbar(
            thumbVisibility: true,
            radius: Radius.circular(40),
            interactive: true,
            thickness: 10,
            controller: controller,
            child: SingleChildScrollView(
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
                                    style: TextStyles.textStyle14w700(
                                      context,
                                    ).copyWith(color: Colors.black),
                                  ),
                                ),
                                Expanded(
                                  child: Text(
                                    'الواجب',
                                    style: TextStyles.textStyle14w700(
                                      context,
                                    ).copyWith(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ListView.separated(
                          controller: controller,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: ProfileCubit.get(context).homeWorksResultsForProfile.length,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: Text(overflow: TextOverflow.ellipsis,
                                      maxLines: 5,
                                      ProfileCubit.get(context).homeWorksResultsForProfile[index]['course_title'],
                                      style: TextStyles.textStyle14w400(
                                        context,
                                      ).copyWith(color: Colors.black,overflow: TextOverflow.ellipsis),
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                  onTap:()async{
                                    await CoursesCubit.get(context).getHomeWorkResult(attemptID: ProfileCubit.get(context).homeWorksResultsForProfile[index]['attempt_id']);
                                    Navigator.push(context, CupertinoPageRoute(builder: (context)=>HomeworkResultView(attemptID: ProfileCubit.get(context).homeWorksResultsForProfile[index]['attempt_id'],)), );
                                  },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: AppColors.primaryColor,
                                            width: 2,
                                          ),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'عرض الواجب',
                                              style: TextStyles.textStyle14w700(
                                                context,
                                              ).copyWith(
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Icon(
                                              Icons
                                                  .keyboard_double_arrow_left_outlined,
                                              color: AppColors.primaryColor,
                                              size: 25,
                                            ),
                                          ],
                                        ),
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
  }
}
