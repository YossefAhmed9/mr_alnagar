import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/text_styles.dart';

class OnBoardingModel {
  final String title;
  final Widget body;
  final String image;

  OnBoardingModel({
    required this.title,
    required this.body,
    required this.image,
  });
}

Widget onBoardBuildingItem(OnBoardingModel model, BuildContext context) =>
    Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(height: 50),
        Center(
          child: Image.asset(
            'assets/images/logo light.png',
            height: 100,
            width: 180,
            fit: BoxFit.fitWidth,
          ),
        ),
        Expanded(
          child: Image(
            image: AssetImage('${model.image}'),
            width: 343,
            height: 304,
          ),
        ),

        //title
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            textAlign: TextAlign.center,

            '${model.title}',
            style: TextStyles.textStyle20w700(context),
          ),
        ),

        //body
        SizedBox(child: model.body),
      ],
    );
