import '../utils/shared_import.dart';

class ScheduledComponent extends StatefulWidget {
  ScheduledComponent(
      {super.key,
      required this.scheduledWorkoutList,
      required this.myCallback});

  final ScheduledModelData scheduledWorkoutList;
  final Function(String price, String id) myCallback;

  @override
  State<ScheduledComponent> createState() => _ScheduledComponentState();
}

class _ScheduledComponentState extends State<ScheduledComponent> {
  @override
  void initState() {
    super.initState();
    getDays();
  }

  String formatTime(String startTime, String endTime) {
    DateTime start = DateTime.parse('1970-01-01 $startTime');
    DateTime end = DateTime.parse('1970-01-01 $endTime');

    DateFormat formatter = DateFormat.jm();

    String formattedStart = formatter.format(start);
    String formattedEnd = formatter.format(end);

    return '$formattedStart - $formattedEnd';
  }

  String getDays() {
    DateTime startDate =
        DateTime.parse(widget.scheduledWorkoutList.startDate ?? '');
    DateTime endDate =
        DateTime.parse(widget.scheduledWorkoutList.endDate ?? '');

    Duration difference = endDate.difference(startDate);

    int days = difference.inDays;

    return days.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 14),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 2.0),
        decoration: BoxDecoration(
          color: primaryColor.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                height: 90,
                // width: 60,
                alignment: Alignment.topLeft,
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Text(
                      (widget.scheduledWorkoutList.price != null &&
                              widget.scheduledWorkoutList.isClassSchedulePlan ==
                                  0)
                          ? '${userStore.currencySymbol} ${widget.scheduledWorkoutList.price} '
                          : widget.scheduledWorkoutList.price != null &&
                                  widget.scheduledWorkoutList
                                          .isClassSchedulePlan ==
                                      1
                              ? languages.lblPurchases
                              : languages.lblFree,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ))),
            Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Text(
                    widget.scheduledWorkoutList.className ?? '',
                    style: primaryTextStyle(
                        color:
                            appStore.isDarkMode ? Colors.white : Colors.black,
                        size: 18,
                        weight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${widget.scheduledWorkoutList.startDate}  TO  ${widget.scheduledWorkoutList.endDate}',
                    style: primaryTextStyle(
                        color:
                            appStore.isDarkMode ? Colors.white : Colors.black,
                        size: 12),
                  ),
                  SizedBox(height: 8),
                  Text(
                    formatTime(widget.scheduledWorkoutList.startTime ?? '',
                        widget.scheduledWorkoutList.endTime ?? ''),
                    style: primaryTextStyle(
                        color:
                            appStore.isDarkMode ? Colors.white : Colors.black,
                        size: 12),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: EdgeInsets.only(right: 15),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: GestureDetector(
                onTap: () async {
                  if (widget.scheduledWorkoutList.isPaid == '0') {
                    if (widget.scheduledWorkoutList.link != null) {
                      launchUrlString(widget.scheduledWorkoutList.link ?? '');
                    }
                  } else {
                    if (widget.scheduledWorkoutList.isClassSchedulePlan == 1) {
                      if (widget.scheduledWorkoutList.link != null) {
                        launchUrlString(widget.scheduledWorkoutList.link ?? '');
                      }
                    } else {
                      widget.myCallback(
                          widget.scheduledWorkoutList.price.toString(),
                          widget.scheduledWorkoutList.id.toString());
                    }
                  }
                },
                child: Text(
                  languages.lblJoin,
                  style: boldTextStyle(
                    color: Colors.white,
                    size: 14,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
