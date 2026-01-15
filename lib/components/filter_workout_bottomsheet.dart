import '../utils/shared_import.dart';

bool isSelectedAll = false;
bool isSecondSelectedAll = false;

class FilterWorkoutBottomSheet extends StatefulWidget {
  final int? listId;
  final int? workoutTypeId;

  final Function? onCall;

  final List<LevelModel>? mLevelList;
  final List<WorkoutTypeModel>? mWorkoutTypesList;

  const FilterWorkoutBottomSheet(
      {super.key,
      this.listId,
      this.mLevelList,
      this.onCall,
      this.mWorkoutTypesList,
      this.workoutTypeId});

  @override
  State<FilterWorkoutBottomSheet> createState() =>
      _FilterWorkoutBottomSheetState();
}

class _FilterWorkoutBottomSheetState extends State<FilterWorkoutBottomSheet> {
  List<int> mLevelIdList = [];
  List<int> mWorkoutIdList = [];

  @override
  Widget build(BuildContext context) {
    mLevelIdList.clear();
    mWorkoutIdList.clear();
    return widget.listId == 1
        ? SingleChildScrollView(
            child: Wrap(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.close, size: 24, color: primaryColor)
                            .onTap(() {
                          finish(context);
                        }),
                        16.width,
                        Text(languages.lblTypes, style: boldTextStyle())
                            .expand(),
                        isSelectedAll
                            ? Text(languages.lblClearAll,
                                    style:
                                        primaryTextStyle(color: primaryColor))
                                .onTap(() {
                                for (int i = 0;
                                    i < widget.mWorkoutTypesList!.length;
                                    i++) {
                                  widget.mWorkoutTypesList![i].select = false;
                                }
                                isSelectedAll = false;
                                mWorkoutIdList.clear();
                                setState(() {});
                              })
                            : Text(languages.lblSelectAll,
                                    style:
                                        primaryTextStyle(color: primaryColor))
                                .onTap(() {
                                for (int i = 0;
                                    i < widget.mWorkoutTypesList!.length;
                                    i++) {
                                  widget.mWorkoutTypesList![i].select = true;
                                  mWorkoutIdList.add(widget
                                      .mWorkoutTypesList![i].id
                                      .validate());
                                  isSelectedAll = true;
                                }
                                setState(() {});
                              })
                      ],
                    ).paddingSymmetric(horizontal: 16, vertical: 16),
                    AnimatedListView(
                      itemCount: widget.mWorkoutTypesList!.length,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (widget.mWorkoutTypesList?[index].select == true) {
                          if (!mWorkoutIdList.contains(
                              widget.mWorkoutTypesList?[index].id.validate())) {
                            mWorkoutIdList.add(
                                widget.mWorkoutTypesList![index].id.validate());
                          }
                        } else {
                          mWorkoutIdList.remove(
                              widget.mWorkoutTypesList![index].id.validate());
                        }
                        return Row(
                          children: [
                            Text(
                                    widget.mWorkoutTypesList![index].title
                                        .validate(),
                                    style: primaryTextStyle())
                                .expand(),
                            widget.mWorkoutTypesList![index].select == true
                                ? Icon(Ionicons.md_checkbox,
                                    color: primaryColor)
                                : Icon(
                                    MaterialCommunityIcons
                                        .checkbox_blank_outline,
                                    color: primaryColor)
                          ],
                        ).paddingSymmetric(vertical: 8).onTap(() async {
                          widget.mWorkoutTypesList?[index].select = !widget
                              .mWorkoutTypesList![index].select
                              .validate();
                          var selectedItems = widget.mWorkoutTypesList
                              ?.where((item) => item.select == true)
                              .toList();
                          if (widget.mWorkoutTypesList?.length ==
                              selectedItems?.length) {
                            isSelectedAll = true;
                          } else {
                            isSelectedAll = false;
                          }
                          setState(() {});
                        });
                      },
                    ),
                    AppButton(
                      text: languages.lblShowResult,
                      width: context.width(),
                      color: primaryColor,
                      onTap: () {
                        widget.onCall!.call(mWorkoutIdList);
                        print(mWorkoutIdList);
                        finish(context);
                      },
                    ).paddingSymmetric(horizontal: 16, vertical: 16),
                  ],
                ),
              ],
            ),
          )
        : SingleChildScrollView(
            child: Wrap(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.close, size: 24, color: primaryColor)
                            .onTap(() {
                          finish(context);
                        }),
                        16.width,
                        Text(languages.lblSelectLevels, style: boldTextStyle())
                            .expand(),
                        isSecondSelectedAll
                            ? Text(languages.lblClearAll,
                                    style:
                                        primaryTextStyle(color: primaryColor))
                                .onTap(() {
                                for (int i = 0;
                                    i < widget.mLevelList!.length;
                                    i++) {
                                  widget.mLevelList![i].select = false;
                                }
                                isSecondSelectedAll = false;
                                mLevelIdList.clear();
                                setState(() {});
                              })
                            : Text(languages.lblSelectAll,
                                    style:
                                        primaryTextStyle(color: primaryColor))
                                .onTap(() {
                                for (int i = 0;
                                    i < widget.mLevelList!.length;
                                    i++) {
                                  widget.mLevelList![i].select = true;
                                  mLevelIdList
                                      .add(widget.mLevelList![i].id.validate());
                                  isSecondSelectedAll = true;
                                }
                                setState(() {});
                              })
                      ],
                    ).paddingSymmetric(horizontal: 16, vertical: 16),
                    AnimatedListView(
                      itemCount: widget.mLevelList!.length,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if (widget.mLevelList![index].select == true) {
                          if (!mLevelIdList.contains(
                              widget.mLevelList![index].id.validate())) {
                            mLevelIdList
                                .add(widget.mLevelList![index].id.validate());
                          }
                        } else {
                          mLevelIdList
                              .remove(widget.mLevelList![index].id.validate());
                        }
                        return Row(
                          children: [
                            Text(widget.mLevelList![index].title.validate(),
                                    style: primaryTextStyle())
                                .expand(),
                            widget.mLevelList![index].select == true
                                ? Icon(Ionicons.md_checkbox,
                                    color: primaryColor)
                                : Icon(
                                    MaterialCommunityIcons
                                        .checkbox_blank_outline,
                                    color: primaryColor),
                          ],
                        ).paddingSymmetric(vertical: 8).onTap(() async {
                          widget.mLevelList![index].select =
                              !widget.mLevelList![index].select.validate();
                          var selectedItems = widget.mLevelList
                              ?.where((item) => item.select == true)
                              .toList();

                          if (selectedItems?.length ==
                              widget.mLevelList?.length) {
                            isSecondSelectedAll = true;
                          } else {
                            isSecondSelectedAll = false;
                          }
                          setState(() {});
                        });
                      },
                    ),
                    AppButton(
                      text: languages.lblShowResult,
                      width: context.width(),
                      color: primaryColor,
                      onTap: () {
                        widget.onCall!.call(mLevelIdList);
                        finish(context);
                      },
                    ).paddingAll(16),
                  ],
                ),
              ],
            ),
          );
  }
}
