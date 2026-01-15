import '../utils/shared_import.dart';

class NoInternetScreen extends StatefulWidget {
  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(no_internet,
              height: context.height() * 0.2, width: context.width() * 0.4),
          16.height,
          Text(languages.lblNoInternet, style: boldTextStyle(size: 20)),
        ],
      ).center(),
    );
  }
}
