// FrameID stateProvider
import 'package:annotations_helper/models/frame_id.dart';
import 'package:annotations_helper/services/json_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// These providers are the base for the target frame
// The target frame is the one that should be paused on

final frameIdProvider = StateProvider<FrameID?>((ref) => null);

// FrameTimestamp provider
// Loads the frame timestamp from the corresponding json file
final frameTimestampProvider = FutureProvider<double?>((ref) async {
  final frame = ref.watch(frameIdProvider);
  if (frame == null) {
    return null;
  }

  final json = await loadJson('${frame.videoName}.json', assetPath: 'metadata');

  return json['${frame.frameNumber}'] / 1000.0; // convert to seconds
});

// Loads the framerate from the json file of the video
final videoFrameRateProvider = FutureProvider<double?>((ref) async {
  final frame = ref.watch(frameIdProvider);
  if (frame == null) {
    return null;
  }

  final json = await loadJson('${frame.videoName}.json', assetPath: 'metadata');

  return json['frame_rate'];
});
