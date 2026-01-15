import '../utils/shared_import.dart';

class ProductComponent extends StatefulWidget {
  static String tag = '/productComponent';

  final ProductModel? mProductModel;
  final Function? onCall;

  ProductComponent({this.mProductModel, this.onCall});

  @override
  ProductComponentState createState() => ProductComponentState();
}

class ProductComponentState extends State<ProductComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: boxDecorationWithRoundedCorners(
              borderRadius: radius(12), backgroundColor: GreyLightColor),
          child: cachedImage(widget.mProductModel!.productImage.validate(),
                  height: 155,
                  fit: BoxFit.contain,
                  width: (context.width() - 50) / 2)
              .cornerRadiusWithClipRRect(defaultRadius),
        ),
        Text(widget.mProductModel!.title.validate(),
                style: primaryTextStyle(
                    color: appStore.isDarkMode ? Colors.white : Colors.black),
                maxLines: 2)
            .paddingSymmetric(horizontal: 4, vertical: 8)
      ],
    ).onTap(() {
      ProductDetailScreen(productModel: widget.mProductModel!).launch(context);
    });
  }
}
