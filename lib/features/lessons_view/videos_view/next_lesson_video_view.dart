import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:mr_alnagar/core/cubits/courses_cubit/courses_cubit.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_cubit.dart';
import 'package:mr_alnagar/core/cubits/lessons_cubit/lessons_state.dart';
import 'package:mr_alnagar/core/network/local/cashe_keys.dart';
import 'package:mr_alnagar/core/network/local/shared_prefrence.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:mr_alnagar/features/lessons_view/quiz_view/exam_view.dart';
import 'package:mr_alnagar/features/profile_view/homework_results/home_work_results.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../core/utils/app_loaders.dart';

import '../homework_view/home_work_view.dart';
import 'next_lesson_video_view.dart';

class NextLessonVideoView extends StatefulWidget {
  final int videoIndex;
  const NextLessonVideoView({super.key, required this.videoIndex});

  @override
  _NextLessonVideoViewState createState() => _NextLessonVideoViewState();
}

class _NextLessonVideoViewState extends State<NextLessonVideoView> {
  late YoutubePlayerController controller;
  bool isFullScreen = false;
  bool isControllerReady = false;
  final nextScaffoldKey = GlobalKey<ScaffoldState>();

  List<Map<String, dynamic>> _videos = [];
  bool isLoading = true;
  int currentVideoIndex = 0;
  final ScrollController scrollController = ScrollController();
  bool hd = true;
  Timer? _watchTimer;
  int _sessionWatchSeconds = 0;
  bool _hasSeeked = false;
  bool isLoad = false;

  void showLoadOnRefresh() async {
    isLoad = true;
    await LessonsCubit.get(context).getClassDataByID(
      classId: LessonsCubit.get(context).classData['id'],
      context: context,
    );
    Future.delayed(Duration(seconds: 2)).then((value) {
      Navigator.pop(context);
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder:
              (context) => NextLessonVideoView(
                videoIndex: LessonsCubit.get(context).classData['id'],
              ),
        ),
      );
      isLoad = false;
    });
  }

  @override
  void initState() {
    super.initState();
    CoursesCubit.get(context).isCourseLoading = false;
    LessonsCubit.get(
      context,
    ).getClassDataByID(classId: widget.videoIndex, context: context);
    LessonsCubit.get(context).isLessonLoading = false;
    print(LessonsCubit.get(context).isLessonLoading);

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
    if (videoId != null) {
      LessonsCubit.get(context).postVideoSeconds(
        videoId: videoId,
        lastWatchedSecond: currentPosition.inSeconds,
        watchSeconds: _sessionWatchSeconds,
      );
    }
    controller.pause();
    //controller.dispose();
    super.dispose();
  }

  int? _getCurrentVideoId() {
    if (currentVideoIndex < _videos.length) {
      return _videos[currentVideoIndex]['id'];
    }
    return null;
  }

  void _startTracking() {
    _watchTimer?.cancel();
    _watchTimer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      final position = controller.value.position;
      final videoId = _getCurrentVideoId();
      _sessionWatchSeconds += 30;
      if (videoId != null) {
        await LessonsCubit.get(context).postVideoSeconds(
          videoId: videoId,
          lastWatchedSecond: position.inSeconds,
          watchSeconds: _sessionWatchSeconds,
        );
      }
    });
  }

  void _loadVideos() {
    final data = LessonsCubit.get(context).classData;
    if (data == null) return;

    final courseId = data['id'];

    final savedVideoId = CacheHelper.getData(
      key: CacheKeys.lastLessonVideoIndex,
    );
    final videosList = data['videos'] as List<dynamic>;

    int indexCounter = 0;
    Map<String, dynamic>? selectedVideo;

    List<Map<String, dynamic>> preparedVideos = [];

    for (var video in videosList) {
      final videoUrl = utf8.decode(base64.decode(video['video_url']));
      final videoMap = {
        'index': indexCounter++,
        'id': video['id'],
        'title': video['title'],
        'video_url': videoUrl,
        'duration': video['duration'],
        'image': video['thumbnail'],
        'description': video['description'] ?? '',
        'last_watched_second': video['last_watched_second'] ?? 0,
        'status': video['status'],
      };

      if (video['id'] == savedVideoId) selectedVideo = videoMap;

      preparedVideos.add(videoMap);
    }

    if (preparedVideos.isEmpty) {
      setState(() {
        _videos = [];
        isLoading = false;
      });
      return;
    }

    // Select the initial video early
    final firstVideo = selectedVideo ?? preparedVideos.first;
    final firstVideoId =
        YoutubePlayer.convertUrlToId(firstVideo['video_url']) ?? '';

    // Initialize controller early
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
      if (!_hasSeeked && _videos.isNotEmpty) {
        final currentVideo = _videos.firstWhere(
          (v) => v['index'] == currentVideoIndex,
          //orElse: () => null,
        );

        if (currentVideo != null) {
          _hasSeeked = true;
          controller.seekTo(
            Duration(seconds: currentVideo['last_watched_second'] ?? 0),
          );
          controller.play();
          controller.pause();
          _startTracking();
        }
      }
    });

    // Update UI after controller is ready
    setState(() {
      _videos = preparedVideos;
      isLoading = false;
      currentVideoIndex = firstVideo['index'];
    });
  }

  void _playVideo(Map<String, dynamic> video) {
    final videoId = YoutubePlayer.convertUrlToId(video['video_url']);
    CacheHelper.setData(key: CacheKeys.lastVideoIndex, value: video['id']);
    if (videoId != null) {
      controller.load(videoId);
      controller.seekTo(Duration(seconds: video['last_watched_second']));
      //controller.pause();
      controller.play();
      //controller.pause();
      setState(() {
        currentVideoIndex = video['index'];
        _sessionWatchSeconds = 0;
        _hasSeeked = true;
      });
    }
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
        child: Row(
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
    return BlocConsumer<LessonsCubit, LessonsState>(
      listener: (context, state) {
        state is GetClassDataByIDDone;
      },
      builder: (context, state) {
        return BlocBuilder<LessonsCubit, LessonsState>(
          builder: (context, state) {
            print('////////////////////');
            print(LessonsCubit.get(
              context,
            ).classData['title']);
            return isLoad
                ? Scaffold(body: Center(child: AppLoaderInkDrop()))
                : Scaffold(
                  key: nextScaffoldKey,
                  appBar:
                      isFullScreen
                          ? null
                          : AppBar(
                            leading: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_outlined,
                                size: 30,
                                weight: 80,
                                color: AppColors.primaryColor,
                              ),
                            ),
                            actions: [
                              Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Text(
                                  LessonsCubit.get(
                                    context,
                                  ).classData['title'],
                                  style: TextStyles.textStyle16w700(context),
                                ),
                              ),
                            ],
                          ),
                  body: RefreshIndicator(
                    triggerMode: RefreshIndicatorTriggerMode.anywhere,
                    onRefresh: () async {
                      return showLoadOnRefresh();
                    },
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: SafeArea(
                        child:
                            LessonsCubit.get(context).classData == null &&
                                    isControllerReady == false
                                ? const Center(
                                  child: AppLoaderInkDrop(),
                                )
                                : Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Column(
                                    children: [
                                      Directionality(
                                        textDirection: TextDirection.ltr,

                                        child: YoutubePlayerBuilder(
                                          onEnterFullScreen: () {
                                            setState(() {
                                              isFullScreen = true;
                                            });
                                          },
                                          onExitFullScreen: () {
                                            isFullScreen = false;
                                          },
                                          player: YoutubePlayer(
                                            controller: controller,
                                            bottomActions: [
                                              const SizedBox(width: 8.0),
                                              CurrentPosition(
                                                controller: controller,
                                              ),
                                              const SizedBox(width: 8.0),
                                              ProgressBar(
                                                isExpanded: true,
                                                controller: controller,
                                                colors: ProgressBarColors(
                                                  backgroundColor: Colors.grey,
                                                  handleColor: Colors.green,
                                                  bufferedColor: Colors.white10,
                                                  playedColor: Colors.green,
                                                ),
                                              ),

                                              IconButton(
                                                onPressed: () {
                                                  setState(() {
                                                    hd = !hd;
                                                  });
                                                },
                                                icon: Icon(
                                                  hd
                                                      ? Icons.hd
                                                      : Icons.hd_outlined,
                                                  color: Colors.white,
                                                ),
                                              ),

                                              RemainingDuration(
                                                controller: controller,
                                              ),
                                              const SizedBox(width: 4.0),
                                              PlaybackSpeedButton(
                                                controller: controller,
                                              ),

                                              const SizedBox(width: 4.0),
                                              FullScreenButton(
                                                controller: controller,
                                              ),
                                            ],

                                            showVideoProgressIndicator: true,
                                            controlsTimeOut: const Duration(
                                              seconds: 3,
                                            ),
                                            progressIndicatorColor: Colors.red,
                                            onReady: () {
                                              setState(() {
                                                isControllerReady = true;
                                              });
                                            },
                                          ),
                                          builder:
                                              (context, player) => Column(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          12,
                                                        ),
                                                    child: player,
                                                  ),
                                                  const SizedBox(height: 15),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          'الفيديو الحالي',
                                                          style: TextStyles.textStyle14w700(
                                                            context,
                                                          ).copyWith(
                                                            color:
                                                                AppColors
                                                                    .primaryColor,
                                                          ),
                                                          maxLines: 3,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis,
                                                        ),
                                                      ),
                                                      Text(
                                                        currentVideoIndex <
                                                                _videos.length
                                                            ? _videos[currentVideoIndex]['title']
                                                            : '',
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
                                                    currentVideoIndex <
                                                            _videos.length
                                                        ? _videos[currentVideoIndex]['description']
                                                        : '',
                                                    style: TextStyle(
                                                      color: Colors.grey[700],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        ),
                                      ),

                                      // _videos.isEmpty
                                      //     ? Center(
                                      //       child: Text(
                                      //         'لا توجد فيديوهات حاليا, ستتوفر قريبا',
                                      //         style: TextStyles.textStyle16w700(
                                      //           context,
                                      //         ).copyWith(
                                      //           color: AppColors.primaryColor,
                                      //         ),
                                      //       ),
                                      //     )
                                      //     :
                                      Expanded(
                                        child: Container(
                                          // height: MediaQuery.sizeOf(context).height * 0.5,
                                          width: double.infinity,
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
                                            child: SingleChildScrollView(
                                              controller: scrollController,
                                              child: Column(
                                                children: [
                                                  ..._videos.asMap().entries.map((
                                                    entry,
                                                  ) {
                                                    final videoIndex =
                                                        entry.key;
                                                    final video = entry.value;
                                                    return InkWell(
                                                      onTap: () {
                                                        _playVideo(video);
                                                      },
                                                      child: Container(
                                                        margin:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 12,
                                                              vertical: 6,
                                                            ),
                                                        padding:
                                                            const EdgeInsets.all(
                                                              8,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          border:
                                                              video['index'] ==
                                                                      currentVideoIndex
                                                                  ? Border.all(
                                                                    color:
                                                                        AppColors
                                                                            .primaryColor,
                                                                    width: 2,
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
                                                                    width: 120,
                                                                    height: 80,
                                                                    fit:
                                                                        BoxFit
                                                                            .cover,
                                                                    errorBuilder: (
                                                                      context,
                                                                      error,
                                                                      stackTrace,
                                                                    ) {
                                                                      return Image.asset(
                                                                        'assets/images/error image.png',
                                                                        fit:
                                                                            BoxFit.cover,
                                                                        height:
                                                                            80,
                                                                        width:
                                                                            120,
                                                                      );
                                                                    },
                                                                  ),
                                                                  Container(
                                                                    width: 120,
                                                                    height: 80,
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomRight,
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                          4,
                                                                        ),
                                                                    child: Text(
                                                                      video['duration'],
                                                                      style: const TextStyle(
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
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
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
                                                                        borderRadius:
                                                                            BorderRadius.circular(
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
                                                                  if (video['index'] ==
                                                                      currentVideoIndex)
                                                                    Row(
                                                                      children: [
                                                                        Icon(
                                                                          Icons
                                                                              .play_circle_fill,
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
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                      color:
                                                                          Colors
                                                                              .grey[700],
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

                                                  // ✅ This is your extra button after the videos
                                                  LessonsCubit.get(
                                                            context,
                                                          ).classData['next_class_id'] !=
                                                          null
                                                      ? Column(
                                                        children: [
                                                          const SizedBox(
                                                            height: 12,
                                                          ),
                                                          Container(
                                                            width: 150,
                                                            height: 70,
                                                            child: ElevatedButton(
                                                              onPressed: () async {
                                                                setState(() {
                                                                  LessonsCubit.get(
                                                                        context,
                                                                      ).isLessonLoading =
                                                                      true;
                                                                });

                                                                // Use getClassDataByID instead of getVideosByClass
                                                                await LessonsCubit.get(
                                                                  context,
                                                                ).getClassDataByID(
                                                                  classId:
                                                                      LessonsCubit.get(
                                                                        context,
                                                                      ).classData?['next_class_id'] ??
                                                                      0,
                                                                  context:
                                                                      context,
                                                                );

                                                                // Check if we have valid data before navigation
                                                                if (LessonsCubit.get(
                                                                      context,
                                                                    ).classData !=
                                                                    null) {
                                                                  Navigator.pushReplacement(
                                                                    context,
                                                                    CupertinoPageRoute(
                                                                      builder:
                                                                          (
                                                                            context,
                                                                          ) => NextLessonVideoView(
                                                                            videoIndex:
                                                                                LessonsCubit.get(
                                                                                  context,
                                                                                ).nextClass ??
                                                                                0,
                                                                          ),
                                                                    ),
                                                                  );
                                                                } else {
                                                                  // Show error message if data loading failed
                                                                  LessonsCubit.get(
                                                                    context,
                                                                  ).showSnackBar(
                                                                    context,
                                                                    'فشل في تحميل بيانات الحصة التالية',
                                                                    3,
                                                                    Colors.red,
                                                                  );
                                                                }

                                                                setState(() {
                                                                  LessonsCubit.get(
                                                                        context,
                                                                      ).isLessonLoading =
                                                                      false;
                                                                });
                                                              },
                                                              style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    AppColors
                                                                        .primaryColor,
                                                                padding:
                                                                    const EdgeInsets.symmetric(
                                                                      horizontal:
                                                                          24,
                                                                      vertical:
                                                                          12,
                                                                    ),
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                        12,
                                                                      ),
                                                                ),
                                                              ),
                                                              child:
                                                                  LessonsCubit.get(
                                                                        context,
                                                                      ).isLessonLoading
                                                                      ? Center(
                                                                        child: AppLoaderInkDrop(
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      )
                                                                      : Text(
                                                                        "الحصة التالية",
                                                                        style: TextStyles.textStyle16w700(
                                                                          context,
                                                                        ).copyWith(
                                                                          color:
                                                                              Colors.white,
                                                                        ),
                                                                      ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 12,
                                                          ),
                                                        ],
                                                      )
                                                      : Container(),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Container(
                                        width:
                                            MediaQuery.sizeOf(context).width *
                                            1,
                                        //height: 40,
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              top: 20.0,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              spacing: 5,
                                              children: [
                                                LessonsCubit.get(
                                                          context,
                                                        ).classData['attachment'] !=
                                                        null
                                                    ? _buildActionButton(
                                                      context,
                                                      Icons
                                                          .picture_as_pdf_outlined,
                                                      'تحميل المذكرة',
                                                      () async {
                                                        var url =
                                                            LessonsCubit.get(
                                                              context,
                                                            ).classData['attachment'];
                                                        if (url != null &&
                                                            url
                                                                .toString()
                                                                .isNotEmpty) {
                                                          var uri = Uri.parse(
                                                            url,
                                                          );
                                                          if (await canLaunchUrl(
                                                            uri,
                                                          )) {
                                                            await launchUrl(
                                                              uri,
                                                              mode:
                                                                  LaunchMode
                                                                      .externalApplication,
                                                            );
                                                          } else {
                                                            LessonsCubit.get(
                                                              context,
                                                            ).showSnackBar(
                                                              context,
                                                              'تعذر فتح الرابط',
                                                              3,
                                                              Colors.red,
                                                            );
                                                          }
                                                        } else {
                                                          LessonsCubit.get(
                                                            context,
                                                          ).showSnackBar(
                                                            context,
                                                            'لا يوجد ملف مرفق',
                                                            3,
                                                            Colors.orange,
                                                          );
                                                        }
                                                      },
                                                    )
                                                    : Container(),

                                                LessonsCubit.get(
                                                          context,
                                                        ).classData['has_homeworks'] ==
                                                        true
                                                    ? _buildActionButton(
                                                      context,
                                                      Icons.assignment,
                                                      'حل الواجب',
                                                      () async {
                                                        controller.pause();
                                                        await LessonsCubit.get(
                                                          context,
                                                        ).startHomework(
                                                          homeworkId:
                                                              LessonsCubit.get(
                                                                context,
                                                              ).classData['homework_id'],
                                                        );

                                                        Navigator.push(
                                                          context,
                                                          CupertinoPageRoute(
                                                            builder: (context) {
                                                              return LessonsHomeworkView(
                                                                homeworkID:
                                                                    LessonsCubit.get(
                                                                      context,
                                                                    ).classData['homework_id'],
                                                              );
                                                            },
                                                          ),
                                                        );
                                                      },
                                                    )
                                                    : Container(),
                                                LessonsCubit.get(
                                                          context,
                                                        ).classData['has_quizzes'] ==
                                                        true
                                                    ? _buildActionButton(
                                                      context,
                                                      Icons.quiz,
                                                      'عرض الامتحان',
                                                      () async {
                                                        controller.pause;

                                                        await LessonsCubit.get(
                                                          context,
                                                        ).startQuiz(
                                                          quizId:
                                                              LessonsCubit.get(
                                                                context,
                                                              ).classData['quiz_id'],
                                                        );

                                                        showDialog(
                                                          context: context,
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
                                                                      TextDirection
                                                                          .rtl,
                                                                  child: AlertDialog(
                                                                    backgroundColor:
                                                                        Colors
                                                                            .white,
                                                                    title: Text(
                                                                      'تنبيهات مهمة',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                    ),
                                                                    titleTextStyle: TextStyles.textStyle16w700(
                                                                      context,
                                                                    ).copyWith(
                                                                      color:
                                                                          AppColors
                                                                              .secondary,
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
                                                                              ),
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
                                                                                          AppLoaderInkDrop(),
                                                                                    )
                                                                                    : Padding(
                                                                                      padding: const EdgeInsets.all(
                                                                                        8.0,
                                                                                      ),
                                                                                      child: Text(
                                                                                        HtmlUnescape().convert(
                                                                                          LessonsCubit.get(
                                                                                                context,
                                                                                              ).quiz['quiz']['description']
                                                                                              .replaceAll(
                                                                                                RegExp(
                                                                                                  r'<style[^>]*>[\s\S]*?</style>',
                                                                                                  caseSensitive:
                                                                                                      false,
                                                                                                ),
                                                                                                '',
                                                                                              )
                                                                                              .replaceAll(
                                                                                                RegExp(
                                                                                                  r'<[^>]+>',
                                                                                                ),
                                                                                                '',
                                                                                              )
                                                                                              .replaceAll(
                                                                                                RegExp(
                                                                                                  r'\s+',
                                                                                                ),
                                                                                                ' ',
                                                                                              )
                                                                                              .trim(),
                                                                                        ),
                                                                                        style: TextStyles.textStyle16w700(
                                                                                          context,
                                                                                        ).copyWith(
                                                                                          color:
                                                                                              AppColors.secondary,
                                                                                        ),
                                                                                        textDirection:
                                                                                            TextDirection.rtl,
                                                                                        textAlign:
                                                                                            TextAlign.right,
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
                                                                                              ).classData['quiz_id'],
                                                                                        );
                                                                                        //Navigator.pop(context);
                                                                                        Navigator.pushAndRemoveUntil(
                                                                                          context,
                                                                                          CupertinoPageRoute(
                                                                                            builder:
                                                                                                (
                                                                                                  context,
                                                                                                ) => LessonsExamView(
                                                                                                  quizID:
                                                                                                      LessonsCubit.get(
                                                                                                        context,
                                                                                                      ).classData['quiz_id'],
                                                                                                ),
                                                                                          ),
                                                                                          (
                                                                                            route,
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
                                          ),
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
        );
      },
    );
  }
}
