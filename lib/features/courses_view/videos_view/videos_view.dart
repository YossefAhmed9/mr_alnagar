import 'dart:async';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/features/courses_view/quiz_view/exam_view.dart';
import 'package:mr_alnagar/features/profile_view/homework_results/home_work_results.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../core/cubits/courses_cubit/courses_state.dart';
import '../homework_view/home_work_view.dart';

class CourseVideoScreen extends StatefulWidget {
  final int videoIndex;
  const CourseVideoScreen({super.key, required this.videoIndex});

  @override
  _CourseVideoScreenState createState() => _CourseVideoScreenState();
}

class _CourseVideoScreenState extends State<CourseVideoScreen> {
  bool isFullScreen=false;
  late YoutubePlayerController controller;
  List<Map<String, dynamic>> _sections = [];
  bool isLoading = true;
  int currentVideoIndex = 0;
  final ScrollController scrollController = ScrollController();
bool hd=true;
  Timer? _watchTimer;
  int _sessionWatchSeconds = 0;
  bool _hasSeeked = false;
  int? _expandedSectionIndex;

  @override
  void initState() {
    super.initState();
    CoursesCubit.get(context).getVideosByCourse(id: widget.videoIndex,context: context);
    CoursesCubit.get(context).isCourseLoading=false;

     // _expandedSectionIndex = _sections.length - 1;

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _loadVideos();
  }

  Color getStatusColor(String status) {
    switch (status) {
      case 'not_started':
        return Colors.amber;
      case 'in_progress':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      default:
        return Colors.amber;
    }
  }

  String getStatusLabel(String status) {
    switch (status) {
      case 'not_started':
        return 'لم يبدأ بعد';
      case 'in_progress':
        return 'قيد التقدم';
      case 'completed':
        return 'مكتمل';
      default:
        return 'غير معروف';
    }
  }


  @override
  void dispose() {
    super.dispose();

    _watchTimer?.cancel();
    final currentPosition = controller.value.position;
    final videoId = _getCurrentVideoId();

    final video = _sections.expand((s) => s['videos']).firstWhere(
          (v) => v['index'] == currentVideoIndex,
      orElse: () => null,
    );
    if (video != null) {
      CacheHelper.setData(key: CacheKeys.lastSectionIndex, value: video['section_id']);
      CacheHelper.setData(key: CacheKeys.lastVideoIndex, value: video['id']);
    }

    if (videoId != null) {
      CoursesCubit.get(context).postVideoSeconds(
        videoId: videoId,
        lastWatchedSecond: currentPosition.inSeconds,
        watchSeconds: _sessionWatchSeconds,
      );
    }
    controller.pause();
    //controller.dispose();
  }

  int? _getCurrentVideoId() {
    for (final section in _sections) {
      for (final video in section['videos']) {
        if (video['index'] == currentVideoIndex) {
          return video['id'];
        }
      }
    }
    return null;
  }

  void _startTracking() {
    _watchTimer?.cancel();
    _watchTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      final position = controller.value.position;
      final watchedSeconds = position.inSeconds;
      _sessionWatchSeconds += 30;
      final videoId = _getCurrentVideoId();
      if (videoId != null) {
        await CoursesCubit.get(context).postVideoSeconds(
          videoId: videoId,
          lastWatchedSecond: watchedSeconds,
          watchSeconds: _sessionWatchSeconds,
        );
      }
    });
  }

  void _loadVideos() {
    final data = CoursesCubit.get(context).coursesVideos;
    final courseId = data['course_data']['course_id'];
    if (courseId != widget.videoIndex) return;

    int indexCounter = 0;
    List<Map<String, dynamic>> sectionsList = [];
    final sections = data['sections_data'] as List<dynamic>;

    final savedSectionId = CacheHelper.getData(key: CacheKeys.lastSectionIndex);
    final savedVideoId = CacheHelper.getData(key: CacheKeys.lastVideoIndex);
    Map<String, dynamic>? selectedVideo;

    // First, preprocess all videos and find the selected one
    for (var section in sections) {
      List<Map<String, dynamic>> videos = [];
      for (var video in section['videos']) {
        final videoUrl = utf8.decode(base64.decode(video['video_url']));
        final videoMap = {
          'index': indexCounter++,
          'section_id': section['id'],
          'id': video['id'],
          'title': video['title'],
          'video_url': videoUrl,
          'duration': video['duration'],
          'image': video['thumbnail'],
          'description': video['description'] ?? '',
          'last_watched_second': video['last_watched_second'] ?? 0,
          'status': video['status'],
        };
        videos.add(videoMap);

        if (section['id'] == savedSectionId && video['id'] == savedVideoId) {
          selectedVideo = videoMap;
        }
      }

      sectionsList.add({
        'short_title': section['short_title'],
        'title': section['title'],
        'attachment': section['attachment'],
        'has_quizzes': section['has_quizzes'],
        'has_homeworks': section['has_homeworks'],
        'quiz_attempted': section['quiz_attempted'],
        'quiz_required': section['quiz_required'],
        'videos': videos,
      });
    }

    // Select the initial video early
    final firstVideo = selectedVideo ?? sectionsList.first['videos'].first;
    final firstVideoId = YoutubePlayer.convertUrlToId(firstVideo['video_url']) ?? '';

    // Initialize controller as early as possible
    controller = YoutubePlayerController(
      initialVideoId: firstVideoId,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        enableCaption: false,
        hideThumbnail: true,
        showLiveFullscreenButton: true,
        forceHD: hd,
        useHybridComposition: true,
      ),
    );

    controller.addListener(() {
      if (!_hasSeeked && _sections.isNotEmpty) {
        final currentVideo = _sections
            .expand((s) => s['videos'])
            .firstWhere((v) => v['index'] == currentVideoIndex, orElse: () => null);

        if (currentVideo != null) {
          _hasSeeked = true;
          controller.seekTo(Duration(seconds: currentVideo['last_watched_second'] ?? 0));
          controller.pause();
          _startTracking();
        }
      }
    });

    // Now update state after controller setup
    setState(() {
      _sections = sectionsList;
      isLoading = false;
      currentVideoIndex = firstVideo['index'];
    });
  }

  void _playVideo(Map<String, dynamic> video) {
    final videoId = YoutubePlayer.convertUrlToId(video['video_url']);
    CacheHelper.setData(key: CacheKeys.lastSectionIndex, value: video['section_id']);
    CacheHelper.setData(key: CacheKeys.lastVideoIndex, value: video['id']);
    if (videoId != null) {
      controller.load(videoId);
      controller.seekTo(Duration(seconds: video['last_watched_second']));
      controller.play();

      setState(() {
        currentVideoIndex = video['index'];
        _sessionWatchSeconds = 0;
        _hasSeeked = true;
      });


    }
  }


  String _findSectionShortAndTitle(int videoIndex) {
    for (final section in _sections) {
      for (final video in section['videos']) {
        if (video['index'] == videoIndex) {
          final shortTitle = section['short_title'] ?? '';
          final title = section['title'] ?? '';
          return '$shortTitle - $title';
        }
      }
    }
    return '';
  }


  Widget _buildActionButton(BuildContext context, IconData icon, String label, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      splashColor: AppColors.primaryColor,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child:
        CoursesCubit.get(context).isCourseLoading ? CircularProgressIndicator()

         : Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyles.textStyle12w700(context).copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //print(    CacheHelper.getData(key: CacheKeys.lastSectionIndex));
    //print(    CoursesCubit.get(context).coursesVideos['sections_data'][3]['id']);
    return BlocBuilder<CoursesCubit, CoursesState>(
  builder: (context, state) {
    return Scaffold(
      appBar: isFullScreen ? null : AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back_ios_outlined,
          size:30,weight: 80,
          color: AppColors.primaryColor,),
        ),
        actions:[
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Text(CoursesCubit.get(context).courseResult[0]['title'], style: TextStyles.textStyle16w700(context)),
          )
        ],
          ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: CoursesCubit.get(context).coursesVideos == null
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                child: Column(
                            children: [
                              // Row(
                              //   children: [
                              //     Padding(
                              //       padding: const EdgeInsets.all(15.0),
                              //       child: Container(
                              //         decoration: BoxDecoration(),
                              //         child:
                              //         Text(CoursesCubit.get(context).courseResult[0]['title'], style: TextStyles.textStyle16w700(context)),
                              //       ),
                              //     ),
                              //     Spacer(),
                              //     IconButton(onPressed: (){
                              //       Navigator.pop(context);
                              //     }, icon: Icon(Icons.arrow_forward_ios_outlined,
                              //       size:30,weight: 80,
                              //       color: AppColors.primaryColor,),
                              //     ),
                              //   ],
                              // ),

                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    Directionality(
                                      textDirection: TextDirection.ltr,
                                      child: YoutubePlayerBuilder(
                                        onEnterFullScreen: () {

                                          setState(() {
                                            isFullScreen=true;
                                          });
                                          controller.fitWidth(Size.infinite);
                                          controller.fitHeight(Size.infinite);

                                          // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
                                          // SystemChrome.setPreferredOrientations([
                                          //   DeviceOrientation.landscapeLeft,
                                          //   DeviceOrientation.landscapeRight,
                                          // ]);
                                        },
                                        onExitFullScreen: () {
                                          isFullScreen=false;
                                          // SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
                                          // SystemChrome.setPreferredOrientations([
                                          //   DeviceOrientation.portraitUp,
                                          //   DeviceOrientation.portraitDown,
                                          // ]);
                                        },
                                        player: YoutubePlayer(
                                          controller: controller,
                                          bottomActions: [
                                            const SizedBox(width: 8.0),
                                             CurrentPosition(controller: controller,
                                             ),
                                            const SizedBox(width: 8.0),
                                             ProgressBar(isExpanded: true,controller:controller ,
                                              colors: ProgressBarColors(
                                                  backgroundColor: Colors.grey,
                                                  handleColor: Colors.green,
                                                  bufferedColor: Colors.white10,
                                                  playedColor: Colors.green),
                                            ),
                                            const SizedBox(width: 8.0),
                                             RemainingDuration(controller: controller,
                                             ),
                                            const SizedBox(width: 4.0),
                                             PlaybackSpeedButton(controller: controller,
                                             ),
                                            const SizedBox(width: 4.0),
                                            FullScreenButton(
                                              controller: controller,
                                            ),
                                          ],
                                          actionsPadding: EdgeInsets.symmetric(vertical: 10),
                                          showVideoProgressIndicator: true,

                                          controlsTimeOut: const Duration(minutes: 1),
                                          topActions: [
                                            IconButton(
                                              icon: Icon(hd
                                                  ? Icons.hd
                                                  : Icons.hd_outlined),
                                              onPressed: () {
                                                setState(() {
                                                  hd = !hd;
                                                });
                                              },
                                            ),
                                          ],
                                          progressIndicatorColor: Colors.red,onEnded: (value){
                                          if (kDebugMode) {
                                            print('ended ended ended ended ended ended ended ended');
                                          }
                                            CoursesCubit.get(context).postVideoSeconds(
                                            videoId: _getCurrentVideoId()!,
                                            lastWatchedSecond: controller.value.position.inSeconds,
                                            watchSeconds: _sessionWatchSeconds,
                                          );
                                        },
                                          onReady: () {
                                              // if (!_hasSeeked && _sections.isNotEmpty) {
                                              //   final currentVideo = _sections
                                              //       .expand((s) => s['videos'])
                                              //       .firstWhere((v) => v['index'] == currentVideoIndex, orElse: () => null);
                                              //
                                              //   if (currentVideo != null) {
                                              //     _hasSeeked = true;
                                              //     controller.seekTo(Duration(seconds: currentVideo['last_watched_second'] ?? 0));
                                              //     controller.pause(); // or play() based on your logic
                                              //     _startTracking();
                                              //   }
                                              // }

                                            controller.reload();
                                          },

                                        ), builder: (context, player) => Column(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: player,
                                          ),
                                          const SizedBox(height: 15),
                                          Row(

                                            children: [
                                              Expanded(
                                                child: Text(
                                                  _findSectionShortAndTitle(currentVideoIndex),
                                                  style: TextStyles.textStyle14w700(context).copyWith(color: AppColors.primaryColor),
                                                  maxLines: 3,textDirection: TextDirection.rtl,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              //const Spacer(),
                                              // Text(
                                              //   _sections.expand((s) => s['videos']).toList()[currentVideoIndex]['title'],
                                              //   style: const TextStyle(
                                              //     fontSize: 18,
                                              //     fontWeight: FontWeight.bold,
                                              //   ),
                                              // ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            _sections.expand((s) => s['videos']).toList()[currentVideoIndex]['description'],
                                            style: TextStyle(color: Colors.grey[700]),
                                          ),
                                          //const SizedBox(height: 10),
                                        ],
                                      ),
                                      ),
                                    ),
                                    //const SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      height: MediaQuery.sizeOf(context).height * 0.52,
                                      // margin: const EdgeInsets.all(12),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                                      decoration: BoxDecoration(
                                        color: AppColors.secondary8,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: SizedBox(
                                        child: RefreshIndicator(
                                          triggerMode: RefreshIndicatorTriggerMode.anywhere,
                                          onRefresh: ()async{
                                            CoursesCubit.get(context).coursesVideos=null;
                                            //controller.reload();
                                            // SystemChrome.setPreferredOrientations([
                                            //   DeviceOrientation.portraitUp,
                                            //   DeviceOrientation.portraitDown,
                                            // ]);
                                            await CoursesCubit.get(context).getVideosByCourse(id:
                                            CoursesCubit.get(context).courseResult[0]['id'], context: context,).then((value){
                                            });
                                            //_loadVideos();
                                            return  CoursesCubit.get(context).getVideosByCourse(id:
                                            CoursesCubit.get(context).courseResult[0]['id'], context: context,).then((value){
                                            });



                                          },
                                          child: Scrollbar(
                                            controller: scrollController,
                                            child: ListView.builder(
                                              controller: scrollController,
                                              itemCount: _sections.length,
                                              physics: ScrollPhysics(),
                                              itemBuilder: (context, sectionIndex) {
                                                var section = _sections[sectionIndex];
                                                var isExpanded = _expandedSectionIndex == sectionIndex;

                                                return Container(
                                                  margin: const EdgeInsets.only(bottom: 12),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: ExpansionTile(
                                                    trailing: Icon(Icons.keyboard_arrow_down_outlined, color: AppColors.primaryColor, size: 45),
                                                    onExpansionChanged: (expanded) {
                                                      setState(() {
                                                       // CacheHelper.setData(key: CacheKeys.lastSectionIndex,value: sectionIndex+1);
                                                        print(CacheHelper.getData(key: CacheKeys.lastSectionIndex));

                                                        _expandedSectionIndex = expanded ? sectionIndex : null;
                                                      });
                                                    },
                                                    initiallyExpanded: CacheHelper.getData(key: CacheKeys.lastSectionIndex)==CoursesCubit.get(context).coursesVideos['sections_data'][3]['id'],
                                                    title: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          section['short_title'] ?? '',
                                                          style: TextStyles.textStyle16w700(context).copyWith(color: AppColors.primaryColor),
                                                        ),
                                                        const SizedBox(height: 8),
                                                        Wrap(
                                                          spacing: 5,
                                                          children: [
                                                            section['attachment'] != null
                                                                ? _buildActionButton(
                                                              context,
                                                              Icons.picture_as_pdf_outlined,
                                                              'تحميل المذكرة',
                                                                  () async {
                                                                var url = CoursesCubit.get(context).coursesVideos[sectionIndex]['attachment'];
                                                                if (url != null && url.toString().isNotEmpty) {
                                                                  var uri = Uri.parse(url);
                                                                  if (await canLaunchUrl(uri)) {
                                                                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                                                                  } else {
                                                                   CoursesCubit.get(context).showSnackBar(context, 'تعذر فتح الرابط', 3, Colors.red);
                                                                  }
                                                                } else {
                                                                  CoursesCubit.get(context).showSnackBar(context, 'لا يوجد ملف مرفق', 3, Colors.orange);
                                                                }
                                                              },
                                                            )
                                                                : Container(),
                                                            section['has_homeworks'] == true
                                                                ? _buildActionButton(context, Icons.assignment, 'حل الواجب', () async {
                                                              controller.pause();
                                                              await CoursesCubit.get(context).startHomework(
                                                                homeworkId: CoursesCubit.get(context).coursesVideos['sections_data'][sectionIndex]['homework_id'],
                                                              );

                                                              Navigator.push(context, CupertinoPageRoute(
                                                                builder: (context) {
                                                                  return HomeworkView(
                                                                    homeworkID: CoursesCubit.get(context).coursesVideos['sections_data'][sectionIndex]['homework_id'],
                                                                  );
                                                                },
                                                              ));
                                                            })
                                                                : Container(),
                                                            section['has_quizzes'] == true
                                                                ? _buildActionButton(context, Icons.quiz, 'عرض الامتحان', () async {
                                                              controller.pause;
                                                              CoursesCubit.get(context).changeIsCourseLoading();
                                                              await CoursesCubit.get(context).startQuiz(
                                                                quizId: CoursesCubit.get(context).coursesVideos['sections_data'][sectionIndex]['quiz_id'],
                                                              );

                                                              showDialog(
                                                                context: context,
                                                                barrierDismissible: true,
                                                                builder: (context) => WillPopScope(
                                                                  onWillPop: () async => false,
                                                                  child: Directionality(
                                                                    textDirection: TextDirection.rtl,
                                                                    child: AlertDialog(
                                                                      backgroundColor: Colors.white,
                                                                      title: Text('تنبيهات مهمة', textAlign: TextAlign.center),
                                                                      titleTextStyle: TextStyles.textStyle16w700(context).copyWith(color: AppColors.secondary),
                                                                      content: SingleChildScrollView(
                                                                        child: Column(
                                                                          children: [
                                                                            Image.asset('assets/images/pic2.png'),
                                                                            Container(
                                                                              decoration: BoxDecoration(
                                                                                color: const Color(0xFFFDF3D0),
                                                                                borderRadius: BorderRadius.circular(15),
                                                                              ),
                                                                              child: Column(
                                                                                children: [
                                                                                  CoursesCubit.get(context).quiz == null
                                                                                      ? const Center(child: CircularProgressIndicator())
                                                                                      : Padding(
                                                                                    padding: const EdgeInsets.all(8.0),
                                                                                    child: Text(
                                                                                      HtmlUnescape().convert(
                                                                                        CoursesCubit.get(context)
                                                                                            .quiz['quiz']['description']
                                                                                            .replaceAll(RegExp(r'<style[^>]*>[\s\S]*?</style>', caseSensitive: false), '')
                                                                                            .replaceAll(RegExp(r'<[^>]+>'), '')
                                                                                            .replaceAll(RegExp(r'\s+'), ' ')
                                                                                            .trim(),
                                                                                      ),
                                                                                      style: TextStyles.textStyle16w700(context).copyWith(color: AppColors.secondary),
                                                                                      textDirection: TextDirection.rtl,
                                                                                      textAlign: TextAlign.right,
                                                                                    ),
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        color: AppColors.primaryColor,
                                                                                        borderRadius: BorderRadius.circular(25),
                                                                                      ),
                                                                                      width: double.infinity,
                                                                                      height: 44,
                                                                                      child: MaterialButton(
                                                                                        onPressed: () async {
                                                                                          controller.pause();
                                                                                          await CoursesCubit.get(context).startQuiz(
                                                                                            quizId: CoursesCubit.get(context)
                                                                                                .coursesVideos['sections_data'][sectionIndex]['quiz_id'],
                                                                                          );
                                                                                          //Navigator.pop(context);
                                                                                          Navigator.pushAndRemoveUntil(
                                                                                            context,
                                                                                            CupertinoPageRoute(
                                                                                              builder: (context) => ExamView(
                                                                                                quizID: CoursesCubit.get(context)
                                                                                                    .coursesVideos['sections_data'][sectionIndex]['quiz_id'],
                                                                                              ),
                                                                                            ),
                                                                                              (route)=>false
                                                                                          );
                                                                                        },
                                                                                        child: Text(
                                                                                          'ابدا الامتحان',
                                                                                          style: TextStyles.textStyle16w700(context).copyWith(color: Colors.white),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            })
                                                                : Container(),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    children: section['videos'].map<Widget>((video) {
                                                      final currentVideo = _sections.expand((s) => s['videos']).toList()[currentVideoIndex];
                                                      final isCurrentVideo = currentVideo['id'] == video['id'];

                                                      return InkWell(
                                                        onTap: () {

                                                          //CacheHelper.setData(key: CacheKeys.lastSectionIndex, value: sectionIndex);
                                                          final parentSection = _sections[sectionIndex];
                                                          final hasQuiz = parentSection['has_quizzes'];
                                                          //final quizAttempted = parentSection['quiz_attempted'];

                                                          if (hasQuiz == true && parentSection['quiz_required'] == 1) {
                                                            showDialog(
                                                              context: context,
                                                              builder: (context) => AlertDialog(
                                                                backgroundColor: Colors.white,
                                                                title: Text('تنبيه', textAlign: TextAlign.center),
                                                                titleTextStyle: TextStyles.textStyle16w700(context).copyWith(color: AppColors.secondary),
                                                                content: Text(
                                                                  'يجب عليك الدخول إلى الامتحان أولاً لمشاهدة الفيديوهات',
                                                                  textAlign: TextAlign.center,
                                                                  style: TextStyles.textStyle16w700(context),
                                                                ),
                                                                actionsAlignment: MainAxisAlignment.center,
                                                                actionsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                                                actions: [
                                                                  TextButton(
                                                                    style: TextButton.styleFrom(
                                                                      backgroundColor: Colors.grey[200],
                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                                                      padding: const EdgeInsets.symmetric(horizontal: 24),
                                                                    ),
                                                                    onPressed: () => Navigator.pop(context),
                                                                    child: Text('إلغاء', style: TextStyles.textStyle16w700(context).copyWith(color: AppColors.secondary)),
                                                                  ),
                                                                  SizedBox(width: 12),
                                                                  TextButton(
                                                                    style: TextButton.styleFrom(
                                                                      backgroundColor: AppColors.primaryColor,
                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                                                      padding: const EdgeInsets.symmetric(horizontal: 24),
                                                                    ),
                                                                    onPressed: () async {
                                                                      controller.pause();
                                                                      await CoursesCubit.get(context).startQuiz(
                                                                        quizId: CoursesCubit.get(context).coursesVideos['sections_data'][sectionIndex]['quiz_id'],
                                                                      );

                                                                      showDialog(
                                                                        context: context,
                                                                        barrierDismissible: true,
                                                                        builder: (context) => WillPopScope(
                                                                          onWillPop: () async => false,
                                                                          child: Directionality(
                                                                            textDirection: TextDirection.rtl,
                                                                            child: AlertDialog(
                                                                              backgroundColor: Colors.white,
                                                                              title: Text('تنبيهات مهمة', textAlign: TextAlign.center),
                                                                              titleTextStyle: TextStyles.textStyle16w700(context).copyWith(color: AppColors.secondary),
                                                                              content: SingleChildScrollView(
                                                                                child: Column(
                                                                                  children: [
                                                                                    Image.asset('assets/images/pic2.png'),
                                                                                    Container(
                                                                                      decoration: BoxDecoration(
                                                                                        color: const Color(0xFFFDF3D0),
                                                                                        borderRadius: BorderRadius.circular(15),
                                                                                      ),
                                                                                      child: Column(
                                                                                        children: [
                                                                                          CoursesCubit.get(context).quiz == null
                                                                                              ? const Center(child: CircularProgressIndicator())
                                                                                              : Padding(
                                                                                            padding: const EdgeInsets.all(8.0),
                                                                                            child: Text(
                                                                                              HtmlUnescape().convert(
                                                                                                CoursesCubit.get(context)
                                                                                                    .quiz['quiz']['description']
                                                                                                    .replaceAll(RegExp(r'<style[^>]*>[\s\S]*?</style>', caseSensitive: false), '')
                                                                                                    .replaceAll(RegExp(r'<[^>]+>'), '')
                                                                                                    .replaceAll(RegExp(r'\s+'), ' ')
                                                                                                    .trim(),
                                                                                              ),
                                                                                              style: TextStyles.textStyle16w700(context).copyWith(color: AppColors.secondary),
                                                                                              textDirection: TextDirection.rtl,
                                                                                              textAlign: TextAlign.right,
                                                                                            ),
                                                                                          ),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
                                                                                            child: Container(
                                                                                              decoration: BoxDecoration(
                                                                                                color: AppColors.primaryColor,
                                                                                                borderRadius: BorderRadius.circular(25),
                                                                                              ),
                                                                                              width: double.infinity,
                                                                                              height: 44,
                                                                                              child: MaterialButton(
                                                                                                onPressed: () async {
                                                                                                  controller.pause();
                                                                                                  await CoursesCubit.get(context).startQuiz(
                                                                                                    quizId: CoursesCubit.get(context)
                                                                                                        .coursesVideos['sections_data'][sectionIndex]['quiz_id'],
                                                                                                  );
                                                                                                  Navigator.pop(context);
                                                                                                  Navigator.pushAndRemoveUntil(
                                                                                                    context,
                                                                                                    CupertinoPageRoute(
                                                                                                      builder: (context) => ExamView(
                                                                                                        quizID: CoursesCubit.get(context)
                                                                                                            .coursesVideos['sections_data'][sectionIndex]['quiz_id'],
                                                                                                      ),
                                                                                                    ),
                                                                                                        (context) => false,
                                                                                                  );
                                                                                                },
                                                                                                child: Text(
                                                                                                  'ابدا الامتحان',
                                                                                                  style: TextStyles.textStyle16w700(context).copyWith(color: Colors.white),
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      );
                                                                    },
                                                                    child: Text('دخول الامتحان', style: TextStyles.textStyle16w700(context).copyWith(color: Colors.white)),
                                                                  ),
                                                                ],
                                                              ),
                                                            );

                                                            return;
                                                          }

                                                          _playVideo(video);
                                                        },
                                                        child: Container(
                                                          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                                          padding: const EdgeInsets.all(8),
                                                          decoration: BoxDecoration(
                                                            color: isCurrentVideo ? AppColors.primaryColor.withOpacity(0.05) : Colors.white,
                                                            border: isCurrentVideo ? Border.all(color: AppColors.primaryColor, width: 2) : null,
                                                            borderRadius: BorderRadius.circular(12),
                                                            boxShadow: [
                                                              BoxShadow(
                                                                color: Colors.black12,
                                                                blurRadius: 4,
                                                                offset: const Offset(0, 2),
                                                              ),
                                                            ],
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius: BorderRadius.circular(12),
                                                                child: Stack(
                                                                  children: [
                                                                    Image.network(
                                                                      video['image'],
                                                                      width: 120,
                                                                      height: 80,
                                                                      fit: BoxFit.cover,
                                                                      errorBuilder: (context, error, stackTrace) {
                                                                        return Image.asset('assets/images/error image.png', fit: BoxFit.cover,height: 80,width: 120,);
                                                                      },
                                                                    ),
                                                                    Container(
                                                                      width: 120,
                                                                      height: 80,
                                                                      alignment: Alignment.bottomRight,
                                                                      padding: const EdgeInsets.all(4),
                                                                      child: Text(
                                                                        video['duration'],
                                                                        style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.w900),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(width: 12),
                                                              Expanded(
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: [
                                                                    Text(
                                                                      video['title'],
                                                                      style: TextStyles.textStyle16w700(context).copyWith(color: AppColors.secondary),
                                                                    ),
                                                                    if (video['status'] != null)
                                                                      Container(
                                                                        margin: const EdgeInsets.symmetric(vertical: 4),
                                                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                                        decoration: BoxDecoration(
                                                                          color: getStatusColor(video['status']),
                                                                          borderRadius: BorderRadius.circular(12),
                                                                        ),
                                                                        child: Text(
                                                                          getStatusLabel(video['status']),
                                                                          style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    if (isCurrentVideo)
                                                                      Row(
                                                                        children: [
                                                                          Icon(Icons.play_circle_fill, color: AppColors.primaryColor, size: 16),
                                                                          const SizedBox(width: 4),
                                                                          Text(
                                                                            'الفيديو الحالي',
                                                                            style: TextStyle(color: AppColors.primaryColor, fontSize: 12, fontWeight: FontWeight.bold),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    const SizedBox(height: 4),
                                                                    if (video['description'] != null)
                                                                      Text(
                                                                        video['description'],
                                                                        maxLines: 2,
                                                                        overflow: TextOverflow.ellipsis,
                                                                        style: TextStyle(color: Colors.grey[700], fontSize: 12),
                                                                      ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                );
                                              },
                                            )
                                            ,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
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
