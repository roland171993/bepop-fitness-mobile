import 'shared_import.dart';

class CastManager {
  GoogleCastOptions? options;
  StreamSubscription<GoggleCastMediaStatus?>? _mediaStatusSubscription;

  Future<void> initPlatformState(
      {int retryCount = 0, int maxRetries = 3}) async {
    try {
      const appId = GoogleCastDiscoveryCriteria.kDefaultApplicationId;
      print("Initializing Google Cast with appId: $appId");

      if (Platform.isIOS) {
        options = IOSGoogleCastOptions(
          GoogleCastDiscoveryCriteriaInitialize.initWithApplicationID(appId),
        );
        await GoogleCastContext.instance.setSharedInstanceWithOptions(options!);
      } else if (Platform.isAndroid) {
        options = GoogleCastOptionsAndroid(
          appId: appId,
        );
        await GoogleCastContext.instance.setSharedInstanceWithOptions(options!);
      } else {
        throw UnsupportedError("Platform not supported");
      }

      // Initialize Cast context

      print("GoogleCastContext initialized successfully");
    } catch (e, s) {
      print('Error initializing CastContext: $e');
      print('Stack trace: $s');

      // Retry logic
      if (retryCount < maxRetries) {
        print(
            "Retrying initialization (attempt ${retryCount + 1}/$maxRetries)...");
        await Future.delayed(Duration(seconds: retryCount + 1));
        return initPlatformState(
            retryCount: retryCount + 1, maxRetries: maxRetries);
      } else {
        print("Failed to initialize CastContext after $maxRetries attempts.");
        rethrow;
      }
    }
  }

  Stream<List<GoogleCastDevice>> streamOfDevices() {
    return GoogleCastDiscoveryManager.instance.devicesStream;
  }

  Stream<GoogleCastSession?> streamOfState() {
    return GoogleCastSessionManager.instance.currentSessionStream;
  }

  Future<void> startCast(GoogleCastDevice device,
      {String? videoUrl,
      String? imageUrl,
      required Duration startTime,
      required bool isPlaying}) async {
    print("CheckVideoURL:::$videoUrl");
    print("CheckVideoURL2:::$imageUrl");
    await GoogleCastSessionManager.instance.startSessionWithDevice(device);
    final completer = Completer<void>();
    GoogleCastSessionManager.instance.currentSessionStream.listen(
      (event) async {
        print("DeviceState:::${event?.connectionState.name}");
        if (event?.connectionState == GoogleCastConnectState.connected) {
          GoogleCastRemoteMediaClient.instance.loadMedia(
            GoogleCastMediaInformation(
              contentId: '${Random().nextInt(1000)}',
              streamType: CastMediaStreamType.buffered,
              contentUrl: Uri.parse(videoUrl ??
                  'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'),
              contentType: videoUrl.validate().contains(".m3u8")
                  ? 'application/x-mpegurl'
                  : 'video/mp4',
            ),
            autoPlay: isPlaying,
            // activeTrackIds: [0],
            playPosition: startTime,
          );
          if (!completer.isCompleted) {
            completer.complete();
          }
        }
      },
    );
    return completer.future;
  }

  void startListeningForPlaybackCompletion(String? videoUrl) {
    _mediaStatusSubscription?.cancel();
    _mediaStatusSubscription =
        GoogleCastRemoteMediaClient.instance.mediaStatusStream.listen((status) {
      if (status != null) {
        print(
            'Player state: ${status.playerState}, idleReason: ${status.idleReason}');
        if (status.playerState == CastMediaPlayerState.idle &&
            status.idleReason == GoogleCastMediaIdleReason.finished) {
          print('Playback finished. Restarting...');
          GoogleCastRemoteMediaClient.instance.loadMedia(
            GoogleCastMediaInformation(
              contentId: '${Random().nextInt(1000)}',
              streamType: CastMediaStreamType.buffered,
              contentUrl: Uri.parse(videoUrl ??
                  'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'),
              contentType: videoUrl.validate().contains(".m3u8")
                  ? 'application/x-mpegurl'
                  : 'video/mp4',
            ),
            // autoPlay: true,
            // activeTrackIds: [0],
          );
        }
      }
    });
  }

  Future<bool> endCast() async {
    return await GoogleCastSessionManager.instance.endSessionAndStopCasting();
  }
}
