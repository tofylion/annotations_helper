import 'package:annotations_helper/constants/app_colors.dart';
import 'package:annotations_helper/constants/app_text_styles.dart';
import 'package:annotations_helper/constants/dimensions.dart';
import 'package:annotations_helper/main_screen_animator.dart';
import 'package:annotations_helper/main_screen_view_model.dart';
import 'package:annotations_helper/widgets/input_box.dart';
import 'package:annotations_helper/widgets/main_action_button.dart';
import 'package:annotations_helper/widgets/my_back_button.dart';
import 'package:annotations_helper/yt_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});
  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with SingleTickerProviderStateMixin {
  late MainScreenAnimator _controller;

  @override
  void initState() {
    super.initState();
    _controller = MainScreenAnimator(
      vsync: this, // the SingleTickerProviderStateMixin
    );
    _controller.addListener(() {
      setState(() {}); //To make animation changes update the widgets
    });
  }

  @override
  Widget build(BuildContext context) {
    final vmState = ref.watch(MainScreenViewModel.provider);
    final vm = ref.read(MainScreenViewModel.provider.notifier);
    final videoReady = ref.watch(vm.videoReady);
    final videoExpanded = ref.watch(_controller.videoExpandedProvider);

    switch (vmState) {
      case MainScreenStates.playingVideo:
        _controller.forward().whenComplete(() {
          ref
              .read(_controller.videoExpandedProvider.notifier)
              .update((state) => true);
        });
        break;
      case MainScreenStates.waitingForInput:
        _controller.reverse();
        // This is a hack to make sure the provider updates after the widgets have finished rebuilding
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref
              .read(_controller.videoExpandedProvider.notifier)
              .update((state) => false);
        });

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
                  top: _controller.inputBoxValue,
                  child: InputBox(
                      focusNode: vm.mainInputFocusNode,
                      controller: vm.textController,
                      onFieldSubmitted: (value) async =>
                          await vm.updateVideo(value)),
                ),
                Positioned(
                  top: _controller.mainActionButtonMoveValue,
                  child: videoReady
                      ? Container(
                          width: _controller.mainActionButtonWidthValue,
                          height: _controller.mainActionButtonHeightValue,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.teal
                                    .withOpacity(0.25 * _controller.value),
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
                  top: _controller.mainActionButtonMoveValue,
                  child: !videoExpanded
                      ? MainActionButton(
                          width: _controller.mainActionButtonWidthValue,
                          height: _controller.mainActionButtonHeightValue,
                          text: !videoReady ? 'Go' : '',
                          onTap: () async {
                            await vm.updateVideo(vm.textController.text);
                          })
                      : const SizedBox.shrink(),
                ),
                Positioned(
                    top: _controller.backButtonValue,
                    child: MyBackButton(
                      onTap: () => vm.backToInput(),
                      shadowOpacity: videoReady ? 0.25 : 0,
                    )),
                Positioned(
                    bottom: 78.sp,
                    child: Opacity(
                      opacity: 1 - _controller.value,
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
}
