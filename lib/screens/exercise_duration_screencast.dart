import '../utils/shared_import.dart';

class ExerciseDurationScreencast extends StatefulWidget {
  static String tag = '/ExerciseDurationScreen';
  final ExerciseDetailResponse? mExerciseModel;
  final String? workOutId;

  ExerciseDurationScreencast({this.mExerciseModel, this.workOutId});

  @override
  ExerciseDurationScreencastState createState() =>
      ExerciseDurationScreencastState();
}

class ExerciseDurationScreencastState extends State<ExerciseDurationScreencast>
    with TickerProviderStateMixin {
  CountDownController1 mCountDownController1 = CountDownController1();

  Duration? duration;

  //FlutterTts? flutterTts;
  int i = 0;
  int? mLength;
  Workout? _workout;
  Tabata? _tabata;
  bool _isMuted = false;

  List<String>? mExTime = [];
  List<String>? mRestTime = [];
  bool _isBottomSheetOpen = false;

  late VideoPlayerController _controller;
  GoogleCastOptions? options;

  bool _isInitialized = false;
  bool _isPlaying = false;
  double _videoProgress = 0.0;
  bool _isCurrentlyLandscape = false;
  bool _isShowControllar = false;
  Timer? _hideTimer;

  String _currentTime = '0:00';
  String _totalTime = '0:00';

  int? bufferDelay;
  YoutubePlayerController? youtubePlayerController;
  late TextEditingController _idController;
  late TextEditingController _seekToController;
  late PlayerState? _playerState;
  late YoutubeMetaData videoMetaData;
  bool _isPlayerReady = false;
  String? videoId = '';

  bool visibleOption = true;
  bool? isChanged = false;
  final castManager = CastManager();
  bool isLoading = false;

  @override
  initState() {
    print("--------------85>>>>${widget.mExerciseModel?.data?.exerciseImage}");
    super.initState();
    WakelockPlus.enable();

    if (widget.mExerciseModel!.data!.sets != null) {
      print("abc");
      widget.mExerciseModel!.data!.sets!.forEachIndexed((element, index) {
        mExTime!.add(element.time.toString());
        mRestTime!.add(element.rest.toString());
        setState(() {});
      });
      _tabata = Tabata(
          sets: 1,
          reps: widget.mExerciseModel!.data!.sets!.length,
          startDelay: Duration(seconds: 3),
          exerciseTime: mExTime,
          restTime: mRestTime,
          breakTime: Duration(seconds: 60),
          status:
              widget.mExerciseModel!.data!.based == "reps" ? "reps" : "second");
    }

    _initVideoPlayer();
    _setOrientation(isLandscape: false);

    init();
    castManager.initPlatformState();

    if (videoId != null)
      videoId = YoutubePlayer.convertUrlToId(
          widget.mExerciseModel!.data!.videoUrl.validate());
    // if (flutterTts != null) flutterTts!.awaitSpeakCompletion(true);
    // flutterTts!.pause();
    if (videoId != null)
      youtubePlayerController = YoutubePlayerController(
        initialVideoId: videoId!,
        flags: YoutubePlayerFlags(
          mute: false,
          autoPlay: true,
          disableDragSeek: false,
          loop: false,
          isLive: false,
          forceHD: false,
          enableCaption: true,
          showLiveFullscreenButton: false,
        ),
      )..addListener(listener);
    _idController = TextEditingController();
    _seekToController = TextEditingController();
    if (youtubePlayerController != null)
      youtubePlayerController!.addListener(() {
        if (_playerState == PlayerState.playing) {
          if (isChanged == true) {
            _workout!.resetTimer();
            isChanged = false;
          }
        }
        if (_playerState == PlayerState.paused) {
          _workout!.pause();
          // if (flutterTts != null) flutterTts!.pause();
          // isChanged = true;
        }
      });
    videoMetaData = const YoutubeMetaData();
    _playerState = PlayerState.unknown;
    initPlatformState();
    GoogleCastDiscoveryManager.instance.startDiscovery();
    GoogleCastDiscoveryManager.instance.devicesStream.listen((devices) {
      print("Devices Found: ${devices.map((e) => e.friendlyName).join(", ")}");
    });

    GoogleCastSessionManager.instance.currentSessionStream.listen((session) {
      print("Session updated: $session");
    });
  }

  void _toggleController() {
    setState(() {
      _isShowControllar = !_isShowControllar;
    });

    _hideTimer?.cancel();

    if (_isShowControllar) {
      _hideTimer = Timer(const Duration(seconds: 4), () {
        if (mounted) {
          setState(() {
            _isShowControllar = false;
          });
        }
      });
    }
  }

  init() async {
    //
    if (widget.mExerciseModel!.data!.sets != null) {
      mLength = widget.mExerciseModel!.data!.sets!.length - 1;
    }
    if (_tabata == null) return;
    _workout = Workout(_tabata!, _onWorkoutChanged);
    _start();
  }

  Future<void> initPlatformState(
      {int retryCount = 0, int maxRetries = 3}) async {
    try {
      const appId = GoogleCastDiscoveryCriteria.kDefaultApplicationId;
      print("Initializing Google Cast with appId: $appId");

      if (Platform.isIOS) {
        options = IOSGoogleCastOptions(
          GoogleCastDiscoveryCriteriaInitialize.initWithApplicationID(appId),
        );
      } else if (Platform.isAndroid) {
        options = GoogleCastOptionsAndroid(
          appId: appId,
        );
      } else {
        throw UnsupportedError("Platform not supported");
      }

      await GoogleCastContext.instance.setSharedInstanceWithOptions(options!);
      print("GoogleCastContext initialized successfully");
    } catch (e) {
      if (retryCount < maxRetries) {
        await Future.delayed(Duration(seconds: retryCount + 1));
        return initPlatformState(
            retryCount: retryCount + 1, maxRetries: maxRetries);
      } else {
        print("Failed to initialize CastContext after $maxRetries attempts.");
        rethrow;
      }
    }
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    _workout?.dispose();
    _seekToController.dispose();
    _controller.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if (youtubePlayerController != null) youtubePlayerController!.pause();
    if (youtubePlayerController != null) youtubePlayerController!.dispose();
    _idController.dispose();
    GoogleCastDiscoveryManager.instance.stopDiscovery();
    GoogleCastSessionManager.instance.endSessionAndStopCasting();
    GoogleCastSessionManager.instance.endSession();
    _hideTimer?.cancel();
    castManager.endCast();
    WakelockPlus.disable();

    super.dispose();
  }

  void exitScreen() {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
    finish(context);
  }

  void listener() {
    if (_isPlayerReady &&
        mounted &&
        !youtubePlayerController!.value.isFullScreen) {
      setState(() {
        _playerState = youtubePlayerController!.value.playerState;
        videoMetaData = youtubePlayerController!.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    if (youtubePlayerController != null) youtubePlayerController!.pause();
    super.deactivate();
  }

  void _initVideoPlayer() async {
    debugPrint('---initVideoPlayer----------');
    _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.mExerciseModel?.data?.videoUrl ?? ''));
    await _controller.initialize();
    _controller.setLooping(true);
    _isInitialized = true;
    setState(() {});

    if (_controller.value.isInitialized) {
      _controller.play();
      _isPlaying = true;
      //_controller.pause();
    }

    _controller.addListener(() {
      if (_controller.value.isInitialized) {
        // _videoProgress = _controller.value.position.inMilliseconds / _controller.value.duration.inMilliseconds;
        final position = _controller.value.position.inMilliseconds.toDouble();
        final duration = _controller.value.duration.inMilliseconds.toDouble();
        _videoProgress =
            duration > 0 ? (position / duration).clamp(0.0, 1.0) : 0.0;
        //_controller.setVolume(0.0);
        _currentTime = _formatDuration(_controller.value.position);
        _totalTime = _formatDuration(_controller.value.duration);
        if (mounted) setState(() {});
      }
    });
  }

  void _toggleVolume() {
    setState(() {
      _isMuted = !_isMuted;
      _controller.setVolume(_isMuted ? 0.0 : 1.0);
      GoogleCastSessionManager.instance.setDeviceVolume(_isMuted ? 0.0 : 1.0);
      _isPlaying == true
          ? GoogleCastRemoteMediaClient.instance.play()
          : GoogleCastRemoteMediaClient.instance.pause();
    });
  }

  void _setOrientation({required bool isLandscape}) {
    setState(() {
      _isCurrentlyLandscape = isLandscape;
    });

    SystemChrome.setPreferredOrientations([
      if (isLandscape) ...[
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ] else ...[
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]
    ]);
  }

  void _toggleOrientation() {
    _setOrientation(isLandscape: !_isCurrentlyLandscape);
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  void _togglePlay() {
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        GoogleCastRemoteMediaClient.instance.pause();
        _isPlaying = false;
      } else {
        _controller.play();
        GoogleCastRemoteMediaClient.instance.play();
        _isPlaying = true;
      }
    });
  }

  void _skipForward() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition + Duration(seconds: 10);

    if (newPosition < _controller.value.duration) {
      _controller.seekTo(newPosition);
      if (GoogleCastSessionManager.instance.connectionState ==
          GoogleCastConnectState.connected) {
        GoogleCastRemoteMediaClient.instance
            .seek(GoogleCastMediaSeekOption(position: newPosition));
        _isPlaying == true
            ? GoogleCastRemoteMediaClient.instance.play()
            : GoogleCastRemoteMediaClient.instance.pause();
      }
    } else {
      _controller.seekTo(_controller.value.duration);
      if (GoogleCastSessionManager.instance.connectionState ==
          GoogleCastConnectState.connected) {
        GoogleCastRemoteMediaClient.instance.seek(
            GoogleCastMediaSeekOption(position: _controller.value.duration));
        _isPlaying == true
            ? GoogleCastRemoteMediaClient.instance.play()
            : GoogleCastRemoteMediaClient.instance.pause();
      }
    }
  }

  void _skipBackward() {
    final currentPosition = _controller.value.position;
    final newPosition = currentPosition - Duration(seconds: 10);
    if (newPosition > Duration.zero) {
      _controller.seekTo(newPosition);
      if (GoogleCastSessionManager.instance.connectionState ==
          GoogleCastConnectState.connected) {
        GoogleCastRemoteMediaClient.instance
            .seek(GoogleCastMediaSeekOption(position: newPosition));
        _isPlaying == true
            ? GoogleCastRemoteMediaClient.instance.play()
            : GoogleCastRemoteMediaClient.instance.pause();
      }
    } else {
      _controller.seekTo(Duration.zero);
      if (GoogleCastSessionManager.instance.connectionState ==
          GoogleCastConnectState.connected) {
        GoogleCastRemoteMediaClient.instance
            .seek(GoogleCastMediaSeekOption(position: Duration.zero));
        _isPlaying == true
            ? GoogleCastRemoteMediaClient.instance.play()
            : GoogleCastRemoteMediaClient.instance.pause();
      }
    }
  }

  int currPlayIndex = 0;

  _onWorkoutChanged() async {
    if (_workout!.step == WorkoutState.finished) {
      await setExerciseApi();
      if (_isBottomSheetOpen) {
        Navigator.pop(context);
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
      }
    }
    if (mounted) this.setState(() {});
  }

  _start() {
    _workout!.start();
  }

  setExerciseApi() async {
    Map? req = {
      "workout_id": widget.workOutId ?? '',
      "exercise_id": widget.mExerciseModel?.data?.id ?? ''
    };
    await setExerciseHistory(req).then((value) {
      if (mounted) setState(() {});
    }).catchError((e) {});
  }

  Widget dividerHorizontalLine({bool? isSmall = false}) {
    return Container(
      height: isSmall == true ? 40 : 65,
      width: 4,
      color: whiteColor,
    );
  }

  Widget mSetText(String value, {String? value2}) {
    return Text(value, style: boldTextStyle(size: 18)).center();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Duration parseDuration(String durationString) {
    List<String> components = durationString.split(':');

    int hours = int.parse(components[0]);
    int minutes = int.parse(components[1]);
    int seconds = int.parse(components[2]);

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  Widget mData(List<Sets> strings) {
    List<Widget> list = [];
    for (var i = 0; i < strings.length; i++) {
      list.add(new Text(strings[i].time.toString()));
    }
    return new Row(children: list);
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            appStore.isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness:
            appStore.isDarkMode ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        appBar: isLandscape
            ? null
            : appBarWidget(widget.mExerciseModel?.data?.title ?? "",
                context: context,
                actions: [
                    StreamBuilder<GoogleCastSession?>(
                      stream: castManager.streamOfState(),
                      builder: (context, snapshot) {
                        bool? isConnected =
                            GoogleCastSessionManager.instance.connectionState ==
                                GoogleCastConnectState.connected;
                        print("---------232>>>${isConnected}");
                        GoogleCastSessionManager.instance.setDeviceVolume(0);
                        return Row(
                          children: [
                            IconButton(
                                onPressed: () {
                                  if (widget.mExerciseModel?.data?.videoUrl !=
                                          null &&
                                      (widget.mExerciseModel!.data!.videoUrl!
                                              .contains("https://youtu") ||
                                          widget.mExerciseModel!.data!.videoUrl!
                                              .contains("https://www.youtu"))) {
                                    toast("Casting not supported");
                                  } else {
                                    if (snapshot.data?.connectionState !=
                                        GoogleCastConnectState.connected) {
                                      _showDeviceBottomSheet(context);
                                    } else if (snapshot.data?.connectionState ==
                                        GoogleCastConnectState.connected) {
                                      showConfirmDialogCustom(context,
                                          dialogType: DialogType.CONFIRMATION,
                                          title: "Stop Casting",
                                          primaryColor: primaryColor,
                                          positiveText: "Stop",
                                          image: ic_logo,
                                          onAccept: (buildContext) {
                                        castManager.endCast();
                                      });
                                    }
                                  }
                                },
                                icon: Icon(
                                  isConnected
                                      ? Icons.cast_connected
                                      : Icons.cast_outlined,
                                  color: primaryColor,
                                )),
                            if (Platform.isIOS) ...[
                              GestureDetector(
                                  onTap: () {
                                    if (widget.mExerciseModel?.data?.videoUrl !=
                                            null &&
                                        (widget.mExerciseModel!.data!.videoUrl!
                                                .contains("https://youtu") ||
                                            widget
                                                .mExerciseModel!.data!.videoUrl!
                                                .contains(
                                                    "https://www.youtu"))) {
                                      toast("Casting not supported");
                                    } else {
                                      if (snapshot.data?.connectionState !=
                                          GoogleCastConnectState.connected) {
                                        _showDeviceBottomSheet(context);
                                      } else if (snapshot
                                              .data?.connectionState ==
                                          GoogleCastConnectState.connected) {
                                        showConfirmDialogCustom(context,
                                            dialogType: DialogType.CONFIRMATION,
                                            title: "Stop Casting",
                                            primaryColor: primaryColor,
                                            positiveText: "Stop",
                                            image: ic_logo,
                                            onAccept: (buildContext) {
                                          castManager.endCast();
                                        });
                                      }
                                    }
                                  },
                                  child: Image.asset(ic_broadcast,
                                      color: isConnected
                                          ? primaryColor
                                          : Colors.black54,
                                      width: 30,
                                      height: 30))
                            ],
                            15.width,
                          ],
                        );
                      },
                    ),
                  ]),
        body: SingleChildScrollView(
          physics: isLandscape
              ? NeverScrollableScrollPhysics()
              : AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              widget.mExerciseModel!.data!.videoUrl
                          .validate()
                          .contains("https://youtu") ||
                      widget.mExerciseModel!.data!.videoUrl
                          .validate()
                          .contains("https://www.youtu")
                  ? AspectRatio(
                      aspectRatio: 12 / 7,
                      child: YoutubePlayerScreen(
                        url: widget.mExerciseModel!.data!.videoUrl.validate(),
                        img: widget.mExerciseModel!.data!.exerciseImage
                            .validate(),
                      ))
                  : AspectRatio(
                      aspectRatio: isLandscape ? 12 / 6 : 12 / 7,
                      child: _isInitialized
                          ? GestureDetector(
                              onTap: _toggleController,
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: Stack(
                                    alignment: Alignment.bottomCenter,
                                    children: [
                                      VideoPlayer(_controller),
                                      Positioned(
                                          left: 0,
                                          right: 0,
                                          bottom: 0,
                                          top: 0,
                                          child: _controls()),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Stack(
                              children: [
                                cachedImage(
                                        widget
                                            .mExerciseModel!.data!.exerciseImage
                                            .validate(),
                                        fit: BoxFit.fill,
                                        height: context.height(),
                                        width: double.infinity)
                                    .cornerRadiusWithClipRRect(0),
                                if (!_controller.value.isInitialized) ...[
                                  Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                ],
                              ],
                            ),
                    ).center().paddingSymmetric(horizontal: 4),
              30.height,
              if (widget.mExerciseModel!.data!.sets != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                            '${_workout?.rep}/${widget.mExerciseModel?.data?.sets?.length.toString()}',
                            style: boldTextStyle(size: 18)),
                        Text(
                          languages.lblSets,
                          style: secondaryTextStyle(),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        _workout!.rep >= 1
                            ? mSetText(
                                widget.mExerciseModel!.data!.based == "reps"
                                    ? widget.mExerciseModel!.data!
                                        .sets![_workout!.rep - 1].reps
                                        .toString()
                                    : widget.mExerciseModel!.data!
                                        .sets![_workout!.rep - 1].time
                                        .toString())
                            : mSetText("-"),
                        Text(
                          widget.mExerciseModel!.data!.based == "reps"
                              ? languages.lblReps
                              : languages.lblSecond,
                          style: secondaryTextStyle(),
                        )
                      ],
                    ),
                  ],
                ).paddingSymmetric(horizontal: 16),
              50.height,
              Container(
                child: _workout != null && _workout!.timeLeft != null
                    ? FittedBox(
                        child: Text(
                          formatTime1(_workout!.timeLeft),
                          style: boldTextStyle(size: 110),
                        ),
                      )
                    : SizedBox.shrink(),
              ),
              16.height,
              16.height,
            ],
          ).center(),
        ),
      ),
    );
  }

  Widget _controls() {
    return Visibility(
      visible: _isShowControllar == true,
      child: Container(
        color: Colors.black.withValues(alpha: 0.3),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 65),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: GestureDetector(
                      onTap: _skipBackward,
                      child: Image.asset(ic_backward, height: 30, width: 30)),
                ),
                20.width,
                Container(
                  decoration: BoxDecoration(
                    color:
                        Colors.black.withValues(alpha: 0.6), // Background color
                    shape: BoxShape.circle, // Make it round
                  ),
                  child: IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: _togglePlay,
                  ),
                ),
                20.width,
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                  ),
                  child: GestureDetector(
                      onTap: _skipForward,
                      child: Image.asset(ic_forward, width: 30, height: 30)),
                ),
              ],
            ).expand(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            _currentTime,
                            style: boldTextStyle(color: Colors.white, size: 13),
                          ),
                          Text(
                            ' / ${_totalTime}',
                            style:
                                primaryTextStyle(color: Colors.white, size: 13),
                          ),
                          IconButton(
                            icon: Icon(
                              _isMuted ? Icons.volume_off : Icons.volume_up,
                              size: 30,
                            ),
                            onPressed: _toggleVolume,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(
                              _isCurrentlyLandscape
                                  ? Icons.fullscreen_exit
                                  : Icons.fullscreen,
                              color: Colors.white,
                            ),
                            onPressed: _toggleOrientation,
                          ),
                        ],
                      )
                    ],
                  ),
                  Container(
                    height: 5,
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 5.0,
                        overlayShape: SliderComponentShape.noOverlay,
                        //overlayShape: SliderComponentShape.noThumb,
                        thumbColor: primaryColor,
                        trackShape: SliderCustomTrackShape(),
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 6.0),
                      ),
                      child: Slider(
                        value: _videoProgress,
                        onChanged: (value) {
                          setState(() {
                            _videoProgress = value;
                          });
                        },
                        onChangeStart: (value) {
                          setState(() {});
                        },
                        onChangeEnd: (value) {
                          final milliseconds =
                              (_controller.value.duration.inMilliseconds *
                                      value)
                                  .toInt();
                          _controller
                              .seekTo(Duration(milliseconds: milliseconds));
                          if (GoogleCastSessionManager
                                  .instance.connectionState ==
                              GoogleCastConnectState.connected) {
                            GoogleCastRemoteMediaClient.instance.seek(
                                GoogleCastMediaSeekOption(
                                    position:
                                        Duration(milliseconds: milliseconds)));
                            _isPlaying == true
                                ? GoogleCastRemoteMediaClient.instance.play()
                                : GoogleCastRemoteMediaClient.instance.pause();
                          }

                          setState(() {});
                        },
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeviceList() {
    return StreamBuilder<List<GoogleCastDevice>>(
      stream: GoogleCastDiscoveryManager.instance.devicesStream,
      builder: (context, snapshot) {
        var devices = snapshot.data ?? [];

        if (devices.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.cast, size: 48, color: Colors.black),
                SizedBox(height: 10),
                Text(
                  languages.lblNoFoundData,
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          itemCount: devices.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            final device = devices[index];
            return InkWell(
              onTap: () async {
                setState(() {
                  isLoading = true;
                });
                await castManager
                    .startCast(
                  device,
                  imageUrl: widget.mExerciseModel?.data?.exerciseImage,
                  videoUrl: widget.mExerciseModel?.data?.videoUrl,
                  startTime: _controller.value.position,
                  // videoController: _controller,
                  isPlaying: _isPlaying,
                )
                    .then((v) {
                  setState(() {
                    isLoading = false;
                  });
                  if (mounted) Navigator.pop(context);
                });
                castManager.startListeningForPlaybackCompletion(
                    widget.mExerciseModel?.data?.videoUrl);
              },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surface
                      .withValues(alpha: 0.05),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.15),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withValues(alpha: 0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Leading Icon with gradient container
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            primaryColor.withValues(alpha: 0.2),
                            primaryColor.withValues(alpha: 0.4),
                          ],
                        ),
                        border: Border.all(
                          color: primaryColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.cast_connected,
                        size: 28,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Device Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            device.friendlyName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                              letterSpacing: 0.2,
                            ),
                          ),
                          if (device.modelName != null &&
                              device.modelName!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                device.modelName!,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Trailing Icon with subtle animation
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      child: isLoading
                          ? Loader(
                              color: Colors.transparent,
                            )
                          : Icon(
                              Icons.chevron_right,
                              size: 24,
                              color: primaryColor.withValues(alpha: 0.7),
                            ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showDeviceBottomSheet(BuildContext context) {
    setState(() {
      _isBottomSheetOpen = true;
    });
    showModalBottomSheet(
      context: context,
      isDismissible: true,
      elevation: 0,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      transitionAnimationController: AnimationController(
          vsync: this, duration: const Duration(seconds: 1)),
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Material(
        elevation: 10,
        child: Container(
          decoration: BoxDecoration(
            color: appStore.isDarkMode ? Colors.black54 : Colors.black12,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          height: MediaQuery.of(context).size.height * 0.3,
          child: _buildDeviceList(),
        ),
      ),
    ).then((_) {
      setState(() {
        _isBottomSheetOpen = false;
      });
    });
    ;
  }
}
