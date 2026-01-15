import '../utils/shared_import.dart';

class SubscriptionDetailScreen extends StatefulWidget {
  final SubscriptionPlan? mList;

  const SubscriptionDetailScreen({super.key, this.mList});

  @override
  State<SubscriptionDetailScreen> createState() =>
      _SubscriptionDetailScreenState();
}

class _SubscriptionDetailScreenState extends State<SubscriptionDetailScreen> {
  List<SubscriptionPlan> mSubscriptionPlanList = [];
  String? activePlanData;
  bool select = true;

  ScrollController scrollController = ScrollController();

  int page = 1;
  int? numPage;

  bool isLastPage = false;

  @override
  void initState() {
    super.initState();
    init();
    LiveStream().on(PAYMENT, (p0) {
      init();
    });
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
  }

  @override
  void dispose() {
    super.dispose();
  }

  void init() async {
    getSubscriptionList();
  }

  Future<void> getSubscriptionList() async {
    appStore.setLoading(true);
    getSubScriptionPlanList(page: page).then((value) {
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mSubscriptionPlanList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mSubscriptionPlanList.add(e)).toList();

      mSubscriptionPlanList.forEach((e) {});

      setState(() {});
      appStore.setLoading(false);
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      setState(() {});
    });
  }

  Future<void> cancelPackage({int? id}) async {
    appStore.setLoading(true);
    Map req = {
      "id":
          id != null ? id : userStore.subscriptionDetail?.subscriptionPlan?.id,
    };
    await cancelPlanApi(req).then((value) async {
      await getUSerDetail(context, userStore.userId).whenComplete(() {
        userStore.isSubscribe = 0;
        setState(() {});
        toast(value.message);
        appStore.setLoading(false);
        finish(context);
      });
    }).catchError((e) {
      appStore.setLoading(false);
      print(e.toString());
    });
  }

  Color getTextColor(String? state) {
    switch (state) {
      case ACTIVE:
        return GreenColor;
      case INACTIVE:
        return Colors.grey;
      case CANCELLED:
        return RedColor;
      case EXPIRED:
        return YellowColor;
      default:
        return Colors.black;
    }
  }

  Color getBgColor(String? state) {
    switch (state) {
      case ACTIVE:
        return GreenColor.withValues(alpha: 0.15);
      case INACTIVE:
        return Colors.grey.withValues(alpha: 0.10);
      case CANCELLED:
        return RedColor.withValues(alpha: 0.10);
      case EXPIRED:
        return YellowColor.withValues(alpha: 0.5);
      default:
        return Colors.black;
    }
  }

  Widget buildSubscriptionWidget() {
    if (userStore.subscriptionDetail == null ||
        userStore.subscriptionDetail!.subscriptionPlan == null ||
        userStore.subscriptionDetail!.subscriptionPlan!.status == "inactive") {
      print("dfgdfgdfgdfg150");
      for (var status in mSubscriptionPlanList)
        if (status.status == 'active') {
          return SingleChildScrollView(
            child: Column(
              children: [
                16.height,
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: boxDecorationWithRoundedCorners(
                    backgroundColor: appStore.isDarkMode
                        ? cardDarkColor
                        : GreenColor.withValues(alpha: 0.10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            status.packageName ?? '',
                            style: boldTextStyle(),
                          ).expand(),
                          PriceWidget(
                            price: status.totalAmount
                                ?.validate()
                                .toStringAsFixed(2),
                            color: primaryColor,
                            textStyle:
                                boldTextStyle(color: primaryColor, size: 20),
                          ),
                        ],
                      ),
                      Text(
                        languages.lblYourPlanValid +
                            " " +
                            parseDocumentDate(DateTime.parse(
                                status.subscriptionStartDate.validate())) +
                            " ${languages.lblTo} " +
                            parseDocumentDate(DateTime.parse(
                                status.subscriptionEndDate.validate())),
                        style: primaryTextStyle(color: primaryColor, size: 12),
                      ),
                      8.height,
                      HtmlWidget(
                        postContent: status.packageData!.description.validate(),
                      ),
                      16.height,
                    ],
                  ),
                ),
                24.height,
                AppButton(
                  text: languages.lblCancelSubscription,
                  width: context.width(),
                  color: primaryOpacity,
                  textColor: primaryColor,
                  onTap: () {
                    cancelPackage(id: status.id);
                  },
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
          );
        }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(no_data_found,
              height: context.height() * 0.2, width: context.width() * 0.4),
          20.height,
          Text(
            languages.lblSubscriptionMsg,
            style: boldTextStyle(size: 16, color: textSecondaryColorGlobal),
          ),
          50.height,
          AppButton(
            text: languages.lblViewPlans,
            width: context.width(),
            color: primaryColor,
            onTap: () {
              SubscribeScreen()
                  .launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
            },
          ).paddingAll(16),
        ],
      );
    } else {
      print("dfgdfgdfgdfg173");

      return SingleChildScrollView(
        child: Column(
          children: [
            16.height,
            Container(
              padding: EdgeInsets.all(16),
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: appStore.isDarkMode
                    ? cardDarkColor
                    : GreenColor.withValues(alpha: 0.10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userStore.subscriptionDetail?.subscriptionPlan
                                ?.packageName ??
                            '',
                        style: boldTextStyle(),
                      ).expand(),
                      PriceWidget(
                        price: userStore
                            .subscriptionDetail?.subscriptionPlan?.totalAmount
                            ?.validate()
                            .toStringAsFixed(2),
                        color: primaryColor,
                        textStyle: boldTextStyle(color: primaryColor, size: 20),
                      ),
                    ],
                  ),
                  Text(
                    languages.lblYourPlanValid +
                        " " +
                        parseDocumentDate(DateTime.parse(userStore
                            .subscriptionDetail!
                            .subscriptionPlan!
                            .subscriptionStartDate
                            .validate())) +
                        " ${languages.lblTo} " +
                        parseDocumentDate(DateTime.parse(userStore
                            .subscriptionDetail!
                            .subscriptionPlan!
                            .subscriptionEndDate
                            .validate())),
                    style: primaryTextStyle(color: primaryColor, size: 12),
                  ),
                  8.height,
                  HtmlWidget(
                    postContent: userStore.subscriptionDetail!.subscriptionPlan!
                        .packageData!.description
                        .validate(),
                  ),
                  16.height,
                ],
              ),
            ),
            24.height,
            AppButton(
              text: languages.lblCancelSubscription,
              width: context.width(),
              color: primaryOpacity,
              textColor: primaryColor,
              onTap: () {
                cancelPackage();
              },
            ),
          ],
        ).paddingSymmetric(horizontal: 16),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblSubscriptionPlans,
          context: context,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(45),
            child: Container(
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: context.dividerColor))),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1.5,
                                color: select
                                    ? primaryColor
                                    : Colors.transparent))),
                    child: Text(languages.lblActive,
                            style: boldTextStyle(
                                color: select
                                    ? primaryColor
                                    : textSecondaryColorGlobal))
                        .center(),
                  ).onTap(() {
                    setState(() {
                      select = !select;
                    });
                  }).expand(),
                  Container(
                    padding: EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1.5,
                                color: select
                                    ? Colors.transparent
                                    : primaryColor))),
                    child: Text(languages.lblHistory,
                            style: boldTextStyle(
                                color: select
                                    ? textSecondaryColorGlobal
                                    : primaryColor))
                        .center(),
                  ).onTap(() {
                    setState(() {
                      select = !select;
                      print("-----167>>>${select}");
                    });
                  }).expand(),
                ],
              ).paddingSymmetric(horizontal: 16),
            ),
          )),
      body: Stack(children: [
        select
            ? /*userStore.subscriptionDetail == null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(no_data_found, height: context.height() * 0.2, width: context.width() * 0.4),
                      20.height,
                      Text(languages.lblSubscriptionMsg, style: boldTextStyle(size: 16, color: textSecondaryColorGlobal)),
                      50.height,
                      AppButton(
                        text: languages.lblViewPlans,
                        width: context.width(),
                        color: primaryColor,
                        onTap: () {
                          SubscribeScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                        },
                      ).paddingAll(16)
                    ],
                  )
                : userStore.subscriptionDetail!.subscriptionPlan == null || userStore.subscriptionDetail!.subscriptionPlan!.status == "inactive"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(no_data_found, height: context.height() * 0.2, width: context.width() * 0.4),
                          20.height,
                          Text(languages.lblSubscriptionMsg, style: boldTextStyle(size: 16, color: textSecondaryColorGlobal)),
                          50.height,
                          AppButton(
                            text: languages.lblViewPlans,
                            width: context.width(),
                            color: primaryColor,
                            onTap: () {
                              SubscribeScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                            },
                          ).paddingAll(16)
                        ],
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            16.height,
                            Container(
                              padding: EdgeInsets.all(16),
                              decoration: boxDecorationWithRoundedCorners(backgroundColor: appStore.isDarkMode ? cardDarkColor : GreenColor.withValues(alpha:0.10)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(userStore.subscriptionDetail?.subscriptionPlan?.packageName ?? '', style: boldTextStyle()).expand(),
                                      PriceWidget(
                                          price: userStore.subscriptionDetail?.subscriptionPlan?.totalAmount.validate().toStringAsFixed(2),
                                          color: primaryColor,
                                          textStyle: boldTextStyle(color: primaryColor, size: 20)),
                                    ],
                                  ),
                                  Text(
                                      languages.lblYourPlanValid +
                                          " " +
                                          parseDocumentDate(DateTime.parse(userStore.subscriptionDetail!.subscriptionPlan!.subscriptionStartDate.validate())) +
                                          " ${languages.lblTo} " +
                                          parseDocumentDate(DateTime.parse(userStore.subscriptionDetail!.subscriptionPlan!.subscriptionEndDate.validate())),
                                      style: primaryTextStyle(color: primaryColor, size: 12)),
                                  8.height,
                                  HtmlWidget(postContent: userStore.subscriptionDetail!.subscriptionPlan!.packageData!.description.validate()),
                                  16.height,
                                ],
                              ),
                            ),
                            24.height,
                            AppButton(
                              text: languages.lblCancelSubscription,
                              width: context.width(),
                              color: primaryOpacity,
                              textColor: primaryColor,
                              onTap: () {
                                cancelPackage();
                              },
                            ),
                          ],
                        ).paddingSymmetric(horizontal: 16),
                      )*/

            buildSubscriptionWidget()
            : mSubscriptionPlanList.isNotEmpty
                ? AnimatedListView(
                    itemCount: mSubscriptionPlanList.length,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                    shrinkWrap: true,
                    controller: scrollController,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return mSubscriptionPlanList[index].status == 'inactive'
                          ? Container(
                              padding: EdgeInsets.all(16),
                              margin: EdgeInsets.only(bottom: 16),
                              decoration: boxDecorationWithRoundedCorners(
                                  backgroundColor: appStore.isDarkMode
                                      ? cardDarkColor
                                      : getBgColor(mSubscriptionPlanList[index]
                                          .status
                                          .validate())),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                              mSubscriptionPlanList[index]
                                                  .packageName
                                                  .validate(),
                                              style: boldTextStyle())
                                          .expand(),
                                      PriceWidget(
                                        price: mSubscriptionPlanList[index]
                                            .totalAmount
                                            .validate()
                                            .toStringAsFixed(2),
                                        color: primaryColor,
                                        textStyle: boldTextStyle(),
                                      ),
                                    ],
                                  ),
                                  8.height,
                                  Text(
                                    parseDocumentDate(DateTime.parse(
                                            mSubscriptionPlanList[index]
                                                .subscriptionStartDate
                                                .validate())) +
                                        " ${languages.lblTo} " +
                                        parseDocumentDate(DateTime.parse(
                                            mSubscriptionPlanList[index]
                                                .subscriptionEndDate
                                                .validate())),
                                    style: secondaryTextStyle(),
                                  ),
                                  8.height,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                              height: 6,
                                              width: 6,
                                              decoration:
                                                  boxDecorationWithRoundedCorners(
                                                      boxShape: BoxShape.circle,
                                                      backgroundColor:
                                                          textSecondaryColorGlobal)),
                                          6.width,
                                          Text(
                                              mSubscriptionPlanList[index]
                                                  .paymentType
                                                  .validate()
                                                  .capitalizeFirstLetter(),
                                              style: primaryTextStyle()),
                                        ],
                                      ).expand(),
                                      Text(
                                          mSubscriptionPlanList[index]
                                              .status
                                              .validate()
                                              .capitalizeFirstLetter(),
                                          style: boldTextStyle(
                                              color: getTextColor(
                                                  mSubscriptionPlanList[index]
                                                      .status
                                                      .validate())))
                                    ],
                                  )
                                ],
                              ),
                            )
                          : SizedBox.shrink();
                    },
                  )
                : SizedBox(
                        height: context.height() * 0.65,
                        child: NoDataScreen().center())
                    .visible(!appStore.isLoading),
        Observer(builder: (context) {
          return Container(
                  color: Colors.transparent,
                  width: double.infinity,
                  height: double.infinity,
                  child: Loader().center())
              .visible(appStore.isLoading);
        })
      ]),
    );
  }
}
