import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:mr_alnagar/core/cubits/home_cubit/home_cubit.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';

class FAQSection extends StatefulWidget {
  const FAQSection({super.key});

  @override
  State<FAQSection> createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection> {
  int? _expandedTileIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade200),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header section with images
            Container(
              width: double.infinity,
              decoration: BoxDecoration(),
              child: Image.network(
                HomeCubit.get(context).faqQuestion['image_url'],
                fit: BoxFit.cover,
                height: 140.h,
              ),
            ),
            SizedBox(height: 16.h),

            // FAQ Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  Text(
                    HomeCubit.get(context).faqQuestion['label'],
                    style: TextStyles.textStyle16w700(
                      context,
                    ).copyWith(color: AppColors.primaryColor),
                  ),

                  Text(
                    maxLines: 20,
                    HtmlUnescape()
                        .convert(
                          '${HomeCubit.get(context).faqQuestion['description']}',
                        )
                        .replaceAll(RegExp(r'<[^>]*>'), ''),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w200,
                      color: Colors.black,
                      height: 2,
                    ),
                  ),
                  // // First main question
                  // _buildFAQTile(
                  //   question: 'إزاي أعمل حساب على المنصة؟',
                  //   answer:
                  //       'ادخل على صفحة التسجيل، واكتب بياناتك الأساسية زي الاسم ورقم الموبايل والبريد، وهتوصلك رسالة تأكيد.',
                  //   index: -1,
                  // ),

                  // Dynamic questions from HomeCubit
                  ...List.generate(
                    HomeCubit.get(context).commonQuestion.length,
                    (index) {
                      final item = HomeCubit.get(context).commonQuestion[index];
                      return _buildFAQTile(
                        question: item['question']!,
                        answer: item['answer']!,
                        index: index,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQTile({
    required String question,
    required String answer,
    required int index,
  }) {
    final isExpanded = _expandedTileIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: isExpanded ? AppColors.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isExpanded ? AppColors.primaryColor : Colors.grey.shade300,
            width: 1,
          ),
        ),
        child: ExpansionTile(
          title: Text(
            question,
            style: TextStyles.textStyle16w700(
              context,
            ).copyWith(color: isExpanded ? Colors.white : Colors.black),
            textAlign: TextAlign.right,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isExpanded ? Colors.white : AppColors.primaryColor,
            ),
            child: Icon(
              isExpanded ? Icons.arrow_upward : Icons.arrow_downward,
              color: isExpanded ? AppColors.primaryColor : Colors.white,
            ),
          ),
          initiallyExpanded: isExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              _expandedTileIndex = expanded ? index : null;
            });
          },
          children: [
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Text(
                answer,
                style: TextStyles.textStyle16w700(
                  context,
                ).copyWith(color: isExpanded ? Colors.white : Colors.black87),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
