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
  static final provider = Provider.autoDispose<VideoPlayerViewModel>((ref) {
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

    _controllerSubscription =
        _controller.listen((event) async => await _controllerListener(event));
    _initVideoStateSubscription();
  }

  // Private variables
  late YoutubePlayerController _controller;
  StreamSubscription<YoutubeVideoState>? _videoStateSubscription;
  Timer? videoStateEnsureTimer;
  bool videoStateSubscriptionActive = false;
  StreamSubscription<YoutubePlayerValue>? _controllerSubscription;
  bool shouldPause = true;
  final Ref ref;

  PlayerState? lastControllerState;

  // Private methods
  Future<void> _controllerListener(YoutubePlayerValue event) async {
    final lastState = lastControllerState;

    if ((lastState == PlayerState.paused ||
            lastState == PlayerState.unknown ||
            lastState == PlayerState.unStarted ||
            lastState == PlayerState.ended) &&
        (event.playerState == PlayerState.playing ||
            event.playerState == PlayerState.buffering)) {
      //Starts playing
      final timestamp = await ref.read(frameTimestampProvider.future);

      // If the current time is greater than or equal to the timestamp, don't do anything
      final currentTime = await _controller.currentTime;
      if (currentTime >= timestamp!) {
        if (currentTime < await _controller.duration) {
          // There's a bug where the current time is equal to the duration. This is a workaround
          shouldPause = false;
        }
      } else {
        shouldPause = true;
        videoStateEnsureTimer =
            Timer.periodic(const Duration(seconds: 1), (timer) async {
          if (!videoStateSubscriptionActive) {
            print('restarting service');
            _videoStateSubscription?.cancel();
            _initVideoStateSubscription();

            // In case the video state subscription is still not active, we need to ensure that the video is paused at the correct frame
            if (await _pauseVideoAtFrameStamp((currentTime * 1000).toInt())) {
              timer.cancel();
            }
          } else {
            timer.cancel();
          }
        });
      }
    }

    // Update the last controller state
    lastControllerState = event.playerState;
  }

  Future<bool> _pauseVideoAtFrameStamp(int timeInMilliseconds) async {
    final timestamp = await ref.read(frameTimestampProvider.future);

    if (shouldPause && timeInMilliseconds >= (timestamp! * 1000)) {
      pause();
      _controller.seekTo(seconds: timestamp, allowSeekAhead: true);
      shouldPause = false;
      return true;
    }
    return false;
  }

  void _initVideoStateSubscription() {
    _videoStateSubscription =
        _controller.videoStateStream.listen((event) async {
      videoStateSubscriptionActive = true;
      _pauseVideoAtFrameStamp(event.position.inMilliseconds);
    });
  }

  // Public methods
  void dispose() {
    _controllerSubscription?.cancel();
    _videoStateSubscription?.cancel();
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
