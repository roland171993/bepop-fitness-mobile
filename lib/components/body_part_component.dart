import '../utils/shared_import.dart';

class BodyPartComponent extends StatefulWidget {
  final isGrid;
  final isFilter;
  final BodyPartModel? bodyPartModel;

  BodyPartComponent(
      {this.bodyPartModel, this.isGrid = false, this.isFilter = false});

  @override
  _BodyPartComponentState createState() => _BodyPartComponentState();
}

class _BodyPartComponentState extends State<BodyPartComponent> {
  bool isBody = false;

  @override
  Widget build(BuildContext context) {
    double width = widget.isGrid == true
        ? (context.width() - 64) / 3
        : context.width() * 0.23;
    double height = widget.isGrid == true
        ? (context.width() - 64) / 3
        : context.width() * 0.23;

    return SizedBox(
      width: widget.isFilter == true ? context.width() * 0.24 : width,
      child: Column(
        children: [
          cachedImage(widget.bodyPartModel!.bodypartImage.validate(),
                  fit: BoxFit.fill, width: width, height: height)
              .cornerRadiusWithClipRRect(150),
          6.height,
          Text(widget.bodyPartModel!.title.validate(),
              style: primaryTextStyle(
                  size: 14,
                  color: isBody == true
                      ? primaryColor
                      : appStore.isDarkMode
                          ? Colors.white
                          : Colors.black),
              textAlign: TextAlign.center,
              maxLines: 2),
        ],
      ),
    ).onTap(() {
      setState(() {
        widget.isFilter == true
            ? widget.bodyPartModel!.select = true
            : SizedBox();
      });
      widget.isFilter == true
          ? SizedBox()
          : ExerciseListScreen(
                  mTitle: widget.bodyPartModel!.title.validate(),
                  isBodyPart: true,
                  id: widget.bodyPartModel!.id.validate())
              .launch(context);
    });
  }
}
