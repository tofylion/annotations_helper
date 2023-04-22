import 'package:annotations_helper/video_player_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class YTVideoPlayer extends ConsumerStatefulWidget {
  const YTVideoPlayer(
      {required this.controller,
      super.key,
      required this.height,
      required this.width});

  final double height;
  final double width;

  final YoutubePlayerController controller;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _YTVideoPlayerState();
}

class _YTVideoPlayerState extends ConsumerState<YTVideoPlayer> {
  late VideoPlayerViewModel vm;
  @override
  void initState() {
    super.initState();
    vm = ref.read(VideoPlayerViewModel.provider)
      ..controller = widget.controller;
  }

  @override
  Widget build(BuildContext context) {
    vm = ref.watch(VideoPlayerViewModel.provider);
    return YoutubePlayerScaffold(
      controller: widget.controller,
      aspectRatio: 16 / 9,
      builder: (context, player) {
        return Column(
          children: [
            SizedBox(height: widget.height, width: widget.width, child: player),
          ],
        );
      },
    );
  }
}
