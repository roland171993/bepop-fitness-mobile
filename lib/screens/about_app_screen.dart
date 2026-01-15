import '../utils/shared_import.dart';

class AboutAppScreen extends StatefulWidget {
  static String tag = '/AboutAppScreen';

  @override
  AboutAppScreenState createState() => AboutAppScreenState();
}

class AboutAppScreenState extends State<AboutAppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblAboutApp, context: context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            mOption(ic_rate_us, languages.lblPrivacyPolicy, () {
              PrivacyPolicyScreen()
                  .launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
            }).visible(getStringAsync(PRIVACY_POLICY).isNotEmpty),
            Divider(height: 0)
                .visible(getStringAsync(PRIVACY_POLICY).isNotEmpty),
            mOption(ic_terms, languages.lblTermsOfServices, () {
              TermsAndConditionScreen()
                  .launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
            }).visible(getStringAsync(TERMS_SERVICE).isNotEmpty),
            Divider(height: 0)
                .visible(getStringAsync(TERMS_SERVICE).isNotEmpty),
            mOption(ic_info, languages.lblAboutUs, () {
              AboutUsScreen()
                  .launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
            }),
          ],
        ),
      ),
    );
  }
}
