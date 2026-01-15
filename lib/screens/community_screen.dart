import 'package:mobx/mobx.dart';
import '../utils/shared_import.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> with SingleTickerProviderStateMixin {
  bool isFav = true;

  // List<PostData> mPostList = [];
  //List<PostData> mPinList = [];
  //List<CommentData> mCommentList = [];
  ObservableList<PostData> mPostList = ObservableList<PostData>();
  ObservableList<PostData> mPinList = ObservableList<PostData>();
  ObservableList<CommentData> mCommentList = ObservableList<CommentData>();

  ScrollController scrollController = ScrollController();
  final ScrollController scrollControllerComment = ScrollController();

  ValueNotifier<int> likeChange = ValueNotifier(0);
  ValueNotifier<int> bookMarkChange = ValueNotifier(0);
  ValueNotifier<int> pageChange = ValueNotifier(0);
  late List<ValueNotifier<bool>> heartVisibleList;

  int page = 1;
  int? numPage;

  int pageComment = 1;
  int? numPageComment;

  bool isLastPage = false;
  bool isLastPageComment = false;

  late AnimationController _controller;
  // late Animation<double> _animation;
  bool isBottomSheetOpen = false;
  List<bool> isShowReply = [];
  final Map<int, PageController> _pageControllers = {};
  final Map<int, int> _currentPages = {};

  String extractRelativeTime(String createdAt) {
    if (createdAt.contains("on")) {
      return createdAt.split("on")[0].trim();
    }
    return createdAt;
  }

  @override
  void initState() {
    super.initState();

    init();
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !appStore.isLoading) {
        if (page < numPage!) {
          page++;
          init();
        }
      }
    });

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    // _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
    //   CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    // );
  }

  @override
  void dispose() {
    _controller.dispose();
    scrollController.dispose();
    scrollControllerComment.dispose();
    _pageControllers.forEach((_, controller) => controller.dispose());
    super.dispose();
  }

  void init() async {
    getPostList();
  }

  Future<void> getPostList() async {
    appStore.setLoading(true);
    await getPostsApi(page: page).then((value) {
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        print("-------93>>>fddfdfdfdf");
        mPostList.clear();
        //      mPinList.clear();
      }
      Iterable it = value.data ?? [];
      it.map((e) => mPostList.add(e)).toList();
      //   Iterable its = value.postingList ?? [];
      //  its.map((e) => mPinList.add(e)).toList();
      heartVisibleList = List.generate(mPostList.length, (_) => ValueNotifier(false));
      appStore.setLoading(false);
    }).catchError((e, s) {
      isLastPage = true;
      appStore.setLoading(false);
    });
  }

  Future<void> reportComment(String? reason, int? postId) async {
    // appStore.setLoading(true);
    Map req = {
      "posting_id": postId,
      "reason": reason,
    };
    await reportApi(req).then((value) {
      toast(value.message.validate());
      init();
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  Future<void> addComment(String? msg, int? postId, int? reshreshPostId) async {
    Map req = {
      "id": null,
      "posting_id": postId,
      "comment": msg,
    };
    //appStore.setLoading(true);
    await saveCommentApi(req).then((value) {
      appStore.setLoading(false);
      commentController.clear();
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  Future<void> updateComment(String? msg, int? commentId) async {
    Map req = {
      "comment": msg,
    };
    //  appStore.setLoading(true);
    await updateCommentApi(req, commentId).then((value) {
      appStore.setLoading(false);
      commentController.clear();
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  Future<void> likePost(int? posting_id) async {
    Map req = {"posting_id": posting_id};
    await likePostApi(req).then((value) {
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  Future<void> deletePost(id) async {
    appStore.setLoading(true);
    Map req = {"id": id};
    await deletePostApi(req).then((value) {
      mPostList.removeWhere((post) => post.id == id);
      appStore.setLoading(false);
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  Future<void> bookMarkPost(id) async {
    Map req = {"posting_id": id};
    await bookMarkPostApi(req).then((value) {}).catchError((e) {
      debugPrint('----error-${e}---');
    });
  }

  Future<void> updateReComment(String? msg, int? commentId, int postingId) async {
    Map req = {
      "id": commentId,
      "posting_id": postingId,
      "comment": msg,
    };
    // appStore.setLoading(true);
    await updateReCommentApi(req).then((value) {
      appStore.setLoading(false);
      commentController.clear();
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  Future<void> updateCommentReply(String? msg, int? commentId, int? id) async {
    Map req = {
      "id": id,
      "comment_id": commentId,
      "comment": msg,
    };
    // appStore.setLoading(true);
    await saveReCommentApi(req).then((value) {
      appStore.setLoading(false);
      commentController.clear();
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  Future<void> commentList(int? postId, {bool isFirstTime = false}) async {
    if (isFirstTime) {
      appStore.setLoading(true);
    }
    await commentListApi(postId.validate(), pageComment).then((value) {
      appStore.setLoading(false);
      numPageComment = value.pagination!.totalPages;
      isLastPageComment = false;
      if (pageComment == 1) {
        mCommentList.clear();
        isShowReply.clear();
      }
      Iterable it = value.data!;
      isShowReply.clear();
      it.map((e) {
        mCommentList.add(e);
        isShowReply.add(true);
      }).toList();
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
    });
  }

  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.light,
        systemNavigationBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.light,
      ),
      child: Scaffold(
        appBar: appBarWidget(languages.lblCommunity,
            showBack: false,
            color: appStore.isDarkMode ? scaffoldColorDark : Colors.white,
            context: context,
            titleSpacing: 16,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: InkWell(
                    onTap: () async {
                      var data = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddPostScreen()),
                      );
                      if (data == "refresh") {
                        mPostList.clear();
                        page = 1;
                        getPostList();
                      }
                    },
                    borderRadius: BorderRadius.circular(35),
                    child: Container(
                      height: 32,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.add_circle_outline, color: Colors.white, size: 18),
                          SizedBox(width: 4),
                          Text(
                            languages.lblPost,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
        body: Observer(builder: (_) {
          return Material(
            color: Colors.grey.withOpacity(0.1),
            child: Stack(
              children: [
                if (mPostList.isNotEmpty) ...[
                  ListView.builder(
                    controller: scrollController,
                    physics: AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: mPostList.length,
                    itemBuilder: (context, index) {
                      _pageControllers[index] ??= PageController();
                      return Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                cachedImage(
                                  mPostList[index].users?.profileImage ?? '',
                                  fit: BoxFit.cover,
                                  height: 40,
                                  width: 40,
                                ).cornerRadiusWithClipRRect(20),
                                8.width,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(mPostList[index].users?.displayName ?? '', style: boldTextStyle(size: 16), maxLines: 3),
                                    5.height,
                                    Text("${languages.posted} ${mPostList[index].createdAt}",
                                        style: secondaryTextStyle(
                                          size: 12,
                                          color: textSecondaryColorGlobal,
                                        )
                                        // color: Colors.grey[600])
                                        ),
                                  ],
                                ),
                                Spacer(),
                                PopupMenuButton<int>(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  color: primaryOpacity,
                                  itemBuilder: (context) => [
                                    if (mPostList[index].users?.id != userStore.userId) ...[
                                      PopupMenuItem(
                                          height: 38,
                                          onTap: () {
                                            _showAnimatedDialog(context, mPostList[index].id);
                                          },
                                          value: 1,
                                          child: Text(
                                            languages.lblReportPost,
                                            style: primaryTextStyle(color: scaffoldColorDark),
                                          )),
                                    ],
                                    if (mPostList[index].users?.id == userStore.userId) ...[
                                      PopupMenuItem(
                                          height: 38,
                                          onTap: () async {
                                            var data = await Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => AddPostScreen(flow: 'EditFlow', postData: mPostList[index])),
                                            );
                                            if (data == "refresh") {
                                              mPostList.clear();
                                              page = 1;
                                              getPostList();
                                            }
                                          },
                                          value: 2,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                FontAwesomeIcons.pen,
                                                size: 16,
                                                color: Colors.black,
                                              ),
                                              6.width,
                                              Text(
                                                languages.lblEditPost,
                                                style: primaryTextStyle(color: scaffoldColorDark),
                                              ),
                                            ],
                                          )),
                                      PopupMenuItem<int>(
                                        enabled: false,
                                        height: 1,
                                        padding: EdgeInsets.zero,
                                        child: Container(
                                          height: 1,
                                          color: Colors.white,
                                        ),
                                      ),
                                      PopupMenuItem(
                                          height: 38,
                                          onTap: () {
                                            showConfirmDialogCustom(context,
                                                dialogType: DialogType.DELETE,
                                                title: languages.lblDeletePost,
                                                primaryColor: primaryColor,
                                                positiveText: languages.lblDelete,
                                                image: ic_delete, onAccept: (buildContext) {
                                              deletePost(mPostList[index].id);
                                            });
                                          },
                                          value: 3,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                size: 20,
                                                color: Colors.black,
                                              ),
                                              6.width,
                                              Text(
                                                languages.lblDelPost,
                                                style: primaryTextStyle(color: scaffoldColorDark),
                                              ),
                                            ],
                                          ))
                                    ],
                                  ],
                                  child: Image.asset(ic_menu, height: 24, width: 24, color: primaryColor),
                                ),
                              ],
                            ).paddingSymmetric(horizontal: 10, vertical: 16),
                            ValueListenableBuilder(
                                valueListenable: likeChange,
                                builder: (context, value, child) {
                                  return GestureDetector(
                                    onDoubleTap: () async {
                                      mPostList[index].isLiked = !(mPostList[index].isLiked ?? false);
                                      if (mPostList[index].isLiked.validate()) {
                                        mPostList[index].postingLikeCount = mPostList[index].postingLikeCount.validate() + 1;
                                        heartVisibleList[index].value = true;
                                        Future.delayed(Duration(seconds: 1), () {
                                          heartVisibleList[index].value = false;
                                        });
                                      } else {
                                        mPostList[index].postingLikeCount = mPostList[index].postingLikeCount.validate() - 1;
                                      }
                                      likeChange.value++;
                                      await likePost(mPostList[index].id);
                                      _controller.forward(from: 0.0);
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            if (mPostList[index].postingMediaArray!.isNotEmpty) ...[
                                              ValueListenableBuilder(
                                                  valueListenable: pageChange,
                                                  builder: (context, value, child) {
                                                    return Column(
                                                      children: [
                                                        if (mPostList[index].postingMediaArray != null &&
                                                            mPostList[index].postingMediaArray!.isNotEmpty)
                                                          LayoutBuilder(
                                                            builder: (context, constraints) {
                                                              double size = constraints.maxWidth;
                                                              return SizedBox(
                                                                height: size,
                                                                width: size,
                                                                child: PageView.builder(
                                                                  controller: _pageControllers[index],
                                                                  onPageChanged: (page) {
                                                                    _currentPages[index] = page;
                                                                    pageChange.value++;
                                                                  },
                                                                  itemCount: mPostList[index].postingMediaArray!.length,
                                                                  itemBuilder: (context, mediaIndex) {
                                                                    final media = mPostList[index].postingMediaArray![mediaIndex];
                                                                    if (media.mimeType == "image/jpeg" || media.mimeType == "image/png") {
                                                                      return cachedImage(
                                                                        media.url,
                                                                        height: size,
                                                                        width: size,
                                                                        fit: BoxFit.cover,
                                                                      ).cornerRadiusWithClipRRect(10).onTap(() async {
                                                                        List<String> urls = [];
                                                                        mPostList[index].postingMediaArray?.forEach((e) {
                                                                          urls.add(e.url.validate());
                                                                        });
                                                                        _showFullScreenDialog(
                                                                          context,
                                                                          urls,
                                                                          mPostList[index].users?.displayName ?? '',
                                                                          index,
                                                                        );
                                                                      }).paddingSymmetric(horizontal: 10);
                                                                    } else {
                                                                      return AspectRatio(
                                                                        aspectRatio: 16 / 9,
                                                                        child: ChewieScreen(
                                                                          url: media.url ?? '',
                                                                          image: "",
                                                                          autoPlay: true,
                                                                        ),
                                                                      ).onTap(() async {
                                                                        List<String> urls = [];
                                                                        mPostList[index].postingMediaArray?.forEach((e) {
                                                                          urls.add(e.url.validate());
                                                                        });
                                                                        _showFullScreenDialog(
                                                                          context,
                                                                          urls,
                                                                          mPostList[index].users?.displayName ?? '',
                                                                          index,
                                                                        );
                                                                      }).paddingSymmetric(horizontal: 10);
                                                                    }
                                                                  },
                                                                ),
                                                              );
                                                            }
                                                          ),
                                                        7.height,
                                                        SmoothPageIndicator(
                                                          controller: _pageControllers[index]!,
                                                          count: mPostList[index].postingMediaArray!.length,
                                                          effect: ExpandingDotsEffect(
                                                            dotHeight: 5,
                                                            dotWidth: 5,
                                                            activeDotColor: primaryColor,
                                                          ),
                                                        ).visible(mPostList[index].postingMediaArray!.length > 1)
                                                      ],
                                                    );
                                                  }),
                                            ],
                                            Container(
                                              width: double.infinity,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                                child: ReadMoreText(
                                                  mPostList[index].description ?? '',
                                                  trimLines: 3,
                                                  trimMode: TrimMode.Line,
                                                  trimCollapsedText: languages.readMore,
                                                  trimExpandedText: languages.readLess,
                                                  colorClickableText: primaryColor,
                                                  style: primaryTextStyle(size: 16),
                                                ),
                                                // Text(mPostList[index].description ?? '', textAlign: TextAlign.start, style: primaryTextStyle(size: 16))
                                              ),
                                            ).visible(!mPostList[index].description.isEmptyOrNull),
                                          ],
                                        ),
                                        // Heart animation overlay
                                        ValueListenableBuilder<bool>(
                                          valueListenable: heartVisibleList[index],
                                          builder: (context, isVisible, _) {
                                            return IgnorePointer(
                                              ignoring: !isVisible,
                                              child: AnimatedOpacity(
                                                opacity: isVisible ? 1.0 : 0.0,
                                                duration: Duration(milliseconds: 300),
                                                child: Icon(Icons.favorite, color: Colors.redAccent, size: 100),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                            Divider(
                              thickness: 0.25,
                            ).paddingSymmetric(horizontal: 8),
                            4.height,
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ValueListenableBuilder(
                                    valueListenable: likeChange,
                                    builder: (context, value, child) {
                                      return Image.asset(
                                        mPostList[index].isLiked.validate() ? ic_like_filled : ic_like,
                                        color: mPostList[index].isLiked.validate()
                                            ? Colors.red
                                            : appStore.isDarkMode
                                                ? GreyLightColor
                                                : Colors.black,
                                        height: 21,
                                        width: 21,
                                      ).onTap(() async {
                                        mPostList[index].isLiked = !(mPostList[index].isLiked ?? false);
                                        if (mPostList[index].isLiked.validate()) {
                                          mPostList[index].postingLikeCount = mPostList[index].postingLikeCount.validate() + 1;
                                        } else {
                                          mPostList[index].postingLikeCount = mPostList[index].postingLikeCount.validate() - 1;
                                        }
                                        likeChange.value++;
                                        await likePost(mPostList[index].id);
                                      });
                                    }),
                                5.width,
                                ValueListenableBuilder(
                                    valueListenable: likeChange,
                                    builder: (context, value, child) {
                                      return Text('${(mPostList[index].postingLikeCount ?? 0)}', style: primaryTextStyle(size: 17));
                                    }),
                                ValueListenableBuilder(
                                    valueListenable: likeChange,
                                    builder: (context, value, child) {
                                      return Text((mPostList[index].postingLikeCount! <= 1) ? ' ${languages.lblLike}' : ' ${languages.lblLikes}',
                                          style: secondaryTextStyle(size: 15, color: textSecondaryColorGlobal));
                                    }),
                                15.width,
                                GestureDetector(
                                  onTap: () async {
                                    if (isBottomSheetOpen) return;
                                    isBottomSheetOpen = true;
                                    mCommentList.clear();
                                    pageComment = 1;
                                    bottomSheetBuilder(index, mPostList[index].id, mPostList[index].users?.id ?? 0, isFirstTime: true);
                                    await commentList(mPostList[index].id, isFirstTime: true);
                                    isBottomSheetOpen = false;
                                  },
                                  child: SizedBox(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          ic_comment,
                                          height: 20,
                                          width: 20,
                                          color: appStore.isDarkMode ? GreyLightColor : Colors.black,
                                        ),
                                        5.width,
                                        Text('${(mPostList[index].postingCommentCount ?? 0)}', style: primaryTextStyle(size: 17)),
                                        Text((mPostList[index].postingCommentCount! <= 1) ? ' ${languages.lblCmt}' : ' ${languages.lblComments}',
                                            style: secondaryTextStyle(size: 15, color: textSecondaryColorGlobal)),
                                      ],
                                    ),
                                  ),
                                ),
                                15.width,
                                GestureDetector(
                                  onTap: () async {
                                    String postLink = '${mBackendURL}?postId=${mPostList[index].id}';
                                    Share.share('${languages.checkOutPost} $postLink');
                                  },
                                  child: SizedBox(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          ic_share_community,
                                          height: 20,
                                          width: 20,
                                          color: appStore.isDarkMode ? GreyLightColor : Colors.black,
                                        ),
                                        5.width,
                                        Text(languages.share, style: secondaryTextStyle(size: 15, color: textSecondaryColorGlobal))
                                      ],
                                    ),
                                  ),
                                ),
                                Spacer(),
                                ValueListenableBuilder(
                                    valueListenable: bookMarkChange,
                                    builder: (context, value, child) {
                                      return Image.asset(mPostList[index].isBookmark ?? false ? ic_save_filled : ic_save,
                                          color: appStore.isDarkMode ? GreyLightColor : Colors.black, height: 20, width: 20)
                                          .onTap(() async {
                                        mPostList[index].isBookmark = !(mPostList[index].isBookmark ?? false);
                                        bookMarkChange.value++;
                                        await bookMarkPost(mPostList[index].id);
                                      });
                                    }),
                              ],
                            ).paddingSymmetric(horizontal: 10),
                            10.height,
                          ],
                        ),
                      );
                    },
                  ),
                  8.height,
                ] else ...[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(no_data_found, height: context.height() * 0.2, width: context.width() * 0.4),
                      16.height,
                      Text(languages.lblNoPost, style: boldTextStyle()),
                    ],
                  ).center().visible(!appStore.isLoading)
                ],
                Container(width: double.infinity, height: double.infinity, child: Loader()).visible(appStore.isLoading)
              ],
            ),
          );
        }),
      ),
    );
  }

  bottomSheetBuilder(int index, int? postId, int? userId, {bool isFirstTime = false}) {
    String? replyComment = '';
    String? replyId = '';
    String? replyName = '';
    String? updateText = '';
    String? updateReText = '';
    int? updateCommentId = 0;
    int? updateReCommentId = -1;
    FocusNode _focusNode = FocusNode();
    showModalBottomSheet(
      showDragHandle: true,
      backgroundColor: appStore.isDarkMode ? scaffoldColorDark : Colors.white,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          scrollControllerComment.addListener(() async {
            if (scrollControllerComment.position.pixels == scrollControllerComment.position.maxScrollExtent && !appStore.isLoading) {
              if (pageComment < numPageComment!) {
                pageComment++;
                appStore.setLoading(true);
                await commentListApi(postId.validate(), pageComment).then((value) {
                  appStore.setLoading(false);
                  numPageComment = value.pagination!.totalPages;
                  isLastPageComment = false;
                  if (pageComment == 1) {
                    mCommentList.clear();
                    isShowReply.clear();
                  }
                  Iterable it = value.data!;
                  isShowReply.clear();
                  it.map((e) {
                    mCommentList.add(e);
                    isShowReply.add(true);
                  }).toList();
                });
              }
            }
          });

          return SafeArea(
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(languages.lblComments, style: boldTextStyle(size: 24)).paddingOnly(left: 12),
                      20.height,
                      Expanded(
                        child: Observer(builder: (_) {
                          return appStore.isLoading && isFirstTime
                              ? SizedBox.shrink()
                              : ListView.builder(
                                  controller: scrollControllerComment,
                                  shrinkWrap: true,
                                  itemCount: mCommentList.length,
                                  itemBuilder: (context, i) {
                                    print("---------427>>>${mCommentList[i].users?.id}");
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            cachedImage(
                                              mCommentList[i].users?.profileImage,
                                              fit: BoxFit.cover,
                                              height: 33,
                                              width: 33,
                                            ).cornerRadiusWithClipRRect(20),
                                            8.width,
                                            Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(mCommentList[i].users?.displayName ?? '', style: boldTextStyle(size: 15), maxLines: 3),
                                                    8.width,
                                                    Text(
                                                      extractRelativeTime(mCommentList[i].createdAt.toString()),
                                                      style: secondaryTextStyle(size: 12),
                                                      maxLines: 1,
                                                    ),
                                                  ],
                                                ),
                                                2.height,
                                                Flexible(child: Text(mCommentList[i].comment ?? '', style: primaryTextStyle(size: 15),  softWrap: true,)),
                                              ],
                                            ).expand(),
                                           8.width,
                                            if (mCommentList[i].userId == userStore.userId)
                                              PopupMenuButton<int>(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                color: primaryOpacity,
                                                itemBuilder: (context) => [
                                                  if (mCommentList[i].canEdit.validate()) ...[
                                                    PopupMenuItem(
                                                        onTap: () async {
                                                          updateReText = mCommentList[i].comment ?? '';
                                                          updateCommentId = mCommentList[i].id ?? 0;
                                                          commentController.text = mCommentList[i].comment ?? '';
                                                          setState(() {});
                                                        },
                                                        value: 2,
                                                        child: Row(
                                                          mainAxisSize: MainAxisSize.min,
                                                          children: [
                                                            Icon(
                                                              FontAwesomeIcons.pen,
                                                              size: 16,
                                                              color: Colors.black,
                                                            ),
                                                            6.width,
                                                            Text(
                                                              languages.edtCmt,
                                                              style: primaryTextStyle(color: scaffoldColorDark),
                                                            ),
                                                          ],
                                                        )),
                                                    PopupMenuItem<int>(
                                                      enabled: false,
                                                      height: 1,
                                                      padding: EdgeInsets.zero,
                                                      child: Container(
                                                        height: 1,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                  PopupMenuItem(
                                                      onTap: () async {
                                                        showConfirmDialogCustom(Navigator.of(context, rootNavigator: true).context,
                                                            dialogType: DialogType.DELETE,
                                                            title: languages.confirmDeleteComment,
                                                            primaryColor: primaryColor,
                                                            positiveText: languages.lblDelete,
                                                            image: ic_delete, onAccept: (buildContext) async {
                                                          Map req = {
                                                            "id": mCommentList[i].id,
                                                          };
                                                          appStore.setLoading(true);
                                                          await deleteReCommentApi(req).then((value) {
                                                            mPostList[index].postingCommentCount = mPostList[index].postingCommentCount! - 1;
                                                            appStore.setLoading(false);
                                                          }).catchError((e) {
                                                            appStore.setLoading(false);
                                                          });
                                                          await commentList(postId);
                                                        });
                                                      },
                                                      value: 3,
                                                      child: Row(
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            Icons.delete,
                                                            size: 20,
                                                            color: Colors.black,
                                                          ),
                                                          6.width,
                                                          Text(
                                                            languages.dltCmt,
                                                            style: primaryTextStyle(color: scaffoldColorDark),
                                                          ),
                                                        ],
                                                      ))
                                                ],
                                                child: Image.asset(ic_menu, height: 24, width: 24, color: primaryColor),
                                              ),
                                          ],
                                        ),
                                        8.height,
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              replyComment = mCommentList[i].comment ?? "";
                                              replyName = mCommentList[i].users?.displayName ?? "";
                                              replyId = mCommentList[i].id.toString();
                                              commentController.clear();
                                              FocusScope.of(context).requestFocus(_focusNode);
                                            });
                                          },
                                          child: Text(
                                            languages.lblReply,
                                            style: secondaryTextStyle(size: 13, color: primaryColor),
                                          ).paddingSymmetric(horizontal: 36),
                                        ),
                                        8.height,
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              updateText = '';
                                              setState(() {
                                                isShowReply[i] = !isShowReply[i];
                                              });
                                            });
                                          },
                                          child: Text(
                                            !isShowReply[i] ? languages.lblViewR : languages.lblHideR,
                                            style: secondaryTextStyle(size: 13, color: primaryColor),
                                          ).paddingSymmetric(horizontal: 36),
                                        ).visible(mCommentList[i].commentReplyCount.validate() > 0),
                                        AnimatedListView(
                                          itemCount: mCommentList[i].commentReplyCount ?? 0,
                                          shrinkWrap: true,
                                          physics: NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, recommentIndex) {
                                            return Padding(
                                                padding: const EdgeInsets.only(left: 15, top: 7, bottom: 7),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        cachedImage(
                                                          mCommentList[i].commentReply?[recommentIndex].users?.profileImage ?? '',
                                                          fit: BoxFit.cover,
                                                          height: 35,
                                                          width: 35,
                                                        ).cornerRadiusWithClipRRect(20),
                                                        SizedBox(width: 8),
                                                        Column(
                                                          mainAxisSize: MainAxisSize.min,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Row(
                                                              mainAxisSize: MainAxisSize.min,
                                                              children: [
                                                                Text(
                                                                  mCommentList[i].commentReply?[recommentIndex].users?.displayName ?? '',
                                                                  style: boldTextStyle(size: 15),
                                                                  maxLines: 3,
                                                                ),
                                                                6.width,
                                                                Text(
                                                                  extractRelativeTime(
                                                                      mCommentList[i].commentReply?[recommentIndex].createdAt.toString() ?? ""),
                                                                  style: secondaryTextStyle(size: 12),
                                                                  maxLines: 1,
                                                                ),
                                                              ],
                                                            ),
                                                            Flexible(
                                                              child: Text(mCommentList[i].commentReply?[recommentIndex].comment ?? '',
                                                                  softWrap: true,
                                                                  style: primaryTextStyle(size: 15)),
                                                            ),
                                                          ],
                                                        ).expand(),
                                                        8.width,
                                                        if (mCommentList[i].commentReply![recommentIndex].userId == userStore.userId)
                                                          PopupMenuButton<int>(
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.circular(10),
                                                            ),
                                                            color: primaryOpacity,
                                                            itemBuilder: (context) => [
                                                              if (mCommentList[i].commentReply![recommentIndex].canEdit.validate()) ...[
                                                                PopupMenuItem(
                                                                    onTap: () async {
                                                                      replyName = mCommentList[i].users?.displayName ?? "";
                                                                      updateReText = mCommentList[i].commentReply![recommentIndex].comment ?? '';
                                                                      updateReCommentId = mCommentList[i].commentReply![recommentIndex].id ?? -1;
                                                                      updateCommentId = mCommentList[i].commentReply![recommentIndex].commentId ?? 0;
                                                                      commentController.text =
                                                                          mCommentList[i].commentReply![recommentIndex].comment ?? '';
                                                                      FocusScope.of(context).requestFocus(_focusNode);
                                                                      setState(() {});
                                                                    },
                                                                    value: 2,
                                                                    child: Row(
                                                                      mainAxisSize: MainAxisSize.min,
                                                                      children: [
                                                                        Icon(
                                                                          FontAwesomeIcons.pen,
                                                                          size: 16,
                                                                          color: Colors.black,
                                                                        ),
                                                                        6.width,
                                                                        Text(
                                                                          languages.edtRpl,
                                                                          style: primaryTextStyle(color: scaffoldColorDark),
                                                                        ),
                                                                      ],
                                                                    )),
                                                                PopupMenuItem<int>(
                                                                  enabled: false,
                                                                  height: 1,
                                                                  padding: EdgeInsets.zero,
                                                                  child: Container(
                                                                    height: 1,
                                                                    color: Colors.white,
                                                                  ),
                                                                ),
                                                              ],
                                                              PopupMenuItem(
                                                                  onTap: () async {
                                                                    showConfirmDialogCustom(Navigator.of(context, rootNavigator: true).context,
                                                                        dialogType: DialogType.DELETE,
                                                                        title: languages.confirmDeleteCommentReply,
                                                                        primaryColor: primaryColor,
                                                                        positiveText: languages.lblDelete,
                                                                        image: ic_delete, onAccept: (buildContext) async {
                                                                      Map req = {
                                                                        "id": mCommentList[i].commentReply![recommentIndex].id,
                                                                      };
                                                                      appStore.setLoading(true);
                                                                      await deleteCommentReplyApi(req).then((value) {
                                                                        appStore.setLoading(false);
                                                                      }).catchError((e) {
                                                                        appStore.setLoading(false);
                                                                      });
                                                                      await commentList(postId);
                                                                    });
                                                                  },
                                                                  value: 3,
                                                                  child: Row(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    children: [
                                                                      Icon(
                                                                        Icons.delete,
                                                                        size: 20,
                                                                        color: Colors.black,
                                                                      ),
                                                                      6.width,
                                                                      Text(
                                                                        languages.dltRpl,
                                                                        style: primaryTextStyle(color: scaffoldColorDark),
                                                                      ),
                                                                    ],
                                                                  ))
                                                            ],
                                                            child: Image.asset(ic_menu, height: 24, width: 24, color: primaryColor),
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ));
                                          },
                                        ).visible(mCommentList[i].commentReplyCount.validate() > 0 && isShowReply[i]),
                                        10.height,
                                      ],
                                    ).paddingSymmetric(horizontal: 16);
                                  },
                                );
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 200, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            20.width,
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Reply to ',
                                    style: secondaryTextStyle(size: 12, color: appStore.isDarkMode ? Colors.white : scaffoldColorDark),
                                  ),
                                  TextSpan(
                                    text: replyName,
                                    style: primaryTextStyle(size: 13, color: primaryColor, weight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            5.width,
                            GestureDetector(
                                onTap: () {
                                  setState(() {
                                    replyComment = '';
                                    replyName = '';
                                    replyId = '';
                                    updateText = '';
                                    updateReText = '';
                                    commentController.text = '';
                                  });
                                },
                                child: Icon(
                                  Icons.close,
                                  size: 15,
                                  color: appStore.isDarkMode ? Colors.white : scaffoldColorDark,
                                ))
                          ],
                        ),
                      ).visible(replyName?.isNotEmpty ?? false),
                      Row(
                        children: [
                          SizedBox(
                            height: 50,
                            child: AppTextField(
                              focus: _focusNode,
                              controller: commentController,
                              textFieldType: TextFieldType.MULTILINE,
                              isValidationRequired: true,
                              decoration: defaultInputDecoration(context, label: languages.lblAddComments),
                            ),
                          ).expand(),
                          8.width,
                          Icon(Icons.send, color: primaryColor).onTap(() async {
                            if (commentController.text.isNotEmpty) {
                              appStore.setLoading(true);
                              if (replyComment?.isNotEmpty ?? true) {
                                Map req = {
                                  "id": null,
                                  "comment_id": replyId,
                                  "comment": commentController.text,
                                };
                                await saveReCommentApi(req).then((value) {
                                  appStore.setLoading(false);
                                  commentController.clear();
                                  replyComment = '';
                                  replyName = '';
                                  replyId = '';
                                }).catchError((e) {
                                  appStore.setLoading(false);
                                });
                              } else if (updateReText?.isNotEmpty == true && updateReCommentId != -1 && updateCommentId != 0) {
                                await updateCommentReply(commentController.text, updateCommentId, updateReCommentId);
                                updateReText = '';
                                updateReCommentId = -1;
                                updateCommentId = 0;
                                await commentList(postId);
                                return;
                              } else {
                                print("-------674>>>${updateText}");
                                if (updateReText?.isNotEmpty == true) {
                                  await updateReComment(commentController.text, updateCommentId, mPostList[index].id.validate());
                                  updateReText = '';
                                  updateCommentId = 0;
                                  await commentList(postId);
                                  return;
                                }
                                if (updateText?.isNotEmpty == true) {
                                  await updateComment(commentController.text, updateCommentId);
                                  updateText = '';
                                  updateCommentId = 0;
                                } else {
                                  mPostList[index].postingCommentCount = mPostList[index].postingCommentCount! + 1;
                                  await addComment(commentController.text, mPostList[index].id, postId);
                                }
                              }
                              await commentList(postId);
                            }
                          }),
                        ],
                      ).paddingOnly(bottom: 16, left: 16, right: 16),
                    ],
                  ),
                ),
                Observer(builder: (context) {
                  return SizedBox(
                      width: double.infinity, height: MediaQuery.sizeOf(context).height, child: Loader().visible(appStore.isLoading).center());
                  //return Loader().center().visible(appStore.isLoading);
                }),
              ],
            ),
          );
        });
      },
    ).then((value) {
      print("--------911>>>${value}");
      if (value == null) {
        setState(() {});
      }
      /*  if (value == null) {
        getPostList();
      }*/
    });
  }

  void _showAnimatedDialog(BuildContext context, int? postId) {
    TextEditingController textController = TextEditingController();

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (context, animation1, animation2) {
        // ignore: deprecated_member_use
        return WillPopScope(
          onWillPop: () async => true,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(languages.lblReports, style: primaryTextStyle(color: appStore.isDarkMode ? Colors.white : scaffoldColorDark)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  style: primaryTextStyle(color: appStore.isDarkMode ? Colors.white : scaffoldColorDark),
                  controller: textController,
                  decoration: InputDecoration(
                    labelText: languages.lblRepoDes,
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(languages.lblCancel),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (textController.text.trim().isNotEmpty) {
                    await reportComment(textController.text.trim(), postId);
                    Navigator.of(context).pop();
                    // toast("${languages.lblRepo} ${textController.text.trim()}");
                  }
                },
                child: Text(languages.lblReports),
              ),
            ],
          ),
        );
      },
      transitionBuilder: (context, animation1, animation2, child) {
        return ScaleTransition(
          scale: CurvedAnimation(parent: animation1, curve: Curves.easeInOut),
          child: child,
        );
      },
    );
  }

  void _showFullScreenDialog(BuildContext context, List<String>? imageUrl, String? userName, int index) {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return FullScreenDialogContent(
            imageUrls: imageUrl.validate(),
            userName: userName,
            initialIndex: index,
          );
        },
        transitionsBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
          Widget child,
        ) {
          return FadeTransition(opacity: animation, child: child);
        }));
  }

  askForNameEntry() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Text(
                    languages.finishProfileSetting,
                    style: boldTextStyle(color: textPrimaryColorGlobal, size: 18),
                    maxLines: 2,
                  )).expand(),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.redAccent,
                  ))
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppButton(
                text: languages.gotoProfile,
                // width: context.width(),
                color: primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                onTap: () async {
                  await EditProfileScreen().launch(context);
                  Navigator.pop(context);
                },
              ).paddingSymmetric(horizontal: 16, vertical: 0).center(),
              // TextButton(
              //   onPressed: () {
              //
              //   },
              //   child: Text("Go"),
              // ),
            ],
          ),
          actions: [
            // TextButton(
            //   onPressed: () {
            //     // Navigator.of(context).pop();
            //     if(firstNameController.text.trim().isEmpty)return toast(languages.lblEnterFirstName);
            //     if(lastNameController.text.trim().isEmpty)return toast(languages.lblEnterLastName);
            //     saveProfile();
            //   },
            //   child: Text(languages.lblSave),
            // ),
            // TextButton(
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            //   child: Text(languages.lblCancel),
            // ),
          ],
        );
      },
    ).then(
      (value) {
        setState(() {});
      },
    );
  }
}
