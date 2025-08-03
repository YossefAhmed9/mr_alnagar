import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

abstract class TextStyles {
  static TextStyle textStyle12w700(context) => TextStyle(
    fontSize: 12 ,
    fontWeight: FontWeight.w700,
    fontFamily: 'cairo',
  );
  static TextStyle textStyle12w400(context) => TextStyle(
    fontSize: 12 ,
    fontWeight: FontWeight.w400,
    fontFamily: 'cairo',
  );

  static TextStyle textStyle18w700(context) => TextStyle(
    fontSize: 18 ,
    fontWeight: FontWeight.w700,
    fontFamily: 'cairo',
  );
  static TextStyle textStyle18w400(context) => TextStyle(
    fontSize: 18 ,
    fontWeight: FontWeight.w400,
    fontFamily: 'cairo',
  );

  static TextStyle textStyle20w700(context) => TextStyle(
    fontSize: 20 ,
    fontWeight: FontWeight.w700,
    fontFamily: 'cairo',
  );

  static TextStyle textStyle14w700(context) => TextStyle(
    color: Colors.white,
    fontSize: 14 ,
    fontWeight: FontWeight.w700,
    fontFamily: 'cairo',
  );
  static TextStyle textStyle14w400(context) => TextStyle(
    color: Colors.white60,
    fontSize: 14 ,
    fontWeight: FontWeight.w400,
    fontFamily: 'cairo',
    overflow: TextOverflow.ellipsis,
  );

  static TextStyle textStyle16w700(context) => TextStyle(
    fontSize: 16 ,
    fontWeight: FontWeight.w700,
    fontFamily: 'cairo',
  );

  static TextStyle textStyle16w400(context) => TextStyle(
    fontSize: 17 ,
    fontWeight: FontWeight.w400,
    fontFamily: 'cairo',
  );
  //
  // static TextStyle textStyle22Bold(context) =>
  //     const TextStyle(
  //         fontSize:22,
  //         fontWeight: FontWeight.bold,        fontFamily: 'cairo'
  //
  //     );
  //
  // static TextStyle textStyle25(context) =>
  //     const TextStyle(
  //         fontSize: 25,
  //         fontWeight: FontWeight.bold,        fontFamily: 'cairo'
  //
  //     );
  //
  // static TextStyle textStyle28Bold(context) =>
  //     const TextStyle(
  //         fontSize: 28,
  //         fontWeight: FontWeight.bold,        fontFamily: 'cairo'
  //
  //     );
  //
  // static TextStyle textStyle30(context) =>
  //     const TextStyle(
  //         fontSize:30,
  //         fontWeight: FontWeight.w400,        fontFamily: 'cairo'
  //
  //     );
  //
  // static TextStyle textStyle35(context) =>
  //     const TextStyle(
  //         fontSize: 35,
  //         fontWeight: FontWeight.w700,        fontFamily: 'cairo'
  //
  //     );
  //
}

// double getResponsiveFontSize(context, {required double fontSize}) {
//   double scaleFactor = getScaleFactor(context);
//   double responsiveFontSize = fontSize * scaleFactor;
//   double lowerLimit = fontSize * .8;
//   double upperLimit = fontSize * 1.2;
//    print("base fontSize= $fontSize lower=$lowerLimit h =$upperLimit");
//   return responsiveFontSize.clamp(lowerLimit, upperLimit);
// }
//
// double getScaleFactor(context) {
//   double width = MediaQuery
//       .sizeOf(context)
//       .width;
//   if (width < SizeConfig.tablet) {
//     return width / 400;
//   } else if (width < SizeConfig.desktop) {
//     return width / 1000;
//   } else {
//     return width / 1920;
//   }
// }
