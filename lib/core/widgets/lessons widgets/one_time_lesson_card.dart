import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_cubit.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_state.dart';
import '../../utils/app_colors.dart';
import '../../utils/text_styles.dart';

class OneTimeLessonCard extends StatefulWidget {
  const OneTimeLessonCard({super.key, required this.data, required this.index});
  final data;
  final int index;

  @override
  State<OneTimeLessonCard> createState() => _OneTimeLessonCardState();
}

class _OneTimeLessonCardState extends State<OneTimeLessonCard> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LessonsCubit, LessonsState>(
      listener: (context, state) {

      },
      builder: (context, state) {
        TextEditingController codeController=TextEditingController();
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),

                    // image: DecorationImage(
                    //   image: AssetImage('assets/images/pattern 1.png'),
                    //   fit: BoxFit.fill,
                    // ),
                  ),
                  child: Image.network(
                    LessonsCubit.get(
                      context,
                    ).oneTimeClassesAll[widget.index]['image'],
                    fit: BoxFit.fill,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/error image.png',
                        fit: BoxFit.cover,
                        width: 100,
                        height: 150,
                      );
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 20,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 10.0,
                          ),
                          child: Row(
                            spacing: 5,
                            children: [
                              Icon(
                                FeatherIcons.calendar,
                                size: 20,
                                color: Colors.black,
                              ),
                              Text(
                                LessonsCubit.get(
                                  context,
                                ).oneTimeClassesAll[widget.index]['started_at'],
                                style: TextStyles.textStyle14w400(
                                  context,
                                ).copyWith(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              LessonsCubit.get(
                                context,
                              ).oneTimeClassesAll[widget.index]['title'],
                              style: TextStyles.textStyle16w700(
                                context,
                              ).copyWith(color: Colors.black),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 15.0,
                          ),
                          child: Container(
                            color: Colors.grey.shade400,
                            width: double.infinity,
                            height: 2,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          height: 45.h,
                          width: double.infinity,
                          child: MaterialButton(
                            onPressed: () async {

                              showDialog(
                                context: context,
                                builder:
                                    (context)
                                {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    child: Container(
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: AppColors.lightBlue, // Light background color
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 5.0),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                                    child: Container(
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
                                                        onPressed: () {
                                                          Navigator.pop(context);
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Text(
                                                    "برجاء ادخال الكود للدخول للحصة",
                                                    style: TextStyles.textStyle12w700(
                                                      context,
                                                    ).copyWith(color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Divider(color: Colors.white, height: 1, thickness: 4),
                                            const SizedBox(height: 10),
                                            Image.asset(
                                              'assets/images/lock.png', // Replace with your image path
                                              height: 150,
                                            ),
                                            const SizedBox(height: 16),
                                            const Text(
                                              "برجاء إدخال الكود",
                                              style: TextStyle(fontSize: 16),
                                            ),
                                            const SizedBox(height: 12),
                                            TextFormField(
                                              controller: codeController,
                                              decoration: const InputDecoration(border: OutlineInputBorder()),
                                              onChanged: (value){
                                                print(value);
                                              },
                                            ),
                                            const SizedBox(height: 20),
                                            Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(25),
                                              ),
                                              width: double.infinity,
                                              child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: AppColors.primaryColor,
                                                ),
                                                onPressed: () async{
                                                 LessonsCubit.get(context).oneTimeLessonAccessClass(
                                                   classID: widget.data['id'],
                                                   code: codeController.text,
                                                 );
                                                },
                                                child: Text(
                                                  "ابدا ياللا",
                                                  style: TextStyles.textStyle16w700(
                                                    context,
                                                  ).copyWith(color: Colors.white),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                              );
                            },
                            child: Text(
                              'الدخول للحصة',
                              style: TextStyles.textStyle20w700(
                                context,
                              ).copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
