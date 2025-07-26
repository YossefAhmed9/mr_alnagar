import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mr_alnagar/core/cubits/auth_cubit/auth_cubit/auth_cubit.dart';
import 'package:mr_alnagar/core/cubits/home_cubit/home_cubit.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_cubit.dart';
import 'package:mr_alnagar/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/core/widgets/Home%20widgets/about_us_container.dart';
import 'package:mr_alnagar/core/widgets/Home%20widgets/about_us_records.dart';
import 'package:mr_alnagar/core/widgets/Home%20widgets/ask_question.dart';
import 'package:mr_alnagar/core/widgets/Home%20widgets/contact_us.dart';
import 'package:mr_alnagar/core/widgets/Home%20widgets/courses_section_in_home.dart';
import 'package:mr_alnagar/core/widgets/Home%20widgets/f_a_q_section.dart';
import 'package:mr_alnagar/core/widgets/Home%20widgets/how_to_use.dart';
import 'package:mr_alnagar/core/widgets/Home%20widgets/leader_board.dart';
import 'package:mr_alnagar/core/widgets/Home%20widgets/welcome_container.dart';
import 'package:mr_alnagar/features/home_screen/about_us_view.dart';
import 'package:mr_alnagar/core/widgets/Home%20widgets/showing_books_in_home.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../core/widgets/Home widgets/featured_courses.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    AuthCubit.get(context).getLevelsForAuthCategories();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _refreshData();
  }

  Future<void> _refreshData() async {
    await ProfileCubit.get(context).getProfileInfo();
    return HomeCubit.get(context).getHomeData(context: context);
  }

  @override
  Widget build(BuildContext context) {
    int categoryID=CacheHelper.getData(key: CacheKeys.categoryId);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: RefreshIndicator(
            key: _refreshIndicatorKey,
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: _refreshData,
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const WelcomeContainer().animate().fade(duration: 500.ms).slideY(begin: 0.3),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                                  child: Column(
                                    children: [
                                      HomeCubit.get(context).aboutUs == null
                                          ? Container()
                                          : Row(
                                        children: [
                                          Text(
                                            'نبذة عن المستر',
                                            style: TextStyles.textStyle20w700(context).copyWith(fontSize: 20),
                                          ).animate().fade().moveX(begin: 40),
                                          Spacer(),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                CupertinoPageRoute(builder: (context) => AboutUsView()),
                                              );
                                            },
                                            child: Text(
                                              'عرض المزيد',
                                              style: TextStyles.textStyle16w400(context).copyWith(color: AppColors.secondary),
                                            ),
                                          ).animate().fade(duration: 400.ms),
                                        ],
                                      ),
                                      HomeCubit.get(context).homeData == null
                                          ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Center(child: CircularProgressIndicator()),
                                      )
                                          : AboutUsContainer().animate().fade(duration: 600.ms).slideY(begin: 0.3),
                                      SizedBox(height: 20,),
                                      Container(
                                        width: double.infinity,
                                        height: 1,
                                        decoration: BoxDecoration(color: Colors.grey),
                                      ),
                                      HomeCubit.get(context).homeData==null ?
                                      Center(child: CircularProgressIndicator(),)
                                          :  Padding(
                                        padding: const EdgeInsets.only(right:  8.0,left:8,top: 35,bottom:12),
                                        child: const FeaturedCourses().animate().fade(duration: 500.ms).slideY(begin: 0.3),
                                      ),

                                      HomeCubit.get(context).homeData == null
                                          ? Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
                                          : const AboutUsRecords().animate().fade(duration: 500.ms).slideY(begin: 0.2),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          HomeCubit.get(context).howToUse == null
                              ? Center(child: CircularProgressIndicator(color: AppColors.secondary30))
                              : HowToUse(data: HomeCubit.get(context).howToUse).animate().fade().scale(),



                          Padding(
                            padding: const EdgeInsets.only(top: 30.0, right: 10),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 1, // increase width to prevent overflow
                              height: 50,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'ابطالنا الاوائل',
                                      style: TextStyles.textStyle16w700(context).copyWith(fontSize: 20),
                                    ).animate().fade(duration: 400.ms).slideX(begin: -0.2),
                                  ),
                                  const SizedBox(width: 40),
                                  Expanded(
                                    flex: 2,
                                    child: AuthCubit.get(context).levelsForAuthCategories.length <= 2
                                        ? Center(child: CircularProgressIndicator(color: AppColors.primaryColor))
                                        : Container(
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(25)),
                                          child: DropdownButtonFormField<String>(
                                            style: TextStyles.textStyle12w400(context).copyWith(
                                              overflow: TextOverflow.ellipsis,
                                              color: Colors.white,
                                            ),
                                            dropdownColor: AppColors.primaryColor,iconSize: 30,iconDisabledColor:
                                          Colors.white,
                                            iconEnabledColor: Colors.white,
                                            validator: (value) {
                                          if (value == null) {
                                            return 'يجب ادخال الصف الدراسي ';
                                          }
                                          return null;
                                          },
                                            hint: Text('الصف الدراسي',style:TextStyle(color: Colors.white,fontSize: 11) ,),
                                            decoration: InputDecoration(
                                          hintText: 'الصف الدراسي',
                                          hintStyle: TextStyle(color: Colors.white,fontSize: 25),
                                              labelStyle:TextStyle(color: Colors.white,fontSize: 25) ,


                                          alignLabelWithHint: true,

                                          
                                          enabledBorder: OutlineInputBorder(
                                          
                                            borderSide: BorderSide(color: Colors.transparent),
                                            borderRadius: BorderRadius.circular(25),
                                          ),
                                          filled: true,
                                          fillColor:  AppColors.primaryColor,
                                            ),
                                            items: AuthCubit.get(context).levelsForAuthCategories
                                            .map<DropdownMenuItem<String>>((level) {
                                          return DropdownMenuItem<String>(
                                            value: level['id'].toString(),
                                            child: Text(level['name'].toString(),style: TextStyles.textStyle14w700(context).copyWith(fontSize:12),),
                                          );
                                                                                }).toList(),
                                                                                onChanged: (value) {
                                          print('************************$value');
                                          print(HomeCubit.get(context).topStudents);
                                          setState(() async{
                                            categoryID=int.parse(value!);
                                            HomeCubit.get(context).topStudents ==[];
                                            await HomeCubit.get(context).getLeaderBoard(categoryID: int.parse(value!));
                                          
                                          });
                                                                                },
                                                                              ),
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: LeaderBoard(categoryID: categoryID,).animate().fade(duration: 500.ms).slideY(begin: 0.3),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 10),
                            child: Text(
                              'اسأل مستر محمد',
                              style: TextStyles.textStyle16w700(context),
                            ).animate().fade().slideX(begin: 0.2),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const AskQuestion().animate().fade().scale(),
                          ),






                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const CoursesSectionInHome().animate().fade(duration: 500.ms).slideY(begin: 0.3),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const ShowingBooksInHome().animate().fade().slideY(begin: 0.4),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const FAQSection().animate().fade(duration: 400.ms).slideX(begin: -0.2),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const ContactUs().animate().fade(duration: 500.ms).slideY(begin: 0.3),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
