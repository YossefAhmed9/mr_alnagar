import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_cubit.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/core/widgets/lessons%20widgets/one_time_lesson_card.dart';

import '../../cubits/auth_cubit/auth_cubit/auth_cubit.dart';
import '../../cubits/lessons_cubit/lessons_state.dart';
import '../../network/local/cashe_keys.dart';
import '../../network/local/shared_prefrence.dart';


class OneTimeLessonsTabBar extends StatefulWidget {
  const OneTimeLessonsTabBar({
    Key? key,
    required this.lessons,
    required this.physics,

  }) : super(key: key);

  final dynamic lessons; // Strong type for clarity
  final ScrollPhysics physics;

  @override
  State<OneTimeLessonsTabBar> createState() => _OneTimeLessonsTabBarState();
}

class _OneTimeLessonsTabBarState extends State<OneTimeLessonsTabBar> {
  int? categoryID; // nullable for "All"
  int? levelID; // nullable for "All"
  //List filteredLessons = [];

  @override
  void initState() {
    super.initState();
    categoryID = null; // start with All
    levelID = null; // start with All
   // filteredLessons = List.from(widget.lessons);
  }

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<LessonsCubit, LessonsState>(
  builder: (context, state) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: SafeArea(
          child: widget.lessons.isEmpty
              ? const Center(child: Text('لا توجد بيانات'))
              : Column(
            mainAxisSize: MainAxisSize.min,
                children: [
                  LessonsCubit.get(context).isOneTimeLessonShowAll
                      ?
                  Container(
                    height: 130,
                    child: Column(
                      spacing: 10,
                      children: [
                        // Category dropdown
                        Directionality(
                          textDirection: TextDirection.rtl,

                          child: Expanded(

                            child: DropdownButtonFormField<String>(icon: Icon(Icons.keyboard_arrow_down),
                                value: categoryID?.toString(),
                                style: TextStyles.textStyle12w400(context).copyWith(
                                  overflow: TextOverflow.ellipsis,
                                  color: Colors.white,
                                ),
                                dropdownColor: AppColors.primaryColor,itemHeight: 70,isDense: true,
                                iconSize: 30,
                                iconEnabledColor: Colors.white,
                                hint: const Text(
                                  'الصف الدراسي',
                                  style: TextStyle(color: Colors.white, fontSize: 20),
                                ),
                                decoration: _dropdownDecoration('الصف الدراسي'),
                                items: [
                                  const DropdownMenuItem<String>(
                                    value: null,
                                    child: Align(
                                      alignment: AlignmentDirectional.centerEnd,
                                      child: Text(
                                        textAlign: TextAlign.center,
                                        'كل الصفوف',
                                        style: TextStyle(color: Colors.white,fontSize: 20,),
                                      ),
                                    ),
                                  ),
                                  ...AuthCubit.get(context)
                                      .levelsForAuthCategories
                                      .map<DropdownMenuItem<String>>((level) {
                                    return DropdownMenuItem<String>(
                                      alignment: AlignmentDirectional.centerEnd,
                                      value: level['id'].toString(),
                                      child: Text(
                                        level['name'].toString(),
                                        style:
                                        TextStyles.textStyle18w700(context).copyWith(
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    categoryID = int.tryParse(value ?? '');
                                  });
                                  LessonsCubit.get(context).getLessonsListForOneTimeClasses(category_id: categoryID!);
                                  LessonsCubit.get(context).getFilterationAllOneTimeClasses(
                                    categoryID: categoryID == -1 ? null : categoryID,
                                    courseID: levelID == -1 ? null : levelID,
                                  );
                                }

                            ),
                          ),
                        ),



                        // Lesson dropdown
                        Directionality(
                          textDirection: TextDirection.rtl,

                          child: Expanded(

                            child: DropdownButtonFormField<String>(icon: Icon(Icons.keyboard_arrow_down),
                                value: levelID?.toString(),
                                dropdownColor: AppColors.primaryColor,
                                iconEnabledColor: Colors.white,
                                //style: TextStyles.textStyle14w700(context).copyWith(color: Colors.white),
                                decoration: _dropdownDecoration('الحصة'),
                                items: [
                                  const DropdownMenuItem<String>(
                                    value: null,alignment: AlignmentDirectional.centerEnd,
                                    child: Text(
                                      'كل الحصص',
                                      style: TextStyle(color: Colors.white,fontSize: 20),
                                    ),
                                  ),
                                  ...LessonsCubit.get(context).lessonsListForOneTimeClasses.map<DropdownMenuItem<String>>((lesson) {
                                    return DropdownMenuItem<String>(alignment: AlignmentDirectional.topEnd,
                                      value: lesson['id'].toString(),
                                      child: SizedBox(
                                        //width: MediaQuery.sizeOf(context).width * 0.3,
                                        child: Text(
                                          lesson['title'].toString(),

                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyles.textStyle18w700(context).copyWith(
                                            fontSize: 20,
                                            color: Colors.white,
                                          ), // match category style
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    levelID = int.tryParse(value ?? '');
                                  });
                                  LessonsCubit.get(context).getFilterationAllOneTimeClasses(
                                    categoryID: categoryID == -1 ? null : categoryID,
                                    courseID: levelID == -1 ? null : levelID,
                                  );
                                }

                            ),
                          ),
                        ),
                      ],
                    ),
                  ) : Container(),

                  Expanded(
                    child: ListView.builder(
                                itemCount: LessonsCubit.get(context).oneTimeLessonFiltered.length,
                                physics: widget.physics,
                                itemBuilder: (context, index) {
                    final course = LessonsCubit.get(context).oneTimeLessonFiltered[index];
                    return Stack(
                      children: [
                        OneTimeLessonCard(data: course),
                        if (course['has_live'] == true)
                          Positioned(
                            top: 15,
                            left: 8,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(25),
                              ),
                              height: 50,
                              width: 120,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.signal_cellular_alt_outlined,
                                    color: Colors.white,
                                  ),
                                  Text(
                                    'Live Now',
                                    style:
                                    TextStyles.textStyle14w700(context),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                                },
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

  Future<void> _refreshLessons() async {
    await LessonsCubit.get(context).getCoursesByCategory(
      categoryID: CacheHelper.getData(key: CacheKeys.categoryId),
    );
    await LessonsCubit.get(context).getMyLessons(
      categoryID: CacheHelper.getData(key: CacheKeys.categoryId),
    );
  }

  InputDecoration _dropdownDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: EdgeInsets.only(top: 0,bottom: 20, right: 20,left: 20), // Control padding

      hintStyle: const TextStyle(color: Colors.white, fontSize: 12),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      filled: true,
      fillColor: AppColors.primaryColor,
    );
  }
}
