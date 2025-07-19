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
              child: Image.network(HomeCubit.get(context).homeData['image_url'])
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
