import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_state.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/core/widgets/lessons%20widgets/reservation_steps_list_view.dart';
import 'package:mr_alnagar/features/courses_view/videos_view/videos_view.dart';
import '../../core/cubits/lessons_cubit/lessons_cubit.dart';
import '../../core/cubits/lessons_cubit/lessons_state.dart';
import '../../core/utils/app_colors.dart';
import '../lessons_view/subscriptions_list_view.dart';

class CourseReservationScreen extends StatefulWidget {
  const CourseReservationScreen({Key? key, required this.data})
    : super(key: key);
  final data;

  @override
  State<CourseReservationScreen> createState() =>
      _CourseReservationScreenState();
}

class _CourseReservationScreenState extends State<CourseReservationScreen> {

  String showMore='عرض المزيد';
  String showLess='عرض اقل';
  bool showMoreButton=false;
  int newMaxLinesValue=5;

  @override
  void initState() {
    super.initState();
    CoursesCubit.get(context).isCourseLoading=false;
    // Always fetch the latest course data by ID when the screen is opened
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CoursesCubit.get(context).getCourseByID(id: widget.data['id']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CoursesCubit, CoursesState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        // print('*****************');
        // print(widget.data);

        List icons = [
          Icons.menu_book_outlined,
          Icons.list,
          Icons.video_library_sharp,
          Icons.library_books_outlined,
        ];

        List titles = ['مذكرات', 'امتحانات', 'فيديوهات', 'واجبات'];
        List counts = [
          'count_attachment',

          'count_quiz',

          'count_video',
          'count_homework',
        ];

        // Use the latest course data from the cubit
         dynamic course = CoursesCubit.get(context).courseResult[0];
         bool isEnrolled = course['is_enrolled'] == true;
         String status =
            course['request_status']?['key'] ??
            (isEnrolled ? 'approved' : course['status'] ?? '');

        Color buttonColor;
        Color textColor;
        String buttonLabel;
        bool isDisabled = false;
        bool showPrice = true;

        if (!isEnrolled && status == 'approved') {
          buttonColor = Colors.red;
          textColor = Colors.white;
          buttonLabel = 'تم الغلق برجاء التواصل مع الدعم';
          isDisabled = true;
          showPrice = false;
        } else if (status == 'pending') {
          buttonColor = Colors.yellow.shade600;
          textColor = Colors.black;
          buttonLabel = 'برجاء الانتظار حتى قبول طلبك';
          isDisabled = true;
        } else if (status == 'rejected') {
          buttonColor = Colors.red;
          textColor = Colors.white;
          buttonLabel = 'تم الرفض، برجاء التواصل مع الدعم';
          isDisabled = true;
          showPrice = false;
        } else if (status == 'approved') {
          buttonColor = AppColors.primaryColor;
          textColor = Colors.white;
          buttonLabel = 'ابدا الان';
          isDisabled = false;
        } else {
          buttonColor = AppColors.primaryColor;
          textColor = Colors.white;
          buttonLabel = 'احجز الان';
          isDisabled = false;
        }

        return CoursesCubit.get(context).courseResult.isEmpty
            ? Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            )
            : RefreshIndicator(
              onRefresh: () async {
                setState(() {

                });
                return await CoursesCubit.get(context).getCourses();
              },
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Scaffold(
                  bottomNavigationBar: Container(
                    decoration: BoxDecoration(color: Colors.grey.shade100),
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        bottom: 5.0,
                        right: 10,
                        left: 10,
                      ),
                      child: Builder(
                        builder: (context) {
                          return Row(
                            children: [
                              if (showPrice &&
                                  status != 'approved' &&
                                  status != 'pending') ...[
                                Text(
                                  '${course['price']} جنيه',
                                  style: TextStyles.textStyle20w700(
                                    context,
                                  ).copyWith(color: Colors.red),
                                ),
                                const SizedBox(width: 10),
                              ],
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: buttonColor,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  height: 45.h,
                                  child: MaterialButton(
                                    onPressed:
                                        isDisabled
                                            ? null
                                            : () async {
                                              if (status == 'approved') {
                                                CoursesCubit.get(context,).changeIsCourseLoading();

                                                await CoursesCubit.get(context).getVideosByCourse(id:
                                                course['id'], context: context,).then((value){
                                                  Navigator.push(
                                                    context,
                                                    CupertinoPageRoute(
                                                      builder:
                                                          (context) =>
                                                          CourseVideoScreen(
                                                            videoIndex:
                                                            course['id'],
                                                          ),
                                                    ),
                                                  );
                                                });

                                              } else {
                                                await CoursesCubit.get(context).enrollInCourse(
                                                  courseID: course['id'],
                                                  paymentType:
                                                      course['payment_type']!,
                                                );
                                                // After enrollment, fetch the latest course data
                                                await CoursesCubit.get(
                                                  context,
                                                ).getCourseByID(
                                                  id: course['id'],
                                                );
                                                setState(() {});
                                              }
                                            },
                                    child:
                                        CoursesCubit.get(
                                              context,
                                            ).isCourseLoading
                                            ? const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            )
                                            : Text(
                                              buttonLabel,
                                              style: TextStyles.textStyle16w700(
                                                context,
                                              ).copyWith(color: textColor),
                                            ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                  //             floatingActionButton: FloatingActionButton(onPressed: () async {
                  //
                  //
                  //               //await CoursesCubit.get(context).watchVideo(videoId: 4);
                  //               await CoursesCubit.get(context).postVideoSeconds(videoId: 7,watchSeconds: 30,lastWatchedSecond: 40);
                  // //               print(CoursesCubit.get(context).courses[2]['is_enrolled']);
                  // //               print(CoursesCubit.get(context).courses);
                  // // //
                  // //               await CoursesCubit.get(context).getVideosByCourse(id:4);
                  // //               print(CacheHelper.getData(key: CacheKeys.token));
                  // //               await CoursesCubit.get(context).getCourseByID(id: 4);
                  //               //print(CoursesCubit.get(context).courses[index]['phone']);
                  //             }),
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    leading: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios),
                    ),
                    title: Text(
                      course['title'],
                      style: TextStyles.textStyle16w700(context),
                    ),
                    centerTitle: true,
                  ),
                  body: SingleChildScrollView(
                    child: ModalProgressHUD(
                      inAsyncCall: CoursesCubit.get(context).isCourseLoading,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 0.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: double.infinity,
                              height: 30.h,

                              child: ListView.builder(
                                itemCount: icons.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5.0,
                                    ),
                                    child: Container(
                                      width: 140,
                                      //height: 55.h,
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary70,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                          vertical: 5,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          spacing: 3,
                                          children: [
                                            Icon(
                                              icons[index],
                                              color: Colors.white,
                                            ),
                                            Text(
                                              '${CoursesCubit.get(context).courseResult[0][counts[index]]}',
                                              style: TextStyles.textStyle12w700(
                                                context,
                                              ).copyWith(color: Colors.white),
                                            ),

                                            Text(
                                              titles[index],
                                              style: TextStyles.textStyle14w400(
                                                context,
                                              ).copyWith(color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 15.0,
                                bottom: 5,
                              ),
                              child: Text(
                                'اشترك دلوقتي وابدأ رحلة التفوق مع مستر محمد النجار !',
                                style: TextStyles.textStyle16w700(context),
                              ),
                            ),
                            Text(
                              HtmlUnescape()
                                  .convert(course['note'])
                                  .replaceAll(RegExp(r'<[^>]*>'), ''),
                              style: TextStyles.textStyle16w400(context),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              child: Container(
                                alignment: AlignmentDirectional.center,
                                decoration: BoxDecoration(
                                  color: AppColors.secondary8,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Image.network(
                                  course['image'] ?? widget.data['image'],
                                ),
                              ),
                            ),
                            Text(
                              'محتوى الإشتراك الشهري',
                              style: TextStyles.textStyle16w700(context),
                            ),

                            Wrap(alignment:WrapAlignment.center,
                              children: [
                                Text(maxLines: newMaxLinesValue,
                                  HtmlUnescape()
                                      .convert('${course['description']}')
                                      .replaceAll(RegExp(r'<[^>]*>'), ''),
                                  style:
                                  TextStyles.textStyle16w400(
                                    context,
                                  ).copyWith(),
                                ),
                                TextButton(onPressed: (){
                                  print(newMaxLinesValue);
                                  setState(() {
                                    showMoreButton=!showMoreButton;
                                    if (newMaxLinesValue == 5) {
                                      newMaxLinesValue=200;
                                    }
                                    else if (newMaxLinesValue ==200){
                                      newMaxLinesValue=5;
                                    }
                                  });
                                }, child: Container(
                                    width: 100,height: 30,
                                    decoration: BoxDecoration(color: AppColors.secondary,borderRadius: BorderRadius.circular(20)),
                                    child: Center(child: Text(showMoreButton ? showLess : showMore,style: TextStyle(fontSize: 15,fontWeight: FontWeight.w900,color: Colors.white),))))
                              ],
                            ),

                            // ListView.builder(
                            //     itemCount: points.length,
                            //     shrinkWrap: true,
                            //     physics: NeverScrollableScrollPhysics(),
                            //
                            //     itemBuilder: (context,index){
                            //       return  Padding(
                            //         padding: const EdgeInsets.symmetric(vertical: 8.0),
                            //         child: Row(
                            //           spacing: 10,
                            //           children:  [
                            //             Icon(Icons.check_circle, color: Colors.teal),
                            //             Flexible(child: ),
                            //           ],
                            //         ),
                            //       );
                            //     }),
                            ReservationStepsListView(data: course),

                            // Column(
                            //   crossAxisAlignment: CrossAxisAlignment.start,
                            //   children: [
                            //     Container(
                            //       decoration: BoxDecoration(color: Colors.grey.shade100,borderRadius: BorderRadius.circular(15),),
                            //       child: Column(
                            //         children: [
                            //           Padding(
                            //             padding: const EdgeInsets.all(8.0),
                            //             child: Row(
                            //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //               children: [
                            //                 Text('التقييمات', style: TextStyle(fontWeight: FontWeight.bold)),
                            //                 TextButton(
                            //                   child: Text('أكتب تقييمك', style: TextStyles.textStyle14w700(context).copyWith(color: AppColors.primaryColor)),
                            //                   onPressed: (){
                            //                     showDialog(
                            //                       context: context,
                            //
                            //                       builder: (context) => Dialog(
                            //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            //
                            //                         child: Container(
                            //                           decoration: BoxDecoration(
                            //                             color: Color(0xffE6FAFA),
                            //                           ),
                            //                           child: Padding(
                            //                             padding: const EdgeInsets.all(16.0),
                            //                             child: Column(
                            //                               mainAxisSize: MainAxisSize.min,
                            //                               mainAxisAlignment: MainAxisAlignment.end,
                            //                               crossAxisAlignment: CrossAxisAlignment.end,
                            //                               children: [
                            //                                 Row(
                            //                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //                                   children: [
                            //                                     Icon(Icons.close, color: Colors.red),
                            //                                     Text('أكتب تقييمك', style: TextStyle(fontWeight: FontWeight.bold)),
                            //                                   ],
                            //                                 ),
                            //                                 Padding(
                            //                                   padding: const EdgeInsets.symmetric(vertical:  15.0),
                            //                                   child: Container(
                            //                                     decoration: BoxDecoration(color: Colors.white,
                            //                                       borderRadius: BorderRadius.circular(10),
                            //                                     ),
                            //                                     width: double.infinity,
                            //                                     height: 2,
                            //                                   ),
                            //                                 ),
                            //                                 TextFormField(
                            //                                   controller: rateController,
                            //                                   decoration: InputDecoration(border: OutlineInputBorder()),
                            //                                   maxLines: 3,
                            //                                 ),
                            //                                 SizedBox(height: 12),
                            //                                 Text('سجل بصوتك',textAlign: TextAlign.end,),
                            //                                 Container(
                            //                                   decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(20)),
                            //                                   child: Row(
                            //                                     children: [
                            //                                       IconButton(onPressed: () {}, icon: Icon(Icons.delete, color: Colors.red)),
                            //                                       IconButton(onPressed: () {}, icon: Icon(Icons.check_circle, color: Colors.green)),
                            //                                       Expanded(
                            //                                         child: Container(
                            //                                           height: 40,
                            //                                           color: Colors.white,
                            //                                           // child: Center(child: Text('🎙️ Waveform Here')),
                            //                                         ),
                            //                                       ),
                            //                                       IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow, color: Colors.blue)),
                            //                                     ],
                            //                                   ),
                            //                                 ),
                            //                                 SizedBox(height: 12),
                            //                                 ElevatedButton(
                            //                                   style: ElevatedButton.styleFrom(backgroundColor: Color(0xff4C67FF)),
                            //                                   onPressed: () {},
                            //                                   child: Center(child: Text('إرسال', style: TextStyle(color: Colors.white))),
                            //                                 ),
                            //                               ],
                            //                             ),
                            //                           ),
                            //                         ),
                            //                       ),
                            //                     );
                            //                   },
                            //                 ),
                            //               ],
                            //             ),
                            //           ),
                            //           SizedBox(height: 8),
                            //           Padding(
                            //             padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            //             child: Row(
                            //               spacing: 12,
                            //               children: [
                            //                 Expanded(
                            //                   child: Column(
                            //                     children: List.generate(5, (index) {
                            //                       return Row(
                            //                         children: [
                            //                           Expanded(
                            //                             child: LinearProgressIndicator(minHeight: 10,borderRadius: BorderRadius.circular(10),
                            //                               value: [0.8, 0.6, 0.4, 0.2, 0.1][index],
                            //                               color: Colors.orange,
                            //                               backgroundColor: Colors.grey.shade300,
                            //                             ),
                            //                           ),
                            //                           SizedBox(width: 8),
                            //                           Text('${5 - index}'),
                            //                         ],
                            //                       );
                            //                     }),
                            //                   ),
                            //                 ),
                            //                 Column(
                            //                   spacing: 10,
                            //                   children: [
                            //                     Text('4.5', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            //                     Text('20 تقييم'),
                            //                     Text('88 %'),
                            //                     Text('توصية'),
                            //
                            //                   ],
                            //                 ),
                            //
                            //
                            //
                            //               ],
                            //             ),
                            //           ),
                            //           SizedBox(height: 12),
                            //
                            //         ],
                            //       ),
                            //     ),
                            //
                            //     Padding(
                            //       padding: const EdgeInsets.only(bottom:  8.0,top: 10),
                            //       child: Container(
                            //         decoration: BoxDecoration(color: Colors.grey.shade100,borderRadius: BorderRadius.circular(15),),
                            //         child: Column(
                            //           spacing: 10,
                            //           crossAxisAlignment: CrossAxisAlignment.start,
                            //           children: [
                            //             Padding(
                            //               padding: const EdgeInsets.all(8.0),
                            //               child: Text('تقييمات الطلاب', style: TextStyle(fontWeight: FontWeight.bold)),
                            //             ),
                            //
                            //             Padding(
                            //               padding: const EdgeInsets.only(bottom: 15.0),
                            //               child: Container(
                            //                 width: double.infinity,
                            //                 height: 2,
                            //                 decoration: BoxDecoration(color: Colors.grey),
                            //               ),
                            //             ),
                            //             // Example single review
                            //             Padding(
                            //               padding: const EdgeInsets.all(12.0),
                            //               child: Column(
                            //                 crossAxisAlignment: CrossAxisAlignment.start,
                            //                 children: [
                            //                   Row(
                            //                     children: [
                            //                       CircleAvatar(radius: 16, ),
                            //                       SizedBox(width: 8),
                            //                       Text('عمر ماهر', style: TextStyle(fontWeight: FontWeight.bold)),
                            //                       SizedBox(width: 8),
                            //                       Row(children: List.generate(5, (i) => Icon(Icons.star, color: Colors.orange, size: 16))),
                            //                     ],
                            //                   ),
                            //                   SizedBox(height: 8),
                            //                   Text(
                            //                     'الحمد لله قفلت في الامتحان الزيادة وحده بفضل ربنا ثم حضرتك...',
                            //                     softWrap: true,
                            //                   ),
                            //                   SizedBox(height: 8),
                            //                   Row(
                            //                     children: [
                            //                       Icon(Icons.play_circle_fill, color: Colors.blue),
                            //                       Text('0:05')
                            //                     ],
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ),
                            //
                            //
                            //   ],
                            // )
                          ],
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
