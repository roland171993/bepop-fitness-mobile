import 'package:bepop_fitness/screens/payment_screen.dart';
import '../utils/shared_import.dart';

class SubscribeScreen extends StatefulWidget {
  SubscribeScreen({super.key});

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  ScrollController scrollController = ScrollController();

  List<SubscriptionModel> mSubscriptionListNew = [];
  String mSubscriptionDataGet = '';

  int page = 1;
  int? numPage;
  int? currentIndex = 0;

  bool isLastPage = false;

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
  }

  void init() async {
    getPackageData();
  }

  Future<void> getPackageData() async {
    appStore.setLoading(true);
    getSubscription().then((value) {
      appStore.setLoading(false);
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mSubscriptionListNew.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mSubscriptionListNew.add(e)).toList();
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
    });
  }

  Widget overlayContainer() {
    return Container(
      height: context.height() / 2.4,
      width: context.width(),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            appStore.isDarkMode
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.transparent,
            appStore.isDarkMode
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.3),
            appStore.isDarkMode
                ? context.scaffoldBackgroundColor
                : Colors.white,
          ],
        ),
      ),
    );
  }

  int selectedIndex = -1;

  Future<void> paymentConfirm(int? id) async {
    appStore.setLoading(true);
    Map req = {
      "package_id": id,
      "payment_status": "paid",
      "payment_type": 'free',
      "txn_id": "",
      "transaction_detail": ""
    };
    await subscribePackageApi(req).then((value) async {
      toast(value.message);
      await getUSerDetail(context, userStore.userId).whenComplete(() {
        setState(() {
          appStore.setLoading(false);
          LiveStream().emit(PAYMENT);
          finish(context);
          finish(context);
        });
      });
    }).catchError((e) {
      appStore.setLoading(false);
      print(e.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            appStore.isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness:
            appStore.isDarkMode ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
          backgroundColor: context.scaffoldBackgroundColor,
          body: SingleChildScrollView(
            clipBehavior: Clip.none,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  // alignment: Alignment.topLeft,
                  children: [
                    Image.asset(Subscribe_Bg,
                        fit: BoxFit.fill,
                        height: context.height() / 2.4,
                        width: context.width()),
                    overlayContainer(),
                    Positioned(
                      left: 16,
                      bottom: 0,
                      right: appStore.selectedLanguageCode == 'ar' ? 16 : 100,
                      child: Text(languages.lblPackageTitle,
                          style: boldTextStyle(
                              size: 26, color: primaryColor, height: 1.3),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: true),
                    ),
                    Positioned(
                      top: context.statusBarHeight,
                      child: IconButton(
                        onPressed: () {
                          finish(context);
                        },
                        icon: Icon(
                            appStore.selectedLanguageCode == 'ar'
                                ? MaterialIcons.arrow_forward_ios
                                : Octicons.chevron_left,
                            color: whiteColor,
                            size: 28),
                      ),
                    ),
                  ],
                ),
                4.height,
                Text(languages.lblPackageTitle1, style: secondaryTextStyle())
                    .paddingSymmetric(horizontal: 16, vertical: 8),
                16.height,
                Loader().center().visible(appStore.isLoading),
                if (!appStore.isLoading)
                  mSubscriptionListNew.isNotEmpty
                      ? Column(
                          children: [
                            AnimatedListView(
                              itemCount: mSubscriptionListNew.length,
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 16),
                                  padding: appStore.selectedLanguageCode == 'ar'
                                      ? EdgeInsets.symmetric(horizontal: 16)
                                      : EdgeInsets.symmetric(horizontal: 0),
                                  decoration: boxDecorationWithRoundedCorners(
                                      borderRadius: radius(12),
                                      border: Border.all(
                                          color: selectedIndex == index
                                              ? primaryColor
                                              : context.dividerColor)),
                                  child: Column(
                                    children: [
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                      selectedIndex == index
                                                          ? ic_radio_fill
                                                          : ic_radio,
                                                      height: 20,
                                                      width: 20,
                                                      color: primaryColor),
                                                  8.width,
                                                  Expanded(
                                                    child: Text(
                                                      mSubscriptionListNew[
                                                              index]
                                                          .name
                                                          .validate(),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: boldTextStyle(
                                                          size: 18),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Expanded(
                                              flex: 2,
                                              child: Row(
                                                children: [
                                                  PriceWidget(
                                                    price: mSubscriptionListNew[
                                                            index]
                                                        .price
                                                        ?.toStringAsFixed(2)
                                                        .validate(),
                                                    color: primaryColor,
                                                    textStyle: boldTextStyle(
                                                        color: primaryColor,
                                                        size: 20),
                                                  ),
                                                  2.width,
                                                  mSubscriptionListNew[index]
                                                              .durationUnit
                                                              .toString() ==
                                                          "monthly"
                                                      ? Text(
                                                          "/ " +
                                                              mSubscriptionListNew[
                                                                      index]
                                                                  .duration
                                                                  .toString()
                                                                  .validate() +
                                                              " " +
                                                              languages
                                                                  .lblMonth,
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style:
                                                              primaryTextStyle())
                                                      : Flexible(
                                                          child: Text(
                                                              "/ " +
                                                                  mSubscriptionListNew[
                                                                          index]
                                                                      .duration
                                                                      .toString()
                                                                      .validate() +
                                                                  " " +
                                                                  languages
                                                                      .lblYear
                                                                      .capitalizeFirstLetter(),
                                                              maxLines: 1,
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style:
                                                                  primaryTextStyle()),
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ]),
                                      10.height,
                                      HtmlWidget(
                                          postContent:
                                              mSubscriptionListNew[index]
                                                  .description
                                                  .validate()),
                                      8.height,
                                    ],
                                  ).paddingOnly(
                                      left: 16, right: 16, bottom: 8, top: 16),
                                ).onTap(() {
                                  setState(() {
                                    if (selectedIndex == index) {
                                      selectedIndex = -1;
                                    } else {
                                      selectedIndex = index;
                                    }
                                  });
                                });
                              },
                            ),
                            AppButton(
                              text: languages.lblSubscribe,
                              width: context.width(),
                              color: primaryColor,
                              onTap: () async {
                                print(
                                    "---------------->>>228${mSubscriptionListNew[selectedIndex].price ?? ''}");
                                selectedIndex == -1
                                    ? toast(languages.lblSelectPlanToContinue)
                                    : mSubscriptionListNew[selectedIndex]
                                                .price ==
                                            0
                                        ? paymentConfirm(
                                            mSubscriptionListNew[selectedIndex]
                                                .id)
                                        : PaymentScreen(
                                            mSubscriptionModel:
                                                mSubscriptionListNew[
                                                    selectedIndex],
                                          ).launch(context);
                              },
                            ).paddingSymmetric(horizontal: 16, vertical: 16),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(no_data_found,
                                height: context.height() * 0.2,
                                width: context.width() * 0.4),
                            16.height,
                            Text(languages.lblNoFoundData,
                                style: boldTextStyle()),
                          ],
                        ).center()
              ],
            ),
          )),
    );
  }
}
