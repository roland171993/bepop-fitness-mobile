import '../utils/shared_import.dart';

class ChewieScreen extends StatefulWidget {
  final String? url;
  final String? image;
  final bool? autoPlay;

  ChewieScreen({this.url, this.image, this.autoPlay = false});

  @override
  State<StatefulWidget> createState() {
    return _ChewieScreenState();
  }
}

class _ChewieScreenState extends State<ChewieScreen>
    with WidgetsBindingObserver {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  int? bufferDelay;

  @override
  void initState() {
    super.initState();
    initializePlayer();
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  Future<void> initializePlayer() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.url ?? ''),
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
    );

    await _videoPlayerController.initialize();
    _createChewieController();
    setState(() {});
  }

  void _createChewieController() {
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: widget.autoPlay ?? false,
      looping: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      progressIndicatorDelay:
          bufferDelay != null ? Duration(milliseconds: bufferDelay!) : null,
      hideControlsTimer: const Duration(seconds: 1),
      showOptions: false,
      materialProgressColors: ChewieProgressColors(
        playedColor: primaryColor,
        handleColor: primaryColor,
        backgroundColor: textSecondaryColorGlobal,
        bufferedColor: textSecondaryColorGlobal,
      ),
    );
  }

  void handleVisibility(bool visible) {
    if (visible) {
      if (!_videoPlayerController.value.isPlaying) {
        _videoPlayerController.play();
      }
    } else {
      if (_videoPlayerController.value.isPlaying) {
        _videoPlayerController.pause();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 12 / 7,
      child: _chewieController != null &&
              _chewieController!.videoPlayerController.value.isInitialized &&
              widget.autoPlay == true
          ? VisibilityDetector(
              key:
                  Key('${widget.url}-${DateTime.now().microsecondsSinceEpoch}'),
              onVisibilityChanged: (VisibilityInfo info) {
                bool isVisible = info.visibleFraction > 0.5;
                handleVisibility(isVisible);
              },
              child: Chewie(controller: _chewieController!),
            )
          : cachedImage(widget.image,
                  fit: BoxFit.fill, height: context.height())
              .cornerRadiusWithClipRRect(0),
    );
  }
}
