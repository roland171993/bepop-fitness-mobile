import '../utils/shared_import.dart';

class HtmlYoutubePlayer extends StatefulWidget {
  final String? url;
  final String? img;

  HtmlYoutubePlayer({this.url, this.img});

  @override
  HtmlYoutubePlayerState createState() => HtmlYoutubePlayerState();
}

class HtmlYoutubePlayerState extends State<HtmlYoutubePlayer> {
  late YoutubePlayerController youtubePlayerController;
  late TextEditingController _idController;
  late TextEditingController _seekToController;
  bool _isPlayerReady = false;
  String videoId = '';

  bool visibleOption = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    videoId = YoutubePlayer.convertUrlToId(widget.url!)!;

    youtubePlayerController = YoutubePlayerController(
      initialVideoId: videoId,
      flags: YoutubePlayerFlags(
        mute: false,
        autoPlay: false,
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
    // _videoMetaData = const YoutubeMetaData();
    // _playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady &&
        mounted &&
        !youtubePlayerController.value.isFullScreen) {
      setState(() {
        // _playerState = youtubePlayerController.value.playerState;
        // _videoMetaData = youtubePlayerController.metadata;
      });
    }
  }

  @override
  void deactivate() {
    youtubePlayerController.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    youtubePlayerController.dispose();
    _idController.dispose();
    _seekToController.dispose();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: YoutubePlayerBuilder(
        player: YoutubePlayer(
          bottomActions: [
            const SizedBox(width: 14.0),
            //   CurrentPosition(),
            //   const SizedBox(width: 8.0),
            //  ProgressBar(),
            //  RemainingDuration(),
            //   const PlaybackSpeedButton(),
          ],
          controller: youtubePlayerController,
          showVideoProgressIndicator: true,
          progressIndicatorColor: Colors.white,
          //  thumbnail: cachedImage(widget.img, fit: BoxFit.fill, height: context.height()).cornerRadiusWithClipRRect(0),
          progressColors: ProgressBarColors(
            playedColor: Colors.white,
            bufferedColor: Colors.grey.shade200,
            handleColor: Colors.white,
            backgroundColor: Colors.grey,
          ),
          onReady: () {
            _isPlayerReady = true;
          },
          onEnded: (data) {
            //
          },
        ),
        builder: (context, player) => Scaffold(
          body: Container(
            height: context.height(),
            child: Stack(
              alignment: Alignment.topLeft,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    player,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        IconButton(
                            icon: Icon(CupertinoIcons.gobackward_10,
                                color: Colors.white, size: 30),
                            onPressed: () {
                              Duration currentPosition =
                                  youtubePlayerController.value.position;
                              Duration targetPosition =
                                  currentPosition - const Duration(seconds: 10);
                              youtubePlayerController.seekTo(targetPosition);
                            }).visible(!youtubePlayerController
                                .value.isPlaying &&
                            _isPlayerReady),
                        GestureDetector(
                          onTap: () {
                            if (_isPlayerReady) {
                              youtubePlayerController.value.isPlaying
                                  ? youtubePlayerController.pause()
                                  : youtubePlayerController.play();
                              setState(() {});
                            }
                          },
                          child: SizedBox(height: 50, width: 50),
                        ),
                        IconButton(
                            icon: Icon(CupertinoIcons.goforward_10,
                                color: Colors.white, size: 30),
                            onPressed: () {
                              Duration currentPosition =
                                  youtubePlayerController.value.position;
                              Duration targetPosition =
                                  currentPosition + const Duration(seconds: 10);
                              youtubePlayerController.seekTo(targetPosition);
                            }).visible(!youtubePlayerController
                                .value.isPlaying &&
                            _isPlayerReady),
                      ],
                    ),
                  ],
                ).center(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
