import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:mr_alnagar/core/cubits/home_cubit/home_cubit.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/core/widgets/Home%20widgets/google_maps_container.dart';
import 'package:solar_icons/solar_icons.dart';

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Heading
              Text(
                'معاك خطوة بخطوة لحد ما تحقق أعلى درجاتك في الإنجليزي!',
                style: TextStyles.textStyle16w700(context),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),

              // Map preview
              SizedBox(height: 16.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'شارع التليفونات',
                    style: TextStyles.textStyle16w700(context),
                  ),
                  SizedBox(width: 6.w),
                  Icon(Icons.location_on, color: Colors.blue),
                ],
              ),

              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child:
                    HomeCubit.get(context).contactUsData == null
                        ? Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        )
                        : GoogleMapContainer(
                          googleMapUrl:
                              HomeCubit.get(
                                context,
                              ).contactUsData["google_map_url"],
                        ),
              ),
              SizedBox(height: 24.h),

              // Address with location icon

              // Contact Info (Phone and Email)
              HomeCubit.get(context).contactUsData == null
                  ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primaryColor,
                    ),
                  )
                  : Row(
                    spacing: 7,
                    children: [
                      // Phone
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6FAFA),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Icon(
                                SolarIconsBold.phone,
                                color: AppColors.primaryColor,
                                size: 50,
                              ),
                              Text(
                                'رقم الهاتف',
                                style: TextStyles.textStyle16w700(context),
                              ),
                              Text(
                                '${HomeCubit.get(context).contactUsData["phone_number"]}',
                                style: TextStyles.textStyle14w400(
                                  context,
                                ).copyWith(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Email
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(12.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6FAFA),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Column(
                            spacing: 10,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                TablerIcons.mail_filled,
                                color: AppColors.primaryColor,
                                size: 50,
                              ),
                              Text(
                                'البريد الالكتروني',
                                style: TextStyles.textStyle16w700(context),
                              ),
                              Text(
                                '${HomeCubit.get(context).contactUsData["email"]}',
                                style: TextStyles.textStyle14w400(
                                  context,
                                ).copyWith(color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
            ],
          ),
        );
      },
    );
  }
}
