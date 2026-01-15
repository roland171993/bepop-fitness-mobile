import '../utils/shared_import.dart';

class AboutUsScreen extends StatefulWidget {
  @override
  _AboutUsScreenState createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
  Widget mSocialOption(var value, {var color}) {
    return Image.asset(value, height: 30, width: 30, color: color)
        .paddingAll(8);
  }

  Future<void> launchWebsite(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblAboutUs, context: context),
      bottomNavigationBar: Container(
        height: 110,
        child: Column(
          children: [
            Text(languages.lblFollowUs, style: primaryTextStyle(size: 14)),
            SizedBox(
              height: 55,
              child: ListView(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      mSocialOption(ic_facebook)
                          .onTap(() {
                            launchUrls(getStringAsync(FACEBOOK_URL));
                          })
                          .paddingOnly(left: 16, right: 16)
                          .visible(getStringAsync(FACEBOOK_URL).isNotEmpty),
                      mSocialOption(ic_instagram)
                          .onTap(() {
                            launchUrls(getStringAsync(INSTAGRAM_URL));
                          })
                          .paddingRight(16)
                          .visible(getStringAsync(INSTAGRAM_URL).isNotEmpty),
                      mSocialOption(ic_twitter)
                          .onTap(() {
                            launchUrls(getStringAsync(TWITTER_URL));
                          })
                          .paddingRight(16)
                          .visible(getStringAsync(TWITTER_URL).isNotEmpty),
                      mSocialOption(ic_linkedin)
                          .onTap(() {
                            launchUrls(getStringAsync(LINKED_URL));
                          })
                          .paddingRight(16)
                          .visible(getStringAsync(LINKED_URL).isNotEmpty),
                    ],
                  ),
                ],
              ),
            ),
            2.height,
            Text(getStringAsync(SITE_COPYRIGHT),
                    style: secondaryTextStyle(size: 12), maxLines: 1)
                .visible(getStringAsync(SITE_COPYRIGHT).isNotEmpty),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(APP_NAME, style: boldTextStyle()),
            4.height,
            Container(width: 110, height: 2, color: primaryColor),
            16.height,
            Text(getStringAsync(SITE_DESCRIPTION), style: secondaryTextStyle()),
            16.height,
            GestureDetector(
              onTap: () {
                var mailUrl =
                    Uri.parse("mailto:${getStringAsync(CONTACT_EMAIL)}");
                launchUrl(mailUrl);
              },
              child: Row(
                children: [
                  Icon(MaterialIcons.mail_outline,
                      color: textSecondaryColorGlobal),
                  8.width,
                  Text(getStringAsync(CONTACT_EMAIL),
                      style: secondaryTextStyle()),
                ],
              ).visible(getStringAsync(CONTACT_EMAIL).isNotEmpty),
            ),
            16.height,
            GestureDetector(
              onTap: () {
                var supportUri =
                    Uri.parse("https://${getStringAsync(HELP_SUPPORT)}");

                launchWebsite(supportUri);
              },
              child: Row(
                children: [
                  Icon(MaterialIcons.support_agent,
                      color: textSecondaryColorGlobal),
                  8.width,
                  Text(getStringAsync(HELP_SUPPORT),
                      style: secondaryTextStyle()),
                ],
              ).visible(getStringAsync(HELP_SUPPORT).isNotEmpty),
            ),
            16.height,
            Row(
              children: [
                Icon(Ionicons.md_call_outline, color: textSecondaryColorGlobal),
                8.width,
                Text(getStringAsync(CONTACT_NUMBER),
                    style: secondaryTextStyle()),
              ],
            ).visible(getStringAsync(CONTACT_NUMBER).isNotEmpty),
          ],
        ).paddingAll(16),
      ),
    );
  }
}
