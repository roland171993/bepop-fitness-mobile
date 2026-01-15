import '../utils/shared_import.dart';

class ExerciseDayComponent extends StatefulWidget {
  static String tag = '/ExerciseDayComponent';
  final DayExerciseModel? mDayExerciseModel;
  final List<String>? mSets;
  final String? workOutId;

  ExerciseDayComponent({this.mDayExerciseModel, this.workOutId, this.mSets});

  @override
  ExerciseDayComponentState createState() => ExerciseDayComponentState();
}

class ExerciseDayComponentState extends State<ExerciseDayComponent> {
  @override
  Widget build(BuildContext context) {
    print("-----------31>>>>${widget.mSets}");

    return Container(
      decoration: appStore.isDarkMode
          ? boxDecorationWithRoundedCorners(borderRadius: radius(12))
          : boxDecorationRoundedWithShadow(12),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
      margin: EdgeInsets.only(bottom: 8, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              cachedImage(widget.mDayExerciseModel!.exerciseImage.validate(),
                      width: 55, height: 55, fit: BoxFit.fill)
                  .cornerRadiusWithClipRRect(10),
              12.width,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  6.height,
                  Text(widget.mDayExerciseModel!.exerciseTitle.validate(),
                      style: boldTextStyle(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  6.height,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (widget.mDayExerciseModel?.exercise?.type == DURATION)
                        Text(
                            widget.mDayExerciseModel?.exercise?.duration
                                    .toString() ??
                                '' + " " + languages.lblDuration,
                            style: secondaryTextStyle(size: 12)),
                      if (widget.mDayExerciseModel?.exercise?.type == SETS)
                        Text(widget.mSets!.join(" ").toString(),
                            style: secondaryTextStyle(size: 12)),
                      if (userStore.subscription == "1")
                        if (widget.mDayExerciseModel?.exercise?.isPremium == 1)
                          mPro()
                    ],
                  ),
                ],
              ).expand()
            ],
          ).expand(),
        ],
      ),
    ).onTap(() {
      userStore.subscription == "1"
          ? widget.mDayExerciseModel!.exercise!.isPremium == 1
              ? userStore.isSubscribe == 0
                  ? SubscribeScreen().launch(context)
                  : ExerciseDetailScreen(
                          mExerciseName: widget.mDayExerciseModel!.exerciseTitle
                              .validate(),
                          mExerciseId:
                              widget.mDayExerciseModel!.exerciseId.validate(),
                          workOutId: widget.workOutId)
                      .launch(context)
              : ExerciseDetailScreen(
                      mExerciseName:
                          widget.mDayExerciseModel!.exerciseTitle.validate(),
                      mExerciseId:
                          widget.mDayExerciseModel!.exerciseId.validate(),
                      workOutId: widget.workOutId)
                  .launch(context)
          : ExerciseDetailScreen(
                  mExerciseName:
                      widget.mDayExerciseModel!.exerciseTitle.validate(),
                  mExerciseId: widget.mDayExerciseModel!.exerciseId.validate(),
                  workOutId: widget.workOutId)
              .launch(context);

      /*userStore.isSubscribe == "1"
          ? ExerciseDetailScreen(mExerciseName: widget.mDayExerciseModel!.exerciseTitle.validate(), mExerciseId: widget.mDayExerciseModel!.exerciseId.validate()).launch(context)
          : widget.mDayExerciseModel!.exercise!.isPremium == 1
              ? userStore.isSubscribe == 0
                  ? SubscribeScreen().launch(context)
                  : ExerciseDetailScreen(mExerciseName: widget.mDayExerciseModel!.exerciseTitle.validate(), mExerciseId: widget.mDayExerciseModel!.exerciseId.validate()).launch(context)
              : ExerciseDetailScreen(mExerciseName: widget.mDayExerciseModel!.exerciseTitle.validate(), mExerciseId: widget.mDayExerciseModel!.exerciseId.validate()).launch(context);*/
    });
  }
}
