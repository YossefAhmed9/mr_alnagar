import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mr_alnagar/features/home_screen/home_layout.dart';

import '../core/utils/app_colors.dart';
import '../core/utils/text_styles.dart';
import 'home_screen/home_page.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Stack(
                children: [
                  Image.asset('assets/images/error BG.png'),
                  Center(child: Image.asset('assets/images/error.png')),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text('هذه الصفحة غير متوفرة',style: TextStyles.textStyle16w700(context),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal:  16.0),
              child: Container(
                decoration: BoxDecoration(color: AppColors.primaryColor,borderRadius: BorderRadius.circular(25)),
                width: double.infinity,
                height: 50,
                child: MaterialButton(

                  onPressed: (){
                    Navigator.pushAndRemoveUntil(context,
                      CupertinoPageRoute(builder: (context)=>HomeLayout()),

                       (route) {
                          return false;
                        },);
                  },
                  child: Text('الذهاب الى الصفحة الرئيسية',style: TextStyles.textStyle16w700(context).copyWith(color: Colors.white),),

                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
