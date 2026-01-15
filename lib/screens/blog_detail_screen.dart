import '../utils/shared_import.dart';

class BlogDetailScreen extends StatefulWidget {
  final BlogModel? mBlogModel;

  BlogDetailScreen({this.mBlogModel});

  @override
  _BlogDetailScreenState createState() => _BlogDetailScreenState();
}

class _BlogDetailScreenState extends State<BlogDetailScreen> {
  Map? req;

  late final WebViewController wbController;

  BlogModel? mBlog;

  @override
  void initState() {
    super.initState();
    wbController = WebViewController();
    init();
  }

  init() async {
    if (userStore.adsBannerDetailShowAdsOnBlogDetail == 1)
      loadInterstitialAds();
    req = {"id": widget.mBlogModel!.id};
    appStore.setLoading(true);
    await getBlogDetailApi(req!).then((value) {
      mBlog = value.data!;
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
    });
  }

  @override
  void dispose() {
    if (userStore.adsBannerDetailShowAdsOnBlogDetail == 1)
      showInterstitialAds();
    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  // String _onLoadHtmlStringExample() {
  //   return wbController.loadHtmlString(mBlog!.description.validate()).toString();
  // }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            appStore.isDarkMode ? Brightness.dark : Brightness.light,
        systemNavigationBarIconBrightness:
            appStore.isDarkMode ? Brightness.dark : Brightness.light,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            Stack(
              fit: StackFit.expand,
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  top: 0,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Hero(
                        tag: widget.mBlogModel!,
                        transitionOnUserGestures: true,
                        child: cachedImage(
                            widget.mBlogModel!.postImage?.validate(),
                            width: context.width(),
                            height: context.height() * 0.39,
                            fit: BoxFit.fill),
                      ),
                      mBlackEffect(context.width(), context.height() * 0.37,
                          radiusValue: 0),
                      Positioned(
                          top: context.statusBarHeight + 8,
                          left: 8,
                          child: Icon(
                                  appStore.selectedLanguageCode == 'ar'
                                      ? MaterialIcons.arrow_forward_ios
                                      : Octicons.chevron_left,
                                  color: Colors.white,
                                  size: 28)
                              .onTap(() {
                            Navigator.pop(context);
                          })),
                      Positioned(
                        top: context.statusBarHeight + 55,
                        left: 16,
                        child: Container(
                          decoration: boxDecorationWithRoundedCorners(
                              backgroundColor:
                                  whiteColor.withValues(alpha: (0.4)),
                              borderRadius: radius(8)),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(Icons.access_time_outlined,
                                          color: Colors.white, size: 16)
                                      .paddingRight(4),
                                ),
                                TextSpan(
                                    text: parseDocumentDate(DateTime.parse(
                                        widget.mBlogModel!.datetime
                                            .validate())),
                                    style: secondaryTextStyle(
                                        color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 40,
                        child: Text(widget.mBlogModel!.title.validate(),
                            style: boldTextStyle(color: Colors.white, size: 18),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      )
                    ],
                  ),
                ),
                DraggableScrollableSheet(
                  initialChildSize: 0.65,
                  minChildSize: 0.65,
                  maxChildSize: 0.9,
                  builder: (context, controller) => Container(
                    width: context.width(),
                    decoration: boxDecorationWithRoundedCorners(
                        borderRadius: radiusOnly(topLeft: 20.0, topRight: 20.0),
                        backgroundColor: context.scaffoldBackgroundColor),
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          widget.mBlogModel!.tagsName!.isNotEmpty
                              ? Wrap(
                                  runSpacing: 8,
                                  spacing: 8,
                                  children: List.generate(
                                    widget.mBlogModel!.tagsName!.length,
                                    (index) {
                                      return GestureDetector(
                                        onTap: (() {
                                          setState(() {});
                                        }),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration:
                                              boxDecorationWithRoundedCorners(
                                                  backgroundColor:
                                                      appStore.isDarkMode
                                                          ? context.cardColor
                                                          : Colors.white,
                                                  borderRadius: radius(24),
                                                  border: Border.all(
                                                      width: 0.3,
                                                      color: primaryColor)),
                                          child: Text(
                                              widget
                                                      .mBlogModel
                                                      ?.tagsName?[index]
                                                      .title ??
                                                  '',
                                              style: secondaryTextStyle(
                                                  color: primaryColor),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      );
                                    },
                                  ),
                                ).paddingOnly(
                                  left: 16,
                                  bottom: 16,
                                  top: 16,
                                  right: appStore.selectedLanguageCode == 'ar'
                                      ? 16
                                      : 0)
                              : SizedBox().paddingOnly(top: 16),
                          widget.mBlogModel!.categoryName!.isNotEmpty
                              ? Wrap(
                                  direction: Axis.horizontal,
                                  //crossAxisAlignment: WrapCrossAlignment.start,
                                  spacing: 8.4,
                                  runSpacing: 4.0,
                                  children: widget.mBlogModel?.categoryName
                                          ?.map((category) => Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 13,
                                                    top: 10,
                                                    bottom: 5,
                                                    right: 5),
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                        height: 6,
                                                        width: 6,
                                                        decoration:
                                                            boxDecorationWithRoundedCorners(
                                                                boxShape:
                                                                    BoxShape
                                                                        .circle,
                                                                backgroundColor:
                                                                    textSecondaryColorGlobal)),
                                                    8.width,
                                                    Text(category.title ?? '',
                                                        style:
                                                            secondaryTextStyle()),
                                                  ],
                                                ),
                                              ))
                                          .toList() ??
                                      [],
                                )
                              : SizedBox.shrink(),

                          /* ? Wrap(
                                  runSpacing: 9,
                                  spacing: 5,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Container(height: 6, width: 6, decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: textSecondaryColorGlobal)),
                                    2.width,
                                    Text(widget.mBlogModel!.title ?? '', style: secondaryTextStyle()),
                                    4.width,
                                  ],
                                ).paddingOnly(left: 16, bottom: 16, top: 16, right: appStore.selectedLanguageCode == 'ar' ? 16 : 0)
                              : SizedBox().paddingOnly(top: 16),*/
                          if (!appStore.isLoading)
                            HtmlWidget(
                                    postContent: mBlog?.description.validate())
                                .paddingSymmetric(horizontal: 8),
                          16.height,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Observer(builder: (context) {
              return Loader().center().visible(appStore.isLoading);
            }),
          ],
        ),
      ),
    );
  }
}
