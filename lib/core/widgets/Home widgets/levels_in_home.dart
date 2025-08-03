import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/home_cubit/home_cubit.dart';

import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';

class LevelsInHome extends StatelessWidget {
  const LevelsInHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var data=HomeCubit.get(context).home['categories'];
    return Column(


      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text('الصفوف الدراسية',style: TextStyles.textStyle16w700(context).copyWith(color: AppColors.primaryColor),),
        ),
        Container(
          width:double.infinity,
          height: 950,
          child: ListView.builder(
              itemCount: 3,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context,index){
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: InkWell(
                splashColor: AppColors.primaryColor,
                onTap: ()async{
                  HomeCubit.get(context).changeBottomNavBarIndex(index: 1);
                },
                child:Container(
                  // width: 240.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
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
                      // Course image
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
                        child: Image.network(
                          data[index]['image'], // Replace with your actual course image
                          height: 150.h,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Image.asset(
                              'assets/images/error image.png',fit: BoxFit.fill,height: 130,width: double.infinity,
                            );
                          },
                        ),
                      ),

                      // Course name
                      Center(
                        child: Padding(
                          padding: EdgeInsets.only(right: 8.w,left:8.w, top: 30.h,bottom:15),
                          child: Column(
                            spacing: 10,
                            children: [
                              Text(
                                data[index]['name'],
                                style: TextStyles.textStyle16w700(context).copyWith(color: AppColors.primaryColor),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Container(decoration: BoxDecoration(color: Colors.grey),width:double.infinity,height: 1,),
                              Text.rich(
                                TextSpan(


                                  children: [
                                    TextSpan(
                                      text: 'عدد الكورسات ',
                                      style: TextStyles.textStyle16w700(context)
                                          .copyWith(color: AppColors.primaryColor),
                                    ),

                                    TextSpan(
                                      text: '${data[index]['count_of_courses']}',
                                      style: TextStyles.textStyle16w700(context).copyWith(
                                        color: AppColors.secondary,
                                        fontSize: 25,
                                      ),
                                    ),
                                  ],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )


                            ],
                          ),
                        ),
                      ),






                    ],
                  ),
                ),

              ),

            );
          }),
        ),
      ],
    );
  }
}
