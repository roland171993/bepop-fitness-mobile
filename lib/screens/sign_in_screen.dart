import '../utils/shared_import.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  GlobalKey<FormState> mFormKey = GlobalKey<FormState>();

  TextEditingController mEmailCont = TextEditingController();
  TextEditingController mPassCont = TextEditingController();

  FocusNode mEmailFocus = FocusNode();
  FocusNode mPassFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if (getBoolAsync(IS_REMEMBER)) {
      mEmailCont.text = getStringAsync(EMAIL);
      mPassCont.text = getStringAsync(PASSWORD);
    }
    getCountryCodeFromLocale();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> save() async {
    hideKeyboard(context);
    Map<String, dynamic> req = {
      'email': mEmailCont.text.trim(),
      'user_type': LoginUser,
      'password': mPassCont.text.trim(),
      'player_id': getStringAsync(PLAYER_ID).validate(),
    };

    if (mFormKey.currentState!.validate()) {
      appStore.setLoading(true);
      await logInApi(req).then((value) async {
        updatePlayerId(mEmailCont.text.trim());
        if (value.data!.status == statusActive) {
          if (getBoolAsync(IS_REMEMBER)) {
            userStore.setUserPassword(mPassCont.text.trim());
          }
          print("------------------81>>>${userStore.email}");
          print("------------------82>>>${mEmailCont.text.trim()}");
          if (userStore.email == mEmailCont.text.trim()) {
            userStore.setIsSTEP('oldUser');
          } else {
            userStore.setIsSTEP('newUser');
          }

          getUSerDetail(context, value.data!.id).then((value) {
            DashboardScreen().launch(context, isNewTask: true);
          }).catchError((e) {
            print("error=>" + e.toString());
          });
        } else {
          toast(languages.lblContactAdmin);
        }
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
      setState(() {});
    }
  }

  Future<String?> getCountryCodeFromLocale() async {
    try {
      String localeName = Platform.localeName; // e.g., "en_US" or "fr_FR"

      if (localeName.contains('_')) {
        print("---------114>>>${localeName.split('_').last}");
        setValue(COUNTRY_CODE, localeName.split('_').last);
        return localeName.split('_').last; // Returns "US", "FR", etc.
      }

      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        String? locale = androidInfo.device; // More reliable locale
        if (locale.contains('_')) {
          return locale.split('_').last;
        }
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        String? locale = iosInfo.localizedModel; // e.g., "en_US"
        if (locale.contains('_')) {
          return locale.split('_').last;
        }
      }
    } catch (e) {
      print('Error getting country code: $e');
    }
    return null; // Return null if no country code is found
  }

  googleLogin() async {
    hideKeyboard(context);
    appStore.setLoading(true);
    await signInWithGoogle().then((user) async {
      print(user);
      setValue(IS_SOCIAL, true);
      await userStore.setUserEmail(user.email.validate());
      await userStore.setUsername(user.email.validate());
      await userStore.setUserImage(user.photoURL.validate());
      await userStore.setDisplayName(user.displayName.validate());
      await userStore.setPhoneNo(user.phoneNumber.validate());
      updatePlayerId(user.email.validate());
      await getUSerDetail(context, userStore.userId).then((value) {
        appStore.setLoading(false);
        setValue(IS_REMEMBER, false);
        DashboardScreen().launch(context, isNewTask: true);
      }).catchError((e) {
        print("error=>" + e.toString());
      });
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  appleLogin() async {
    hideKeyboard(context);
    appStore.setLoading(true);
    await appleLogIn(context).then((value) {
      setValue(IS_SOCIAL, true);
      appStore.setLoading(false);
      if (userStore.isLoggedIn == true) {
        updatePlayerId(value?.credential?.email ?? "");
      }
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  Widget mSocialWidget(String icon, Function onCall) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(
          backgroundColor: socialBackground, boxShape: BoxShape.circle),
      child: Image.asset(icon, height: 40, width: 40),
    ).onTap(() {
      onCall.call();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            appStore.isDarkMode ? Brightness.light : Brightness.dark,
        systemNavigationBarIconBrightness:
            appStore.isDarkMode ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(top: context.statusBarHeight + 16),
              child: Form(
                key: mFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(languages.lblLogin, style: boldTextStyle(size: 18))
                        .paddingSymmetric(horizontal: 16),
                    Container(
                      //width: 40,
                      width: mq.width * 0.1,
                      height: 2,
                      decoration: boxDecorationWithRoundedCorners(
                          backgroundColor: primaryColor),
                      margin: EdgeInsets.only(top: 4),
                    ).paddingSymmetric(horizontal: mq.width * 0.040),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(languages.lblWelcomeBack,
                                style: boldTextStyle(size: 20)),
                            Text(languages.lblWelcomeBackDesc,
                                style: secondaryTextStyle()),
                          ],
                        ),
                        Image.asset(ic_login_new,
                            height: mq.height * 0.12,
                            width: mq.width * 0.26,
                            fit: BoxFit.fill,
                            opacity: AlwaysStoppedAnimation(.5)),
                        //Image.asset(ic_login_new, height: 100, width: 100, fit: BoxFit.fill, opacity: AlwaysStoppedAnimation(.5)),
                      ],
                    ).paddingOnly(left: mq.width * 0.040),
                    16.height,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        16.height,
                        Text(languages.lblEmail,
                            style: secondaryTextStyle(
                                color: textPrimaryColorGlobal)),
                        4.height,
                        AppTextField(
                          controller: mEmailCont,
                          focus: mEmailFocus,
                          textFieldType: TextFieldType.EMAIL,
                          nextFocus: mPassFocus,
                          suffix: mSuffixTextFieldIconWidget(ic_mail),
                          decoration: defaultInputDecoration(context,
                              label: languages.lblEnterEmail),
                          isValidationRequired: true,
                        ),
                        16.height,
                        Text(languages.lblPassword,
                            style: secondaryTextStyle(
                                color: textPrimaryColorGlobal)),
                        4.height,
                        AppTextField(
                          controller: mPassCont,
                          focus: mPassFocus,
                          textFieldType: TextFieldType.PASSWORD,
                          keyboardType: TextInputType.visiblePassword,
                          decoration: defaultInputDecoration(context,
                              label: languages.lblEnterPassword),
                          onFieldSubmitted: (c) {
                            save();
                          },
                        ),
                        16.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: mq.height * 0.025,
                                  width: mq.width * 0.050,
                                  child: Checkbox(
                                    fillColor: WidgetStatePropertyAll(
                                        getBoolAsync(IS_REMEMBER)
                                            ? primaryColor
                                            : Colors.transparent),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: radius(4)),
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    focusColor: primaryColor,
                                    side: BorderSide(color: primaryColor),
                                    activeColor: primaryColor,
                                    value: getBoolAsync(IS_REMEMBER),
                                    onChanged: (bool? value) async {
                                      await setValue(IS_REMEMBER, value);
                                      setState(() {});
                                    },
                                  ),
                                ),
                                6.width,
                                Text(languages.lblRememberMe,
                                    style: secondaryTextStyle(
                                        color: primaryColor)),
                              ],
                            ).expand(),
                            Text(languages.lblForgotPassword,
                                    style:
                                        secondaryTextStyle(color: primaryColor))
                                .onTap(() {
                              ForgotPwdScreen().launch(context);
                            },
                                    hoverColor: Colors.transparent,
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent),
                          ],
                        ),
                        60.height,
                        Row(
                          children: [
                            Container(
                                width: context.width() * 0.4,
                                height: 1,
                                color: context.dividerColor),
                            Text(languages.lblOr, style: secondaryTextStyle())
                                .paddingSymmetric(horizontal: 10),
                            Container(
                                width: context.width() * 0.4,
                                height: 1,
                                color: context.dividerColor),
                          ],
                        ),
                        24.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            mSocialWidget(ic_mobile, () {
                              OTPScreen().launch(context);
                            }).visible(ENABLE_OTP),
                            12.width,
                            mSocialWidget(ic_google, () {
                              googleLogin();
                            }).visible(ENABLE_GOOGLE_SIGN_IN),
                            12.width,
                            mSocialWidget(ic_apple, () {
                              appleLogin();
                            }).visible(ENABLE_APPLE_SIGN_IN && isIOS),
                          ],
                        ).visible(ENABLE_SOCIAL_LOGIN),
                        ENABLE_SOCIAL_LOGIN ? 24.height : 0.height,
                        AppButton(
                          text: languages.lblLogin,
                          width: context.width(),
                          color: primaryColor,
                          onTap: () {
                            save();
                          },
                        ),
                        24.height,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(languages.lblNewUser,
                                style: primaryTextStyle()),
                            GestureDetector(
                                child: Text(languages.lblRegisterNow,
                                        style: primaryTextStyle(
                                            color: primaryColor))
                                    .paddingLeft(4),
                                onTap: () {
                                  SignUpScreen().launch(context);
                                })
                          ],
                        ),
                        24.height,
                      ],
                    ).paddingSymmetric(
                        horizontal: mq.height * 0.020, vertical: 4),
                  ],
                ),
              ),
            ),
            Observer(builder: (context) {
              return Loader().center().visible(appStore.isLoading);
            })
          ],
        ),
      ),
    );
  }
}
