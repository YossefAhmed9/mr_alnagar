import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mr_alnagar/core/cubits/home_cubit/home_cubit.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import '../../../core/utils/app_loaders.dart';

import '../../core/widgets/Home widgets/about_us_records.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        final aboutUsData = HomeCubit.get(context).aboutUs;

        return Scaffold(
          backgroundColor: Colors.grey.shade200,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text(
              "نبذة عن مستر النجار",
              style: TextStyles.textStyle16w700(context),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back_ios_new),
              color: AppColors.primaryColor,
            ),
          ),
          body: aboutUsData == null
              ? Center(
            child: AppLoaderInkDrop(
              color: AppColors.primaryColor,
            ),
          )
              : SingleChildScrollView(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Align(
                            alignment: AlignmentDirectional.topStart,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'نبذه عن المستر',
                                style: TextStyles.textStyle16w700(context),
                              ),
                            ),
                          ),
                          Container(
                            width: 343,
                            height: 200,
                            decoration: BoxDecoration(
                              color: AppColors.secondary8,
                              borderRadius: BorderRadius.circular(20),

                            ),
                            child: CachedNetworkImage(
                              imageUrl: aboutUsData['ask_us']['image_url'],
                              placeholder: (context, url) => Image.asset('assets/images/error image.png'),
                              errorWidget: (context, url, error) => Image.asset('assets/images/error image.png'),
                            )
                            ,
                          ),
                          Text(
                              HtmlUnescape().convert('${aboutUsData['ask_us']['description']}')
                                  .replaceAll(RegExp(r'<[^>]*>'), ''),
                            style: TextStyles.textStyle16w400(context).copyWith(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const AboutUsRecords(),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              spacing: 5,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.asset('assets/images/noto-v1_eyes.png'),
                                Text(
                                  'رؤيتنا - بقلم مستر محمد النجار',
                                  style: TextStyles.textStyle16w700(context)
                                      .copyWith(color: AppColors.primaryColor),
                                ),
                              ],
                            ),
                            Text(
                              HtmlUnescape().convert(aboutUsData['our_mission'])
                                  .replaceAll(RegExp(r'<[^>]*>'), ''),
                              style: TextStyles.textStyle16w400(context).copyWith(height: 2),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 20,

                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.all(16.0),
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.start,
                  //     spacing: 5,
                  //     children: [
                  //       Icon(
                  //         TablerIcons.target_arrow,
                  //         color: AppColors.primaryColor,
                  //         size: 25,
                  //       ),
                  //       Text(
                  //         'اهدافنا',
                  //         style: TextStyles.textStyle16w700(context)
                  //             .copyWith(color: AppColors.primaryColor),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                  // ListView.builder(
                  //   physics: NeverScrollableScrollPhysics(),
                  //   shrinkWrap: true,
                  //   itemCount: goals.length,
                  //   itemBuilder: (context, index) {
                  //     return Padding(
                  //       padding: const EdgeInsets.all(8.0),
                  //       child: Row(
                  //         spacing: 5,
                  //         children: [
                  //           Icon(
                  //             Icons.check_circle,
                  //             color: AppColors.secondary,
                  //             size: 25,
                  //           ),
                  //           Flexible(
                  //             child: Text(
                  //                 HtmlUnescape().convert(aboutUsData['ask_us']['our_mission']),
                  //               style: TextStyles.textStyle16w400(context),
                  //               overflow: TextOverflow.ellipsis,
                  //               maxLines: 8,
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //     );
                  //   },
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      HtmlUnescape().convert(aboutUsData['our_vision'])
                          .replaceAll(RegExp(r'<[^>]*>'), ''),
                        style: TextStyles.textStyle16w400(context).copyWith(height: 2),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
