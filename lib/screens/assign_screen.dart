import '../utils/shared_import.dart';

class AssignScreen extends StatefulWidget {
  static String tag = '/AssignScreen';

  @override
  AssignScreenState createState() => AssignScreenState();
}

class AssignScreenState extends State<AssignScreen> {
  bool select = true;

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblPlan,
          context: context,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(45),
            child: Container(
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: context.dividerColor))),
              child: Row(children: [
                Container(
                  padding: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.5,
                              color:
                                  select ? primaryColor : Colors.transparent))),
                  child: Text(languages.lblWorkouts,
                          style: boldTextStyle(
                              color: select
                                  ? primaryColor
                                  : textSecondaryColorGlobal))
                      .center(),
                ).onTap(
                  () {
                    setState(() {
                      select = !select;
                    });
                  },
                ).expand(),
                Container(
                  padding: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(
                              width: 1.5,
                              color:
                                  select ? Colors.transparent : primaryColor))),
                  child: Text(
                    languages.lblDiet,
                    style: boldTextStyle(
                        color:
                            select ? textSecondaryColorGlobal : primaryColor),
                  ).center(),
                ).onTap(() {
                  setState(() {
                    select = !select;
                  });
                }).expand(),
              ]).paddingSymmetric(horizontal: 16),
            ),
          )),
      body: select
          ? ViewWorkoutsScreen(isAssign: true)
          : ViewAllDiet(isAssign: true),
    );
  }
}
