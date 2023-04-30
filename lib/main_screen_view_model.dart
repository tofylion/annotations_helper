import 'package:annotations_helper/constants/video_ids.dart';
import 'package:annotations_helper/models/config.dart';
import 'package:annotations_helper/models/frame_id.dart';
import 'package:annotations_helper/services/json_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

enum MainScreenStates { waitingForInput, playingVideo }

class MainScreenViewModel extends StateNotifier<MainScreenStates> {
  MainScreenViewModel({required this.ref})
      : super(MainScreenStates.waitingForInput) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      state = MainScreenStates.waitingForInput;
    });
  }

  // State setter override with swtich state
  @override
  set state(MainScreenStates value) {
    super.state = value;
    switch (value) {
      case MainScreenStates.waitingForInput:
        mainInputFocusNode.requestFocus();
        ref.read(videoReady.notifier).update((state) => false);
        // Select all text for easy pasting
        textController.selection = textController.selection
            .copyWith(baseOffset: 0, extentOffset: textController.text.length);

        break;
      case MainScreenStates.playingVideo:
        mainInputFocusNode.unfocus();
        ref.read(videoReady.notifier).update((state) => true);
        break;
    }
  }

  //Ref
  final Ref ref;

  // Text Controller
  final textController = TextEditingController();

  // State provider for videoReady
  final videoReady = StateProvider<bool>((ref) => false);

  // Focus Node
  FocusNode mainInputFocusNode = FocusNode();

  late YoutubePlayerController _controller = _initController();

  // Getters
  YoutubePlayerController get controller => _controller;

  // View Model Provider
  static final provider =
      StateNotifierProvider.autoDispose<MainScreenViewModel, MainScreenStates>(
          (ref) {
    return MainScreenViewModel(ref: ref);
  });

  // Methods
  Future<void> updateVideo(String query) async {
    final tempFrameId = FrameID.parseFrameID(query);
    // Make sure that video name is valid

    if (videoIds[tempFrameId.videoName] == null) {
      // TODO: Show error message
      return;
    }

    ref.read(frameIdProvider.notifier).update((state) => tempFrameId);
    final videoId = videoIds[ref.read(frameIdProvider)!.videoName]!;
    controller.loadVideoById(
      videoId: videoId,
      startSeconds: (await ref.read(frameTimestampProvider.future))! -
          ref.read(configProvider).timeBeforeFrame,
    );
    state = MainScreenStates.playingVideo;
  }

  void backToInput() {
    state = MainScreenStates.waitingForInput;
    _controller.stopVideo();
    _controller = _initController();
  }

  YoutubePlayerController _initController() {
    return YoutubePlayerController(
      params: const YoutubePlayerParams(
        showFullscreenButton: true,
        showControls: true,
      ),
    );
  }
}

// FrameID stateProvider
final frameIdProvider = StateProvider<FrameID?>((ref) => null);

// FrameTimestamp provider
final frameTimestampProvider = FutureProvider<double?>((ref) async {
  final frame = ref.watch(frameIdProvider);
  if (frame == null) {
    return null;
  }
  final json = await loadJson('${frame.videoName}.json');

  return json['${frame.frameNumber}'] / 1000.0; // convert to seconds
});
