import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:mr_alnagar/core/cubits/home_cubit/home_cubit.dart';
import 'package:mr_alnagar/core/utils/app_colors.dart';
import 'package:mr_alnagar/core/utils/text_styles.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../core/utils/app_loaders.dart';

class HowToUse extends StatefulWidget {
  const HowToUse({Key? key, required this.data}) : super(key: key);
  final data;
  @override
  State<HowToUse> createState() => _HowToUseState();
}
// var videoUrl = url;

class _HowToUseState extends State<HowToUse> {
  late YoutubePlayerController controller;

  @override
  void initState() {
    super.initState();
    initializeController();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void initializeController() {
    controller = YoutubePlayerController(
      initialVideoId:
          YoutubePlayer.convertUrlToId(
            HomeCubit.get(context).howToUse['video_url'],
          )!,
      flags: YoutubePlayerFlags(
        autoPlay: false,
        hideControls: false,
        mute: false,
        useHybridComposition: true,
        controlsVisibleAtStart: true,
        forceHD: true,
        enableCaption: false,
        hideThumbnail: false,
      ),
    )..addListener(() {
      if (controller!.value.isReady && controller!.value.isPlaying) {
        // playSelectedVideo(currentVideoIndex);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return HomeCubit.get(context).howToUse == null
            ? Center(
              child: AppLoaderInkDrop(color: AppColors.primaryColor),
            )
            : Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                decoration: BoxDecoration(color: AppColors.secondary80),
                width: double.infinity,
                padding: EdgeInsetsDirectional.all(16),
                //height: 430.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 8,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      HomeCubit.get(context).howToUse['label'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        child: YoutubePlayerBuilder(
                          player: YoutubePlayer(
                            controller: controller,
                            bottomActions: [
                              const SizedBox(width: 8.0),
                              CurrentPosition(),
                              const SizedBox(width: 8.0),
                              ProgressBar(isExpanded: true),
                              const SizedBox(width: 8.0),
                              RemainingDuration(),
                              const SizedBox(width: 4.0),
                              const PlaybackSpeedButton(),
                              const SizedBox(width: 4.0),
                              FullScreenButton(controller: controller),
                            ],

                            progressColors: ProgressBarColors(
                              playedColor: AppColors.primaryColor,
                              handleColor: AppColors.primaryColor,
                              bufferedColor: AppColors.secondary,
                              backgroundColor: AppColors.secondary8,
                            ),
                            showVideoProgressIndicator: true,
                            controlsTimeOut: const Duration(minutes: 1),
                            topActions: [],
                            progressIndicatorColor: Colors.red,
                            onReady: () {},
                          ),
                          builder: (context, player) {
                            return Column(
                              children: [player, const SizedBox(height: 10)],
                            );
                          },
                        ),
                      ),
                    ),

                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            maxLines: 20,
                            HtmlUnescape()
                                .convert(
                                  '${HomeCubit.get(context).howToUse['description']}',
                                )
                                .replaceAll(RegExp(r'<[^>]*>'), ''),
                            style: TextStyles.textStyle16w700(context).copyWith(color: Colors.white,height: 2),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: CachedNetworkImage(
                            imageUrl: HomeCubit.get(context).howToUse['image_url'],
                            placeholder: (context, url) =>  Container(),
                            errorWidget: (context, url, error) => const Icon(Icons.error),
                            fit: BoxFit.cover,
                            height: 250,
                          )
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
      },
    );
  }
}
