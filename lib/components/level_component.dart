import '../utils/shared_import.dart';

class LevelComponent extends StatefulWidget {
  final LevelModel? mLevelModel;

  LevelComponent({this.mLevelModel});

  @override
  _LevelComponentState createState() => _LevelComponentState();
}

class _LevelComponentState extends State<LevelComponent> {
  @override
  Widget build(BuildContext context) {
    double? mHeight = 160;
    return Stack(
      alignment: Alignment.center,
      children: [
        cachedImage(widget.mLevelModel!.levelImage.validate(),
                height: mHeight, width: context.width(), fit: BoxFit.cover)
            .cornerRadiusWithClipRRect(16),
        mBlackEffect(context.width(), mHeight),
        Positioned(
          bottom: 22,
          child: Text(widget.mLevelModel!.title.validate(),
                  style: boldTextStyle(color: whiteColor, size: 22))
              .paddingSymmetric(horizontal: 16),
        )
      ],
    ).paddingBottom(16).onTap(() {
      ExerciseListScreen(
              mTitle: widget.mLevelModel!.title.validate(),
              isLevel: true,
              id: widget.mLevelModel!.id.validate())
          .launch(context);
    });
  }
}
