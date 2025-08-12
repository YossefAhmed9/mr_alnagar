import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_cubit.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_state.dart';
import 'package:mr_alnagar/features/lessons_view/videos_view/one_time_lessons_videos_view.dart';
import 'package:mr_alnagar/features/lessons_view/videos_view/videos_view.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';



class OneTimeLessonCard extends StatefulWidget {
  const OneTimeLessonCard({
    super.key,
    required this.data,
  });

  final Map<String, dynamic> data; // Pass the single lesson data

  @override
  State<OneTimeLessonCard> createState() => _OneTimeLessonCardState();
}

class _OneTimeLessonCardState extends State<OneTimeLessonCard> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            // Lesson Image
            Container(
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Image.network(
                widget.data['image'],
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),

            // Lesson Info
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
              child: Column(
                children: [
                  // Date Row
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      spacing: 5,
                      children: [
                        const Icon(
                          FeatherIcons.calendar,
                          size: 20,
                          color: Colors.black,
                        ),
                        Text(
                          widget.data['started_at'],
                          style: TextStyles.textStyle14w400(context).copyWith(
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Title
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.data['title'],
                          style: TextStyles.textStyle16w700(context)
                              .copyWith(color: Colors.black),
                        ),
                      ),
                    ],
                  ),

                  // Divider
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Container(
                      color: Colors.grey.shade400,
                      width: double.infinity,
                      height: 2,
                    ),
                  ),

                  // Button
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    height: 45.h,
                    width: double.infinity,
                    child: MaterialButton(
                      onPressed: () {
                        _showCodeDialog(context);
                      },
                      child: Text(
                        'الدخول للحصة',
                        style: TextStyles.textStyle20w700(context)
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCodeDialog(BuildContext context) {
    final codeController = LessonsCubit.get(context).codeController;

    showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Form(
          key: formKey,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.lightBlue,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header Row
                    Row(
                      children: [
                        Text(
                          "برجاء ادخال الكود للدخول للحصة",
                          style: TextStyles.textStyle12w700(context)
                              .copyWith(color: Colors.black),
                        ),
                        const Spacer(),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          height: 40,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.red,
                              size: 25,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white, height: 1, thickness: 4),
                    const SizedBox(height: 10),

                    Image.asset(
                      'assets/images/lock.png',
                      height: 150,
                    ),
                    const SizedBox(height: 16),
                    const Text("برجاء إدخال الكود", style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 12),

                    // Code Field
                    TextFormField(
                      controller: codeController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: '',
                      ),
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        final trimmed = value?.trim() ?? '';
                        if (trimmed.isEmpty) return 'برجاء ادخال الكود';
                        if (trimmed.length < 4) return 'Code must be at least 4 characters';
                        if (trimmed.length > 10) return 'Code cannot be longer than 10 characters';
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await LessonsCubit.get(context).oneTimeLessonAccessClass(
                              code: codeController.text,
                              classID: widget.data['id'],
                              context: context,
                            );
                            codeController.clear();
                          }
                        },
                        child: Text(
                          "ابدا ياللا",
                          style: TextStyles.textStyle16w700(context)
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
