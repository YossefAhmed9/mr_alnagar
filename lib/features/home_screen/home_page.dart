import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mr_alnagar/core/cubits/auth_cubit/auth_cubit/auth_cubit.dart';
import 'package:mr_alnagar/core/cubits/books_cubit/books_cubit.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/cubits/home_cubit/home_cubit.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_cubit.dart';
import 'package:mr_alnagar/core/cubits/profile_cubit/profile_cubit.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/app_loaders.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/core/widgets/Home%20widgets/about_us_container.dart';
import 'package:mr_alnagar/core/widgets/Home%20widgets/about_us_records.dart';
import 'package:mr_alnagar/core/widgets/Home%20widgets/ask_question.dart';
import 'package:mr_alnagar/core/widgets/Home%20widgets/contact_us.dart';
import 'package:mr_alnagar/core/widgets/Home%20widgets/courses_section_in_home.dart';
import 'package:mr_alnagar/core/widgets/Home%20widgets/f_a_q_section.dart';
import 'package:mr_alnagar/core/widgets/Home%20widgets/how_to_use.dart';
import 'package:mr_alnagar/core/widgets/Home%20widgets/leader_board.dart';
import 'package:mr_alnagar/core/widgets/Home%20widgets/levels_in_home.dart';
import 'package:mr_alnagar/core/widgets/Home%20widgets/welcome_container.dart';
import 'package:mr_alnagar/core/widgets/lessons%20widgets/one_time_lessons_tab_bar.dart';
import 'package:mr_alnagar/features/home_screen/about_us_view.dart';
import 'package:mr_alnagar/core/widgets/Home%20widgets/showing_books_in_home.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/widgets/Home widgets/featured_courses.dart';
import '../../core/widgets/lessons widgets/one_time_lesson_card.dart';
import '../../main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

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
    await ProfileCubit.get(context).getProfileInfo(context: context);
    await CoursesCubit.get(context).getCourses();
    await BooksCubit.get(context).getAllBooks();
    return HomeCubit.get(context).getHomeData(context: context);
  }

  @override
  Widget build(BuildContext context) {
    int categoryID = CacheHelper.getData(key: CacheKeys.categoryId);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body:
          RefreshIndicator(
            key: _refreshIndicatorKey,
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            onRefresh: _refreshData,
            child: InternetAwareWrapper(
              onInternetRestored: [

                ()=>ProfileCubit.get(context).getProfileInfo(context: context),
            ()=> CoursesCubit.get(context).getCourses(),
                    ()=>BooksCubit.get(context).getAllBooks(),
                    ()=>HomeCubit.get(context).getHomeData(context: context),
              ],
              child: SafeArea(
                child:HomeCubit.get(context).homeData==null ?
                Center(child:AppLoaderHourglass()) : CustomScrollView(

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
                                  const WelcomeContainer()
                                      .animate()
                                      .fade(duration: 500.ms)
                                      .slideY(begin: 0.3),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 30.0,
                                    ),
                                    child: Column(
                                      children: [
                                        HomeCubit.get(context).aboutUs == null
                                            ? Container()
                                            :  Row(
                                          children: [
                                            Text(
                                              'نبذة عن المستر',
                                              style:
                                              TextStyles.textStyle20w700(
                                                context,
                                              ).copyWith(fontSize: 20),
                                            ).animate().fade().moveX(
                                              begin: 40,
                                            ),
                                            Spacer(),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  CupertinoPageRoute(
                                                    builder:
                                                        (context) =>
                                                        AboutUsView(),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                'عرض المزيد',
                                                style:
                                                TextStyles.textStyle16w400(
                                                  context,
                                                ).copyWith(
                                                  color:
                                                  AppColors
                                                      .secondary,
                                                ),
                                              ),
                                            ).animate().fade(
                                              duration: 100.ms,
                                            ),
                                          ],
                                        ),
                                        HomeCubit.get(context).homeData == null
                                            ? Padding(
                                          padding: const EdgeInsets.all(
                                            8.0,
                                          ),
                                          child: Container(),
                                        )
                                            : const AboutUsContainer()
                                            .animate()
                                            .fade(duration: 600.ms)
                                            .slideY(begin: 0.3),
                                        SizedBox(height: 20),
                                        Container(
                                          width: double.infinity,
                                          height: 1,
                                          decoration: BoxDecoration(
                                            color: Colors.grey,
                                          ),
                                        ),

                                        HomeCubit.get(context).home == null
                                            ? Container()
                                            : const LevelsInHome(),

                                        HomeCubit.get(context).homeData == null
                                            ? Container()
                                            : Padding(
                                          padding: const EdgeInsets.only(
                                            right: 8.0,
                                            left: 8,
                                            top: 35,
                                            bottom: 12,
                                          ),
                                          child: const FeaturedCourses()
                                              .animate()
                                              .fade(duration: 500.ms)
                                              .slideY(begin: 0.3),
                                        ),

                                        HomeCubit.get(context).homeData == null
                                            ? Container()
                                            : const AboutUsRecords()
                                            .animate()
                                            .fade(duration: 500.ms)
                                            .slideY(begin: 0.2),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            HomeCubit.get(context).howToUse == null
                                ? Container()
                                : HowToUse(
                              data: HomeCubit.get(context).howToUse,
                            ).animate().fade().scale(),
                            SizedBox(height: 20,),
                            Container(
                              height: 1,
                              width: double.infinity,
                              color: Colors.grey,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 5,bottom: 5,right: 10),
                              child: Row(
                                children: [
                                  Text('حصص المرة الواحدة',style: TextStyles.textStyle16w700(context).copyWith(color: AppColors.primaryColor,fontWeight: FontWeight.w900),),
                                  Spacer(),
                                  LessonsCubit.get(context).lessonsListForOneTimeClasses.isEmpty ?
                                  Container() :
                                  TextButton(onPressed: ()async{
                                    LessonsCubit.get(context).isOneTimeLessonShowAll=true;
                                    // print(LessonsCubit.get(context).isOneTimeLessonShowAll);
                                    // //await LessonsCubit.get(context).getLessonsListForOneTimeClasses();
                                    // print(LessonsCubit.get(context).lessonsListForOneTimeClasses);
                                    // print(CacheHelper.getData(key: CacheKeys.categoryId));
                                    // print(CacheHelper.getData(key: CacheKeys.level));
                                    // print(CacheHelper.getData(key: CacheKeys.categoryId));
                                    //
                                    //
                                    Navigator.push(context, CupertinoPageRoute(builder: (context){
                                      return OneTimeLessonsTabBar(lessons: LessonsCubit.get(context).oneTimeLessonFiltered
                                        , physics: ScrollPhysics(),);
                                    }));

                                  }, child: Text('عرض الكل',style: TextStyles.textStyle16w700(context).copyWith(color: AppColors.secondary),))


                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Container(
                                //padding: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(

                                ),
                                width: double.infinity,
                                height: 410,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: HomeCubit.get(context).classesByCodeInHome.length,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final course = HomeCubit.get(context).classesByCodeInHome[index];
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: SizedBox(
                                          width: 300,
                                          height: 200,
                                          child: OneTimeLessonCard(data: course,)),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 30.0,
                                right: 10,
                              ),
                              child: SizedBox(
                                width:
                                MediaQuery.sizeOf(context).width *
                                    1, // increase width to prevent overflow
                                height: 50,
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        'ابطالنا الاوائل',
                                        style: TextStyles.textStyle16w700(
                                          context,
                                        ).copyWith(fontSize: 20),
                                      )
                                          .animate()
                                          .fade(duration: 100.ms)
                                          .slideX(begin: -0.2),
                                    ),
                                    //SizedBox(width: 10),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 0,
                                        ),
                                        child:
                                        AuthCubit.get(context)
                                            .levelsForAuthCategories
                                            .isEmpty
                                            ? Container()
                                            : Container(
                                          clipBehavior:
                                          Clip.antiAliasWithSaveLayer,

                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(
                                              25,
                                            ),
                                          ),
                                          child: DropdownButtonFormField<String>(
                                            style:
                                            TextStyles.textStyle12w400(context).copyWith(
                                              overflow:
                                              TextOverflow
                                                  .ellipsis,
                                              color: Colors.white,
                                            ),
                                            dropdownColor:
                                            AppColors.primaryColor,
                                            iconSize: 30,
                                            iconDisabledColor:
                                            Colors.white,
                                            iconEnabledColor:
                                            Colors.white,
                                            validator: (value) {
                                              if (value == null) {
                                                return 'يجب ادخال الصف الدراسي ';
                                              }
                                              return null;
                                            },
                                            hint: Text(
                                              'الصف الدراسي',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                              ),
                                            ),
                                            decoration: InputDecoration(
                                              hintText: 'الصف الدراسي',
                                              hintStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25,
                                              ),
                                              labelStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 25,
                                              ),

                                              alignLabelWithHint: true,

                                              enabledBorder: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                  color:
                                                  Colors
                                                      .transparent,
                                                ),
                                                borderRadius:
                                                BorderRadius.circular(
                                                  25,
                                                ),
                                              ),
                                              filled: true,
                                              fillColor:
                                              AppColors
                                                  .primaryColor,
                                            ),

                                            items:
                                            AuthCubit.get(
                                              context,
                                            ).levelsForAuthCategories.map<
                                                DropdownMenuItem<
                                                    String
                                                >
                                            >((level) {
                                              return DropdownMenuItem<
                                                  String
                                              >(
                                                value:
                                                level['id']
                                                    .toString(),
                                                child: Container(
                                                  clipBehavior:
                                                  Clip.antiAliasWithSaveLayer,
                                                  decoration: BoxDecoration(
                                                    color:
                                                    AppColors
                                                        .primaryColor,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                      25,
                                                    ),
                                                  ),
                                                  padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal:
                                                    0,
                                                    vertical: 0,
                                                  ),
                                                  child: Text(
                                                    level['name']
                                                        .toString(),
                                                    style: TextStyles.textStyle14w700(
                                                      context,
                                                    ).copyWith(
                                                      fontSize: 12,
                                                      color:
                                                      Colors
                                                          .white,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList(),

                                            onChanged: (value) {
                                              print(
                                                '************************$value',
                                              );
                                              print(
                                                HomeCubit.get(
                                                  context,
                                                ).topStudents,
                                              );
                                              setState(() async {
                                                categoryID = int.parse(
                                                  value!,
                                                );
                                                HomeCubit.get(
                                                  context,
                                                ).topStudents ==
                                                    [];
                                                await HomeCubit.get(
                                                  context,
                                                ).getLeaderBoard(
                                                  categoryID: int.parse(
                                                    value,
                                                  ),
                                                );
                                              });
                                            },
                                          ),
                                        ),
                                      ),
                                    ),

                                    SizedBox(width: 20),
                                  ],
                                ),
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: LeaderBoard(categoryID: categoryID)
                                  .animate()
                                  .fade(duration: 500.ms)
                                  .slideY(begin: 0.3),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 10,
                              ),
                              child: Text(
                                'اسأل مستر محمد',
                                style: TextStyles.textStyle16w700(context),
                              ).animate().fade().slideX(begin: 0.2),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:
                              const AskQuestion().animate().fade().scale(),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const CoursesSectionInHome()
                                  .animate()
                                  .fade(duration: 500.ms)
                                  .slideY(begin: 0.3),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const ShowingBooksInHome()
                                  .animate()
                                  .fade()
                                  .slideY(begin: 0.4),
                            ),

                            HomeCubit.get(context).faqQuestion == null &&
                                HomeCubit.get(
                                  context,
                                ).commonQuestion.isEmpty
                                ? Container()
                                : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const FAQSection()
                                  .animate()
                                  .fade(duration: 100.ms)
                                  .slideX(begin: -0.2),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: const ContactUs()
                                  .animate()
                                  .fade(duration: 500.ms)
                                  .slideY(begin: 0.3),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
