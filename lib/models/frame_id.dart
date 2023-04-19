class FrameID {
  String videoName;
  int frameNumber;

  FrameID(this.videoName, this.frameNumber);

  /// Parse frame id from image name of the following format:
  /// <video_name>@<frame_number>.jpg
  ///
  /// Example:
  /// - input: `48dcd3_00-15-00@1673.jpg`
  ///
  ///   output: FrameID(videoName: 48dcd3_00-15-00, frameNumber: 1673)
  ///
  /// - input: `48dcd3_00-15-00@1673`
  ///
  ///   output: FrameID(videoName: 48dcd3_00-15-00, frameNumber: 1673)
  factory FrameID.parseFrameID(String imageName) {
    final split = imageName.split('@');
    final videoName = split[0];
    final frameNumber = int.parse(split[1].split('.')[0]);
    return FrameID(videoName, frameNumber);
  }

  @override
  String toString() {
    return '$videoName@$frameNumber';
  }
}
