import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/auth_cubit/auth_cubit/auth_state.dart';
import 'package:mr_alnagar/core/cubits/home_cubit/home_cubit.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import '../../cubits/auth_cubit/auth_cubit/auth_cubit.dart';
import '../../utils/text_styles.dart';
import '../../../core/utils/app_loaders.dart';

class AskQuestion extends StatefulWidget {
  const AskQuestion({super.key});

  @override
  State<AskQuestion> createState() => _AskQuestionState();
}

class _AskQuestionState extends State<AskQuestion> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();


  String _selectedGrade = 'الصف الأول الثانوي';
  int levelValue = 0;
  final List<String> _grades = [
    'الصف الأول الثانوي',
    'الصف الثاني الثانوي',
    'الصف الثالث الثانوي',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFE0F7FA),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // First Row: Name + Grade
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('الاسم', style: TextStyles.textStyle12w400(context).copyWith(color: Colors.grey)),
                        SizedBox(height: 4.h),
                        TextFormField(
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'من فضلك أدخل الاسم';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),

                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('الصف الدراسي',
                            style: TextStyles.textStyle14w400(context).copyWith(color: Colors.grey)),
                        SizedBox(height: 4.h),
                        AuthCubit.get(context).levelsForAuthCategories.length <= 2
                            ? AppLoaderInkDrop(
                          color: AppColors.primaryColor,
                        )
                            : DropdownButtonFormField<String>(
                          isExpanded: true,
                          validator: (value) {
                            if (value == null) {
                              return 'يجب ادخال الصف الدراسي ';
                            }
                            return null;
                          },
                          style: TextStyles.textStyle12w400(
                            context,
                          ).copyWith(
                            overflow: TextOverflow.ellipsis,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            hintText:                             'الصف الدراسي',
                            hintStyle: TextStyles.textStyle16w700(
                              context,
                            ).copyWith(color: Colors.grey.shade200),
                            alignLabelWithHint: true,
                            maintainHintHeight: true,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),

                              borderRadius: BorderRadius.circular(8),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          items:
                          AuthCubit.get(context).levelsForAuthCategories.map<
                              DropdownMenuItem<String>
                          >((level) {
                            return DropdownMenuItem<String>(
                              value: level['id'].toString(),
                              child: Text(
                                level['name'].toString(),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            levelValue = int.parse(value!);
                          },
                        ),                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              // Second Row: Email + Phone
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('البريد الإلكتروني',
                            style: TextStyles.textStyle14w400(context)
                                .copyWith(color: Colors.grey)),
                        SizedBox(height: 4.h),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'من فضلك أدخل البريد الإلكتروني';
                            }
                            final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(value.trim())) {
                              return 'من فضلك أدخل بريد إلكتروني صالح';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),

                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('رقم التليفون',
                            style: TextStyles.textStyle14w400(context)
                                .copyWith(color: Colors.grey)),
                        SizedBox(height: 4.h),
                        TextFormField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'من فضلك أدخل رقم التليفون';
                            }
                            if (value.length < 8 || value.length > 15) {
                              return 'رقم التليفون غير صالح';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),

                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),

              // Message Field
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('سؤالك / رسالتك',
                      style: TextStyles.textStyle14w400(context)
                          .copyWith(color: Colors.grey)),
                  SizedBox(height: 4.h),
                  TextFormField(
                    controller: _messageController,
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'من فضلك أدخل سؤالك أو رسالتك';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent)),

                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent)
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Warning Text
              Text(
                'انتظر اجابة سؤالك على بريدك الإلكتروني، او عن طريق التليفون او سيتم نشر فيديو على المنصة للإجابة عن اسئلتكم',
                style: TextStyles.textStyle14w700(context).copyWith(color: Colors.red),
              ),
              SizedBox(height: 12.h),

              // Submit Button
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(35),
                  ),
                  width: 170.w,
                  height: 50.h,
                  child: MaterialButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Send or handle submission
                        HomeCubit.get(context).POSTaskUS(
                            name: _nameController.text,
                            phone: _phoneController.text,
                            email: _emailController.text,
                            message: _messageController.text,
                            id: levelValue,context: context
                        ).then((value){
                          _nameController.clear();
                          _phoneController.clear();
                          _emailController.clear();
                          _messageController.clear();
                        });
                        if (kDebugMode) {
                          print(_nameController.text);
                          print(_phoneController.text);
                          print(_emailController.text);
                          print(_messageController.text);
                          print(levelValue);
                        }

                      }
                    },
                    child: Text(
                      'ارسال',
                      style: TextStyles.textStyle16w700(context)
                          .copyWith(color: Colors.white),
                    ),
                  ),
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
