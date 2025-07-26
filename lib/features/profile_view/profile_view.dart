import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:mr_alnagar/core/cubits/auth_cubit/auth_cubit/auth_cubit.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_cubit.dart';
import 'package:mr_alnagar/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/features/courses_view/courses_view.dart';
import 'package:mr_alnagar/features/home_screen/about_us_view.dart';
import 'package:mr_alnagar/features/lessons_view/videos_view/videos_view.dart';
import 'package:mr_alnagar/features/notification_view/notification_view.dart';
import 'package:mr_alnagar/features/profile_view/user_statistics/user_statistics.dart';
import '../../core/cubits/home_cubit/home_cubit.dart';
import '../../core/network/remote/api_endPoints.dart';
import '../../core/network/remote/dio_helper.dart';
import '../../core/widgets/profile_widgets/email_pop_up_for_setting_password.dart';
import '../courses_view/homework_view/homework_result.dart';
import '../courses_view/homework_view/home_work_view.dart';
import '../courses_view/quiz_view/quiz_result.dart';
import '../courses_view/videos_view/videos_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final cubit = ProfileCubit.get(context);

    final emailController = TextEditingController(
      text: CacheHelper.getData(key: CacheKeys.email),
    );
    final phoneController = TextEditingController(
      text: CacheHelper.getData(key: CacheKeys.phone),
    );
    final dadJobController = TextEditingController(
      text: CacheHelper.getData(key: CacheKeys.parentJob),
    );
    final dadPhoneController = TextEditingController(
      text: CacheHelper.getData(key: CacheKeys.parentPhone),
    );

    final inputDecoration =
        (String hint) => InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          hintText: hint,
          hintStyle: TextStyles.textStyle16w700(
            context,
          ).copyWith(color: Colors.grey.shade400),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(8),
          ),
          filled: true,
          fillColor: const Color(0xFFF5F5F5),
        );

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
           // floatingActionButton: FloatingActionButton(onPressed: ()async{
           //   // await LessonsCubit.get(context).getVideosByClass(classId:
           //   // 6,);
           //  //print(CacheHelper.getData(key: CacheKeys.lastSectionIndex));
           //
           //  Navigator.push(context, CupertinoPageRoute(builder: (context)=>CoursesView()));
           //  Navigator.push(context, CupertinoPageRoute(builder: (context)=>AboutUsView()));
           //  Navigator.push(context, CupertinoPageRoute(builder: (context)=>UserStatistics()));
           //  Navigator.push(context, CupertinoPageRoute(builder: (context)=>NotificationView()));
           //
           //
           //   // print('%%%%%%%%%%%%%');
           //   // // await DioHelper.getData(
           //   // //   url: 'videos_by_classes/1',
           //   // //   token: CacheHelper.getData(key: CacheKeys.token),
           //   // // ).then((value){
           //   // //   print(value.data);
           //   // // });
           //   // await LessonsCubit.get(context).getVideosByClass(classId: 1);
           //   // print(LessonsCubit.get(context).videos);
           //   // print('%%%%%%%%%%%%%%%%%%%%');
           //
           //   //print(LessonsCubit.get(context).videos);
           // }),
            key: scaffoldKey,
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(

                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundColor: Colors.transparent,
                        child: ClipOval(
                          child: AspectRatio(
                            aspectRatio: 1, // Forces a 1:1 ratio
                            child: Image.network(
                              CacheHelper.getData(key: CacheKeys.image),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset('assets/images/error image.png', fit: BoxFit.cover);
                              },
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        height: 185,
                        width: 30,
                        child: InkWell(
                          onTap: () async {
                            if (!cubit.enabled) {
                              cubit.enableChanges(); // Only enable editing on first tap
                            } else {
                              await cubit.updateProfileInfo(
                                context: context,
                                email: emailController.text,
                                phone: phoneController.text,
                                categoryId: cubit.selectedLevelId,
                                image: cubit.selectedImage,
                                governmentId: cubit.selectedGovernmentId,
                                parentJob: dadJobController.text,
                                parentPhone: dadPhoneController.text,
                              ).then((value) {
                                print('from the profile view');
                                cubit.enableChanges(); // Toggle back to disabled
                              });
                            }
                          },

                          child: CircleAvatar(
                            backgroundColor: AppColors.primaryColor,
                            radius: 12,
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (final namePart in [
                        CacheHelper.getData(key: CacheKeys.firstName),
                        CacheHelper.getData(key: CacheKeys.middleName),
                        CacheHelper.getData(key: CacheKeys.lastName),
                      ])
                        Text(
                          "$namePart ",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          'البريد الإلكتروني',
                          emailController,
                          cubit.enabled,
                          inputDecoration('البريد الإلكتروني'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          'رقم الهاتف',
                          phoneController,
                          cubit.enabled,
                          inputDecoration('رقم الهاتف'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          'وظيفة ولي الأمر (اختياري)',
                          dadJobController,
                          cubit.enabled,
                          inputDecoration('وظيفة ولي الأمر (اختياري)'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          'رقم هاتف ولي الأمر',
                          dadPhoneController,
                          cubit.enabled,
                          inputDecoration('رقم هاتف ولي الأمر'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdown(
                          label: 'النوع',
                          value:
                              CacheHelper.getData(
                                key: CacheKeys.gender,
                              ).toString(),
                          items: const ['male', 'female'],
                          onChanged: (_) {},
                          enabled: false,
                          inputDecoration: inputDecoration('النوع'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('المحافظة',style: TextStyles.textStyle12w400(context).copyWith(color: Colors.grey),),
                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              value:
                                  cubit.selectedGovernmentId?.toString() ??
                                  CacheHelper.getData(
                                    key: CacheKeys.governmentId,
                                  ).toString(),
                              decoration: inputDecoration(
                                CacheHelper.getData(key: CacheKeys.governmentName),
                              ),
                              style: TextStyles.textStyle14w400(
                                context,
                              ).copyWith(color: Colors.black45),
                              items:
                                  AuthCubit.get(context).governments.map((gov) {
                                    return DropdownMenuItem(
                                      value: gov['id'].toString(),
                                      child: Text(gov['name'].toString()),
                                    );
                                  }).toList(),
                              onChanged:
                                  cubit.enabled
                                      ? cubit.setSelectedGovernment
                                      : null,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:CrossAxisAlignment.start,
                          children: [
                            Text('الصف الدراسي',style: TextStyles.textStyle12w400(context).copyWith(color: Colors.grey),),

                            DropdownButtonFormField<String>(
                              isExpanded: true,
                              value:
                                  cubit.selectedLevelId?.toString() ??
                                  CacheHelper.getData(
                                    key: CacheKeys.levelID,
                                  ).toString(),
                              decoration: inputDecoration('الصف الدراسي'),
                              style: TextStyles.textStyle14w400(
                                context,
                              ).copyWith(color: Colors.black),
                              items:
                                  AuthCubit.get(
                                    context,
                                  ).levelsForAuthCategories.map((level) {
                                    return DropdownMenuItem(
                                      value: level['id'].toString(),
                                      child: Text(level['name'].toString()),
                                    );
                                  }).toList(),
                              onChanged:
                                  cubit.enabled ? cubit.setSelectedLevel : null,
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => EmailPopUpForSettingPassword(),
                          );
                        },
                        icon: const Icon(Icons.lock, color: Colors.blue),
                        label: const Text(
                          'تغيير كلمة المرور',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  title: const Text('تأكيد تسجيل الخروج'),
                                  content: const Text(
                                    'هل أنت متأكد أنك تريد تسجيل الخروج؟',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('إلغاء'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        ProfileCubit.get(context).logout(context: context);
                                      },
                                      child: const Text(
                                        'نعم',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                          );
                        },
                        icon: Transform.rotate(
                          angle: 19.6,
                          child: const Icon(
                            LucideIcons.circleArrowOutDownLeft300,
                          ),
                        ),
                        label: const Text('تسجيل الخروج'),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 9.0,top: 10),
                    child: Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Row(
                        spacing: 7,
                        children: [
                          Icon(Icons.privacy_tip_outlined,color: Colors.grey,size: 20,),
                          InkWell(
                            onTap:(){
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('سياسة الخصوصية'),
                                  content: Text(

                                    HtmlUnescape().convert('${ProfileCubit.get(context).privacyPolicy}')
                                        .replaceAll(RegExp(r'<[^>]*>'), '',),                           style: TextStyle(fontSize: 14),
                                    textDirection: TextDirection.rtl,

                                  ),contentTextStyle: TextStyles.textStyle16w700(context).copyWith(color: AppColors.primaryColor),
                                  actions: [
                                    TextButton(
                                      child: Text('حسنًا'),
                                      onPressed: () => Navigator.of(context).pop(),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Text(
                                'سياسة الخصوصية',
                                style: TextStyle(color: Colors.grey,fontWeight: FontWeight.w400),

                            ),
                          ),
                        ],
                      ),
                    ),
                  )


                  // TextButton(
                  //   onPressed: () async {
                  //     cubit.enableChanges();
                  //     if (cubit.enabled) {
                  //       await cubit.updateProfileInfo(
                  //         context: context,
                  //         email: emailController.text,
                  //         phone: phoneController.text,
                  //         parentJob: dadJobController.text,
                  //         parentPhone: dadPhoneController.text,
                  //         governmentId: cubit.selectedGovernmentId,
                  //         categoryId: cubit.selectedLevelId,
                  //          image: cubit.selectedImage,
                  //       );
                  //       cubit.enableChanges();
                  //       //cubit.showSnackBar(context, 'تم حفظ التغييرات بنجاح', 2, AppColors.primaryColor);
                  //     } else {
                  //       cubit.enableChanges();
                  //       //cubit.pickImage();
                  //     }
                  //   },
                  //   child: Text(
                  //     cubit.enabled ? 'حفظ التغييرات' : 'تعديل',
                  //     style: TextStyles.textStyle16w400(
                  //       context,
                  //     ).copyWith(color: AppColors.primaryColor),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller,
    bool enabled,
    InputDecoration? inputDecoration,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          enabled: enabled,
          decoration: inputDecoration,
        ),
      ],
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    required bool enabled,
    InputDecoration? inputDecoration,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade800, fontSize: 12),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: inputDecoration,
          items:
              items
                  .map(
                    (item) => DropdownMenuItem(value: item, child: Text(item)),
                  )
                  .toList(),
          onChanged: enabled ? onChanged : null,
        ),
      ],
    );
  }
}
