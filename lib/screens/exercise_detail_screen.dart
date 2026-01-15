import 'dart:ui';
import '../utils/shared_import.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final int? mExerciseId;
  final String? mExerciseName;
  final String? workOutId;

  ExerciseDetailScreen({this.mExerciseId, this.mExerciseName, this.workOutId});

  @override
  _ExerciseDetailScreenState createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen> {
  ExerciseDetailResponse? mExerciseModel;
  ScrollController mScrollController = ScrollController();
  var mode = "portrait";
  int? mWeight = 1;
  bool isKGClicked = false;
  bool isLBSClicked = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (userStore.adsBannerDetailShowAdsOnExerciseDetail == 1)
      loadInterstitialAds();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget logSetWidget(String text, String subText) {
    return RichText(
      text: TextSpan(
        text: text,
        style: boldTextStyle(size: 20),
        children: [
          WidgetSpan(
            child: Padding(
              padding: EdgeInsets.only(left: 8),
              child: Text(subText, style: secondaryTextStyle()),
            ),
          )
        ],
      ),
    );
  }

  Widget getHeading(String title) {
    return Row(children: [
      Image.asset(ic_level, color: primaryColor, height: 18, width: 18),
      10.width,
      Text(title, style: primaryTextStyle()),
    ]).paddingSymmetric(horizontal: 16);
  }

  Widget dividerHorizontalLine({bool? isSmall = false}) {
    return Container(
      height: isSmall == true ? 40 : 65,
      width: 4,
      color: context.scaffoldBackgroundColor,
    );
  }

  Widget mSetText(String value, {String? value2}) {
    if (isLBSClicked == true && isKGClicked == false) {
      double kgValue = double.tryParse(value2 ?? " ") ?? 0;
      double lbsValue = kgValue * 2.20462;
      value2 = lbsValue.toStringAsFixed(2);
      //print("-----BBB>>>${lbsValue.toStringAsFixed(2)} lbs");
    }
    print("-----BBB>>>${value2}");

    return value2.isEmptyOrNull || value2 == '0.00'
        ? Text(value, style: boldTextStyle()).center()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value, style: boldTextStyle()),
              2.height,
              Text(
                "- ${value2?.validate() ?? '0'} ${isLBSClicked ? languages.lblLbs : languages.lblKg}",
                style: primaryTextStyle(size: 14),
              ),
              // Text("- " + value2.validate() + (isLBSClicked == true && isKGClicked == false)?languages.lblLbs:languages.lblKg, style: primaryTextStyle(size: 14)),
            ],
          );
  }

  Widget mSets1() {
    if (mExerciseModel?.data?.sets?.length == 1) {
      return mSetText(
          mExerciseModel?.data?.based == "reps"
              ? mExerciseModel?.data?.sets?.first.reps ?? '' + "x"
              : mExerciseModel?.data?.sets?.first.time ?? '' + "s",
          value2: mExerciseModel?.data?.sets?.first.weight.validate());
    } else if (mExerciseModel?.data?.sets?.length == 2) {
      return Row(children: [
        mSetText(
                mExerciseModel?.data?.based == "reps"
                    ? mExerciseModel?.data?.sets?.first.reps ?? "" + "x"
                    : mExerciseModel?.data?.sets?.first.time ?? '' + "s",
                value2: mExerciseModel?.data?.sets?.first.weight.validate())
            .expand(),
        dividerHorizontalLine(),
        mSetText(
                mExerciseModel?.data?.based == "reps"
                    ? mExerciseModel!.data!.sets![1].reps.validate() + "x"
                    : mExerciseModel?.data?.sets![1].time ?? '' + "s",
                value2: mExerciseModel?.data?.sets?[1].weight.validate())
            .expand(),
      ]);
    } else if (mExerciseModel?.data?.sets?.length == 3) {
      return Row(children: [
        mSetText(
                mExerciseModel?.data?.based == "reps"
                    ? mExerciseModel?.data?.sets![0].reps ?? '' + "x"
                    : mExerciseModel?.data?.sets![0].time ?? '' + "s",
                value2: mExerciseModel?.data?.sets![0].weight.validate())
            .expand(),
        dividerHorizontalLine(),
        mSetText(
                mExerciseModel?.data?.based == "reps"
                    ? mExerciseModel?.data?.sets![1].reps ?? "" + "x"
                    : mExerciseModel?.data?.sets![1].time ?? '' + "s",
                value2: mExerciseModel?.data?.sets![1].weight.validate())
            .expand(),
        dividerHorizontalLine(),
        mSetText(
                mExerciseModel?.data?.based == "reps"
                    ? mExerciseModel?.data?.sets![2].reps ?? '' + "x"
                    : mExerciseModel?.data?.sets![2].time ?? '' + "s",
                value2: mExerciseModel?.data?.sets![2].weight.validate())
            .expand(),
      ]);
    } else if (mExerciseModel!.data!.sets != null) {
      return HorizontalList(
        itemCount: mExerciseModel!.data!.sets!.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              16.width,
              mSetText(
                  mExerciseModel!.data!.based == "reps"
                      ? mExerciseModel!.data!.sets![index].reps.validate() + "x"
                      : mExerciseModel!.data!.sets![index].time.toString() +
                          "s",
                  value2: mExerciseModel!.data!.sets![index].weight.validate()),
              16.width,
              dividerHorizontalLine(),
              16.width,
            ],
          );
        },
      );
    } else {
      return SizedBox(child: Text(languages.lblNoSetsMsg).center());
    }
  }

  Widget mSets2() {
    if (mExerciseModel?.data?.sets != null &&
        mExerciseModel?.data?.sets?.length == 1) {
      return mSetText(mExerciseModel?.data?.sets?.first.rest ?? '' + "s");
    } else if (mExerciseModel?.data?.sets != null &&
        mExerciseModel?.data?.sets?.length == 2) {
      return Row(children: [
        mSetText(mExerciseModel?.data?.sets?[0].rest ?? '' + "s").expand(),
        dividerHorizontalLine(isSmall: true),
        mSetText(mExerciseModel?.data?.sets?[1].rest ?? '' + "s").expand(),
      ]);
    } else if (mExerciseModel?.data?.sets != null &&
        mExerciseModel?.data?.sets?.length == 3) {
      return Row(children: [
        mSetText(mExerciseModel?.data?.sets![0].rest ?? '' + "s").expand(),
        dividerHorizontalLine(isSmall: true),
        mSetText(mExerciseModel?.data?.sets![1].rest ?? '' + "s").expand(),
        dividerHorizontalLine(isSmall: true),
        mSetText(mExerciseModel?.data?.sets?[2].rest ?? '' + "s").expand(),
      ]);
    } else if (mExerciseModel?.data?.sets != null) {
      return HorizontalList(
        itemCount: mExerciseModel?.data?.sets?.length ?? 0,
        itemBuilder: (context, index) {
          return Row(
            children: [
              16.width,
              mSetText(mExerciseModel?.data?.sets?[index].rest ?? '' + "s"),
              16.width,
              dividerHorizontalLine(isSmall: true),
              16.width,
            ],
          );
        },
      );
    } else {
      return SizedBox(child: Text(languages.lblNoSetsMsg).center());
    }
  }

  @override
  void dispose() {
    if (userStore.adsBannerDetailShowAdsOnExerciseDetail == 1)
      showInterstitialAds();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      mode = "landScape";
    } else {
      mode = "portrait";
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(double.infinity, 56),
        child: Visibility(
          visible: mode == 'portrait' ? true : false,
          child: appBarWidget(widget.mExerciseName.validate(),
              context: context,
              actions: [
                Image.asset(ic_menu, height: 24, width: 24, color: primaryColor)
                    .paddingRight(16)
                    .onTap(() {
                  TipsScreen(
                    mExerciseVideo: mExerciseModel!.data!.videoUrl.validate(),
                    mTips: mExerciseModel!.data!.tips.validate(),
                    mExerciseImage:
                        mExerciseModel!.data!.exerciseImage.validate(),
                    mExerciseInstruction: mExerciseModel!.data!.instruction,
                  ).launch(context);
                })
              ]),
        ),
      ),
      bottomNavigationBar: FutureBuilder(
          future: geExerciseDetailApi(widget.mExerciseId),
          builder: (context, snapshot) {
            final hasData = snapshot.hasData && snapshot.data != null;
            return Visibility(
              visible: (mode == 'portrait' && hasData),
              child: AppButton(
                color: primaryColor,
                margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
                width: context.width(),
                onTap: () {
                  if (mExerciseModel?.data?.type == "duration") {
                    ExerciseDurationScreen(mExerciseModel, widget.workOutId)
                        .launch(context);
                  } else {
                    ExerciseDurationScreencast(
                            mExerciseModel: mExerciseModel,
                            workOutId: widget.workOutId)
                        .launch(context);
                    // ExerciseDurationScreen2(mExerciseModel,widget.workOutId).launch(context);
                  }
                },
                text: languages.lblStartExercise,
              ),
            );
          }),
      body: FutureBuilder(
        future: geExerciseDetailApi(widget.mExerciseId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            mExerciseModel = snapshot.data;
            return SingleChildScrollView(
              physics: mode == 'portrait'
                  ? AlwaysScrollableScrollPhysics()
                  : NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      mExerciseModel!.data!.videoUrl
                                  .validate()
                                  .contains("https://youtu") ||
                              mExerciseModel!.data!.videoUrl
                                  .validate()
                                  .contains("https://www.youtu")
                          ? AspectRatio(
                              aspectRatio: mode == "portrait" ? 12 / 7 : 15 / 7,
                              child: YoutubePlayerScreen(
                                  url:
                                      mExerciseModel!.data!.videoUrl.validate(),
                                  img: mExerciseModel!.data!.exerciseImage
                                      .validate(),
                                  hideControl: true))
                          : ChewieScreen(
                                  url:
                                      mExerciseModel!.data!.videoUrl.validate(),
                                  image: mExerciseModel!.data!.exerciseImage
                                      .validate(),
                                  autoPlay: false)
                              .center(),
                      Positioned(
                        left: 16,
                        top: 16,
                        child: userStore.subscription == "1"
                            ? mExerciseModel!.data!.isPremium == 1
                                ? mPro()
                                : SizedBox()
                            : SizedBox(),
                      )
                    ],
                  ),
                  16.height,
                  Row(
                    children: [
                      getHeading(mExerciseModel!.data!.levelTitle.validate())
                          .visible(
                              !mExerciseModel!.data!.levelTitle.isEmptyOrNull),
                      mExerciseModel?.data?.sets?.isNotEmpty ?? false
                          ? Container(
                              decoration: boxDecorationWithRoundedCorners(
                                borderRadius: radius(4),
                                backgroundColor: appStore.isDarkMode
                                    ? context.cardColor
                                    : GreyLightColor,
                              ),
                              padding: EdgeInsets.all(8),
                              margin: EdgeInsets.all(8),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  mWeightOption(languages.lblLbs, 0),
                                  4.width,
                                  mWeightOption(languages.lblKg, 1),
                                ],
                              ),
                            )
                          : SizedBox.shrink(),
                    ],
                  ),
                  12.height,
                  if (mExerciseModel!.data!.type == SETS)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            languages.lblRepsWeight,
                            style: secondaryTextStyle(
                                weight: FontWeight.bold, size: 12),
                          ),
                        ),
                        4.height,
                        Container(
                          width: context.width(),
                          decoration: boxDecorationWithRoundedCorners(
                              borderRadius: radius(),
                              backgroundColor: appStore.isDarkMode
                                  ? cardDarkColor
                                  : GreyLightColor.withValues(alpha: 0.3)),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: mSets1(),
                        ),
                      ],
                    ),
                  4.height,
                  if (mExerciseModel!.data!.type == SETS)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            languages.lblRest,
                            style: secondaryTextStyle(
                                weight: FontWeight.bold, size: 12),
                          ),
                        ),
                        4.height,
                        Container(
                          width: context.width(),
                          decoration: boxDecorationWithRoundedCorners(
                              borderRadius: radius(),
                              backgroundColor: appStore.isDarkMode
                                  ? cardDarkColor
                                  : GreyLightColor.withValues(alpha: 0.3)),
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          child: mSets2(),
                        ),
                      ],
                    ),
                  if (mExerciseModel!.data!.type == DURATION)
                    Container(
                      width: context.width(),
                      decoration: boxDecorationWithRoundedCorners(
                          borderRadius: radius(),
                          backgroundColor: appStore.isDarkMode
                              ? cardDarkColor
                              : GreyLightColor.withValues(alpha: 0.3)),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(mExerciseModel!.data!.duration.validate(),
                              style: boldTextStyle()),
                          2.height,
                          Text(languages.lblDuration,
                              style: primaryTextStyle()),
                        ],
                      ),
                    ).paddingSymmetric(horizontal: 16),
                  16.height,
                  Divider(endIndent: 16, indent: 16),
                  if (mExerciseModel!.data!.bodypartName != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        8.height,
                        Text(languages.lblBodyParts,
                                style: secondaryTextStyle())
                            .paddingSymmetric(horizontal: 16),
                        8.height,
                        HorizontalList(
                          physics: BouncingScrollPhysics(),
                          controller: mScrollController,
                          itemCount: mExerciseModel!.data!.bodypartName!.length,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          spacing: 16,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: context.width() * 0.18,
                              child: Column(
                                children: [
                                  cachedImage(
                                    mExerciseModel!.data!.bodypartName![index]
                                        .bodypartImage
                                        .validate(),
                                    fit: BoxFit.fill,
                                    height: 65,
                                    width: context.width() * 0.17,
                                  ).cornerRadiusWithClipRRect(150),
                                  6.height,
                                  Text(
                                      mExerciseModel!
                                          .data!.bodypartName![index].title
                                          .validate(),
                                      style: primaryTextStyle(size: 14),
                                      textAlign: TextAlign.center,
                                      maxLines: 2),
                                ],
                              ),
                            );
                          },
                        ),
                        Divider(endIndent: 16, indent: 16),
                      ],
                    ).visible(mExerciseModel!.data!.bodypartName!.isNotEmpty),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      8.height,
                      Text(languages.lblEquipments, style: secondaryTextStyle())
                          .paddingSymmetric(horizontal: 16),
                      16.height,
                      Stack(
                        alignment: Alignment.bottomCenter,
                        children: [
                          cachedImage(
                                  mExerciseModel!.data!.equipmentImg.validate(),
                                  height: 145,
                                  width: context.width() * 0.32,
                                  fit: BoxFit.cover)
                              .cornerRadiusWithClipRRect(12),
                          ClipRRect(
                            borderRadius: radius(12),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                width: context.width() * 0.32,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 10),
                                decoration: boxDecorationWithRoundedCorners(
                                    borderRadius: radius(12),
                                    backgroundColor: Colors.grey.shade100
                                        .withValues(alpha: 0.5)),
                                child: Text(
                                        mExerciseModel!.data!.equipmentTitle
                                            .validate(),
                                        style: primaryTextStyle(
                                            size: 12, color: Colors.black))
                                    .center(),
                              ),
                            ),
                          )
                        ],
                      ).paddingSymmetric(horizontal: 16),
                      30.height,
                    ],
                  ).visible(
                      !mExerciseModel!.data!.equipmentTitle.isEmptyOrNull),
                ],
              ),
            );
          }
          return snapWidgetHelper(snapshot);
        },
      ),
    );
  }

  Widget mWeightOption(String? value, int? index) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(4),
          backgroundColor: mWeight == index
              ? primaryColor
              : appStore.isDarkMode
                  ? context.cardColor
                  : GreyLightColor),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Text(value ?? '',
          style: secondaryTextStyle(
              size: 12,
              color:
                  mWeight == index ? Colors.white : textSecondaryColorGlobal)),
    ).onTap(() {
      mWeight = index;
      if (index == 0) {
        if (!isLBSClicked) {
          isLBSClicked = true;
          isKGClicked = false;
        }
      } else {
        if (!isKGClicked) {
          isKGClicked = true;
          isLBSClicked = false;
        }
      }
      setState(() {});
    });
  }
}
