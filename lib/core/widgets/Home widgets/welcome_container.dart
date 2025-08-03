import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/home_cubit/home_cubit.dart';
import 'package:mr_alnagar/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';

import '../../../features/profile_view/user_courses/user_courses.dart';
import 'custom_search_bar.dart';

class WelcomeContainer extends StatelessWidget {
  const WelcomeContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: AppColors.lightBlue,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
            child: Row(
              spacing: 12.w,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:  8.0),
                  child: InkWell(
                    onTap: (){
                      HomeCubit.get(context).changeBottomNavBarIndex(index: 3);
                    },
                    child:
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.transparent,
                      child: ClipOval(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: Image.network(
                          height: 150,width: 150,
                          fit:BoxFit.cover,
                          CacheHelper.getData(key: CacheKeys.image),
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/error image.png',
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   InkWell(
                     onTap: (){
                       HomeCubit.get(context).changeBottomNavBarIndex(index: 3);

                     },
                     child: Column(
                      crossAxisAlignment:CrossAxisAlignment.start,

                       children: [
                         Text('مرحبا',style: TextStyles.textStyle18w700(context),),
                         Text(CacheHelper.getData(key: CacheKeys.fullName),style: TextStyles.textStyle18w700(context),),


                       ],
                     ),
                   ),

                    Padding(
                      padding: const EdgeInsets.only(top:  15.0),
                      child: Container(
                        width: 120,
                        height: 35,
                        decoration: BoxDecoration(color: AppColors.primaryColor,borderRadius: BorderRadius.circular(15)),
                        child: TextButton(onPressed: (){
                          HomeCubit.get(context).changeBottomNavBarIndex(index: 3);
                          ProfileCubit.get(context).ChangeProfileView(index:3);
                        },
                            child: Text('كورساتي',
                          style: TextStyles.textStyle12w700(context).copyWith(color:Colors.white),)),
                      ),
                    )
                  ],
                ),
                Spacer(),

              ],
            ),
          ),

        ],
      ),
    );
  }
}
