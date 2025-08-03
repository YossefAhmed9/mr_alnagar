import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mr_alnagar/core/cubits/auth_cubit/auth_cubit/auth_cubit.dart';
import 'package:mr_alnagar/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/features/profile_view/profile_view.dart';
import 'package:solar_icons/solar_icons.dart';

import '../../../core/utils/app_colors.dart';
import '../homework_results/home_work_results.dart';

class ProfileLayout extends StatelessWidget {
  const ProfileLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ProfileCubit, ProfileState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    final GlobalKey<ScaffoldState> profilScaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(

      key: profilScaffoldKey,
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              InkWell(
                  onTap: (){
                    ProfileCubit.get(context).ChangeProfileView(index: 0);
                    //scaffoldKey.currentState!.closeDrawer();
                   // Navigator.push(context, CupertinoPageRoute(builder: (context)=>ProfileView()));
                  },
                  child: Row(spacing: 5,children: [Icon(FontAwesomeIcons.solidCircleUser,color: AppColors.secondary,size: 30,),Text('الملف الشخصي',style: TextStyles.textStyle16w400(context),),Spacer(),IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios,color: AppColors.primaryColor,))],)),
              InkWell(

                  onTap: (){
                    ProfileCubit.get(context).ChangeProfileView(index: 1);

                    //Navigator.push(context, CupertinoPageRoute(builder: (context)=>HomeWorkResults()));
                  },
                  child: Row(spacing: 5,children: [Icon(FontAwesomeIcons.filePen,color: AppColors.secondary,size: 30,),Text('نتائج الواجب',style: TextStyles.textStyle16w400(context),),Spacer(),IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios,color: AppColors.primaryColor,))],)),
              InkWell(
                  onTap: (){
                    ProfileCubit.get(context).ChangeProfileView(index: 2);
                  },
                  child: Row(spacing: 5,children: [Icon(Icons.add,color: AppColors.secondary,size: 30,),Text('نتائج الامتحانات',style: TextStyles.textStyle16w400(context),),Spacer(),IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios,color: AppColors.primaryColor,))],)),
              InkWell(
                  onTap: (){
                    ProfileCubit.get(context).ChangeProfileView(index: 3);

                  },
                  child: Row(spacing: 5,children: [Icon(Icons.add,color: AppColors.secondary,size: 30,),Text('الكورسات ',style: TextStyles.textStyle16w400(context),),Spacer(),IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios,color: AppColors.primaryColor,))],)),
              InkWell(
                  onTap: (){
                    ProfileCubit.get(context).ChangeProfileView(index: 4);
                  },
                  child: Row(spacing: 5,children: [Icon(Icons.area_chart_sharp,color: AppColors.secondary,size: 30,),Text('احصائياتك',style: TextStyles.textStyle16w400(context),),Spacer(),IconButton(onPressed: (){}, icon: Icon(Icons.arrow_forward_ios,color: AppColors.primaryColor,))],)),
            ],
          ),
        ),

      ),
      
      appBar: AppBar(
        title:  Text(
          ProfileCubit.get(context).titles[ProfileCubit.get(context).currentIndex],
          style: TextStyles.textStyle16w700(context),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,

        leading: Padding(
          padding: const EdgeInsets.only(right:  10.0,bottom: 5),
          child: Material(

            borderRadius: BorderRadius.circular(10),
            color: Colors.white,
            elevation: 3,
            child:  IconButton(onPressed: (){
              profilScaffoldKey.currentState!.openDrawer();

            },icon: Icon( Icons.menu,color: AppColors.primaryColor,size: 30.sp,)),
          ),
        ),
      ),
      body: ProfileCubit.get(context).profileViews[ProfileCubit.get(context).currentIndex],
    );
  },
);
  }
}
