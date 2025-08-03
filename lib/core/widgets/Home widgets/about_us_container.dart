import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:html_unescape/html_unescape.dart';

import '../../cubits/home_cubit/home_cubit.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';

class AboutUsContainer extends StatelessWidget {
  const AboutUsContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Container(
              alignment: AlignmentDirectional.center,
              decoration: BoxDecoration(
                color: AppColors.secondary8,
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: CachedNetworkImage(
                imageUrl: HomeCubit.get(context).homeData['image_url'],
                placeholder: (context, url) =>  Container(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
                height: 200,
                width: double.infinity,
              )

          ),
        ),
        Text(
          HtmlUnescape().convert(HomeCubit.get(context).homeData['description'] ?? '')
              .replaceAll(RegExp(r'<[^>]*>'), ''),
          style: TextStyles.textStyle12w400(context).copyWith(
            color: AppColors.primaryColor,
            fontSize: 17,
            height: 2,
          ),
        )

      ],
    );
  }
}
