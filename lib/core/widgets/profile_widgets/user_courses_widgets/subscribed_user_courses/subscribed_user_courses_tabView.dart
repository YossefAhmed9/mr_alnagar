import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_state.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_cubit.dart';
import 'package:mr_alnagar/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:mr_alnagar/core/widgets/profile_widgets/user_courses_widgets/subscribed_user_courses/subscribed_course_card.dart';
import 'package:mr_alnagar/features/lessons_view/subscriptions_list_view.dart';

import '../../../../../features/courses_view/videos_view/videos_view.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/text_styles.dart';

class SubscribedUserCoursesTabView extends StatefulWidget {
  final List inProgressCourses;

  const SubscribedUserCoursesTabView(
      {Key? key, required this.inProgressCourses}) : super(key: key);

  @override
  State<SubscribedUserCoursesTabView> createState() => _SubscribedUserCoursesTabViewState();
}

class _SubscribedUserCoursesTabViewState extends State<SubscribedUserCoursesTabView> {
  bool isLoading=false;
  @override
  Widget build(BuildContext context) {
    ScrollController controller = ScrollController();

    return BlocConsumer<CoursesCubit, CoursesState>(
      listener: (context, state) {
        // TODO: implement listener
        //state is
      },
      builder: (context, state) {

        if(ProfileCubit.get(context).inProgressCourses.isEmpty){
          return RefreshIndicator(
            onRefresh: (){
              return ProfileCubit.get(context).getMyInProgressCourses();
            },
            child: Center(
              child: Text('No Courses available'),
            ),
          );
        }
        if (widget.inProgressCourses.isNotEmpty) {
          return RefreshIndicator(
            onRefresh: (){
              return ProfileCubit.get(context).getMyInProgressCourses();
            },
            child: ModalProgressHUD(
             inAsyncCall: isLoading,
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Scrollbar(
                  controller: controller,
                  thumbVisibility: true,
                  radius: Radius.circular(40),
                  interactive: true,
                  thickness: 10,
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: widget.inProgressCourses.length,
                    controller: controller,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      final course = widget.inProgressCourses[index];
                      return Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child:

                            InkWell(
                              onTap: ()async{
                               if (course['is_class']==0) {
                                 setState(() {
                                   isLoading=true;
                                 });
                                 await CoursesCubit.get(context).getVideosByCourse(id: course['id'],context: context);
                                 await CoursesCubit.get(context).getCourseByID(id: course['id']);

                                 Navigator.push(
                                   context,
                                   CupertinoPageRoute(
                                     builder: (context) => CourseVideoScreen(videoIndex: course['id']),
                                   ),);
                                 setState(() {
                                   isLoading=false;
                                 });
                               }
                               if (course['is_class']==1) {
                                 setState(() {
                                   isLoading=true;
                                 });
                                 //await LessonsCubit.get(context).getCourseByID(id: course['id']);
                                 await LessonsCubit.get(context).getUserLessons(id: course['id']);
                                 //await LessonsCubit.get(context).getClassDataByID(classId: course['id'],context: context);
                                // print(course['id']);
                                 Navigator.push(
                                   context,
                                   CupertinoPageRoute(
                                     builder: (context) => SubscriptionsListView(),
                                   ),);
                                 setState(() {
                                   isLoading=false;
                                 });
                               }
                              },
                              child: SubscribedCourseCard(
                                  course: course),
                            ), // make sure your card accepts data
                          ),
                          Positioned(
                            top: 20,
                            left: 20,
                            child: Container(
                              width: 120.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Center(
                                child: Text(
                                  'تم الاشتراك',
                                  style: TextStyles.textStyle16w700(context).copyWith(
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        }
        else{
          return Center(child: CircularProgressIndicator(),);
        }

      },
    );
  }
}
