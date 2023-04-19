import 'dart:async';

import 'package:annotations_helper/constants/video_properties.dart';
import 'package:annotations_helper/main_screen_view_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

/// View model would handle the video player
/// It handles the activity of the video player
/// The functionality is as follows:
/// 1. Have a setter for controller
/// 2. Have a getter for controller
/// 3. Keep track of the latest controller state
/// 4. If the video starts playing and the current time is less than the timestamp,
///    pause the video when the current time is greater than the timestamp using a timer that runs every 33 milliseconds
/// 5. If the video is paused, cancel the timer
/// 6. If the video starts playing and the current time is greater than or equal to the timestamp, don't do anything
/// 7. "Starts playing" means that the controller state changed from paused to playing
/// 8. "Paused" means that the controller state changed from playing to paused
class VideoPlayerViewModel {
  VideoPlayerViewModel({required this.ref});

  // Provider
  static final provider = Provider<VideoPlayerViewModel>((ref) {
    final viewModel = VideoPlayerViewModel(ref: ref);

    ref.onDispose(() {
      viewModel.dispose();
    });

    return viewModel;
  });

  // Getters
  YoutubePlayerController get controller => _controller;

  // Setters
  set controller(YoutubePlayerController controller) {
    _controller = controller;
    lastControllerState = PlayerState.paused;

    _controller.listen(_controllerListener);
  }

  // Private variables
  late YoutubePlayerController _controller;
  late Timer? _timer;
  final Ref ref;

  PlayerState? lastControllerState;

  // Private methods
  void _controllerListener(YoutubePlayerValue event) async {
    final lastState = lastControllerState;

    if ((lastState == PlayerState.paused ||
            lastState == PlayerState.unknown ||
            lastState == PlayerState.buffering) &&
        event.playerState == PlayerState.playing) {
      //Starts playing
      final timestamp = await ref.read(frameTimestampProvider.future);
      print('==> playing $timestamp');

      // If the current time is greater than or equal to the timestamp, don't do anything
      if (await _controller.currentTime >= timestamp!) {
        return;
      }

      _timer = Timer.periodic(const Duration(milliseconds: 33), (timer) async {
        // If the current time is greater than the timestamp, pause the video
        if (await _controller.currentTime >= timestamp) {
          _controller.pauseVideo();
        }
        print('==> ${await _controller.currentTime} $timestamp');
      });
    } else if (lastState == PlayerState.playing &&
        (event.playerState == PlayerState.paused ||
            event.playerState == PlayerState.unknown ||
            event.playerState == PlayerState.buffering)) {
      // Paused
      _timer?.cancel();
      _timer = null;
    }

    // Update the last controller state
    lastControllerState = event.playerState;
  }

  // Public methods
  void dispose() {
    _timer?.cancel();
    _timer = null;
  }

  void play() {
    _controller.playVideo();
  }

  void pause() {
    _controller.pauseVideo();
  }

  void skipFrame({forward = true}) async {
    // Calculate the timestamp of the next frame from the fps of the videos
    final timestamp =
        await _controller.currentTime + ((forward ? 1.0 : -1.0) / VIDEO_FPS);
    _controller.seekTo(seconds: timestamp, allowSeekAhead: true);
    pause();
  }
}
