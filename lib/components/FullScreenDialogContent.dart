import '../utils/shared_import.dart';

class FullScreenDialogContent extends StatefulWidget {
  final List<String> imageUrls;
  final String? userName;
  final int initialIndex;

  FullScreenDialogContent({
    Key? key,
    required this.imageUrls,
    this.userName,
    this.initialIndex = 0,
  }) : super(key: key);

  @override
  State<FullScreenDialogContent> createState() =>
      _FullScreenDialogContentState();
}

class _FullScreenDialogContentState extends State<FullScreenDialogContent>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late int currentIndex;
  final Map<int, VideoPlayerController> _videoControllers = {};
  final Map<int, bool> _videoLoadingStates = {};
  final Map<int, bool> _showControls = {};
  final Map<int, AnimationController> _controlsAnimationControllers = {};
  bool _isControlsVisible = true;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;

    //currentIndex = widget.initialIndex;

    _pageController = PageController(initialPage: currentIndex);
    _initializeControllerIfVideo(currentIndex);
    _preloadAdjacentVideos(currentIndex);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _initializeControllerIfVideo(int index) async {
    if (index < 0 || index >= widget.imageUrls.length) {
      return;
    }
    final url = widget.imageUrls[index];
    if (_isVideo(url) && !_videoControllers.containsKey(index)) {
      setState(() {
        _videoLoadingStates[index] = true;
      });

      try {
        final controller = VideoPlayerController.networkUrl(Uri.parse(url));
        _videoControllers[index] = controller;

        _controlsAnimationControllers[index] = AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: this,
        );
        _showControls[index] = true;
        _controlsAnimationControllers[index]?.forward();

        await controller.initialize();
        controller.setLooping(true);

        if (index == currentIndex) {
          controller.play();
        }
        controller.addListener(() {
          if (mounted && index == currentIndex) {
            setState(() {});
          }
        });

        if (mounted) {
          setState(() {
            _videoLoadingStates[index] = false;
          });
        }
      } catch (e) {
        print("Error initializing video: $e");
        if (mounted) {
          setState(() {
            _videoLoadingStates[index] = false;
          });
        }
      }
    }
  }

  void _preloadAdjacentVideos(int currentIndex) {
    if (currentIndex > 0) {
      _initializeControllerIfVideo(currentIndex - 1);
    }
    if (currentIndex < widget.imageUrls.length - 1) {
      _initializeControllerIfVideo(currentIndex + 1);
    }
  }

  void _pauseAllVideosExcept(int activeIndex) {
    _videoControllers.forEach((index, controller) {
      if (index != activeIndex && controller.value.isPlaying) {
        controller.pause();
      }
    });
  }

  void _toggleVideoControls(int index) {
    if (_controlsAnimationControllers.containsKey(index)) {
      setState(() {
        _showControls[index] = !(_showControls[index] ?? false);
        if (_showControls[index]!) {
          _controlsAnimationControllers[index]?.forward();
        } else {
          _controlsAnimationControllers[index]?.reverse();
        }
      });
    }
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _pageController.dispose();
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    for (var controller in _controlsAnimationControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  bool _isVideo(String url) {
    final lowerUrl = url.toLowerCase();
    return lowerUrl.endsWith(".mp4") ||
        lowerUrl.endsWith(".mov") ||
        lowerUrl.endsWith(".avi") ||
        lowerUrl.endsWith(".mkv") ||
        lowerUrl.endsWith(".webm") ||
        lowerUrl.contains("video");
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }

  Widget _buildVideoControls(VideoPlayerController controller, int index) {
    final animationController = _controlsAnimationControllers[index];
    if (animationController == null) return SizedBox.shrink();

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Opacity(
          opacity: animationController.value,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.7),
                  Colors.transparent,
                  Colors.transparent,
                  Colors.black..withValues(alpha: 0.7),
                ],
              ),
            ),
            child: Column(
              children: [
                // Top controls
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      Expanded(
                        child: Text(
                          widget.userName ?? '',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Text(
                        '${currentIndex + 1} / ${widget.imageUrls.length}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: IconButton(
                    alignment: Alignment.center,
                    icon: Icon(
                      controller.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        if (controller.value.isPlaying) {
                          controller.pause();
                        } else {
                          controller.play();
                        }
                      });
                    },
                  ),
                ),
                Spacer(),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      VideoProgressIndicator(
                        controller,
                        allowScrubbing: true,
                        colors: VideoProgressColors(
                          playedColor: Colors.white,
                          bufferedColor: Colors.white.withOpacity(0.3),
                          backgroundColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            _formatDuration(controller.value.position),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          Spacer(),
                          IconButton(
                            icon: Icon(
                              controller.value.volume > 0
                                  ? Icons.volume_up
                                  : Icons.volume_off,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                controller.setVolume(
                                    controller.value.volume > 0 ? 0.0 : 1.0);
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.fullscreen,
                              color: Colors.white,
                              size: 20,
                            ),
                            onPressed: () {
                              SystemChrome.setEnabledSystemUIMode(
                                  SystemUiMode.immersiveSticky);
                            },
                          ),
                          Text(
                            _formatDuration(controller.value.duration),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: widget.imageUrls.length,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index;
                  });
                  _pauseAllVideosExcept(index);
                  if (_isVideo(widget.imageUrls[index]) &&
                      _videoControllers.containsKey(index)) {
                    _videoControllers[index]?.play();
                  }

                  _initializeControllerIfVideo(index);
                  _preloadAdjacentVideos(index);
                },
                itemBuilder: (context, index) {
                  final mediaUrl = widget.imageUrls[index];
                  print("Loading media: $mediaUrl");

                  if (_isVideo(mediaUrl)) {
                    return _buildVideoPlayer(index, mediaUrl);
                  } else {
                    return _buildImageViewer(mediaUrl);
                  }
                },
              ),
              if (widget.imageUrls.length > 1)
                Positioned(
                  bottom: 16,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.imageUrls.length,
                      (index) => Container(
                        margin: EdgeInsets.symmetric(horizontal: 2),
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == currentIndex
                              ? Colors.white
                              : Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(int index, String videoUrl) {
    final controller = _videoControllers[index];
    final isLoading = _videoLoadingStates[index] ?? false;

    if (isLoading) {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
              SizedBox(height: 16),
              Text(
                'Loading video...',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (controller != null && controller.value.isInitialized) {
      return Container(
        color: Colors.black,
        child: Stack(
          children: [
            Center(
              child: GestureDetector(
                onTap: () => _toggleVideoControls(index),
                child: AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: VideoPlayer(controller),
                ),
              ),
            ),
            if (_showControls[index] == true)
              _buildVideoControls(controller, index),
          ],
        ),
      );
    } else {
      return Container(
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.white, size: 48),
              SizedBox(height: 16),
              Text(
                'Failed to load video',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  _videoControllers.remove(index);
                  _videoLoadingStates.remove(index);
                  _initializeControllerIfVideo(index);
                },
                icon: Icon(Icons.refresh),
                label: Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.2),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _buildImageViewer(String imageUrl) {
    return Material(
      color: Colors.black,
      child: Stack(
        children: [
          InteractiveViewer(
            minScale: 0.5,
            maxScale: 4.0,
            child: Center(
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.high,
                width: double.infinity,
                height: double.infinity,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading image...',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.broken_image, color: Colors.white, size: 48),
                        SizedBox(height: 16),
                        Text(
                          'Failed to load image',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          // Image controls overlay
          if (_isControlsVisible)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
              child: Column(
                children: [
                  // Top bar
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        Expanded(
                          child: Text(
                            widget.userName ?? '',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Text(
                          '${currentIndex + 1} / ${widget.imageUrls.length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
