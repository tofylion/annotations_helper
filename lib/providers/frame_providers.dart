// FrameID stateProvider
import 'package:annotations_helper/models/frame_id.dart';
import 'package:annotations_helper/services/json_utils.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final frameIdProvider = StateProvider<FrameID?>((ref) => null);

// FrameTimestamp provider
final frameTimestampProvider = FutureProvider<double?>((ref) async {
  final frame = ref.watch(frameIdProvider);
  if (frame == null) {
    return null;
  }

  final json = await loadJson('${frame.videoName}.json', assetPath: 'metadata');

  return json['${frame.frameNumber}'] / 1000.0; // convert to seconds
});

final videoFrameRateProvider = FutureProvider<double?>((ref) async {
  final frame = ref.watch(frameIdProvider);
  if (frame == null) {
    return null;
  }

  final json = await loadJson('${frame.videoName}.json', assetPath: 'metadata');

  return json['frameRate'];
});
