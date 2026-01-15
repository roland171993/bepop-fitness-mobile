import '../utils/shared_import.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  SettingList? settingList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblPrivacyPolicy, context: context),
      body: SingleChildScrollView(
          child: HtmlWidget(postContent: userStore.privacyPolicy)
              .paddingSymmetric(horizontal: 8)
              .paddingOnly(bottom: 20)),
    );
  }
}
