import '../utils/shared_import.dart';

class BlogComponent extends StatefulWidget {
  final BlogModel? mBlogModel;
  final Function? onCall;

  BlogComponent({this.mBlogModel, this.onCall});

  @override
  _BlogComponentState createState() => _BlogComponentState();
}

class _BlogComponentState extends State<BlogComponent> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: appStore.isDarkMode
          ? boxDecorationWithRoundedCorners(borderRadius: radius())
          : boxDecorationRoundedWithShadow(defaultRadius.toInt()),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 8),
      margin: EdgeInsets.only(bottom: 8, top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              BlogDetailScreen(mBlogModel: widget.mBlogModel!).launch(context);
            },
            child: Hero(
              tag: widget.mBlogModel!,
              transitionOnUserGestures: true,
              child: cachedImage(widget.mBlogModel!.postImage.validate(),
                      width: 70, height: 70, fit: BoxFit.cover)
                  .cornerRadiusWithClipRRect(12),
            ),
          ),
          12.width,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              4.height,
              Text(widget.mBlogModel!.title.validate(),
                  style: boldTextStyle(size: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
              10.height,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(MaterialIcons.access_time,
                      size: 16, color: textSecondaryColorGlobal),
                  4.width,
                  Text(
                      parseDocumentDate(DateTime.parse(
                          widget.mBlogModel!.datetime.validate())),
                      style: secondaryTextStyle()),
                  16.width,
                ],
              ),
              /*Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 8.0,
                  children: List.generate(100, (index) {
                    return Container(
                      padding: EdgeInsets.all(8.0),
                      color: Colors.blueAccent,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    );
                  }),
                ),
              ),*/
              /* Wrap(
                direction: Axis.horizontal,
                //crossAxisAlignment: WrapCrossAlignment.start,
                spacing: 8.4,
                runSpacing: 4.0,
                children: widget.mBlogModel?.categoryName
                        ?.map((category) => Padding(
                              padding: const EdgeInsets.all(5),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                 */ /* Container(height: 6, width: 6, decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: textSecondaryColorGlobal)),
                                  8.width,
                                  Text(category.title ?? '', style: secondaryTextStyle()),*/ /*
                                  Text(category.title ?? '', style: secondaryTextStyle()),
                                  Text(category.title ?? '', style: secondaryTextStyle()),
                                  Text(category.title ?? '', style: secondaryTextStyle()),
                                  Text(category.title ?? '', style: secondaryTextStyle()),
                                  Text(category.title ?? '', style: secondaryTextStyle()),
                                  Text(category.title ?? '', style: secondaryTextStyle()),

                                ],
                              ),
                            ))
                        .toList() ??
                    [],
              ),*/
              2.height,
            ],
          ).expand()
        ],
      ),
    ).onTap(() {
      BlogDetailScreen(mBlogModel: widget.mBlogModel!).launch(context);
    });
  }
}
