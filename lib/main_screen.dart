import 'package:annotations_helper/constants/app_colors.dart';
import 'package:annotations_helper/constants/app_text_styles.dart';
import 'package:annotations_helper/constants/dimensions.dart';
import 'package:annotations_helper/main_screen_view_model.dart';
import 'package:annotations_helper/widgets/input_box.dart';
import 'package:annotations_helper/widgets/main_action_button.dart';
import 'package:annotations_helper/widgets/my_back_button.dart';
import 'package:annotations_helper/yt_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sprung/sprung.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});
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
    _initAnimations();
  }

  @override
  Widget build(BuildContext context) {
    final vmState = ref.watch(MainScreenViewModel.provider);
    final vm = ref.read(MainScreenViewModel.provider.notifier);
    final videoReady = ref.watch(vm.videoReady);

    switch (vmState) {
      case MainScreenStates.playingVideo:
        _controller.forward().whenComplete(() {
          setState(() {
            videoExpanded = true;
          });
        });
        break;
      case MainScreenStates.waitingForInput:
        _controller.reverse();
        videoExpanded = false;
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
                      focusNode: vm.mainInputFocusNode,
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
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.teal.withOpacity(
                                    0.25 * _curvedAnimationController.value),
                                blurRadius: 50,
                                spreadRadius: 0,
                                offset: const Offset(0, 0),
                              ),
                            ],
                            borderRadius:
                                BorderRadius.circular(Dimensions.radius4),
                          ),
                          child: YTVideoPlayer(
                            width:
                                videoExpanded ? Dimensions.videoPlayerWidth : 0,
                            height: videoExpanded
                                ? Dimensions.videoPlayerHeight
                                : 0,
                            controller: vm.controller,
                          ),
                        )
                      : const SizedBox.shrink(),
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
                      : const SizedBox.shrink(),
                ),
                Positioned(
                    top: _backButtonAnimation.value,
                    child: MyBackButton(
                      onTap: () => vm.backToInput(),
                      shadowOpacity: videoReady ? 0.25 : 0,
                    )),
                Positioned(
                    bottom: 78.sp,
                    child: Opacity(
                      opacity: 1 - _curvedAnimationController.value,
                      child: Center(
                        child: Text(
                          'Made with 🤍 by TofyLion',
                          style: AppTextStyles.creditsTextStyle,
                        ),
                      ),
                    ))
              ],
            ),
          ),
        );
      }),
    );
  }

  void _initAnimations() {
    _controller = AnimationController(
      vsync: this, // the SingleTickerProviderStateMixin
      duration: const Duration(milliseconds: 750),
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
}
