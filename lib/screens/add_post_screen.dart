import 'dart:ui';
import 'package:path_provider/path_provider.dart';
import '../utils/shared_import.dart';
import 'package:image/image.dart' as img;

class AddPostScreen extends StatefulWidget {
  final String? flow;
  final PostData? postData;
  AddPostScreen({Key? key, this.flow, this.postData}) : super(key: key);

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _textController = TextEditingController();

  XFile? image;
  XFile? video;
  String? netWorkImage = '';
  String? netWorkVideo = '';
  List<AssetEntity> selectedAssets = [];
  List<String> existingImages = [];
  List<int> postIds = [];
  Map<String, Future<Uint8List?>> _thumbnailCache = {};

  Map<String, BoxFit> _fitModes = {};

  Future<void> deletePostMedia(id, mediaId) async {
    appStore.setLoading(true);
    Map req = {
      "posting_id": id,
      "ids": mediaId,
    };
    await deletePostMediaApi(req).then((value) {
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.flow == 'EditFlow') {
      _textController.text = widget.postData?.description ?? '';
      widget.postData?.postingMediaArray?.forEach((e) {
        existingImages.add(e.url.validate());
      });
    }
  }

  void removeExistingImage(int index) {
    setState(() {
      existingImages.removeAt(index);
    });
  }

  Future<File> convertToSquare(
      File originalFile, {
        required BoxFit fitMode,
      }) async {
    final bytes = await originalFile.readAsBytes();
    img.Image? original = img.decodeImage(bytes);
    if (original == null) throw Exception("Failed to decode image");

    int size = original.width > original.height ? original.width : original.height;

    if (fitMode == BoxFit.cover) {
      // Crop square
      int x = (original.width - size) ~/ 2;
      int y = (original.height - size) ~/ 2;

      img.Image cropped = img.copyCrop(
        original,
        x: x < 0 ? 0 : x,
        y: y < 0 ? 0 : y,
        width: size > original.width ? original.width : size,
        height: size > original.height ? original.height : size,
      );

      final tempDir = await Directory.systemTemp.createTemp();
      final squareFile = File('${tempDir.path}/square_cover.png')
        ..writeAsBytesSync(img.encodePng(cropped));
      return squareFile;
    } else {
      // 🔹 Step 1: Create a square background by resizing + cropping
      img.Image background = img.copyResizeCropSquare(original, size:  size);

      // 🔹 Step 2: Blur it
      background = img.gaussianBlur(background, radius:  55);

      // 🔹 Step 3: Overlay the original image in the center
      int x = (size - original.width) ~/ 2;
      int y = (size - original.height) ~/ 2;
      img.compositeImage(background, original, dstX: x, dstY: y);

      // 🔹 Step 4: Save
      final directory = await getTemporaryDirectory();
      String newPath =
          '${directory.path}/square_${DateTime.now().millisecondsSinceEpoch}.jpg';
      File newFile = File(newPath);
      await newFile.writeAsBytes(img.encodeJpg(background));
      return newFile;
    }
  }

  Future _submitPost() async {
    appStore.setLoading(true);

    MultipartRequest multiPartRequest =
    await getMultiPartRequest('save-userpost');
    multiPartRequest.fields['description'] = _textController.text;
    List<String> path = [];

    for (AssetEntity e in selectedAssets) {
      final file = await e.file;
      if (file != null) {
        final assetId = e.id;
        final fitMode = _fitModes[assetId] ?? BoxFit.cover;
        if(e.type == AssetType.image) {
          final squareFile = await convertToSquare(
            file,
            fitMode: fitMode,
          );
          path.add(squareFile.path);
        }
        else{
          path.add(file.path);
        }
      }
    }

    for (String filePath in path) {
      multiPartRequest.files.add(
        await MultipartFile.fromPath(
          'posting_media[]',
          filePath,
        ),
      );
    }

    multiPartRequest.headers.addAll(buildHeaderTokens());
    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);
        finish(context, 'refresh');
      },
      onError: (error) {
        log(multiPartRequest.toString());
        toast(error.toString());
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  Future _editPost(int? id) async {
    appStore.setLoading(true);

    MultipartRequest multiPartRequest =
    await getMultiPartRequest('update-userpost');
    multiPartRequest.fields['id'] = id.toString();
    multiPartRequest.fields['description'] = _textController.text;


    for (AssetEntity e in selectedAssets) {
      final file = await e.file;
      if (file != null && await file.exists()) {
        final assetId = e.id;
        final fitMode = _fitModes[assetId] ?? BoxFit.cover;
        if(e.type == AssetType.image) {
          final squareFile = await convertToSquare(
            file,
            fitMode: fitMode,
          );
          multiPartRequest.files.add(
            await MultipartFile.fromPath(
              'posting_media[]',
              squareFile.path,
            ),
          );
        }
        else{
          multiPartRequest.files.add(
            await MultipartFile.fromPath(
              'posting_media[]',
              file.path,
            ),
          );
        }

      }
      else {
        print("Skipping null or non-existent file: $e");
      }
    }

    multiPartRequest.headers.addAll(buildHeaderTokens());
    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        appStore.setLoading(false);
        finish(context, 'refresh');
      },
      onError: (error) {
        log(multiPartRequest.toString());
        toast(error.toString());
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  Future<void> pickMedia(BuildContext context) async {
    final photoStatus = await Permission.photos.request();
    final videoStatus = await Permission.videos.request();

    if (!photoStatus.isGranted || !videoStatus.isGranted) {
      showConfirmDialogCustom(
        context,
        title: languages.lblPermissionDescription,
        primaryColor: primaryColor,
        positiveText: languages.lblOpen,
        image: ic_logout,
        onAccept: (buildContext) async {
          await openAppSettings();
        },
      );
      return;
    }

    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        pickerTheme: AssetPicker.themeData(
          primaryColor,
          light: true,
        ),
        maxAssets: 10,
        requestType: RequestType.common,
      ),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        selectedAssets = result;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
          widget.flow == "EditFlow"
              ? languages.lblEditPost
              : languages.lblNewPost,
          context: context),
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Stack(
                children: [
                  if (widget.flow == "EditFlow") ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppTextField(
                          controller: _textController,
                          textFieldType: TextFieldType.MULTILINE,
                          isValidationRequired: true,
                          decoration: defaultInputDecoration(context, label: languages.WriteSomeThing),
                          onChanged: (value) {},
                        ),
                        20.height,
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.postData!.postingMediaArray!.length + selectedAssets.length,
                            itemBuilder: (context, index) {
                              if (index < widget.postData!.postingMediaArray!.length) {
                                final asset = widget.postData!.postingMediaArray![index];
                                final assetId = asset.id.toString();

                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      cachedImage(asset.url.validate(), width: 150, height: 150, fit: _fitModes[assetId] ?? BoxFit.cover).cornerRadiusWithClipRRect(10),
                                      if (asset.mimeType == "video/mp4")
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(Icons.videocam, color: Colors.white, size: 18),
                                        ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              postIds.add(widget.postData!.postingMediaArray![index].id.validate());
                                              widget.postData!.postingMediaArray!.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              color: Colors.black54,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(Icons.close, color: Colors.white, size: 16),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                final asset = selectedAssets[index - widget.postData!.postingMediaArray!.length];
                                final assetId = asset.id;
                                _thumbnailCache[assetId] ??= asset.thumbnailDataWithSize(ThumbnailSize(150, 150));

                                return FutureBuilder<Uint8List?>(
                                  future: _thumbnailCache[assetId],
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                        child: Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            Stack(
                                              alignment: Alignment.bottomRight,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(8),
                                                  child: Stack(
                                                    children: [
                                                      // Blurred background
                                                      ImageFiltered(
                                                        imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                                        child: Image.memory(
                                                          snapshot.data!,
                                                          width: 150,
                                                          height: 150,
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                      Container(
                                                        color: Colors.black.withOpacity(0.2), // optional dim overlay
                                                        width: 150,
                                                        height: 150,
                                                      ),

                                                      // Foreground image
                                                      Center(
                                                        child: Image.memory(
                                                          snapshot.data!,
                                                          width: 150,
                                                          height: 150,
                                                          fit: _fitModes[assetId] ?? BoxFit.cover,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                if (asset.type == AssetType.video)
                                                  Padding(
                                                    padding: const EdgeInsets.all(4.0),
                                                    child: Icon(Icons.videocam, color: Colors.white, size: 18),
                                                  ),
                                                Positioned(
                                                  top: 4,
                                                  right: 4,
                                                  child: GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        selectedAssets.removeAt(index);
                                                        _thumbnailCache.remove(assetId); // Optionally clear cache
                                                      });
                                                    },
                                                    child: Container(
                                                      padding: EdgeInsets.all(2),
                                                      decoration: BoxDecoration(
                                                        color: Colors.black54,
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Icon(Icons.close, color: Colors.white, size: 16),
                                                    ),
                                                  ),
                                                ),
                                                if (asset.type != AssetType.video)
                                                  Positioned(
                                                    bottom: 4,
                                                    left: 4,
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        setState(() {
                                                          if (_fitModes[assetId] == BoxFit.cover)
                                                            _fitModes[assetId] = BoxFit.contain;
                                                          else
                                                            _fitModes[assetId] = BoxFit.cover;
                                                        });
                                                      },
                                                      child: Container(
                                                        padding: EdgeInsets.all(2),
                                                        decoration: BoxDecoration(
                                                          color: Colors.black54,
                                                          shape: BoxShape.circle,
                                                        ),
                                                        child: Icon(Icons.fit_screen, color: Colors.white, size: 16),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            if (asset.type == AssetType.video)
                                              Padding(
                                                padding: const EdgeInsets.all(4.0),
                                                child: Icon(Icons.videocam, color: Colors.white, size: 18),
                                              ),
                                            Positioned(
                                              top: 4,
                                              right: 4,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedAssets.removeAt(index - widget.postData!.postingMediaArray!.length);
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black54,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(Icons.close, color: Colors.white, size: 16),
                                                ),
                                              ),
                                            ),
                                            if (asset.type != AssetType.video)
                                              Positioned(
                                                bottom: 4,
                                                left: 4,
                                                child: GestureDetector(
                                                  onTap: () async {
                                                    setState(() {
                                                      if (_fitModes[assetId] == BoxFit.cover)
                                                        _fitModes[assetId] = BoxFit.contain;
                                                      else
                                                        _fitModes[assetId] = BoxFit.cover;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                      color: Colors.black54,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Icon(Icons.fit_screen, color: Colors.white, size: 16),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Container(
                                        width: 100,
                                        height: 100,
                                        alignment: Alignment.center,
                                        child: CircularProgressIndicator(strokeWidth: 2),
                                      );
                                    }
                                  },
                                );
                              }
                            },
                          ),
                        ).visible((widget.postData!.postingMediaArray != null && widget.postData!.postingMediaArray!.isNotEmpty) ||
                            selectedAssets.isNotEmpty),
                        10.height,
                        DottedBorder(
                          color: Colors.grey,
                          strokeWidth: 1,
                          dashPattern: [6, 4],
                          borderType: BorderType.RRect,
                          radius: Radius.circular(8),
                          child: InkWell(
                            onTap: () async {
                              pickMedia(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.upload, color: appStore.isDarkMode ? Colors.white : Colors.black),
                                  SizedBox(width: 8),
                                  Text(languages.lblUMedia, style: primaryTextStyle()),
                                ],
                              ),
                            ),
                          ),
                        ),
                        20.height,
                        AppButton(
                            text: languages.lblEditPost,
                            width: context.width(),
                            color: primaryColor,
                            onTap: () async {
                              if (_textController.text.isNotEmpty || image != null || video != null || netWorkVideo != '' || netWorkImage != '') {
                                deletePostMedia(widget.postData!.id, postIds);
                                _editPost(widget.postData?.id ?? 0);
                              } else {
                                toast(languages.lblEmptyMsg);
                              }
                            }),
                      ],
                    ).paddingSymmetric(horizontal: 16),
                  ]
                  else ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        AppTextField(
                          controller: _textController,
                          textFieldType: TextFieldType.MULTILINE,
                          isValidationRequired: true,
                          decoration: defaultInputDecoration(context, label: languages.WriteSomeThing),
                          onChanged: (value) {},
                        ),
                        20.height,
                        SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: selectedAssets.length,
                            itemBuilder: (context, index) {
                              final asset = selectedAssets[index];
                              final assetId = asset.id;

                              _thumbnailCache[assetId] ??= asset.thumbnailDataWithSize(ThumbnailSize(150, 150));

                              return FutureBuilder<Uint8List?>(
                                future: _thumbnailCache[assetId],
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                      child: Stack(
                                        alignment: Alignment.bottomRight,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(8),
                                            child: Stack(
                                              children: [
                                                // Blurred background
                                                ImageFiltered(
                                                  imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // 👈 adjust blur
                                                  child: Image.memory(
                                                    snapshot.data!,
                                                    width: 150,
                                                    height: 150,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                Container(
                                                  color: Colors.black.withOpacity(0.2), // optional dim overlay
                                                  width: 150,
                                                  height: 150,
                                                ),

                                                // Foreground image
                                                Center(
                                                  child: Image.memory(
                                                    snapshot.data!,
                                                    width: 150,
                                                    height: 150,
                                                    fit: _fitModes[assetId] ?? BoxFit.cover,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (asset.type == AssetType.video)
                                            Padding(
                                              padding: const EdgeInsets.all(4.0),
                                              child: Icon(Icons.videocam, color: Colors.white, size: 18),
                                            ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedAssets.removeAt(index);
                                                  _thumbnailCache.remove(assetId); // Optionally clear cache
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  color: Colors.black54,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Icon(Icons.close, color: Colors.white, size: 16),
                                              ),
                                            ),
                                          ),
                                          if (asset.type != AssetType.video)
                                            Positioned(
                                              bottom: 4,
                                              left: 4,
                                              child: GestureDetector(
                                                onTap: () async {
                                                  setState(() {
                                                    if (_fitModes[assetId] == BoxFit.cover)
                                                      _fitModes[assetId] = BoxFit.contain;
                                                    else
                                                      _fitModes[assetId] = BoxFit.cover;
                                                  });
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black54,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Icon(Icons.fit_screen, color: Colors.white, size: 16),
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      alignment: Alignment.center,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    );
                                  }
                                },
                              );
                            },
                          ),
                        ).visible(selectedAssets.isNotEmpty),
                        10.height,
                        DottedBorder(
                          color: Colors.grey,
                          strokeWidth: 1,
                          dashPattern: [6, 4],
                          borderType: BorderType.RRect,
                          radius: Radius.circular(8),
                          child: InkWell(
                            onTap: () async {
                              pickMedia(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              alignment: Alignment.center,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.upload, color: appStore.isDarkMode ? Colors.white : Colors.black),
                                  SizedBox(width: 8),
                                  Text(languages.lblUMedia, style: primaryTextStyle()),
                                ],
                              ),
                            ),
                          ),
                        ),
                        20.height,
                        AppButton(
                            text: languages.lblSharePost,
                            width: context.width(),
                            color: primaryColor,
                            onTap: () async {
                              if (_textController.text.isNotEmpty || image != null || video != null || netWorkVideo != '' || netWorkImage != '') {
                                _submitPost();
                              } else {
                                toast(languages.lblEmptyMsg);
                              }
                            }),
                      ],
                    ).paddingSymmetric(horizontal: 16),
                  ],
                  Observer(builder: (context) {
                    return SizedBox(
                        width: double.infinity, height: MediaQuery.sizeOf(context).height, child: Loader().visible(appStore.isLoading).center());
                  }),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
