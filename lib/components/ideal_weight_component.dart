import '../utils/shared_import.dart';

class IdealWeightComponent extends StatefulWidget {
  static String tag = '/BMIComponent';

  @override
  IdealWeightComponentState createState() => IdealWeightComponentState();
}

class IdealWeightComponentState extends State<IdealWeightComponent>
    with TickerProviderStateMixin {
  double? mCm;

  double result = 0.0;
  int feet = 0;
  int inches = 0;
  late AnimationController controller;
  CountDownController mCountDownController = CountDownController();

  @override
  void initState() {
    super.initState();
    init();
    LiveStream().on(PROGRESS, (p0) {
      setState(() {});
    });
  }

  init() async {
    await convertCmToFeet(double.parse(userStore.height.validate()));
    init2();
  }

  init2() {
    if (userStore.heightUnit == METRICS_CM) {
      result = calculateIdealWeight(
          userStore.gender, feet.toDouble(), inches.toDouble());
      if (mounted) setState(() {});
    } else {
      int heightFeet = userStore.height.toDouble().floor();
      double fractionalFeet = userStore.height.toDouble() - heightFeet;
      int heightInches = (fractionalFeet * 12).round();
      result = calculateIdealWeight(
          userStore.gender, heightFeet.toDouble(), heightInches.toDouble());
      if (mounted) setState(() {});
    }
  }

  // convert Feet to cm
  void convertFeetToCm() {
    mCm = userStore.heightUnit == FEET
        ? double.parse(userStore.height.validate()) * 30.48
        : double.parse(userStore.height.validate());
  }

  convertCmToFeet(double cm) {
    double totalInches = cm / 2.54;
    feet = (totalInches / 12).floor();
    inches = (totalInches % 12).round();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 8),
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: appStore.isDarkMode
          ? boxDecorationWithRoundedCorners(
              borderRadius: radius(16), backgroundColor: context.cardColor)
          : boxDecorationRoundedWithShadow(16,
              backgroundColor: context.cardColor),
      child: Observer(builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radius(8),
                      backgroundColor:
                          appStore.isDarkMode ? Colors.black : Colors.white),
                  padding: EdgeInsets.all(6),
                  child: Image.asset(ic_ideal_weight,
                      width: 20, height: 20, color: primaryColor),
                ),
                Text(languages.lblIdealWeight,
                        style: boldTextStyle(
                            color: appStore.isDarkMode ? primaryColor : black),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2)
                    .flexible(),
              ],
            ),
            12.height,
            Image.asset(ic_ideal_weight1,
                width: 50, height: 50, color: primaryColor),
            10.height,
            Text('$result', style: boldTextStyle(size: 19)),
            Text(languages.lblKg, style: secondaryTextStyle()),
          ],
        );
      }),
    );
  }
}
