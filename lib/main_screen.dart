import 'dart:async';

import 'package:annotations_helper/constants/app_colors.dart';
import 'package:annotations_helper/constants/app_text_styles.dart';
import 'package:annotations_helper/constants/dimensions.dart';
import 'package:annotations_helper/constants/timing.dart';
import 'package:annotations_helper/main_screen_view_model.dart';
import 'package:annotations_helper/models/config.dart';
import 'package:annotations_helper/models/frame_id.dart';
import 'package:annotations_helper/services/json_utils.dart';
import 'package:annotations_helper/widgets/input_box.dart';
import 'package:annotations_helper/widgets/main_action_button.dart';
import 'package:annotations_helper/widgets/my_back_button.dart';
import 'package:annotations_helper/yt_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:googleapis/vision/v1.dart';
import 'package:sprung/sprung.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

import 'constants/video_ids.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _curvedAnimationController;
  late Animation<double> _inputBoxMoveAnimation;
  late Animation<double> _mainActionButtonMoveAnimation;
  late Animation<double> _mainActionButtonWidthAnimation;
  late Animation<double> _mainActionButtonHeightAnimation;
  late Animation<double> _backButtonAnimation;

  bool videoExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: Duration(milliseconds: 750),
    )..addListener(() {
        setState(() {});
      });
    _curvedAnimationController = CurvedAnimation(
        parent: _controller,
        curve: Sprung.overDamped,
        reverseCurve: Sprung.overDamped.flipped);
    _inputBoxMoveAnimation =
        Tween<double>(begin: 154.sp, end: -Dimensions.inputBoxHeight)
            .animate(_curvedAnimationController);
    _mainActionButtonMoveAnimation = Tween<double>(begin: 258.sp, end: 55.sp)
        .animate(_curvedAnimationController);
    _mainActionButtonWidthAnimation = Tween<double>(
            begin: Dimensions.actionButtonWidth,
            end: Dimensions.videoPlayerWidth)
        .animate(_curvedAnimationController);
    _mainActionButtonHeightAnimation = Tween<double>(
            begin: Dimensions.actionButtonHeight,
            end: Dimensions.videoPlayerHeight)
        .animate(_curvedAnimationController);
    _backButtonAnimation =
        Tween<double>(begin: -Dimensions.backButtonHeight, end: 0)
            .animate(_curvedAnimationController);
  }

  @override
  Widget build(BuildContext context) {
    final vmState = ref.watch(MainScreenViewModel.provider);
    final vm = ref.read(MainScreenViewModel.provider.notifier);
    late final videoReady;

    switch (vmState) {
      case MainScreenStates.playingVideo:
        _controller.forward().whenComplete(() {
          setState(() {
            videoExpanded = true;
          });
        });
        videoReady = true;

        break;
      case MainScreenStates.waitingForInput:
        _controller.reverse();
        videoExpanded = false;

        videoReady = false;
        break;
    }

    return YoutubePlayerControllerProvider(
      controller: vm.controller,
      child: Builder(builder: (context) {
        return Scaffold(
          backgroundColor: AppColors.lightBlack,
          body: Center(
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  top: _inputBoxMoveAnimation.value,
                  child: InputBox(
                      controller: vm.textController,
                      onFieldSubmitted: (value) async =>
                          await vm.updateVideo(value)),
                ),
                Positioned(
                  top: _mainActionButtonMoveAnimation.value,
                  child: videoReady
                      ? Container(
                          width: _mainActionButtonWidthAnimation.value,
                          height: _mainActionButtonHeightAnimation.value,
                          decoration:
                              BoxDecoration(color: Colors.black, boxShadow: [
                            BoxShadow(
                              color: AppColors.teal.withOpacity(
                                  0.25 * _curvedAnimationController.value),
                              blurRadius: 50,
                              spreadRadius: 0,
                              offset: Offset(0, 0),
                            ),
                          ]),
                          child: YTVideoPlayer(
                            width:
                                videoExpanded ? Dimensions.videoPlayerWidth : 0,
                            height: videoExpanded
                                ? Dimensions.videoPlayerHeight
                                : 0,
                            controller: vm.controller,
                          ),
                        )
                      : SizedBox.shrink(),
                ),
                Positioned(
                  top: _mainActionButtonMoveAnimation.value,
                  child: !videoExpanded
                      ? MainActionButton(
                          width: _mainActionButtonWidthAnimation.value,
                          height: _mainActionButtonHeightAnimation.value,
                          text: !videoReady ? 'Go' : '',
                          onTap: () async {
                            await vm.updateVideo(vm.textController.text);
                          })
                      : SizedBox.shrink(),
                ),
                Positioned(
                    top: _backButtonAnimation.value,
                    child: MyBackButton(
                      onTap: () => vm.backToInput(),
                      shadowOpacity: videoReady ? 0.25 : 0,
                    ))
              ],
            ),
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
