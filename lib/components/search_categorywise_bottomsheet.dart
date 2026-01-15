import '../utils/shared_import.dart';

import 'dart:ui';

bool isSelectedAll = false;
bool isSecondSelectedAll = false;

class SearchCategoryBottomSheet extends StatefulWidget {
  final int? listId;
  final int? equipmentId;

  final Function? onCall;

  final List<EquipmentModel>? mEquipmentList;
  final List<LevelModel>? mLevelList;

  SearchCategoryBottomSheet(
      {super.key,
      this.listId,
      this.onCall,
      this.equipmentId,
      this.mEquipmentList,
      this.mLevelList});

  @override
  State<SearchCategoryBottomSheet> createState() =>
      _SearchCategoryBottomSheetState();
}

class _SearchCategoryBottomSheetState extends State<SearchCategoryBottomSheet> {
  DraggableScrollableController controller = DraggableScrollableController();
  List<int> mEquipmentIdList = [];
  List<int> mLevelIdList = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {}

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    mEquipmentIdList.clear();
    mLevelIdList.clear();

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
                        10.width,
                        Text(languages.lblEquipments, style: boldTextStyle())
                            .expand(),
                        isSelectedAll
                            ? Text(languages.lblClearAll,
                                    style:
                                        primaryTextStyle(color: primaryColor))
                                .onTap(() {
                                for (int i = 0;
                                    i < widget.mEquipmentList!.length;
                                    i++) {
                                  widget.mEquipmentList![i].isSelected = false;
                                }
                                isSelectedAll = false;
                                mEquipmentIdList.clear();
                                setState(() {});
                              })
                            : Text(languages.lblSelectAll,
                                    style:
                                        primaryTextStyle(color: primaryColor))
                                .onTap(() {
                                for (int i = 0;
                                    i < widget.mEquipmentList!.length;
                                    i++) {
                                  widget.mEquipmentList![i].isSelected = true;
                                  mEquipmentIdList.add(
                                      widget.mEquipmentList![i].id.validate());
                                  isSelectedAll = true;
                                }
                                setState(() {});
                              })
                      ],
                    ).paddingSymmetric(horizontal: 16, vertical: 16),
                    AnimatedWrap(
                      direction: Axis.horizontal,
                      runSpacing: 8,
                      spacing: 8,
                      children:
                          List.generate(widget.mEquipmentList!.length, (index) {
                        if (widget.mEquipmentList![index].isSelected == true) {
                          mEquipmentIdList
                              .add(widget.mEquipmentList![index].id.validate());
                        } else {
                          mEquipmentIdList.remove(
                              widget.mEquipmentList![index].id.validate());
                        }
                        return Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Container(
                              height: 135,
                              decoration: boxDecorationWithRoundedCorners(
                                  borderRadius: radius(12),
                                  border: Border.all(
                                      color: widget.mEquipmentList![index]
                                                  .isSelected ==
                                              true
                                          ? primaryColor
                                          : Colors.transparent)),
                              child: cachedImage(
                                widget.mEquipmentList![index].equipmentImage
                                    .validate(),
                                height: 135,
                                width: (context.width() - 54) / 3,
                                fit: BoxFit.fill,
                              ).cornerRadiusWithClipRRect(12),
                            ),
                            Container(
                              margin: EdgeInsets.only(bottom: 1),
                              child: ClipRRect(
                                borderRadius: radius(12),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 2.0, sigmaY: 2.0),
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 0),
                                    width: (context.width() - 54) / 3,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 8),
                                    decoration: boxDecorationWithRoundedCorners(
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(12),
                                          bottomLeft: Radius.circular(12)),
                                      backgroundColor:
                                          Colors.white.withValues(alpha: 0.7),
                                    ),
                                    child: Text(
                                      widget.mEquipmentList![index].title
                                          .validate(),
                                      style: boldTextStyle(
                                          size: 12, color: Colors.black),
                                    ).center(),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ).onTap(() {
                          setState(() {
                            widget.mEquipmentList![index].isSelected =
                                !widget.mEquipmentList![index].isSelected!;
                            var selectedItems = widget.mEquipmentList
                                ?.where((item) => item.isSelected == true)
                                .toList();
                            if (widget.mEquipmentList?.length ==
                                selectedItems?.length) {
                              isSelectedAll = true;
                            } else {
                              isSelectedAll = false;
                            }
                          });
                        });
                      }),
                    ),
                    AppButton(
                      text: languages.lblShowResult,
                      width: context.width(),
                      color: primaryColor,
                      onTap: () {
                        widget.onCall!.call(mEquipmentIdList);
                        print(mEquipmentIdList);
                        finish(context);
                      },
                    ).paddingSymmetric(horizontal: 16, vertical: 16),
                  ],
                ),
              ],
            ),
          )
        // Levels
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
                        10.width,
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
