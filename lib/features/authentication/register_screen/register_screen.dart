import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mr_alnagar/core/cubits/auth_cubit/auth_cubit/auth_cubit.dart';
import 'package:mr_alnagar/core/cubits/auth_cubit/auth_cubit/auth_state.dart';
import 'package:mr_alnagar/core/widgets/Auth%20widgets/register_widgets/register_password_formfield.dart';
import 'package:mr_alnagar/core/widgets/Auth%20widgets/register_widgets/register_text_field.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/text_styles.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();

    TextEditingController firstName = TextEditingController();
    TextEditingController middleName = TextEditingController();
    TextEditingController lastName = TextEditingController();
    TextEditingController phone = TextEditingController();
    TextEditingController dadPhone = TextEditingController();
    TextEditingController dadWork = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passController = TextEditingController();
    TextEditingController confirmPassController = TextEditingController();
    String genderValue = '';
    int governmentValue = 0;
    int levelValue = 0;

    final border = OutlineInputBorder(
      borderSide: BorderSide(color: Colors.transparent),

      borderRadius: BorderRadius.circular(8),
    );
    inputDecoration(String hint) => InputDecoration(
      hintText: hint,
      hintStyle: TextStyles.textStyle16w700(
        context,
      ).copyWith(color: Colors.grey.shade200),
      alignLabelWithHint: true,
      //maintainHintHeight: true,
      enabledBorder: border,
      filled: true,
      fillColor: Color(0xFFF5F5F5),
    );

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        AuthCubit cubit = AuthCubit.get(context);

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: RefreshIndicator(
                  color: AppColors.primaryColor,
                  triggerMode: RefreshIndicatorTriggerMode.anywhere,
                  onRefresh: () async {
                    await cubit.getLevelsForAuthCategories();
                    await cubit.getGovernments();
                  },
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.all(15.0),
                              child: Text(
                                'انشئ حسابك الآن',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: RegisterTextField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return (' يجب كتابة الاسم الاول');
                                    }
                                    return null;
                                  },
                                  keyboard: TextInputType.name,
                                  onSubmit: (value) {},
                                  onChange: (value) {},
                                  controller: firstName,
                                  hint: 'الاسم الاول',
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: RegisterTextField(
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return (' يجب كتابة الاسم الاوسط');
                                    }
                                    return null;
                                  },
                                  keyboard: TextInputType.name,

                                  onSubmit: (value) {},
                                  onChange: (value) {},
                                  controller: middleName,
                                  hint: ('الاسم الأوسط'),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: RegisterTextField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return (' يجب كتابة الاسم الاخير');
                                      }
                                      return null;
                                    },
                                    keyboard: TextInputType.name,

                                    onSubmit: (value) {},
                                    onChange: (value) {},
                                    controller: lastName,
                                    hint: ('الاسم الأخير'),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: RegisterTextField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return (' يجب كتابة رقم التليفون');
                                      }
                                      return null;
                                    },
                                    keyboard: TextInputType.phone,

                                    onSubmit: (value) {},
                                    onChange: (value) {},
                                    controller: phone,
                                    hint: ('رقم التليفون'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: RegisterTextField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return (' يجب كتابة رقم هاتف ولي الامر');
                                      }
                                      return null;
                                    },
                                    keyboard: TextInputType.phone,

                                    onSubmit: (value) {},
                                    onChange: (value) {},
                                    controller: dadPhone,
                                    hint: ('رقم هاتف ولي الأمر'),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: RegisterTextField(
                                    validator: (value) {},
                                    keyboard: TextInputType.name,

                                    onSubmit: (value) {},
                                    onChange: (value) {},
                                    controller: dadWork,
                                    hint: ('وظيفة ولي الأمر (اختياري)'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'النوع',
                                        style: TextStyles.textStyle12w400(
                                          context,
                                        ),
                                      ),
                                      DropdownButtonFormField<String>(
                                        validator: (value) {
                                          if (value == null) {
                                            return 'يجب ادخال النوع ';
                                          }
                                          return null;
                                        },
                                        style: TextStyles.textStyle14w400(
                                          context,
                                        ).copyWith(color: Colors.black45),

                                        decoration: inputDecoration('النوع'),
                                        items: const [
                                          DropdownMenuItem(
                                            value: 'male',
                                            child: Text('ذكر'),
                                          ),
                                          DropdownMenuItem(
                                            value: 'female',
                                            child: Text('أنثى'),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          genderValue = value.toString();
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                cubit.governments.length < 2
                                    ? CircularProgressIndicator(
                                      color: AppColors.primaryColor,
                                    )
                                    : Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'المحافظة',
                                            style: TextStyles.textStyle12w400(
                                              context,
                                            ),
                                          ),
                                          DropdownButtonFormField<String>(
                                            validator: (value) {
                                              if (value == null) {
                                                return 'يجب ادخال المحافظة ';
                                              }
                                              return null;
                                            },
                                            style: TextStyles.textStyle14w400(
                                              context,
                                            ).copyWith(color: Colors.black45),
                                            decoration: inputDecoration(
                                              'المحافظة',
                                            ),
                                            enableFeedback: true,
                                            items:
                                                cubit.governments.map<
                                                  DropdownMenuItem<String>
                                                >((gov) {
                                                  return DropdownMenuItem<
                                                    String
                                                  >(
                                                    value: gov['id'].toString(),
                                                    child: Text(
                                                      gov['name'].toString(),
                                                    ),
                                                  );
                                                }).toList(),
                                            onChanged: (value) {
                                              governmentValue = int.parse(
                                                value!,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'الصف الدراسي',
                                        style: TextStyles.textStyle12w400(
                                          context,
                                        ),
                                      ),
                                      cubit.levelsForAuthCategories.length <= 2
                                          ? CircularProgressIndicator(
                                            color: AppColors.primaryColor,
                                          )
                                          : DropdownButtonFormField<String>(
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
                                            decoration: inputDecoration(
                                              'الصف الدراسي',
                                            ),
                                            items:
                                                cubit.levelsForAuthCategories
                                                    .map<
                                                      DropdownMenuItem<String>
                                                    >((level) {
                                                      return DropdownMenuItem<
                                                        String
                                                      >(
                                                        value:
                                                            level['id']
                                                                .toString(),
                                                        child: Text(
                                                          level['name']
                                                              .toString(),
                                                        ),
                                                      );
                                                    })
                                                    .toList(),
                                            onChanged: (value) {
                                              levelValue = int.parse(value!);
                                            },
                                          ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: RegisterTextField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return (' يجب كتابة البريد الالكتروني');
                                      }
                                      return null;
                                    },
                                    keyboard: TextInputType.emailAddress,

                                    onSubmit: (value) {},
                                    onChange: (value) {},
                                    controller: emailController,
                                    hint: ('البريد الإلكتروني'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: RegisterPasswordFormField(
                                    controller: passController,
                                    hint: 'كلمة السر',
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'يجب إدخال كلمة المرور';
                                      }
                                      if (value.length < 8) {
                                        return 'يجب أن تحتوي كلمة المرور على 8 أحرف على الأقل';
                                      }
                                      final hasLetter = RegExp(r'[A-Za-z]');
                                      final hasNumber = RegExp(r'\d');
                                      if (!hasLetter.hasMatch(value) ||
                                          !hasNumber.hasMatch(value)) {
                                        return 'يجب أن تحتوي كلمة المرور على حروف وأرقام';
                                      }
                                      return null;
                                    },

                                    onChange: (value) {},
                                    onSubmit: (value) {},
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: RegisterPasswordFormField(
                                    controller: confirmPassController,
                                    hint: 'تأكيد كلمة السر',
                                    validator: (value) {
                                      if (value.isEmpty ||
                                          passController.text !=
                                              confirmPassController.text) {
                                        return (' كلمة السر غير متطابقة');
                                      }
                                      return null;
                                    },
                                    onChange: (value) {},
                                    onSubmit: (value) {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  AuthCubit.get(context).listenAuthLoading();

                                  await cubit
                                      .register(
                                        context: context,
                                        firstName: firstName.text,
                                        middleName: middleName.text,
                                        lastName: lastName.text,
                                        phone: phone.text,
                                        parentPhone: dadPhone.text,
                                        parentJob: dadWork.text,
                                        email: emailController.text,
                                        gender: genderValue.toString(),
                                        governmentID: governmentValue,
                                        categoryID: levelValue,
                                        pass: passController.text,
                                        confirmPass: confirmPassController.text,
                                      )
                                      .then((value) {
                                    AuthCubit.get(context).listenAuthLoading();

                                    // firstName.clear();
                                        // middleName.clear();
                                        // lastName.clear();
                                        // phone.clear();
                                        // dadPhone.clear();
                                        // dadWork.clear();
                                        // emailController.clear();
                                      });
                                  if (kDebugMode) {
                                    print('''
First Name: ${firstName.text}
Middle Name: ${middleName.text}
Last Name: ${lastName.text}
Phone: ${phone.text}
Dad's Phone: ${dadPhone.text}
Dad's Work: ${dadWork.text}
Email: ${emailController.text}
Gender: $genderValue
Governorate ID: $governmentValue
Level ID: $levelValue
Password: ${passController.text}
Confirm Password: ${confirmPassController.text}
''');
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2F3C89),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                child:
                                    AuthCubit.get(context).loading == true
                                        ? Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                        : Text(
                                          ' انشاء الحساب',
                                          style: TextStyles.textStyle16w700(
                                            context,
                                          ).copyWith(color: Colors.white),
                                        ),
                              ),
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('لديك حساب بالفعل؟'),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'تسجيل الدخول',
                                  style: TextStyle(color: Color(0xFF0AA9A5)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
