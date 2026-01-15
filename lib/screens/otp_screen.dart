import '../utils/shared_import.dart';

class OTPScreen extends StatefulWidget {
  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  GlobalKey<FormState> mFormKey = GlobalKey<FormState>();
  TextEditingController mMobileNumberCont = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    //
    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> sendOTP() async {
    hideKeyboard(context);
    appStore.setLoading(true);

    String number = '$countryCode${mMobileNumberCont.text.trim()}';
    if (!number.startsWith('+')) {
      number = '$mMobileNumberCont${mMobileNumberCont.text.trim()}';
    }

    await loginWithOTP(context, number, mMobileNumberCont.text.trim())
        .then((value) {})
        .catchError((e) {
      toast(e.toString());
      appStore.setLoading(false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("", context: context),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Form(
              key: mFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(languages.lblContinueWithPhone,
                      style: boldTextStyle(size: 22)),
                  6.height,
                  Text(languages.lblRcvCode, style: secondaryTextStyle()),
                  24.height,
                  Text(languages.lblPhoneNumber, style: secondaryTextStyle()),
                  6.height,
                  AppTextField(
                    controller: mMobileNumberCont,
                    textFieldType: TextFieldType.PHONE,
                    isValidationRequired: true,
                    suffix: mSuffixTextFieldIconWidget(ic_call),
                    decoration: defaultInputDecoration(context,
                        label: languages.lblEnterPhoneNumber,
                        mPrefix: IntrinsicHeight(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CountryCodePicker(
                                initialSelection: getStringAsync(COUNTRY_CODE,
                                    defaultValue: countryCode!),
                                showCountryOnly: false,
                                showFlag: false,
                                boxDecoration: BoxDecoration(
                                    borderRadius: radius(defaultRadius),
                                    color: context.scaffoldBackgroundColor),
                                showFlagDialog: true,
                                showOnlyCountryWhenClosed: false,
                                alignLeft: false,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                textStyle: primaryTextStyle(),
                                onInit: (c) {
                                  countryCode = c!.dialCode;
                                  setValue(COUNTRY_CODE, c.code);
                                },
                                onChanged: (c) {
                                  countryCode = c.dialCode;
                                  setValue(COUNTRY_CODE, c.code);
                                },
                              ),
                              // CountryCodePicker(
                              //   initialSelection: countryCode,
                              //   showCountryOnly: false,
                              //   showFlag: false,
                              //   boxDecoration: BoxDecoration(borderRadius: radius(defaultRadius), color: context.scaffoldBackgroundColor),
                              //   showFlagDialog: true,
                              //   showOnlyCountryWhenClosed: false,
                              //   alignLeft: false,
                              //   padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              //   textStyle: primaryTextStyle(),
                              //   onInit: (c) {
                              //     countryCode = c!.dialCode;
                              //   },
                              //   onChanged: (c) {
                              //     countryCode = c.dialCode;
                              //   },
                              // ),
                              VerticalDivider(
                                  color: Colors.grey.withValues(alpha: 0.5)),
                              16.width,
                            ],
                          ),
                        )),
                  ),
                  30.height,
                  AppButton(
                    text: languages.lblContinue,
                    width: context.width(),
                    color: primaryColor,
                    onTap: () {
                      sendOTP();
                    },
                  ),
                ],
              ).paddingSymmetric(horizontal: 16),
            ),
          ),
          Observer(builder: (context) {
            return Loader().visible(appStore.isLoading);
          })
        ],
      ),
    );
  }
}
