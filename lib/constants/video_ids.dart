import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:annotations_helper/services/json_utils.dart';

final videoIdsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  return loadJson('youtube_ids.json', assetPath: 'video_ids');
});
