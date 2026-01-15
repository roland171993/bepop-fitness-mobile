import '../utils/shared_import.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WebViewScreen extends StatefulWidget {
  static String tag = '/WebViewScreen';
  final String? mInitialUrl;
  final bool isAdsLoad;
  final Function(String)? onClick;

  WebViewScreen({this.mInitialUrl, this.isAdsLoad = false, this.onClick});

  @override
  WebViewScreenState createState() => WebViewScreenState();
}

class WebViewScreenState extends State<WebViewScreen> {
  final GlobalKey webViewKey = GlobalKey();
  InAppWebViewController? webViewController;
  bool? isLoading = true;
  final String successUrl = "status=successful";

  ///If Deprecated Remove
  // InAppWebViewSettings options = InAppWebViewSettings(
  //   useShouldOverrideUrlLoading: true,
  //   mediaPlaybackRequiresUserGesture: false,
  //   allowFileAccessFromFileURLs: true,
  //   useOnDownloadStart: true,
  //   javaScriptEnabled: true,
  //   allowUniversalAccessFromFileURLs: true,
  //   userAgent: "Mozilla/5.0 (Linux; Android 4.2.2; GT-I9505 Build/JDQ39) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.59 Mobile Safari/537.36",
  //   javaScriptCanOpenWindowsAutomatically: true,
  // );
// ignore: deprecated_member_use
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      // ignore: deprecated_member_use
      crossPlatform: InAppWebViewOptions(
        useShouldOverrideUrlLoading: true,
        mediaPlaybackRequiresUserGesture: false,
        allowFileAccessFromFileURLs: true,
        useOnDownloadStart: true,
        javaScriptEnabled: true,
        allowUniversalAccessFromFileURLs: true,
        userAgent:
            "Mozilla/5.0 (Linux; Android 4.2.2; GT-I9505 Build/JDQ39) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/31.0.1650.59 Mobile Safari/537.36",
        javaScriptCanOpenWindowsAutomatically: true,
      ),
      // ignore: deprecated_member_use
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      // ignore: deprecated_member_use
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget mBody() {
    return Observer(builder: (context) {
      print("-----------62>>>>${widget.mInitialUrl}");
      return Stack(
        children: [
          InAppWebView(
            key: webViewKey,
            initialUrlRequest: URLRequest(
                url: WebUri(widget.mInitialUrl == null
                    ? 'https://www.google.com'
                    : widget.mInitialUrl ?? '')),
            // ignore: deprecated_member_use
            initialOptions: options,
            onWebViewCreated: (controller) {
              webViewController = controller;
            },
            onLoadStart: (controller, url) {
              log("onLoadStart");
              setState(() {
                isLoading = true;
              });
            },
            shouldOverrideUrlLoading: (controller, navigationAction) async {
              var uri = navigationAction.request.url;
              var url = navigationAction.request.url.toString();
              print("URL----->>" + url.toString());
              if (url.contains("https://www.google.com") ||
                  url.contains(successUrl)) {
                widget.onClick?.call('Success');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(languages.lblPaymentSuccessful)),
                );
                return NavigationActionPolicy.CANCEL;
              }
              if (url.contains("https://login.yahoo.com") ||
                  url.contains("status=cancelled")) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(languages.lblPaymentCancelled)),
                );
                return NavigationActionPolicy.CANCEL;
              }
              if (Platform.isAndroid && url.contains("intent")) {
                if (url.contains("maps")) {
                  var mNewURL = url.replaceAll("intent://", "https://");
                  if (await canLaunchUrlString(mNewURL)) {
                    await launchUrlString(mNewURL);
                    return NavigationActionPolicy.CANCEL;
                  }
                } else {
                  return NavigationActionPolicy.CANCEL;
                }
              } else if (url.contains("linkedin.com") ||
                  url.contains("market://") ||
                  url.contains("whatsapp://") ||
                  url.contains("truecaller://") ||
                  url.contains("pinterest.com") ||
                  url.contains("snapchat.com") ||
                  url.contains("instagram.com") ||
                  url.contains("play.google.com") ||
                  url.contains("mailto:") ||
                  url.contains("tel:") ||
                  url.contains("share=telegram") ||
                  url.contains("messenger.com")) {
                if (url.contains("https://api.whatsapp.com/send?phone=+")) {
                  url = url.replaceAll("https://api.whatsapp.com/send?phone=+",
                      "https://api.whatsapp.com/send?phone=");
                } else if (url.contains("whatsapp://send/?phone=%20")) {
                  url = url.replaceAll(
                      "whatsapp://send/?phone=%20", "whatsapp://send/?phone=");
                }
                if (!url.contains("whatsapp://")) {
                  url = Uri.encodeFull(url);
                }
                try {
                  if (await canLaunchUrlString(url)) {
                    launchUrlString(url);
                  } else {
                    launchUrlString(url);
                  }
                  return NavigationActionPolicy.CANCEL;
                } catch (e) {
                  launchUrlString(url);
                  return NavigationActionPolicy.CANCEL;
                }
              } else if (![
                "http",
                "https",
                "chrome",
                "data",
                "javascript",
                "about"
              ].contains(uri!.scheme)) {
                if (await canLaunchUrlString(url)) {
                  await launchUrlString(
                    url,
                  );
                  return NavigationActionPolicy.CANCEL;
                }
              }
              return NavigationActionPolicy.ALLOW;
            },
            onLoadStop: (controller, url) async {
              log("onLoadStop");
              setState(() {
                isLoading = false;
              });
            },
            onReceivedError: (controller, request, error) {
              log("onLoadError" + error.toString());
              setState(() {
                isLoading = false;
              });
            },
            // onLoadError: (controller, url, code, message) {
            //   log("onLoadError" + message);
            //   setState(() {
            //     isLoading = false;
            //   });
            // },
          ),
          Container(
              height: context.height(),
              color: Colors.white,
              child: Loader().center().visible(isLoading == true))
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("",
          context: context,
          showBack: true,
          color: primaryColor,
          backWidget: IconButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              icon: Icon(Feather.chevron_left, color: primaryColor))),
      body: mBody(),
    );
  }
}
