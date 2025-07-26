import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_cubit.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/features/courses_view/quiz_view/exam_view.dart';
import 'package:mr_alnagar/features/profile_view/homework_results/home_work_results.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../homework_view/home_work_view.dart';

class LessonVideoScreen extends StatefulWidget {
  final int videoIndex;
  const LessonVideoScreen({super.key, required this.videoIndex});

  @override
  _LessonVideoScreenState createState() => _LessonVideoScreenState();
}

class _LessonVideoScreenState extends State<LessonVideoScreen> {
  late YoutubePlayerController controller;
  List<Map<String, dynamic>> _sections = [];
  bool isLoading = true;
  int currentVideoIndex = 0;
  final ScrollController scrollController = ScrollController();
  bool hd = true;
  Timer? _watchTimer;
  int _sessionWatchSeconds = 0;
  bool _hasSeeked = false;
  int? _expandedSectionIndex;

  @override
  void initState() {
    super.initState();
    LessonsCubit.get(
      context,
    ).getVideosByLesson(id: widget.videoIndex, context: context);
    LessonsCubit.get(context).changeIsLessonLoading();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _loadVideos();
  }

  @override
  void dispose() {
    _watchTimer?.cancel();
    final currentPosition = controller.value.position;
    final videoId = _getCurrentVideoId();

    final video = _sections
        .expand((s) => s['videos'])
        .firstWhere((v) => v['index'] == currentVideoIndex, orElse: () => null);
    if (video != null) {
      CacheHelper.setData(
        key: CacheKeys.lastSectionIndex,
        value: video['section_id'],
      );
      CacheHelper.setData(key: CacheKeys.lastVideoIndex, value: video['id']);
    }

    if (videoId != null) {
      LessonsCubit.get(context).postVideoSeconds(
        videoId: videoId,
        lastWatchedSecond: currentPosition.inSeconds,
        watchSeconds: _sessionWatchSeconds,
      );
    }
    controller.pause();
    controller.dispose();
    super.dispose();
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
        await LessonsCubit.get(context).postVideoSeconds(
          videoId: videoId,
          lastWatchedSecond: watchedSeconds,
          watchSeconds: _sessionWatchSeconds,
        );
      }
    });
  }

  void _loadVideos() {
    final data = LessonsCubit.get(context).LessonsVideos;
    final courseId = data['course_data']['course_id'];
    if (courseId != widget.videoIndex) return;

    int indexCounter = 0;
    List<Map<String, dynamic>> sectionsList = [];
    final sections = data['sections_data'] as List<dynamic>;

    final savedSectionId = CacheHelper.getData(key: CacheKeys.lastSectionIndex);
    final savedVideoId = CacheHelper.getData(key: CacheKeys.lastVideoIndex);
    Map<String, dynamic>? selectedVideo;

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

    final firstVideo = selectedVideo ?? sectionsList.first['videos'].first;
    final firstVideoId =
        YoutubePlayer.convertUrlToId(firstVideo['video_url']) ?? '';

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
      if (controller.value.isReady && !_hasSeeked) {
        _hasSeeked = true;
        controller.seekTo(Duration(seconds: firstVideo['last_watched_second']));
        controller.play();
        _startTracking();
      }
    });

    setState(() {
      _sections = sectionsList;
      isLoading = false;
      currentVideoIndex = firstVideo['index'];
    });
  }

  void _playVideo(Map<String, dynamic> video) {
    final videoId = YoutubePlayer.convertUrlToId(video['video_url']);
    CacheHelper.setData(
      key: CacheKeys.lastSectionIndex,
      value: video['section_id'],
    );
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

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child:
            LessonsCubit.get(context).isLessonLoading
                ? CircularProgressIndicator()
                : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 16, color: Colors.white),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: TextStyles.textStyle12w700(
                        context,
                      ).copyWith(color: Colors.white),
                    ),
                  ],
                ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        shrinkWrap: true,

        scrollDirection: Axis.vertical,
        slivers: [
          SliverToBoxAdapter(
            child: RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: () {
                controller.reload();
                SystemChrome.setPreferredOrientations([
                  DeviceOrientation.portraitUp,
                  DeviceOrientation.portraitDown,
                ]);
                controller.reload();

                _loadVideos();
                return LessonsCubit.get(
                  context,
                ).getVideosByLesson(id: widget.videoIndex, context: context);
              },
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: SafeArea(
                  child:
                      LessonsCubit.get(context).LessonsVideos == null
                          ? const Center(child: CircularProgressIndicator())
                          : Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    child: Text(
                                      LessonsCubit.get(
                                        context,
                                      ).lessonResult[0]['title'],
                                      style: TextStyles.textStyle16w700(
                                        context,
                                      ),
                                    ),
                                  ),
                                ),

                                _sections.isEmpty
                                    ? Container()
                                    : YoutubePlayerBuilder(
                                      onEnterFullScreen: () {
                                        SystemChrome.setEnabledSystemUIMode(
                                          SystemUiMode.immersiveSticky,
                                        );
                                        SystemChrome.setPreferredOrientations([
                                          DeviceOrientation.landscapeLeft,
                                          DeviceOrientation.landscapeRight,
                                        ]);
                                      },
                                      onExitFullScreen: () {
                                        SystemChrome.setEnabledSystemUIMode(
                                          SystemUiMode.edgeToEdge,
                                        );
                                        SystemChrome.setPreferredOrientations([
                                          DeviceOrientation.portraitUp,
                                          DeviceOrientation.portraitDown,
                                        ]);
                                      },
                                      player: YoutubePlayer(
                                        controller: controller,
                                        bottomActions: [
                                          const SizedBox(width: 8.0),
                                          const CurrentPosition(),
                                          const SizedBox(width: 8.0),
                                          const ProgressBar(isExpanded: true),
                                          const SizedBox(width: 8.0),
                                          const RemainingDuration(),
                                          const SizedBox(width: 4.0),
                                          const PlaybackSpeedButton(),
                                          const SizedBox(width: 4.0),
                                          FullScreenButton(
                                            controller: controller,
                                          ),
                                        ],
                                        progressColors: ProgressBarColors(
                                          playedColor: Colors.orange,
                                          handleColor: Colors.deepOrange,
                                          bufferedColor: Colors.grey,
                                          backgroundColor: Colors.orange[500],
                                        ),
                                        showVideoProgressIndicator: true,
                                        controlsTimeOut: const Duration(
                                          minutes: 1,
                                        ),
                                        topActions: [
                                          IconButton(
                                            icon: Icon(
                                              hd ? Icons.hd : Icons.hd_outlined,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                hd = !hd;
                                              });
                                            },
                                          ),
                                        ],
                                        progressIndicatorColor: Colors.red,
                                        onReady: () {},
                                      ),
                                      builder:
                                          (context, player) => Column(
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                child: player,
                                              ),
                                              const SizedBox(height: 15),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      _findSectionShortAndTitle(
                                                        currentVideoIndex,
                                                      ),
                                                      style:
                                                          TextStyles.textStyle14w700(
                                                            context,
                                                          ).copyWith(
                                                            color:
                                                                AppColors
                                                                    .primaryColor,
                                                          ),
                                                      maxLines: 3,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  //const Spacer(),
                                                  Text(
                                                    _sections
                                                        .expand(
                                                          (s) => s['videos'],
                                                        )
                                                        .toList()[currentVideoIndex]['title'],
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                _sections
                                                    .expand((s) => s['videos'])
                                                    .toList()[currentVideoIndex]['description'],
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                              //const SizedBox(height: 10),
                                            ],
                                          ),
                                    ),

                                //const SizedBox(height: 8),
                                _sections.isEmpty
                                    ? Center(
                                      child: Text(
                                        'لا توجد فيديوهات حاليا, ستتوفر قريبا',
                                        style: TextStyles.textStyle16w700(
                                          context,
                                        ).copyWith(
                                          color: AppColors.primaryColor,
                                        ),
                                      ),
                                    )
                                    : Expanded(
                                      child: Container(
                                        // margin: const EdgeInsets.all(12),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.secondary8,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: Scrollbar(
                                          controller: scrollController,
                                          child: ListView.builder(
                                            controller: scrollController,
                                            itemCount: _sections.length,
                                            itemBuilder: (
                                              context,
                                              sectionIndex,
                                            ) {
                                              final section =
                                                  _sections[sectionIndex];
                                              final isExpanded =
                                                  _expandedSectionIndex ==
                                                  sectionIndex;
                                              return Container(
                                                margin: const EdgeInsets.only(
                                                  bottom: 12,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                child: ExpansionTile(
                                                  trailing: Icon(
                                                    Icons
                                                        .keyboard_arrow_down_outlined,
                                                    color:
                                                        AppColors.primaryColor,
                                                    size: 45,
                                                  ),
                                                  onExpansionChanged: (
                                                    expanded,
                                                  ) {
                                                    setState(() {
                                                      _expandedSectionIndex =
                                                          expanded
                                                              ? sectionIndex
                                                              : null;
                                                    });
                                                  },
                                                  initiallyExpanded: isExpanded,
                                                  title: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        section['short_title'] ??
                                                            '',
                                                        style: TextStyles.textStyle16w700(
                                                          context,
                                                        ).copyWith(
                                                          color:
                                                              AppColors
                                                                  .primaryColor,
                                                        ),
                                                      ),
                                                      Text(
                                                        section['title'],
                                                        style: TextStyles.textStyle14w700(
                                                          context,
                                                        ).copyWith(
                                                          color:
                                                              AppColors
                                                                  .secondary80,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Row(
                                                        children: [
                                                          section['attachment'] !=
                                                                  null
                                                              ? _buildActionButton(
                                                                context,
                                                                Icons
                                                                    .picture_as_pdf_outlined,
                                                                'تحميل المذكرة',
                                                                () {},
                                                              )
                                                              : Container(),
                                                          section['has_homeworks'] ==
                                                                  true
                                                              ? _buildActionButton(
                                                                context,
                                                                Icons
                                                                    .assignment,
                                                                'حل الواجب',
                                                                () async {
                                                                  controller
                                                                      .pause();
                                                                  await LessonsCubit.get(
                                                                    context,
                                                                  ).startHomework(
                                                                    homeworkId:
                                                                        LessonsCubit.get(
                                                                          context,
                                                                        ).LessonsVideos['sections_data'][sectionIndex]['homework_id'],
                                                                  );

                                                                  Navigator.push(
                                                                    context,
                                                                    CupertinoPageRoute(
                                                                      builder: (
                                                                        context,
                                                                      ) {
                                                                        return LessonsHomeworkView(
                                                                          homeworkID:
                                                                              LessonsCubit.get(
                                                                                context,
                                                                              ).LessonsVideos['sections_data'][sectionIndex]['homework_id'],
                                                                        );
                                                                      },
                                                                    ),
                                                                  );
                                                                },
                                                              )
                                                              : Container(),
                                                          section['has_quizzes'] ==
                                                                  true
                                                              ? _buildActionButton(
                                                                context,
                                                                Icons.quiz,
                                                                'عرض الامتحان',
                                                                () async {
                                                                  LessonsCubit.get(
                                                                    context,
                                                                  ).changeIsLessonLoading();
                                                                  await LessonsCubit.get(
                                                                    context,
                                                                  ).startQuiz(
                                                                    quizId:
                                                                        LessonsCubit.get(
                                                                          context,
                                                                        ).LessonsVideos['sections_data'][sectionIndex]['quiz_id'],
                                                                  );
                                                                  print(
                                                                    LessonsCubit.get(
                                                                      context,
                                                                    ).LessonsVideos['sections_data'][sectionIndex]['quiz_id'],
                                                                  );
                                                                  showDialog(
                                                                    context:
                                                                        context,
                                                                    barrierDismissible:
                                                                        true,
                                                                    builder:
                                                                        (
                                                                          context,
                                                                        ) => WillPopScope(
                                                                          onWillPop:
                                                                              () async =>
                                                                                  false,
                                                                          child: Directionality(
                                                                            textDirection:
                                                                                TextDirection.rtl,
                                                                            child: AlertDialog(
                                                                              backgroundColor:
                                                                                  Colors.white,
                                                                              title: Text(
                                                                                'تنبيهات مهمة',
                                                                                textAlign:
                                                                                    TextAlign.center,
                                                                              ),
                                                                              titleTextStyle: TextStyles.textStyle16w700(
                                                                                context,
                                                                              ).copyWith(
                                                                                color:
                                                                                    AppColors.secondary,
                                                                              ),
                                                                              content: SingleChildScrollView(
                                                                                child: Column(
                                                                                  children: [
                                                                                    Image.asset(
                                                                                      'assets/images/pic2.png',
                                                                                    ),
                                                                                    Container(
                                                                                      decoration: BoxDecoration(
                                                                                        color: const Color(
                                                                                          0xFFFDF3D0,
                                                                                        ), // keeping your inner box color
                                                                                        borderRadius: BorderRadius.circular(
                                                                                          15,
                                                                                        ),
                                                                                      ),
                                                                                      child: Column(
                                                                                        children: [
                                                                                          LessonsCubit.get(
                                                                                                    context,
                                                                                                  ).quiz ==
                                                                                                  null
                                                                                              ? const Center(
                                                                                                child:
                                                                                                    CircularProgressIndicator(),
                                                                                              )
                                                                                              : Padding(
                                                                                                padding: const EdgeInsets.all(
                                                                                                  8.0,
                                                                                                ),
                                                                                                child: Text(
                                                                                                  HtmlUnescape()
                                                                                                      .convert(
                                                                                                        LessonsCubit.get(
                                                                                                          context,
                                                                                                        ).quiz['quiz']['description'],
                                                                                                      )
                                                                                                      .replaceAll(
                                                                                                        RegExp(
                                                                                                          r'<[^>]*>',
                                                                                                        ),
                                                                                                        '',
                                                                                                      ),
                                                                                                  style: TextStyles.textStyle16w700(
                                                                                                    context,
                                                                                                  ).copyWith(
                                                                                                    color:
                                                                                                        AppColors.secondary,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                          Padding(
                                                                                            padding: const EdgeInsets.symmetric(
                                                                                              horizontal:
                                                                                                  16.0,
                                                                                              vertical:
                                                                                                  16,
                                                                                            ),
                                                                                            child: Container(
                                                                                              decoration: BoxDecoration(
                                                                                                color:
                                                                                                    AppColors.primaryColor,
                                                                                                borderRadius: BorderRadius.circular(
                                                                                                  25,
                                                                                                ),
                                                                                              ),
                                                                                              width:
                                                                                                  double.infinity,
                                                                                              height:
                                                                                                  44,
                                                                                              child: MaterialButton(
                                                                                                onPressed: () async {
                                                                                                  controller.pause();
                                                                                                  await LessonsCubit.get(
                                                                                                    context,
                                                                                                  ).startQuiz(
                                                                                                    quizId:
                                                                                                        LessonsCubit.get(
                                                                                                          context,
                                                                                                        ).LessonsVideos['sections_data'][sectionIndex]['quiz_id'],
                                                                                                  );
                                                                                                  Navigator.pushAndRemoveUntil(
                                                                                                    context,
                                                                                                    CupertinoPageRoute(
                                                                                                      builder: (
                                                                                                        context,
                                                                                                      ) {
                                                                                                        return ExamView(
                                                                                                          quizID:
                                                                                                              LessonsCubit.get(
                                                                                                                context,
                                                                                                              ).LessonsVideos['sections_data'][sectionIndex]['quiz_id'],
                                                                                                        );
                                                                                                      },
                                                                                                    ),
                                                                                                    (
                                                                                                      context,
                                                                                                    ) =>
                                                                                                        false,
                                                                                                  );
                                                                                                },
                                                                                                child: Text(
                                                                                                  'ابدا الامتحان',
                                                                                                  style: TextStyles.textStyle16w700(
                                                                                                    context,
                                                                                                  ).copyWith(
                                                                                                    color:
                                                                                                        Colors.white,
                                                                                                  ),
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
                                                              )
                                                              : Container(),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  children:
                                                      section['videos'].map<
                                                        Widget
                                                      >((video) {
                                                        return InkWell(
                                                          onTap: () {
                                                            final parentSection =
                                                                _sections[sectionIndex];
                                                            final hasQuiz =
                                                                parentSection['has_quizzes'];
                                                            final quizAttempted =
                                                                parentSection['quiz_attempted'];
                                                            print(
                                                              '**********************',
                                                            );
                                                            print(
                                                              parentSection['quiz_required'],
                                                            );
                                                            print(
                                                              '**********************',
                                                            );

                                                            if (hasQuiz ==
                                                                    true &&
                                                                quizAttempted ==
                                                                    false &&
                                                                parentSection['quiz_required'] ==
                                                                    1) {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (
                                                                      context,
                                                                    ) => AlertDialog(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      title: Text(
                                                                        'تنبيه',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                      ),
                                                                      titleTextStyle: TextStyles.textStyle16w700(
                                                                        context,
                                                                      ).copyWith(
                                                                        color:
                                                                            AppColors.secondary,
                                                                      ),
                                                                      content: Text(
                                                                        'يجب عليك الدخول إلى الامتحان أولاً لمشاهدة الفيديوهات',
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: TextStyles.textStyle16w700(
                                                                          context,
                                                                        ),
                                                                      ),
                                                                      actionsAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      actionsPadding: const EdgeInsets.symmetric(
                                                                        horizontal:
                                                                            12,
                                                                        vertical:
                                                                            12,
                                                                      ),
                                                                      actions: [
                                                                        SizedBox(
                                                                          height:
                                                                              44,
                                                                          child: TextButton(
                                                                            style: TextButton.styleFrom(
                                                                              backgroundColor:
                                                                                  Colors.grey[200],
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(
                                                                                  25,
                                                                                ),
                                                                              ),
                                                                              padding: const EdgeInsets.symmetric(
                                                                                horizontal:
                                                                                    24,
                                                                              ),
                                                                            ),
                                                                            onPressed:
                                                                                () => Navigator.pop(
                                                                                  context,
                                                                                ),
                                                                            child: Text(
                                                                              'إلغاء',
                                                                              style: TextStyles.textStyle16w700(
                                                                                context,
                                                                              ).copyWith(
                                                                                color:
                                                                                    AppColors.secondary,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              12,
                                                                        ),
                                                                        SizedBox(
                                                                          height:
                                                                              44,
                                                                          child: TextButton(
                                                                            style: TextButton.styleFrom(
                                                                              backgroundColor:
                                                                                  AppColors.primaryColor,
                                                                              shape: RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.circular(
                                                                                  25,
                                                                                ),
                                                                              ),
                                                                              padding: const EdgeInsets.symmetric(
                                                                                horizontal:
                                                                                    24,
                                                                              ),
                                                                            ),
                                                                            onPressed: () async {
                                                                              await LessonsCubit.get(
                                                                                context,
                                                                              ).startQuiz(
                                                                                quizId:
                                                                                    LessonsCubit.get(
                                                                                      context,
                                                                                    ).LessonsVideos['sections_data'][sectionIndex]['quiz_id'],
                                                                              );
                                                                              Navigator.pop(
                                                                                context,
                                                                              );
                                                                              Navigator.push(
                                                                                context,
                                                                                CupertinoPageRoute(
                                                                                  builder:
                                                                                      (
                                                                                        _,
                                                                                      ) => ExamView(
                                                                                        quizID:
                                                                                            section['quiz_id'],
                                                                                      ),
                                                                                ),
                                                                              );
                                                                            },
                                                                            child: Text(
                                                                              'دخول الامتحان',
                                                                              style: TextStyles.textStyle16w700(
                                                                                context,
                                                                              ).copyWith(
                                                                                color:
                                                                                    Colors.white,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                              );

                                                              return;
                                                            }

                                                            _playVideo(video);
                                                          },
                                                          child: Container(
                                                            margin:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 6,
                                                                ),
                                                            padding:
                                                                const EdgeInsets.all(
                                                                  8,
                                                                ),
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              border:
                                                                  video['index'] ==
                                                                          currentVideoIndex
                                                                      ? Border.all(
                                                                        color:
                                                                            AppColors.primaryColor,
                                                                        width:
                                                                            2,
                                                                      )
                                                                      : null,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    12,
                                                                  ),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color:
                                                                      Colors
                                                                          .black12,
                                                                  blurRadius: 4,
                                                                  offset:
                                                                      const Offset(
                                                                        0,
                                                                        2,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        12,
                                                                      ),
                                                                  child: Stack(
                                                                    children: [
                                                                      Image.network(
                                                                        video['image'],
                                                                        width:
                                                                            120,
                                                                        height:
                                                                            80,
                                                                        fit:
                                                                            BoxFit.cover,
                                                                      ),
                                                                      Container(
                                                                        width:
                                                                            120,
                                                                        height:
                                                                            80,
                                                                        //color: Colors.black.withOpacity(0.4),
                                                                        alignment:
                                                                            Alignment.bottomRight,
                                                                        padding:
                                                                            const EdgeInsets.all(
                                                                              4,
                                                                            ),
                                                                        child: Text(
                                                                          video['duration'],
                                                                          style: TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                13,
                                                                            fontWeight:
                                                                                FontWeight.w900,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  width: 12,
                                                                ),
                                                                Expanded(
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Text(
                                                                        video['title'],
                                                                        style: const TextStyle(
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                      // Status label (if exists)
                                                                      if (video['status'] !=
                                                                          null)
                                                                        Container(
                                                                          margin: const EdgeInsets.symmetric(
                                                                            vertical:
                                                                                4,
                                                                          ),
                                                                          padding: const EdgeInsets.symmetric(
                                                                            horizontal:
                                                                                8,
                                                                            vertical:
                                                                                4,
                                                                          ),
                                                                          decoration: BoxDecoration(
                                                                            color: getStatusColor(
                                                                              video['status'],
                                                                            ),
                                                                            borderRadius: BorderRadius.circular(
                                                                              12,
                                                                            ),
                                                                          ),
                                                                          child: Text(
                                                                            getStatusLabel(
                                                                              video['status'],
                                                                            ),
                                                                            style: const TextStyle(
                                                                              color:
                                                                                  Colors.white,
                                                                              fontSize:
                                                                                  12,
                                                                              fontWeight:
                                                                                  FontWeight.bold,
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      // Playing indicator
                                                                      if (video['index'] ==
                                                                          currentVideoIndex)
                                                                        Row(
                                                                          children: [
                                                                            Icon(
                                                                              Icons.play_circle_fill,
                                                                              color:
                                                                                  AppColors.primaryColor,
                                                                              size:
                                                                                  16,
                                                                            ),
                                                                            const SizedBox(
                                                                              width:
                                                                                  4,
                                                                            ),
                                                                            Text(
                                                                              'الفيديو الحالي',
                                                                              style: TextStyle(
                                                                                color:
                                                                                    AppColors.primaryColor,
                                                                                fontSize:
                                                                                    12,
                                                                                fontWeight:
                                                                                    FontWeight.bold,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      Text(
                                                                        video['description'],
                                                                        maxLines:
                                                                            2,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                          color:
                                                                              Colors.grey[700],
                                                                          fontSize:
                                                                              12,
                                                                        ),
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
                                          ),
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
        ],
      ),
    );
  }
}
