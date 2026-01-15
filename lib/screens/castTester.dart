// import 'package:flutter/material.dart';
// import 'package:flutter_chrome_cast/lib.dart';
// import 'package:flutter_chrome_cast/widgets/mini_controller.dart';
// import 'package:bepop_fitness/utils/CastManager.dart';
//
// class Casttester extends StatefulWidget {
//   @override
//   _CasttesterState createState() => _CasttesterState();
// }
//
// class _CasttesterState extends State<Casttester> {
//   GoogleCastOptions? options;
//   final castManager = CastManager();
//   @override
//   void initState() {
//     super.initState();
//     castManager.initPlatformState();
//     GoogleCastDiscoveryManager.instance.devicesStream.listen((devices) {
//       print("Devices Found: ${devices.map((e) => e.friendlyName).join(", ")}");
//     });
//
//     GoogleCastSessionManager.instance.currentSessionStream.listen((session) {
//       print("Session updated: $session");
//     });
//   }
//
//  /* Future<void> initPlatformState() async {
//     try {
//       const appId = GoogleCastDiscoveryCriteria.kDefaultApplicationId;
//       print("-----------24>>>>${appId}");
//
//       if (Platform.isIOS) {
//         options = IOSGoogleCastOptions(
//           GoogleCastDiscoveryCriteriaInitialize.initWithApplicationID(appId),
//         );
//       } else if (Platform.isAndroid) {
//         options = GoogleCastOptionsAndroid(
//           appId: appId,
//         );
//       }
//
//       await GoogleCastContext.instance.setSharedInstanceWithOptions(options!);
//       print("GoogleCastContext initialized successfully");
//     } catch (e, s) {
//       print('Error initializing CastContext37: ${e.toString()}');
//       print('Error initializing CastContext38: ${s.toString()}');
//     }
//   }*/
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: Container(
//         margin: const EdgeInsets.only(bottom: 40),
//         child: Stack(
//           children: [
//             StreamBuilder(
//                 stream: GoogleCastSessionManager.instance.currentSessionStream,
//                 builder: (context, snapshot) {
//                   final isConnected = GoogleCastSessionManager.instance.connectionState == GoogleCastConnectState.connected;
//                   print("--------51>>>>${isConnected}");
//                   return Visibility(
//                     visible: isConnected,
//                     child: FloatingActionButton(
//                       onPressed: _insertQueueItemAndPlay,
//                       child: const Icon(Icons.add),
//                     ),
//                   );
//                 }),
//             const GoogleCastMiniController(),
//           ],
//         ),
//       ),
//       appBar: AppBar(
//         title: const Text('fitness'),
//         actions: [
//           StreamBuilder<GoogleCastSession?>(
//               stream: GoogleCastSessionManager.instance.currentSessionStream,
//               builder: (context, snapshot) {
//                 final bool isConnected = GoogleCastSessionManager.instance.connectionState == GoogleCastConnectState.connected;
//                 return IconButton(
//                     onPressed: () {
//                       print("-----------86>>>>${isConnected}");
//                       if (isConnected == false) {
//                         castManager.initPlatformState();
//                       } else {
//                         GoogleCastSessionManager.instance.endSessionAndStopCasting;
//                       }
//                     },
//                     icon: Icon(isConnected ? Icons.cast_connected : Icons.cast));
//               })
//         ],
//       ),
//       body: StreamBuilder<List<GoogleCastDevice>>(
//         stream: GoogleCastDiscoveryManager.instance.devicesStream,
//         builder: (context, snapshot) {
//           final devices = snapshot.data ?? [];
//           return Column(
//             children: [
//               Expanded(
//                 child: ListView(
//                   children: [
//                     ...devices.map((device) {
//                       return ListTile(
//                         title: Text(device.friendlyName),
//                         subtitle: Text(device.modelName ?? ''),
//                         onTap: () => _loadMedia(device),
//                       );
//                     })
//                   ],
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
//
//   void _changeCurrentTime(double value) {
//     final seconds = GoogleCastRemoteMediaClient.instance.mediaStatus?.mediaInformation?.duration?.inSeconds ?? 0;
//     final position = (value * seconds).floor();
//     GoogleCastRemoteMediaClient.instance.seek(GoogleCastMediaSeekOption(position: Duration(seconds: position)));
//   }
//
//   void _togglePLayPause() {
//     final isPlaying = GoogleCastRemoteMediaClient.instance.mediaStatus?.playerState == CastMediaPlayerState.playing;
//     if (isPlaying) {
//       GoogleCastRemoteMediaClient.instance.pause();
//     } else {
//       GoogleCastRemoteMediaClient.instance.play();
//     }
//   }
//
//   void _loadMedia(GoogleCastDevice device) async {
//     await GoogleCastSessionManager.instance.startSessionWithDevice(device);
//
//     GoogleCastRemoteMediaClient.instance.loadMedia(
//       GoogleCastMediaInformationIOS(
//         contentId: '',
//         streamType: CastMediaStreamType.buffered,
//         contentUrl: Uri.parse('http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'),
//         contentType: 'video/mp4',
//         metadata: GoogleCastTvShowMediaMetadata(
//           episode: 1,
//           season: 2,
//           seriesTitle: 'Big Buck Bunny',
//           originalAirDate: DateTime.now(),
//           images: [
//             GoogleCastImage(
//               url: Uri.parse('https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg'),
//               height: 480,
//               width: 854,
//             ),
//           ],
//         ),
//         tracks: [
//           GoogleCastMediaTrack(
//             trackId: 0,
//             type: TrackType.text,
//             trackContentId: Uri.parse('https://raw.githubusercontent.com/felnanuke2/flutter_cast/master/example/assets/VEED-subtitles_Blender_Foundation_-_Elephants_Dream_1024.vtt').toString(),
//             trackContentType: 'text/vtt',
//             name: 'English',
//             // language: RFC5646_LANGUAGE.PORTUGUESE_BRAZIL,
//             subtype: TextTrackType.subtitles,
//           ),
//         ],
//       ),
//       autoPlay: true,
//       playPosition: const Duration(seconds: 0),
//       playbackRate: 2,
//       activeTrackIds: [0],
//     );
//   }
//
//   _loadQueue(GoogleCastDevice device) async {
//     await GoogleCastSessionManager.instance.startSessionWithDevice(device);
//     await GoogleCastRemoteMediaClient.instance.queueLoadItems(
//       [
//         GoogleCastQueueItem(
//           activeTrackIds: [0],
//           mediaInformation: GoogleCastMediaInformationIOS(
//             contentId: '0',
//             streamType: CastMediaStreamType.buffered,
//             contentUrl: Uri.parse('http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4'),
//             contentType: 'video/mp4',
//             metadata: GoogleCastMovieMediaMetadata(
//               title: 'The first Blender Open Movie from 2006',
//               studio: 'Blender Inc',
//               releaseDate: DateTime(2011),
//               subtitle:
//                   'Song : Raja Raja Kareja Mein Samaja\nAlbum : Raja Kareja Mein Samaja\nArtist : Radhe Shyam Rasia\nSinger : Radhe Shyam Rasia\nMusic Director : Sohan Lal, Dinesh Kumar\nLyricist : Vinay Bihari, Shailesh Sagar, Parmeshwar Premi\nMusic Label : T-Series',
//               images: [
//                 GoogleCastImage(
//                   url: Uri.parse('https://i.ytimg.com/vi_webp/gWw23EYM9VM/maxresdefault.webp'),
//                   height: 480,
//                   width: 854,
//                 ),
//               ],
//             ),
//             tracks: [
//               GoogleCastMediaTrack(
//                 trackId: 0,
//                 type: TrackType.text,
//                 trackContentId: Uri.parse('https://raw.githubusercontent.com/felnanuke2/flutter_cast/master/example/assets/VEED-subtitles_Blender_Foundation_-_Elephants_Dream_1024.vtt').toString(),
//                 trackContentType: 'text/vtt',
//                 name: 'English',
//                 // language: RFC5646_LANGUAGE.PORTUGUESE_BRAZIL,
//                 subtype: TextTrackType.subtitles,
//               ),
//             ],
//           ),
//         ),
//         GoogleCastQueueItem(
//           preLoadTime: const Duration(seconds: 15),
//           mediaInformation: GoogleCastMediaInformationIOS(
//             contentId: '1',
//             streamType: CastMediaStreamType.buffered,
//             contentUrl: Uri.parse('http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4'),
//             contentType: 'video/mp4',
//             metadata: GoogleCastMovieMediaMetadata(
//               title: 'Big Buck Bunny',
//               releaseDate: DateTime(2011),
//               studio: 'Vlc Media Player',
//               images: [
//                 GoogleCastImage(
//                   url: Uri.parse('https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/images/BigBuckBunny.jpg'),
//                   height: 480,
//                   width: 854,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//       options: GoogleCastQueueLoadOptions(
//         startIndex: 0,
//         repeatMode: GoogleCastMediaRepeatMode.all,
//         playPosition: const Duration(seconds: 30),
//       ),
//     );
//   }
//
//   void _previous() {
//     GoogleCastRemoteMediaClient.instance.queuePrevItem();
//   }
//
//   void _next() {
//     GoogleCastRemoteMediaClient.instance.queueNextItem();
//   }
//
//   void _insertQueueItem() {
//     GoogleCastRemoteMediaClient.instance.queueInsertItems(
//       [
//         GoogleCastQueueItem(
//           preLoadTime: const Duration(seconds: 15),
//           mediaInformation: GoogleCastMediaInformationIOS(
//             contentId: '3',
//             streamType: CastMediaStreamType.buffered,
//             contentUrl: Uri.parse('http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4'),
//             contentType: 'video/mp4',
//             metadata: GoogleCastMovieMediaMetadata(
//               title: 'For Bigger Blazes',
//               subtitle:
//                   'Song : Raja Raja Kareja Mein Samaja\nAlbum : Raja Kareja Mein Samaja\nArtist : Radhe Shyam Rasia\nSinger : Radhe Shyam Rasia\nMusic Director : Sohan Lal, Dinesh Kumar\nLyricist : Vinay Bihari, Shailesh Sagar, Parmeshwar Premi\nMusic Label : T-Series',
//               releaseDate: DateTime(2011),
//               studio: 'T-Series Regional',
//               images: [
//                 GoogleCastImage(
//                   url: Uri.parse('https://i.ytimg.com/vi/Dr9C2oswZfA/maxresdefault.jpg'),
//                   height: 480,
//                   width: 854,
//                 ),
//               ],
//             ),
//           ),
//         )
//       ],
//       beforeItemWithId: 2,
//     );
//   }
//
//   void _insertQueueItemAndPlay() {
//     GoogleCastRemoteMediaClient.instance.queueInsertItemAndPlay(
//       GoogleCastQueueItem(
//         preLoadTime: const Duration(seconds: 15),
//         mediaInformation: GoogleCastMediaInformationIOS(
//           contentId: '3',
//           streamType: CastMediaStreamType.buffered,
//           contentUrl: Uri.parse('http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4'),
//           contentType: 'video/mp4',
//           metadata: GoogleCastMovieMediaMetadata(
//             title: 'For Bigger Blazes',
//             subtitle:
//                 'Song : Raja Raja Kareja Mein Samaja\nAlbum : Raja Kareja Mein Samaja\nArtist : Radhe Shyam Rasia\nSinger : Radhe Shyam Rasia\nMusic Director : Sohan Lal, Dinesh Kumar\nLyricist : Vinay Bihari, Shailesh Sagar, Parmeshwar Premi\nMusic Label : T-Series',
//             releaseDate: DateTime(2011),
//             studio: 'T-Series Regional',
//             images: [
//               GoogleCastImage(
//                 url: Uri.parse('https://i.ytimg.com/vi/Dr9C2oswZfA/maxresdefault.jpg'),
//                 height: 480,
//                 width: 854,
//               ),
//             ],
//           ),
//         ),
//       ),
//       beforeItemWithId: 2,
//     );
//   }
//
//   String? _getImage(GoogleCastMediaMetadata? metadata) {
//     if (metadata == null) {
//       return null;
//     }
//     if (metadata.images?.isEmpty ?? true) {
//       return null;
//     }
//     return metadata.images!.first.url.toString();
//   }
// }
