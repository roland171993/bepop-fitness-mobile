import '../utils/shared_import.dart';
import 'package:mobx/mobx.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen>
    with SingleTickerProviderStateMixin {
  bool isFav = true;

  ObservableList<BookmarkData> mPostList = ObservableList<BookmarkData>();
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
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !appStore.isLoading) {
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
    await getBookMarkPostsApi(page: page).then((value) {
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        print("-------93>>>fddfdfdfdf");
        mPostList.clear();
      }
      Iterable it = value.data ?? [];
      it.map((e) => mPostList.add(e)).toList();
      heartVisibleList =
          List.generate(mPostList.length, (_) => ValueNotifier(false));
      appStore.setLoading(false);
    }).catchError((e, s) {
      isLastPage = true;
      appStore.setLoading(false);
    });
  }

  Future<void> reportComment(String? reason, int? postId) async {
    appStore.setLoading(true);
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
    appStore.setLoading(true);
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
    appStore.setLoading(true);
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
    await bookMarkPostApi(req).then((value) {
      init();
    }).catchError((e) {
      debugPrint('----error-${e}---');
    });
  }

  Future<void> updateReComment(
      String? msg, int? commentId, int postingId) async {
    Map req = {
      "id": commentId,
      "posting_id": postingId,
      "comment": msg,
    };
    appStore.setLoading(true);
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
    appStore.setLoading(true);
    await saveReCommentApi(req).then((value) {
      appStore.setLoading(false);
      commentController.clear();
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  Future<void> commentList(int? postId) async {
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
      print("bookmark ===> ${isShowReply.toString()}");
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
        statusBarIconBrightness:
            appStore.isDarkMode ? Brightness.light : Brightness.light,
        systemNavigationBarIconBrightness:
            appStore.isDarkMode ? Brightness.light : Brightness.light,
      ),
      child: Scaffold(
        appBar: appBarWidget(languages.lblPostBmk,
            center: true,
            color: appStore.isDarkMode ? scaffoldColorDark : Colors.white,
            context: context,
            titleSpacing: 16,
            actions: []),
        body: Observer(builder: (_) {
          return Stack(
            children: [
              if (mPostList.isNotEmpty) ...[
                SingleChildScrollView(
                  controller: scrollController,
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: mPostList.length,
                        itemBuilder: (context, index) {
                          _pageControllers[index] ??= PageController();
                          return Card(
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            margin: EdgeInsets.symmetric(
                                horizontal: 6, vertical: 6),
                            child: Column(
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    cachedImage(
                                      mPostList[index]
                                              .posts
                                              ?.users
                                              ?.profileImage ??
                                          '',
                                      fit: BoxFit.cover,
                                      height: 40,
                                      width: 40,
                                    ).cornerRadiusWithClipRRect(20),
                                    8.width,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            mPostList[index]
                                                    .posts
                                                    ?.users
                                                    ?.displayName ??
                                                '',
                                            style: boldTextStyle(size: 16),
                                            maxLines: 3),
                                        5.height,
                                        Text(
                                          "${languages.posted} ${mPostList[index].posts?.createdAt}",
                                          style: secondaryTextStyle(
                                              size: 12,
                                              color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                    Spacer(),
                                    if (mPostList[index].posts?.users?.id !=
                                        userStore.userId)
                                      PopupMenuButton<int>(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        color: primaryOpacity,
                                        itemBuilder: (context) => [
                                          if (mPostList[index]
                                                  .posts
                                                  ?.users
                                                  ?.id !=
                                              userStore.userId) ...[
                                            PopupMenuItem(
                                                height: 38,
                                                onTap: () {
                                                  _showAnimatedDialog(
                                                      context,
                                                      mPostList[index]
                                                          .posts
                                                          ?.id);
                                                },
                                                value: 1,
                                                child: Text(
                                                  languages.lblReportPost,
                                                  style: primaryTextStyle(
                                                      color: appStore.isDarkMode
                                                          ? Colors.white
                                                          : scaffoldColorDark),
                                                )),
                                          ],
                                        ],
                                        child: Image.asset(ic_menu,
                                            height: 24,
                                            width: 24,
                                            color: primaryColor),
                                      ),
                                  ],
                                ).paddingSymmetric(
                                    horizontal: 16, vertical: 16),
                                ValueListenableBuilder(
                                    valueListenable: likeChange,
                                    builder: (context, value, child) {
                                      return GestureDetector(
                                        onDoubleTap: () async {
                                          mPostList[index].posts?.isLiked =
                                              !(mPostList[index]
                                                      .posts
                                                      ?.isLiked ??
                                                  false);
                                          if (mPostList[index]
                                              .posts!
                                              .isLiked
                                              .validate()) {
                                            mPostList[index]
                                                    .posts
                                                    ?.postingLikeCount =
                                                mPostList[index]
                                                        .posts!
                                                        .postingLikeCount
                                                        .validate() +
                                                    1;
                                            heartVisibleList[index].value =
                                                true;
                                            Future.delayed(Duration(seconds: 1),
                                                () {
                                              heartVisibleList[index].value =
                                                  false;
                                            });
                                          } else {
                                            mPostList[index]
                                                    .posts
                                                    ?.postingLikeCount =
                                                mPostList[index]
                                                        .posts!
                                                        .postingLikeCount
                                                        .validate() -
                                                    1;
                                          }
                                          likeChange.value++;
                                          await likePost(
                                              mPostList[index].posts?.id);
                                          _controller.forward(from: 0.0);
                                        },
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (mPostList[index]
                                                            .posts
                                                            ?.postingMediaArray !=
                                                        null &&
                                                    mPostList[index]
                                                        .posts!
                                                        .postingMediaArray!
                                                        .isNotEmpty) ...[
                                                  ValueListenableBuilder(
                                                      valueListenable:
                                                          pageChange,
                                                      builder: (context, value,
                                                          child) {
                                                        return Column(
                                                          children: [
                                                            if (mPostList[index]
                                                                        .posts
                                                                        ?.postingMediaArray !=
                                                                    null &&
                                                                mPostList[index]
                                                                    .posts!
                                                                    .postingMediaArray!
                                                                    .isNotEmpty)
                                                              SizedBox(
                                                                height: 280,
                                                                width: double
                                                                    .infinity,
                                                                child: PageView
                                                                    .builder(
                                                                  controller:
                                                                      _pageControllers[
                                                                          index],
                                                                  onPageChanged:
                                                                      (page) {
                                                                    _currentPages[
                                                                            index] =
                                                                        page;
                                                                    pageChange
                                                                        .value++;
                                                                  },
                                                                  itemCount: mPostList[
                                                                          index]
                                                                      .posts
                                                                      ?.postingMediaArray!
                                                                      .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          mediaIndex) {
                                                                    final media = mPostList[
                                                                            index]
                                                                        .posts
                                                                        ?.postingMediaArray![mediaIndex];
                                                                    if (media?.mimeType ==
                                                                            "image/jpeg" ||
                                                                        media?.mimeType ==
                                                                            "image/png") {
                                                                      return cachedImage(
                                                                        media
                                                                            ?.url,
                                                                        height:
                                                                            280,
                                                                        width: double
                                                                            .infinity,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                      ).cornerRadiusWithClipRRect(10).onTap(
                                                                          () {
                                                                        List<String>
                                                                            urls =
                                                                            [];
                                                                        mPostList[index]
                                                                            .posts
                                                                            ?.postingMediaArray
                                                                            ?.forEach((e) {
                                                                          urls.add(e
                                                                              .url
                                                                              .validate());
                                                                        });
                                                                        _showFullScreenDialog(
                                                                          context,
                                                                          urls,
                                                                          mPostList[index].posts?.users?.displayName ??
                                                                              '',
                                                                        );
                                                                      }).paddingSymmetric(
                                                                          horizontal:
                                                                              6);
                                                                    } else {
                                                                      return AspectRatio(
                                                                        aspectRatio:
                                                                            16 /
                                                                                9,
                                                                        child:
                                                                            ChewieScreen(
                                                                          url: media!.url ??
                                                                              '',
                                                                          image:
                                                                              "",
                                                                          autoPlay:
                                                                              true,
                                                                        ),
                                                                      ).paddingSymmetric(
                                                                          horizontal:
                                                                              6);
                                                                    }
                                                                  },
                                                                ),
                                                              ),
                                                            7.height,
                                                            SmoothPageIndicator(
                                                              controller:
                                                                  _pageControllers[
                                                                      index]!,
                                                              count: mPostList[
                                                                      index]
                                                                  .posts!
                                                                  .postingMediaArray!
                                                                  .length,
                                                              effect:
                                                                  ExpandingDotsEffect(
                                                                dotHeight: 5,
                                                                dotWidth: 5,
                                                                activeDotColor:
                                                                    primaryColor,
                                                              ),
                                                            ).visible(mPostList[
                                                                        index]
                                                                    .posts!
                                                                    .postingMediaArray!
                                                                    .length >
                                                                1)
                                                          ],
                                                        );
                                                      }),
                                                ],
                                                Container(
                                                  width: double.infinity,
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        vertical: 10,
                                                        horizontal: 18),
                                                    child: ReadMoreText(
                                                      mPostList[index]
                                                              .posts!
                                                              .description ??
                                                          '',
                                                      trimLines: 5,
                                                      trimMode: TrimMode.Line,
                                                      trimCollapsedText:
                                                          languages.readMore,
                                                      trimExpandedText:
                                                          languages.readLess,
                                                      colorClickableText:
                                                          primaryColor,
                                                      style: primaryTextStyle(
                                                          size: 16),
                                                    ),
                                                    // Text(
                                                    //   mPostList[index].posts!.description ?? '',
                                                    //   textAlign: TextAlign.start,
                                                    //   style: primaryTextStyle(size: 16),
                                                    // ),
                                                  ),
                                                ).visible(!mPostList[index]
                                                    .posts!
                                                    .description
                                                    .isEmptyOrNull),
                                              ],
                                            ),
                                            // Heart animation overlay
                                            ValueListenableBuilder<bool>(
                                              valueListenable:
                                                  heartVisibleList[index],
                                              builder: (context, isVisible, _) {
                                                return IgnorePointer(
                                                  ignoring: !isVisible,
                                                  child: AnimatedOpacity(
                                                    opacity:
                                                        isVisible ? 1.0 : 0.0,
                                                    duration: Duration(
                                                        milliseconds: 300),
                                                    child: Icon(Icons.favorite,
                                                        color: Colors.redAccent,
                                                        size: 100),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        ValueListenableBuilder(
                                            valueListenable: likeChange,
                                            builder: (context, value, child) {
                                              return Image.asset(
                                                mPostList[index]
                                                        .posts!
                                                        .isLiked
                                                        .validate()
                                                    ? ic_like_filled
                                                    : ic_like,
                                                color: mPostList[index]
                                                        .posts!
                                                        .isLiked
                                                        .validate()
                                                    ? Colors.red
                                                    : Colors.black,
                                                height: 21,
                                                width: 21,
                                              ).onTap(() async {
                                                mPostList[index]
                                                        .posts
                                                        ?.isLiked =
                                                    !(mPostList[index]
                                                            .posts
                                                            ?.isLiked ??
                                                        false);
                                                if (mPostList[index]
                                                    .posts!
                                                    .isLiked
                                                    .validate()) {
                                                  mPostList[index]
                                                          .posts
                                                          ?.postingLikeCount =
                                                      mPostList[index]
                                                              .posts!
                                                              .postingLikeCount
                                                              .validate() +
                                                          1;
                                                } else {
                                                  mPostList[index]
                                                          .posts
                                                          ?.postingLikeCount =
                                                      mPostList[index]
                                                              .posts!
                                                              .postingLikeCount
                                                              .validate() -
                                                          1;
                                                }
                                                likeChange.value++;
                                                await likePost(
                                                    mPostList[index].posts?.id);
                                              });
                                            }),
                                        5.width,
                                        ValueListenableBuilder(
                                            valueListenable: likeChange,
                                            builder: (context, value, child) {
                                              return Text(
                                                  '${(mPostList[index].posts!.postingLikeCount ?? 0)}',
                                                  style: primaryTextStyle(
                                                      size: 17));
                                            }),
                                        ValueListenableBuilder(
                                            valueListenable: likeChange,
                                            builder: (context, value, child) {
                                              return Text(
                                                  mPostList[index]
                                                              .posts
                                                              ?.postingLikeCount ==
                                                          null
                                                      ? ' ${languages.lblLike}'
                                                      : (mPostList[index]
                                                                  .posts!
                                                                  .postingLikeCount! <=
                                                              1)
                                                          ? ' ${languages.lblLike}'
                                                          : ' ${languages.lblLikes}',
                                                  style: secondaryTextStyle(
                                                      size: 15,
                                                      color: Colors.grey[600]));
                                            }),
                                        15.width,
                                        GestureDetector(
                                          onTap: () async {
                                            if (isBottomSheetOpen) return;
                                            isBottomSheetOpen = true;
                                            mCommentList.clear();
                                            pageComment = 1;
                                            bottomSheetBuilder(
                                                index,
                                                mPostList[index].posts?.id,
                                                mPostList[index].posts?.id ??
                                                    0);
                                            await commentList(
                                                mPostList[index].posts?.id);
                                            isBottomSheetOpen = false;
                                          },
                                          child: SizedBox(
                                            child: Row(
                                              children: [
                                                Image.asset(ic_comment,
                                                    height: 20, width: 20),
                                                5.width,
                                                Text(
                                                    '${(mPostList[index].posts?.postingCommentCount ?? 0)}',
                                                    style: primaryTextStyle(
                                                        size: 17)),
                                                Text(
                                                    mPostList[index]
                                                                .posts
                                                                ?.postingCommentCount ==
                                                            null
                                                        ? ' ${languages.lblCmt}'
                                                        : (mPostList[index]
                                                                    .posts!
                                                                    .postingCommentCount! <=
                                                                1)
                                                            ? ' ${languages.lblCmt}'
                                                            : ' ${languages.lblComments}',
                                                    style: secondaryTextStyle(
                                                        size: 15,
                                                        color:
                                                            Colors.grey[600])),
                                              ],
                                            ),
                                          ),
                                        ),
                                        15.width,
                                        GestureDetector(
                                          onTap: () async {
                                            String postLink =
                                                '${mBackendURL}?postId=${mPostList[index].posts?.id}';
                                            Share.share(
                                                '${languages.checkOutPost} $postLink');
                                          },
                                          child: SizedBox(
                                            child: Row(
                                              children: [
                                                Image.asset(ic_share_community,
                                                    height: 20, width: 20),
                                                5.width,
                                                Text('${languages.share}',
                                                    style: secondaryTextStyle(
                                                        size: 15,
                                                        color:
                                                            Colors.grey[600]))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    ValueListenableBuilder(
                                        valueListenable: bookMarkChange,
                                        builder: (context, value, child) {
                                          return Image.asset(
                                                  mPostList[index]
                                                              .posts!
                                                              .isBookmark ??
                                                          false
                                                      ? ic_save_filled
                                                      : ic_save,
                                                  height: 20,
                                                  width: 20)
                                              .onTap(() async {
                                            mPostList[index].posts!.isBookmark =
                                                !(mPostList[index]
                                                        .posts!
                                                        .isBookmark ??
                                                    false);
                                            bookMarkChange.value++;
                                            await bookMarkPost(
                                                mPostList[index].posts!.id);
                                          });
                                        }),
                                  ],
                                ).paddingSymmetric(horizontal: 16),
                                10.height,
                              ],
                            ),
                          );
                        },
                      ),
                      8.height,
                    ],
                  ),
                ),
              ] else ...[
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(no_data_found,
                        height: context.height() * 0.2,
                        width: context.width() * 0.4),
                    16.height,
                    Text(languages.lblNoPost, style: boldTextStyle()),
                  ],
                ).center().visible(!appStore.isLoading)
              ],
              Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Loader())
                  .visible(appStore.isLoading)
            ],
          );
        }),
      ),
    );
  }

  bottomSheetBuilder(int index, int? postId, int? userId) {
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
            if (scrollControllerComment.position.pixels ==
                    scrollControllerComment.position.maxScrollExtent &&
                !appStore.isLoading) {
              if (pageComment < numPageComment!) {
                pageComment++;
                appStore.setLoading(true);
                await commentListApi(postId.validate(), pageComment)
                    .then((value) {
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
                  print("bookmark ===> ${isShowReply.toString()}");
                });
              }
            }
          });

          return Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    top: 10, bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(languages.lblComments, style: boldTextStyle(size: 24))
                        .paddingOnly(left: 12),
                    20.height,
                    Expanded(
                      child: Observer(builder: (_) {
                        return appStore.isLoading
                            ? SizedBox.shrink()
                            : ListView.builder(
                                controller: scrollControllerComment,
                                shrinkWrap: true,
                                itemCount: mCommentList.length,
                                itemBuilder: (context, i) {
                                  print(
                                      "---------427>>>${mCommentList[i].users?.id}");
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                      mCommentList[i]
                                                              .users
                                                              ?.displayName ??
                                                          '',
                                                      style: boldTextStyle(
                                                          size: 15),
                                                      maxLines: 3),
                                                  8.width,
                                                  Text(
                                                    extractRelativeTime(
                                                        mCommentList[i]
                                                            .createdAt
                                                            .toString()),
                                                    style: secondaryTextStyle(
                                                        size: 12),
                                                    maxLines: 1,
                                                  ),
                                                ],
                                              ),
                                              2.height,
                                              Text(
                                                  mCommentList[i].comment ?? '',
                                                  softWrap: true,
                                                  style: primaryTextStyle(
                                                      size: 15)),
                                            ],
                                          ).expand(),
                                          8.width,
                                          if (mCommentList[i].userId ==
                                              userStore.userId)
                                            PopupMenuButton<int>(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              color: primaryOpacity,
                                              itemBuilder: (context) => [
                                                if (mCommentList[i]
                                                    .canEdit
                                                    .validate()) ...[
                                                  PopupMenuItem(
                                                      onTap: () async {
                                                        updateReText =
                                                            mCommentList[i]
                                                                    .comment ??
                                                                '';
                                                        updateCommentId =
                                                            mCommentList[i]
                                                                    .id ??
                                                                0;
                                                        commentController.text =
                                                            mCommentList[i]
                                                                    .comment ??
                                                                '';
                                                        setState(() {});
                                                      },
                                                      value: 2,
                                                      child: Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Icon(
                                                            FontAwesomeIcons
                                                                .pen,
                                                            size: 16,
                                                          ),
                                                          6.width,
                                                          Text(
                                                            languages.edtCmt,
                                                            style: primaryTextStyle(
                                                                color: appStore
                                                                        .isDarkMode
                                                                    ? Colors
                                                                        .white
                                                                    : scaffoldColorDark),
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
                                                      showConfirmDialogCustom(
                                                          Navigator
                                                                  .of(context,
                                                                      rootNavigator:
                                                                          true)
                                                              .context,
                                                          dialogType:
                                                              DialogType.DELETE,
                                                          title: languages
                                                              .confirmDeleteComment,
                                                          primaryColor:
                                                              primaryColor,
                                                          positiveText:
                                                              languages
                                                                  .lblDelete,
                                                          image: ic_delete,
                                                          onAccept:
                                                              (buildContext) async {
                                                        Map req = {
                                                          "id": mCommentList[i]
                                                              .id,
                                                        };
                                                        appStore
                                                            .setLoading(true);
                                                        await deleteReCommentApi(
                                                                req)
                                                            .then((value) {
                                                          mPostList[index]
                                                                  .posts
                                                                  ?.postingCommentCount =
                                                              mPostList[index]
                                                                      .posts!
                                                                      .postingCommentCount! -
                                                                  1;
                                                          appStore.setLoading(
                                                              false);
                                                        }).catchError((e) {
                                                          appStore.setLoading(
                                                              false);
                                                        });
                                                        await commentList(
                                                            postId);
                                                      });
                                                    },
                                                    value: 3,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                          Icons.delete,
                                                          size: 20,
                                                        ),
                                                        6.width,
                                                        Text(
                                                          "${languages.dltCmt}",
                                                          style: primaryTextStyle(
                                                              color: appStore
                                                                      .isDarkMode
                                                                  ? Colors.white
                                                                  : scaffoldColorDark),
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                              child: Image.asset(ic_menu,
                                                  height: 24,
                                                  width: 24,
                                                  color: primaryColor),
                                            ),
                                        ],
                                      ),
                                      8.height,
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            replyComment =
                                                mCommentList[i].comment ?? "";
                                            replyName = mCommentList[i]
                                                    .users
                                                    ?.displayName ??
                                                "";
                                            replyId =
                                                mCommentList[i].id.toString();
                                            commentController.clear();
                                            FocusScope.of(context)
                                                .requestFocus(_focusNode);
                                          });
                                        },
                                        child: Text(
                                          languages.lblReply,
                                          style: secondaryTextStyle(
                                              size: 13, color: primaryColor),
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
                                            print(
                                                "bookmark  2 ===> ${isShowReply.toString()}");
                                          });
                                        },
                                        child: Text(
                                          !isShowReply[i]
                                              ? languages.lblViewR
                                              : languages.lblHideR,
                                          style: secondaryTextStyle(
                                              size: 13, color: primaryColor),
                                        ).paddingSymmetric(horizontal: 36),
                                      ).visible(mCommentList[i]
                                              .commentReplyCount
                                              .validate() >
                                          0),
                                      AnimatedListView(
                                        itemCount:
                                            mCommentList[i].commentReplyCount ??
                                                0,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        itemBuilder: (context, recommentIndex) {
                                          return Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 15, top: 7, bottom: 7),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      cachedImage(
                                                        mCommentList[i]
                                                                .commentReply?[
                                                                    recommentIndex]
                                                                .users
                                                                ?.profileImage ??
                                                            '',
                                                        fit: BoxFit.cover,
                                                        height: 35,
                                                        width: 35,
                                                      ).cornerRadiusWithClipRRect(
                                                          20),
                                                      SizedBox(width: 8),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisSize: MainAxisSize.min,
                                                        children: [
                                                          Row(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: [
                                                              Text(
                                                                mCommentList[i]
                                                                        .commentReply?[
                                                                            recommentIndex]
                                                                        .users
                                                                        ?.displayName ??
                                                                    '',
                                                                style:
                                                                    boldTextStyle(
                                                                        size:
                                                                            15),
                                                                maxLines: 3,
                                                              ),
                                                              6.width,
                                                              Text(
                                                                extractRelativeTime(mCommentList[
                                                                            i]
                                                                        .commentReply?[
                                                                            recommentIndex]
                                                                        .createdAt
                                                                        .toString() ??
                                                                    ""),
                                                                style:
                                                                    secondaryTextStyle(
                                                                        size:
                                                                            12),
                                                                maxLines: 1,
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                              mCommentList[i]
                                                                      .commentReply?[
                                                                          recommentIndex]
                                                                      .comment ??
                                                                  '',
                                                              softWrap: true,
                                                              style:
                                                                  primaryTextStyle(
                                                                      size:
                                                                          15)),
                                                        ],
                                                      ).expand(),
                                                      8.width,
                                                      if (mCommentList[i]
                                                              .commentReply![
                                                                  recommentIndex]
                                                              .userId ==
                                                          userStore.userId)
                                                        PopupMenuButton<int>(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10),
                                                          ),
                                                          color: primaryOpacity,
                                                          itemBuilder:
                                                              (context) => [
                                                            if (mCommentList[i]
                                                                .commentReply![
                                                                    recommentIndex]
                                                                .canEdit
                                                                .validate()) ...[
                                                              PopupMenuItem(
                                                                  onTap:
                                                                      () async {
                                                                    replyName =
                                                                        mCommentList[i].users?.displayName ??
                                                                            "";
                                                                    updateReText =
                                                                        mCommentList[i].commentReply![recommentIndex].comment ??
                                                                            '';
                                                                    updateReCommentId =
                                                                        mCommentList[i].commentReply![recommentIndex].id ??
                                                                            -1;
                                                                    updateCommentId =
                                                                        mCommentList[i].commentReply![recommentIndex].commentId ??
                                                                            0;
                                                                    commentController
                                                                        .text = mCommentList[i]
                                                                            .commentReply![recommentIndex]
                                                                            .comment ??
                                                                        '';
                                                                    FocusScope.of(
                                                                            context)
                                                                        .requestFocus(
                                                                            _focusNode);
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                  value: 2,
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .min,
                                                                    children: [
                                                                      Icon(
                                                                        FontAwesomeIcons
                                                                            .pen,
                                                                        size:
                                                                            16,
                                                                      ),
                                                                      6.width,
                                                                      Text(
                                                                        languages
                                                                            .edtRpl,
                                                                        style: primaryTextStyle(
                                                                            color: appStore.isDarkMode
                                                                                ? Colors.white
                                                                                : scaffoldColorDark),
                                                                      ),
                                                                    ],
                                                                  )),
                                                              PopupMenuItem<
                                                                  int>(
                                                                enabled: false,
                                                                height: 1,
                                                                padding:
                                                                    EdgeInsets
                                                                        .zero,
                                                                child:
                                                                    Container(
                                                                  height: 1,
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                            ],
                                                            PopupMenuItem(
                                                                onTap:
                                                                    () async {
                                                                  showConfirmDialogCustom(
                                                                      Navigator.of(
                                                                              context,
                                                                              rootNavigator:
                                                                                  true)
                                                                          .context,
                                                                      dialogType:
                                                                          DialogType
                                                                              .DELETE,
                                                                      title: languages
                                                                          .confirmDeleteCommentReply,
                                                                      primaryColor:
                                                                          primaryColor,
                                                                      positiveText:
                                                                          languages
                                                                              .lblDelete,
                                                                      image:
                                                                          ic_delete,
                                                                      onAccept:
                                                                          (buildContext) async {
                                                                    Map req = {
                                                                      "id": mCommentList[
                                                                              i]
                                                                          .commentReply![
                                                                              recommentIndex]
                                                                          .id,
                                                                    };
                                                                    appStore
                                                                        .setLoading(
                                                                            true);
                                                                    await deleteCommentReplyApi(
                                                                            req)
                                                                        .then(
                                                                            (value) {
                                                                      appStore.setLoading(
                                                                          false);
                                                                    }).catchError(
                                                                            (e) {
                                                                      appStore.setLoading(
                                                                          false);
                                                                    });
                                                                    await commentList(
                                                                        postId);
                                                                  });
                                                                },
                                                                value: 3,
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .delete,
                                                                      size: 20,
                                                                    ),
                                                                    6.width,
                                                                    Text(
                                                                      "${languages.dltRpl}",
                                                                      style: primaryTextStyle(
                                                                          color: appStore.isDarkMode
                                                                              ? Colors.white
                                                                              : scaffoldColorDark),
                                                                    ),
                                                                  ],
                                                                ))
                                                          ],
                                                          child: Image.asset(
                                                              ic_menu,
                                                              height: 24,
                                                              width: 24,
                                                              color:
                                                                  primaryColor),
                                                        ),
                                                    ],
                                                  ),
                                                ],
                                              ));
                                        },
                                      ).visible(mCommentList[i]
                                                  .commentReplyCount
                                                  .validate() >
                                              0 &&
                                          isShowReply[i]),
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
                                  style: secondaryTextStyle(
                                      size: 12,
                                      color: appStore.isDarkMode
                                          ? Colors.white
                                          : scaffoldColorDark),
                                ),
                                TextSpan(
                                  text: replyName,
                                  style: primaryTextStyle(
                                      size: 13,
                                      color: primaryColor,
                                      weight: FontWeight.w700),
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
                                color: appStore.isDarkMode
                                    ? Colors.white
                                    : scaffoldColorDark,
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
                            decoration: defaultInputDecoration(context,
                                label: languages.lblAddComments),
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
                            } else if (updateReText?.isNotEmpty == true &&
                                updateReCommentId != -1 &&
                                updateCommentId != 0) {
                              await updateCommentReply(commentController.text,
                                  updateCommentId, updateReCommentId);
                              updateReText = '';
                              updateReCommentId = -1;
                              updateCommentId = 0;
                              await commentList(postId);
                              return;
                            } else {
                              print("-------674>>>${updateText}");
                              if (updateReText?.isNotEmpty == true) {
                                await updateReComment(
                                    commentController.text,
                                    updateCommentId,
                                    mPostList[index].posts!.id.validate());
                                updateReText = '';
                                updateCommentId = 0;
                                await commentList(postId);
                                return;
                              }
                              if (updateText?.isNotEmpty == true) {
                                await updateComment(
                                    commentController.text, updateCommentId);
                                updateText = '';
                                updateCommentId = 0;
                              } else {
                                mPostList[index].posts?.postingCommentCount =
                                    mPostList[index]
                                            .posts!
                                            .postingCommentCount! +
                                        1;
                                await addComment(commentController.text,
                                    mPostList[index].posts?.id, postId);
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
                    width: double.infinity,
                    height: MediaQuery.sizeOf(context).height,
                    child: Loader().visible(appStore.isLoading).center());
                //return Loader().center().visible(appStore.isLoading);
              }),
            ],
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
            title: Text(languages.lblReports,
                style: primaryTextStyle(
                    color: appStore.isDarkMode
                        ? Colors.white
                        : scaffoldColorDark)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  style: primaryTextStyle(
                      color: appStore.isDarkMode
                          ? Colors.white
                          : scaffoldColorDark),
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

  void _showFullScreenDialog(
      BuildContext context, List<String>? imageUrl, String? userName) {
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) {
          return FullScreenDialogContent(
            imageUrls: imageUrl.validate(),
            userName: userName,
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
}
