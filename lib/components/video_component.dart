import '../utils/shared_import.dart';

class VideoComponent extends StatefulWidget {
  const VideoComponent({super.key});

  @override
  State<VideoComponent> createState() => _VideoComponentState();
}

class _VideoComponentState extends State<VideoComponent> {
  @override
  Widget build(BuildContext context) {
    var width = context.width();
    var height = 190.0;
    return Stack(
      children: [
        cachedImage("widget.mWorkoutModel!.workoutImage.validate()",
                height: height, fit: BoxFit.cover, width: width)
            .cornerRadiusWithClipRRect(16),
        mBlackEffect(width, height, radiusValue: 16),
        Positioned(
            left: 16,
            right: 16,
            top: 0,
            bottom: 16,
            child: Icon(Icons.video_collection, color: Colors.white)),
        Positioned(
          left: 16,
          right: 16,
          bottom: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("title.capitalizeFirstLetter().validate()",
                  style: boldTextStyle(color: white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              4.height,
              Text("widget.mWorkoutModel!.levelTitle.validate()",
                  style: secondaryTextStyle(color: white),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        )
      ],
    ).paddingBottom(16).onTap(() {
      VideoDetailScreen().launch(context);
    });
  }
}
