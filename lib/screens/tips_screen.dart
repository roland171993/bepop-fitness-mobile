import '../utils/shared_import.dart';

class TipsScreen extends StatefulWidget {
  static String tag = '/TipsScreen';
  final String? mTips;
  final String? mExerciseImage;
  final String? mExerciseVideo;
  final String? mExerciseInstruction;

  TipsScreen(
      {this.mTips,
      this.mExerciseVideo,
      this.mExerciseImage,
      this.mExerciseInstruction});

  @override
  TipsScreenState createState() => TipsScreenState();
}

class TipsScreenState extends State<TipsScreen> {
  bool select = false;
  var mode = "portrait";

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
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
              child: appBarWidget(languages.lblTipsInst, context: context))),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.mExerciseVideo!.validate().contains("https://youtu") ||
                    widget.mExerciseVideo!
                        .validate()
                        .contains("https://www.youtu")
                ? AspectRatio(
                    aspectRatio: mode == "portrait" ? 12 / 7 : 15 / 7,
                    child: YoutubePlayerScreen(
                        url: widget.mExerciseVideo.validate(),
                        img: widget.mExerciseImage.validate(),
                        hideControl: true))
                : ChewieScreen(
                        url: widget.mExerciseVideo.validate(),
                        image: widget.mExerciseImage.validate(),
                        autoPlay: false)
                    .center(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  // padding: EdgeInsets.all(16),
                  margin: EdgeInsets.all(16),
                  decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: appStore.isDarkMode
                          ? context.cardColor
                          : primaryOpacity),
                  child: Column(
                    children: [
                      16.height,
                      Row(children: [
                        Icon(Icons.info_outline, color: primaryColor, size: 25),
                        10.width,
                        Text(languages.lblTips,
                                style: primaryTextStyle(
                                    size: 18,
                                    color: appStore.isDarkMode
                                        ? white
                                        : textPrimaryColor))
                            .expand(),
                        Icon(
                            select
                                ? Icons.keyboard_arrow_down_sharp
                                : Icons.keyboard_arrow_up,
                            color: primaryColor,
                            size: 30),
                      ]).paddingSymmetric(horizontal: 16),
                      8.height.visible(!select),
                      HtmlWidget(postContent: widget.mTips.validate())
                          .visible(!select)
                          .paddingSymmetric(horizontal: 16),
                      16.height,
                    ],
                  ),
                ).onTap(() {
                  setState(() {
                    select = !select;
                  });
                }),
                16.height,
                Text(languages.lblInstruction, style: boldTextStyle())
                    .paddingSymmetric(horizontal: 16)
                    .visible(!widget.mExerciseInstruction.isEmptyOrNull),
                16.height,
                HtmlWidget(postContent: widget.mExerciseInstruction.validate())
                    .paddingSymmetric(horizontal: 8),
              ],
            )
          ],
        ),
      ),
    );
  }
}
