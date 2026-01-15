import '../components/search_categorywise_bottomsheet.dart';
import '../utils/shared_import.dart';

class SearchScreen extends StatefulWidget {
  final int? id;

  const SearchScreen({
    this.id,
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ScrollController scrollController = ScrollController();
  TextEditingController mSearch = TextEditingController();
  FocusNode mSearchFocus = FocusNode();
  int? selectedFilterList = 0;

  List<CategoryModelList> list = [];
  List<ExerciseModel> mExerciseList = [];
  List<EquipmentModel> mEquipmentList = [];
  List<LevelModel> mLevelList = [];
  List<int>? mId = [];
  List<int> arrayList = [];

  int page = 1;
  int? numPage;

  bool isLastPage = false;
  bool _showClearButton = false;
  bool? mIsSearch = false;
  String? SelectedId = "";

  String? mSearchValue = "";

  int pageEquipment = 1;
  int? numPageEquipment;

  bool isLastPageEquipment = false;

  int pageLevel = 1;
  int? numPageLevel;
  bool isLastPageLevel = false;

  @override
  void initState() {
    super.initState();
    getList();
    getExerciseData();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !appStore.isLoading) {
        if (page < numPage!) {
          page++;
          getExercise().whenComplete(() {
            appStore.setLoading(false);
          });
        }
      }
    });
    mSearch.addListener(() {
      setState(() {
        _showClearButton = mSearch.text.length > 0;
      });
    });
  }

  Future<void> getExercise(
      {bool? isFilter = false,
      bool? isLevel = false,
      bool? isEquipment = false,
      var ids}) async {
    appStore.setLoading(true);
    await getExerciseApi(
            page: page,
            id: widget.id.validate(),
            isFilter: isFilter,
            ids: ids,
            isEquipment: isEquipment,
            isLevel: isLevel,
            mSearchValue: mSearchValue)
        .then((value) {
      numPage = value.pagination!.totalPages;
      isLastPage = false;
      if (page == 1) {
        mExerciseList.clear();
      }
      Iterable it = value.data!;
      it.map((e) => mExerciseList.add(e)).toList();
      setState(() {});
    }).catchError((e) {
      isLastPage = true;
      appStore.setLoading(false);
      setState(() {});
    });
  }

  Future<void> getExerciseData(
      {bool? isFilter = false,
      bool? isLevel = false,
      bool? isEquipment = false,
      var ids}) async {
    await getExercise(
            isFilter: isFilter,
            ids: ids,
            isEquipment: isEquipment,
            isLevel: isLevel)
        .whenComplete(() {
      if (mIsSearch == false) {
        if (isFilter == true) {
          appStore.setLoading(false);
        } else {
          getEquipmentBasedData();
        }
      } else {
        appStore.setLoading(false);
        setState(() {});
      }
    });
  }

  Future<void> getEquipmentBasedData() async {
    await getEquipmentListApi(page: pageEquipment).then((value) {
      Iterable it = value.data!;
      numPageEquipment = value.pagination!.totalPages;
      isLastPageEquipment = false;
      if (pageEquipment == 1) {
        mEquipmentList.clear();
      }

      it.map((e) => mEquipmentList.add(e)).toList();
      appStore.setLoading(false);
      setState(() {});
    }).catchError((e) {
      isLastPageEquipment = true;
      appStore.setLoading(false);
    }).whenComplete(() {
      if (pageEquipment < numPageEquipment!) {
        pageEquipment++;
        getEquipmentBasedData();
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

  Widget mExceriseList() {
    return AnimatedWrap(
      runSpacing: 8,
      spacing: 16,
      children: List.generate(mExerciseList.length, (index) {
        return ExerciseComponent(
          mExerciseModel: mExerciseList[index],
          onCall: () {
            mIsSearch = false;
            getExerciseData();
            setState(() {});
          },
        );
      }),
    ).paddingSymmetric(horizontal: 16);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: scrollController,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              30.height,
              Row(
                children: [
                  Icon(
                          appStore.selectedLanguageCode == 'ar'
                              ? MaterialIcons.arrow_forward_ios
                              : Octicons.chevron_left,
                          color: primaryColor,
                          size: 28)
                      .onTap(() {
                    Navigator.pop(context);
                  }),
                  16.width,
                  AppTextField(
                    controller: mSearch,
                    textFieldType: TextFieldType.OTHER,
                    isValidationRequired: true,
                    focus: mSearchFocus,
                    suffix: _getClearButton(),
                    decoration: defaultInputDecoration(context,
                        label: languages.lblSearchExercise),
                    onChanged: (v) {
                      mSearchValue = v;
                      mIsSearch = true;
                      mExerciseList.clear();
                      getExerciseData(
                          isFilter: true,
                          ids: SelectedId,
                          isEquipment: selectedFilterList == 1 ? true : false,
                          isLevel: selectedFilterList == 2 ? true : false);
                      setState(() {});
                    },
                  ).expand()
                ],
              ).paddingSymmetric(horizontal: 16, vertical: 16),
              HorizontalList(
                itemCount: list.length,
                padding: EdgeInsets.only(left: 16, right: 8),
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    decoration: boxDecorationWithRoundedCorners(
                        borderRadius: radius(24),
                        backgroundColor: list[index].select!
                            ? primaryColor
                            : context.scaffoldBackgroundColor,
                        border: Border.all(
                            color: list[index].select!
                                ? primaryColor
                                : context.dividerColor)),
                    child: Text(list[index].title.toString(),
                        style: secondaryTextStyle(
                            color: list[index].select!
                                ? Colors.white
                                : textSecondaryColorGlobal),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                  ).onTap(() async {
                    mSearchFocus.unfocus();
                    hideKeyboard(context);
                    for (int i = 0; i < list.length; i++) {
                      list[i].select = i == index;
                    }
                    setState(() {});
                    if (list[index].id == 0) {
                      mIsSearch = false;
                      getExerciseData(isFilter: true);
                    } else {
                      await showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        useSafeArea: true,
                        backgroundColor: context.cardColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: radiusOnly(topRight: 18, topLeft: 18),
                        ),
                        builder: (BuildContext context) {
                          selectedFilterList = list[index].id;
                          return SearchCategoryBottomSheet(
                            listId: list[index].id,
                            mEquipmentList: mEquipmentList,
                            mLevelList: mLevelList,
                            onCall: (List<int> mList) {
                              SelectedId = mList
                                  .toString()
                                  .removeAllWhiteSpace()
                                  .replaceAll("[", "")
                                  .replaceAll("]", "")
                                  .trim();
                              mIsSearch = false;
                              mExerciseList.clear();
                              page = 1;
                              getExerciseData(
                                  isFilter: true,
                                  ids: mList
                                      .toString()
                                      .removeAllWhiteSpace()
                                      .replaceAll("[", "")
                                      .replaceAll("]", "")
                                      .trim(),
                                  isEquipment:
                                      list[index].id == 1 ? true : false,
                                  isLevel: list[index].id == 2 ? true : false);
                              print(mList);
                            },
                          );
                        },
                      );
                    }
                  });
                },
              ),
              16.height,
              mSearchValue.isEmptyOrNull
                  ? mExerciseList.isNotEmpty
                      ? AnimatedListView(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: mExerciseList.length,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return ExerciseComponent(
                              mExerciseModel: mExerciseList[index],
                              onCall: () {
                                getExerciseData();
                              },
                            );
                          },
                        )
                      : SizedBox(
                          height: context.height() * 0.6,
                          child:
                              NoDataScreen(mTitle: languages.lblExerciseNoFound)
                                  .center()
                                  .visible(!appStore.isLoading),
                        )
                  : Stack(
                      children: [
                        mExceriseList().paddingTop(16),
                        SizedBox(
                          height: context.height() * 0.6,
                          child:
                              NoDataScreen(mTitle: languages.lblExerciseNoFound)
                                  .visible(mExerciseList.isEmpty)
                                  .center()
                                  .visible(!appStore.isLoading),
                        )
                      ],
                    ),
            ]),
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
      ),
    );
  }

  getList() {
    list.add(CategoryModelList(0, languages.lblAll, true));
    list.add(CategoryModelList(1, languages.lblEquipments, false));
    list.add(CategoryModelList(2, languages.lblLevels, false));
  }

  void filterList(List<int> mList) {
    mExerciseList
        .where((element) => mExerciseList.length > mList.length)
        .toList();

    print(mList);
  }

  Widget _getClearButton() {
    if (!_showClearButton) {
      return mSuffixTextFieldIconWidget(ic_search);
    }

    return IconButton(
      onPressed: () {
        setState(() {
          hideKeyboard(context);
          mSearchValue = "";
          page = 1;
          if (!mSearch.text.isEmptyOrNull) {
            mIsSearch = true;
            getExerciseData();
          }
          mSearch.clear();
        });
      },
      icon: Icon(Icons.clear),
    );
  }
}

class CategoryModelList {
  int? id;
  String? title;
  bool? select;

  CategoryModelList(this.id, this.title, this.select);
}
