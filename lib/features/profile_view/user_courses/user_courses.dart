import 'package:flutter/material.dart';
import 'package:mr_alnagar/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:mr_alnagar/core/widgets/profile_widgets/user_courses_widgets/done_user_courses/done_user_courses_tab_view.dart';
import 'package:mr_alnagar/core/widgets/profile_widgets/user_courses_widgets/subscribed_user_courses/subscribed_user_courses_tabView.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/text_styles.dart';

class UserCourses extends StatefulWidget {
  const UserCourses({Key? key}) : super(key: key);



  @override
  State<UserCourses> createState() => _UserCoursesState();

}

class _UserCoursesState extends State<UserCourses> {
  @override
   void initState() {
    // TODO: implement initState
    super.initState();
    //FocusScope.of(context).unfocus();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
         body: Directionality(
           textDirection: TextDirection.rtl,
           child: SafeArea(
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
                         Tab(text: 'كمل الكورس'),

                         Tab(text: 'المنجزة'),
                       ],
                       labelStyle: TextStyles.textStyle16w700(context),
                       labelColor: Colors.white,
                       unselectedLabelColor: Colors.black87,
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
                   Expanded(
                     child: TabBarView(
                       children: [
                         SubscribedUserCoursesTabView(inProgressCourses:
                         ProfileCubit.get(context).inProgressCourses,),
                         
                         DoneUserCoursesTabView(completedCourses:
                         ProfileCubit.get(context).completedCourses
                           ,),
                       ],
                     ),
                   ),
                 ],
               ),
             ),
           ),
         ),
       );


  }
}
