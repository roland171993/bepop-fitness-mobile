import '../utils/shared_import.dart';

class TermsAndConditionScreen extends StatefulWidget {
  const TermsAndConditionScreen({super.key});

  @override
  State<TermsAndConditionScreen> createState() =>
      _TermsAndConditionScreenState();
}

class _TermsAndConditionScreenState extends State<TermsAndConditionScreen> {
  SettingList? settingList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBarWidget(languages.lblTermsOfServices, context: context),
        body: SingleChildScrollView(
            child: HtmlWidget(postContent: userStore.termsCondition)
                .paddingSymmetric(horizontal: 8)
                .paddingOnly(bottom: 20)));
  }
}
