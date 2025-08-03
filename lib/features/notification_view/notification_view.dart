import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/utils/app_colors.dart';
import '../../core/utils/text_styles.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    List notifications = [];

    ScrollController scrollController = ScrollController();
    return Padding(
      padding: const EdgeInsets.only(left: 5.0),
      child: SafeArea(
        child:
            notifications.isEmpty
                ? Center(
                  child: Column(
                    spacing: 20,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/notification.png'),
                      Text(
                        'لا توجد اشعارات حتى الان',
                        style: TextStyle(
                          color: AppColors.primaryColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                )
                : Scrollbar(
                  controller: scrollController,
                  thumbVisibility: true,
                  radius: Radius.circular(40),
                  interactive: true,
                  thickness: 10,

                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: 10,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          width: double.infinity,
                          height: 80.h,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: CircleAvatar(
                                  radius: 20.r,
                                  backgroundColor: AppColors.secondary,
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 30.sp,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'الدرس جاهز',
                                          style: TextStyles.textStyle16w700(
                                            context,
                                          ),
                                        ),
                                        Spacer(),
                                        Text(
                                          '${DateTime.now().hour.toInt() - 12}:${DateTime.now().minute}',
                                          style: TextStyles.textStyle12w400(
                                            context,
                                          ).copyWith(
                                            color: Colors.grey.shade600,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CircleAvatar(
                                            radius: 4.r,
                                            backgroundColor:
                                                AppColors.primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'محتوى الاشعار',
                                      style: TextStyles.textStyle14w400(
                                        context,
                                      ).copyWith(color: Colors.black),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
      ),
    );
  }
}
