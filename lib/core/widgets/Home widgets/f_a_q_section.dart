import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/home_cubit/home_cubit.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';

class FAQSection extends StatefulWidget {
  const FAQSection({super.key});

  @override
  State<FAQSection> createState() => _FAQSectionState();
}

class _FAQSectionState extends State<FAQSection> {
  bool _isMainExpanded = true;
  bool _isSubExpanded = false;
  int? _expandedSubTileIndex;



  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.grey.shade200,),
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Header section with images
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/Group2.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: Image.asset('assets/images/nagar.png', height: 140.h),
            ),
            SizedBox(height: 16.h),

            // FAQ Section
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: ExpansionTile(
                showTrailingIcon: false,
                initiallyExpanded: _isMainExpanded,
                onExpansionChanged: (expanded) {
                  setState(() => _isMainExpanded = expanded);
                },
                title: Container(
                  height: 50,
                  width: 300,
                  decoration: BoxDecoration(color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(

                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'إزاي أعمل حساب على المنصة؟',
                          style: TextStyles.textStyle16w700(context)
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                            radius: 15,
                            backgroundColor:  Colors.white,
                            child:_isMainExpanded ?
                            Icon(Icons.arrow_upward,color:AppColors.primaryColor)
                                : Icon(Icons.arrow_downward,color:AppColors.primaryColor) ),
                      ),

                    ],
                  ),
                ),

                children: [
                  // Main answer
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 8.h,
                    ),
                    child: Text(
                      'ادخل على صفحة التسجيل، واكتب بياناتك الأساسية زي الاسم ورقم الموبايل والبريد، وهتوصلك رسالة تأكيد.',
                      textAlign: TextAlign.right,
                      style: TextStyles.textStyle16w400(context)
                          .copyWith(color: Colors.black87),
                    ),
                  ),

                  // Sub FAQs
                  Column(
                    children: List.generate(HomeCubit.get(context).commonQuestion.length, (index) {
                      final item = HomeCubit.get(context).commonQuestion[index];
                      final isExpanded = _expandedSubTileIndex == index;

                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade300,
                                width: 0.5,
                              ),
                            ),
                          ),
                          child: ExpansionTile(
                            showTrailingIcon: false,
                            title: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    item['question']!,
                                    style: TextStyles.textStyle16w700(context),
                                    textAlign: TextAlign.right,
                                    maxLines: 9,overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Container(
                                  decoration: BoxDecoration( border:Border.all(color: AppColors.primaryColor,width: 1),borderRadius: BorderRadius.circular(50)),
                                  child: CircleAvatar(
                                      radius: 13,
                                      backgroundColor:  Colors.white,
                                      child:isExpanded ?
                                      Icon(Icons.arrow_upward,color:AppColors.primaryColor)
                                          : Icon(Icons.arrow_downward,color:AppColors.primaryColor,) ),
                                ),
                              ],
                            ),
                            initiallyExpanded: isExpanded,enableFeedback: true,
                            expansionAnimationStyle: AnimationStyle(curve: Curves.easeInOutExpo,duration: Duration(milliseconds: 400)),
                            onExpansionChanged: (expanded) {
                              setState(() {
                                _expandedSubTileIndex =
                                expanded ? index : null;
                              });
                            },
                            tilePadding: EdgeInsets.symmetric(horizontal: 16.w),
                            children: [
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.all(16.w),
                                child: Text(
                                  item['answer']!,
                                  style: TextStyles.textStyle16w700(context)
                                      .copyWith(color: Colors.black87),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
