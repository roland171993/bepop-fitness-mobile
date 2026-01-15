import '../utils/shared_import.dart';

class FilterWorkoutScreen extends StatefulWidget {
  final int? id;

  const FilterWorkoutScreen({super.key, this.id});

  @override
  State<FilterWorkoutScreen> createState() => _FilterWorkoutScreenState();
}

class _FilterWorkoutScreenState extends State<FilterWorkoutScreen> {
  ScrollController scrollController = ScrollController();

  List<WorkoutFilterList> list = [];
  List<WorkoutDetailModel> mWorkoutList = [];
  List<LevelModel> mLevelList = [];
  List<WorkoutTypeModel> mWorkoutTypeList = [];
  List<int> mSelectedList = [];
  int saveIndex = 0;
  int pages = 1;
  int page = 1;
  int? numPage;

  int pageLevel = 1;
  int? numPageLevel;
  bool isLastPageLevel = false;

  bool isLastPage = false;

  int pageWorkoutType = 1;
  int? numPageWorkoutType;
  bool isLastPageWorkoutType = false;

  @override
  void initState() {
    super.initState();
    getList();
    getWorkoutData();
    getWorkoutTypeData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !appStore.isLoading) {
        if (page < numPage!) {
          page++;
          // getWorkoutDataTypeData();
          getWorkoutData(
              isFilter: true,
              ids: (list[1].select.validate() || list[2].select.validate())
                  ? mSelectedList
                      .toString()
                      .removeAllWhiteSpace()
                      .replaceAll("[", "")
                      .replaceAll("]", "")
                      .trim()
                  : null,
              isTypes: list[1].select,
              isLevel: list[2].select);
        }
      }
    });
  }

  Future<void> setWorkout(int? id, int? isFavourite) async {
    pages = 1;
    appStore.setLoading(true);
    Map req = {"workout_id": id};
    await setWorkoutFavApi(req).then((value) async {
      toast(value.message);
      appStore.setLoading(false);
      if (isFavourite == 1) {
        isFavourite = 0;
      } else {
        isFavourite = 1;
      }
      appStore.setLoading(false);

      //  getWorkoutDataFavorites();
    }).catchError((e) {
      appStore.setLoading(false);
      setState(() {});
    });
  }

  Future<void> getWorkoutData(
      {bool? isFilter,
      bool? isLevel = false,
      bool? isTypes = false,
      var ids}) async {
    appStore.setLoading(true);
    await getWorkoutFilterListApi(
            page: page,
            id: widget.id.validate(),
            isFilter: isFilter,
            isLevel: isLevel,
            isType: isTypes,
            ids: ids)
        .then((value) {
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mWorkoutList.clear();
      }
      print(value);
      Iterable it = value.data!;
      it.map((e) => mWorkoutList.add(e)).toList();
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      setState(() {});
    });
  }

  Future<void> getWorkoutTypeData() async {
    appStore.setLoading(true);
    await getWorkoutTypeListApi(mPerPage: pageWorkoutType).then((value) {
      Iterable it = value.data!;
      numPageWorkoutType = value.pagination!.totalPages;

      isLastPageWorkoutType = false;
      if (pageWorkoutType == 1) {
        mWorkoutTypeList.clear();
      }
      it.map((e) => mWorkoutTypeList.add(e)).toList();
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);
    }).whenComplete(() {
      if (pageWorkoutType < numPageWorkoutType!) {
        pageWorkoutType++;
        getWorkoutTypeData();
      } else {
        getLevelData();
      }
    });
  }

  Future<void> getLevelData() async {
    appStore.setLoading(true);
    await getLevelListApi(page: pageLevel).then((value) {
      Iterable it = value.data!;
      numPageLevel = value.pagination!.totalPages;

      isLastPageLevel = false;
      if (pageLevel == 1) {
        mLevelList.clear();
      }

      it.map((e) => mLevelList.add(e)).toList();
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      isLastPageLevel = true;
      appStore.setLoading(false);
    }).whenComplete(() {
      if (pageLevel < numPageLevel!) {
        pageLevel++;
        getLevelData();
      }
    });
  }

  getList() {
    list.add(WorkoutFilterList(0, languages.lblAll, true));
    list.add(WorkoutFilterList(
        1,
        '${languages.lblWorkoutLevel.split(' ').first} ${languages.lblTypes}',
        false));
    list.add(WorkoutFilterList(2, languages.lblWorkoutLevel, false));
  }

  @override
  Widget build(BuildContext context) {
    var width = context.width();
    var height = 185.0;

    return Scaffold(
        appBar:
            appBarWidget(languages.lblWorkouts, elevation: 0, context: context),
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HorizontalList(
                      itemCount: list.length,
                      padding: EdgeInsets.only(left: 16, right: 8),
                      itemBuilder: (context, index) {
                        return Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                          decoration: boxDecorationWithRoundedCorners(
                              backgroundColor: list[index].select!
                                  ? primaryColor
                                  : context.scaffoldBackgroundColor,
                              borderRadius: radius(24),
                              border: Border.all(
                                  color: list[index].select!
                                      ? primaryColor
                                      : Colors.grey)),
                          child: Text(list[index].title.toString(),
                              style: secondaryTextStyle(
                                  color: list[index].select!
                                      ? Colors.white
                                      : Colors.grey),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ).onTap(() async {
                          setState(() {
                            for (int i = 0; i < list.length; i++) {
                              list[i].select = i == index;
                            }
                          });
                          if (list[index].id == 0) {
                            page = 1;
                            for (int i = 0; i < mWorkoutTypeList.length; i++) {
                              mWorkoutTypeList[i].select = false;
                            }
                            isSelectedAll = false;
                            for (int i = 0; i < mLevelList.length; i++) {
                              mLevelList[i].select = false;
                            }
                            isSecondSelectedAll = false;
                            getWorkoutData(isFilter: true);
                          } else {
                            await showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                useSafeArea: true,
                                backgroundColor: appStore.isDarkMode
                                    ? cardDarkColor
                                    : context.cardColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        radiusOnly(topRight: 18, topLeft: 18)),
                                builder: (BuildContext context) {
                                  return FilterWorkoutBottomSheet(
                                      listId: list[index].id,
                                      mLevelList: mLevelList,
                                      mWorkoutTypesList: mWorkoutTypeList,
                                      onCall: (List<int> mList) {
                                        page = 1;
                                        getWorkoutData(
                                          isFilter: true,
                                          ids: mList
                                              .toString()
                                              .removeAllWhiteSpace()
                                              .replaceAll("[", "")
                                              .replaceAll("]", "")
                                              .trim(),
                                          isTypes: list[index].id == 1
                                              ? true
                                              : false,
                                          isLevel: list[index].id == 2
                                              ? true
                                              : false,
                                        );
                                        mSelectedList = mList;
                                        print(mList);
                                      });
                                });
                          }
                        });
                      }),
                  16.height,
                  mWorkoutList.isNotEmpty
                      ? AnimatedListView(
                          shrinkWrap: true,
                          itemCount: mWorkoutList.length,
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemBuilder: (context, int i) {
                            return InkWell(
                              highlightColor: Colors.transparent,
                              splashColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              onTap: () async {
                                saveIndex = i;
                                userStore.subscription == "1"
                                    ? mWorkoutList[i].isPremium == 1
                                        ? userStore.isSubscribe == 0
                                            ? await SubscribeScreen()
                                                .launch(context)
                                            : await WorkoutDetailScreen(
                                                id: mWorkoutList[i].id,
                                                mWorkoutModel: mWorkoutList[i],
                                                onCall: (status) {
                                                  print(
                                                      "--------323>>${saveIndex}");
                                                  page = 1;
                                                  mWorkoutList.clear();
                                                  // getWorkoutDataCallBack();
                                                  getWorkoutData(
                                                      isFilter: true,
                                                      ids: (list[1]
                                                                  .select
                                                                  .validate() ||
                                                              list[2]
                                                                  .select
                                                                  .validate())
                                                          ? mSelectedList
                                                              .toString()
                                                              .removeAllWhiteSpace()
                                                              .replaceAll(
                                                                  "[", "")
                                                              .replaceAll(
                                                                  "]", "")
                                                              .trim()
                                                          : null,
                                                      isTypes: list[1].select,
                                                      isLevel: list[2].select);
                                                }).launch(context)
                                        : await WorkoutDetailScreen(
                                            id: mWorkoutList[i].id,
                                            mWorkoutModel: mWorkoutList[i],
                                            onCall: (status) {
                                              print(
                                                  "--------331>>${saveIndex}");
                                              print("--------333>>${status}");
                                              page = 1;
                                              mWorkoutList.clear();
                                              // getWorkoutDataCallBack();
                                              getWorkoutData(
                                                  isFilter: true,
                                                  ids: (list[1]
                                                              .select
                                                              .validate() ||
                                                          list[2]
                                                              .select
                                                              .validate())
                                                      ? mSelectedList
                                                          .toString()
                                                          .removeAllWhiteSpace()
                                                          .replaceAll("[", "")
                                                          .replaceAll("]", "")
                                                          .trim()
                                                      : null,
                                                  isTypes: list[1].select,
                                                  isLevel: list[2].select);
                                            }).launch(context)
                                    : await WorkoutDetailScreen(
                                        id: mWorkoutList[i].id,
                                        mWorkoutModel: mWorkoutList[i],
                                        onCall: (status) {
                                          page = 1;
                                          mWorkoutList.clear();
                                          // getWorkoutDataCallBack();
                                          getWorkoutData(
                                              isFilter: true,
                                              ids: (list[1].select.validate() ||
                                                      list[2].select.validate())
                                                  ? mSelectedList
                                                      .toString()
                                                      .removeAllWhiteSpace()
                                                      .replaceAll("[", "")
                                                      .replaceAll("]", "")
                                                      .trim()
                                                  : null,
                                              isTypes: list[1].select,
                                              isLevel: list[2].select);
                                        }).launch(context);
                                /*  page = 1;
                                mWorkoutList.clear();
                                getWorkoutDataCallBack();*/
                              },
                              child: Stack(
                                children: [
                                  cachedImage(
                                          mWorkoutList[i]
                                              .workoutImage
                                              .validate(),
                                          height: height,
                                          fit: BoxFit.cover,
                                          width: width)
                                      .cornerRadiusWithClipRRect(16),
                                  mBlackEffect(width, height, radiusValue: 16),
                                  Positioned(
                                    left: 16,
                                    top: 8,
                                    right: 12,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        userStore.subscription == "1"
                                            ? mWorkoutList[i].isPremium == 1
                                                ? mPro()
                                                : SizedBox()
                                            : SizedBox(),
                                        Container(
                                                decoration:
                                                    boxDecorationWithRoundedCorners(
                                                        backgroundColor: Colors
                                                            .white
                                                            .withValues(
                                                                alpha: 0.5),
                                                        boxShape:
                                                            BoxShape.circle),
                                                padding: EdgeInsets.all(5),
                                                child: Image.asset(
                                                  mWorkoutList[i].isFavouriteLocally ==
                                                              1 ||
                                                          mWorkoutList[i]
                                                                  .isFavourite ==
                                                              1
                                                      ? ic_favorite_fill
                                                      : ic_favorite,
                                                  color: mWorkoutList[i]
                                                                  .isFavouriteLocally ==
                                                              1 ||
                                                          mWorkoutList[i]
                                                                  .isFavourite ==
                                                              1
                                                      ? primaryColor
                                                      : white,
                                                  width: 20,
                                                  height: 20,
                                                ).center())
                                            .onTap(() {
                                          if (mWorkoutList[i].isFavourite ==
                                                  0 &&
                                              (mWorkoutList[i]
                                                          .isFavouriteLocally ==
                                                      null ||
                                                  mWorkoutList[i]
                                                          .isFavouriteLocally ==
                                                      0)) {
                                            mWorkoutList[i].isFavouriteLocally =
                                                1;
                                            mWorkoutList[i].isFavourite = 1;
                                          } else {
                                            mWorkoutList[i].isFavouriteLocally =
                                                0;
                                            mWorkoutList[i].isFavourite = 0;
                                          }
                                          print(
                                              "-------358>>${mWorkoutList[i].isFavouriteLocally}");
                                          setState(() {});
                                          setWorkout(
                                              mWorkoutList[i].id.validate(),
                                              mWorkoutList[i].isFavourite);
                                        }),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: 16,
                                    right: 16,
                                    bottom: 16,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            mWorkoutList[i]
                                                .title
                                                .capitalizeFirstLetter()
                                                .validate(),
                                            style: boldTextStyle(color: white)),
                                        2.height,
                                        Row(
                                          children: [
                                            Container(
                                                margin:
                                                    EdgeInsets.only(right: 6),
                                                height: 6,
                                                width: 6,
                                                decoration:
                                                    boxDecorationWithRoundedCorners(
                                                        boxShape:
                                                            BoxShape.circle,
                                                        backgroundColor:
                                                            white)),
                                            Text(
                                                '${mWorkoutList[i].workoutTypeTitle.validate()}',
                                                style: secondaryTextStyle(
                                                    color: white)),
                                            8.width,
                                            Container(
                                                height: 14,
                                                width: 2,
                                                color: primaryColor),
                                            8.width,
                                            Text(
                                                mWorkoutList[i]
                                                    .levelTitle
                                                    .validate(),
                                                style: secondaryTextStyle(
                                                    color: white)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ).paddingBottom(16),
                            );
                          },
                        )
                      : SizedBox(
                          height: context.height() * 0.6,
                          child:
                              NoDataScreen(mTitle: languages.lblWorkoutNoFound)
                                  .center()
                                  .visible(!appStore.isLoading),
                        )
                ],
              ),
            ),
            Observer(builder: (context) {
              return Container(
                      color: Colors.transparent,
                      width: double.infinity,
                      height: double.infinity,
                      child: Loader().center())
                  .visible(appStore.isLoading);
            })
          ],
        ));
  }
}

class WorkoutFilterList {
  int? id;
  String? title;
  bool? select;

  WorkoutFilterList(this.id, this.title, this.select);
}
