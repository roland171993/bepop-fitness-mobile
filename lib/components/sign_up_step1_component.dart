import '../utils/shared_import.dart';

class SignUpStep1Component extends StatefulWidget {
  final bool? isNewTask;

  SignUpStep1Component({this.isNewTask = false});

  @override
  _SignUpStep1ComponentState createState() => _SignUpStep1ComponentState();
}

class _SignUpStep1ComponentState extends State<SignUpStep1Component> {
  GlobalKey<FormState> mFormKey = GlobalKey<FormState>();

  String? dialCode;
  TextEditingController mFNameCont = TextEditingController();
  TextEditingController mLNameCont = TextEditingController();
  TextEditingController mEmailCont = TextEditingController();
  TextEditingController mPassCont = TextEditingController();
  TextEditingController mConfirmPassCont = TextEditingController();
  TextEditingController mMobileNumberCont = TextEditingController();

  FocusNode mEmailFocus = FocusNode();
  FocusNode mPassFocus = FocusNode();
  FocusNode mFNameFocus = FocusNode();
  FocusNode mLNameFocus = FocusNode();
  FocusNode mConfirmPassFocus = FocusNode();
  FocusNode mMobileNumberFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    print("------------51>>>${getStringAsync(COUNTRY_CODE)}");
    print("------------52>>>${countryCode}");
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void didChangeDependencies() {
    if (widget.isNewTask != true) {
      mFNameCont.text = userStore.fName.validate();
      mLNameCont.text = userStore.lName.validate();
      mEmailCont.text = userStore.email.validate();
      mPassCont.text = userStore.password.validate();
      mConfirmPassCont.text = userStore.password.validate();
      mMobileNumberCont.text = userStore.phoneNo.validate();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Form(
        key: mFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(languages.lblTellUsAboutYourself,
                style: boldTextStyle(size: 22)),
            16.height,
            Text(languages.lblFirstName,
                style: secondaryTextStyle(color: textPrimaryColorGlobal)),
            4.height,
            AppTextField(
              controller: mFNameCont,
              textFieldType: TextFieldType.NAME,
              isValidationRequired: true,
              focus: mFNameFocus,
              nextFocus: mLNameFocus,
              suffix: mSuffixTextFieldIconWidget(ic_user),
              decoration: defaultInputDecoration(context,
                  label: languages.lblEnterFirstName),
            ),
            16.height,
            Text(languages.lblLastName,
                style: secondaryTextStyle(color: textPrimaryColorGlobal)),
            4.height,
            AppTextField(
              controller: mLNameCont,
              textFieldType: TextFieldType.NAME,
              isValidationRequired: true,
              focus: mLNameFocus,
              cursorColor: primaryColor,
              nextFocus: mMobileNumberFocus,
              suffix: mSuffixTextFieldIconWidget(ic_user),
              decoration: defaultInputDecoration(context,
                  label: languages.lblEnterLastName),
            ),
            16.height,
            Text(languages.lblPhoneNumber,
                    style: secondaryTextStyle(color: textPrimaryColorGlobal))
                .visible(getBoolAsync(IS_OTP) != true),
            4.height.visible(getBoolAsync(IS_OTP) != true),
            AppTextField(
              controller: mMobileNumberCont,
              textFieldType: TextFieldType.PHONE,
              isValidationRequired: false,
              focus: mMobileNumberFocus,
              nextFocus: mEmailFocus,
              suffix: mSuffixTextFieldIconWidget(ic_call),
              // validator: (value){
              //   /*if (value == null || value.isEmpty) {
              //     return 'Please enter your phone number';
              //   }*/
              //  /* if (value!.length < 4 || value.length > 15) {
              //     return 'Phone number must be between 4 and 15 digits';
              //   }
              //   return null;*/
              // },
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
                              color: appStore.isDarkMode
                                  ? context.cardColor
                                  : GreyLightColor),
                          showFlagDialog: true,
                          showOnlyCountryWhenClosed: false,
                          alignLeft: false,
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          textStyle: primaryTextStyle(),
                          onInit: (c) {
                            setValue(COUNTRY_CODE, c!.code);
                          },
                          dialogTextStyle: TextStyle(
                            color: appStore.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          searchStyle: TextStyle(
                            color: appStore.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          onChanged: (c) {
                            dialCode = c.dialCode;
                            setValue(COUNTRY_CODE, c.code);
                          },
                        ),
                        VerticalDivider(
                            color: Colors.grey.withValues(alpha: 0.5)),
                        16.width,
                      ],
                    ),
                  )),
            ).visible(getBoolAsync(IS_OTP) != true),
            16.height.visible(getBoolAsync(IS_OTP) != true),
            Text(languages.lblEmail,
                style: secondaryTextStyle(color: textPrimaryColorGlobal)),
            4.height,
            AppTextField(
              controller: mEmailCont,
              textFieldType: TextFieldType.EMAIL,
              isValidationRequired: true,
              focus: mEmailFocus,
              nextFocus: mPassFocus,
              suffix: mSuffixTextFieldIconWidget(ic_mail),
              decoration: defaultInputDecoration(context,
                  label: languages.lblEnterEmail),
            ),
            16.height.visible(getBoolAsync(IS_OTP) != true),
            Text(languages.lblPassword,
                    style: secondaryTextStyle(color: textPrimaryColorGlobal))
                .visible(getBoolAsync(IS_OTP) != true),
            4.height.visible(getBoolAsync(IS_OTP) != true),
            AppTextField(
              controller: mPassCont,
              focus: mPassFocus,
              nextFocus: mConfirmPassFocus,
              textFieldType: TextFieldType.PASSWORD,
              keyboardType: TextInputType.visiblePassword,
              decoration: defaultInputDecoration(context,
                  label: languages.lblEnterPassword),
              onFieldSubmitted: (c) {},
            ).visible(getBoolAsync(IS_OTP) != true),
            16.height.visible(getBoolAsync(IS_OTP) != true),
            Text(languages.lblConfirmPassword,
                    style: secondaryTextStyle(color: textPrimaryColorGlobal))
                .visible(getBoolAsync(IS_OTP) != true),
            4.height.visible(getBoolAsync(IS_OTP) != true),
            AppTextField(
              controller: mConfirmPassCont,
              focus: mConfirmPassFocus,
              textFieldType: TextFieldType.PASSWORD,
              keyboardType: TextInputType.visiblePassword,
              decoration: defaultInputDecoration(context,
                  label: languages.lblEnterConfirmPwd),
              onFieldSubmitted: (c) {},
              validator: (String? value) {
                if (value!.isEmpty) return errorThisFieldRequired;
                if (value.length < passwordLengthGlobal)
                  return languages.errorPwdLength;
                if (value.trim() != mPassCont.text.trim())
                  return languages.errorPwdMatch;
                return null;
              },
            ).visible(getBoolAsync(IS_OTP) != true),
            24.height,
            AppButton(
              text: languages.lblNext,
              width: context.width(),
              color: primaryColor,
              onTap: () {
                print("--------217>>>${mMobileNumberCont.text}");
                print("--------218>>>${dialCode}");
                if (mFormKey.currentState!.validate()) {
                  hideKeyboard(context);
                  userStore.setFirstName(mFNameCont.text);
                  userStore.setLastName(mLNameCont.text);
                  if (getBoolAsync(IS_OTP) != true) {
                    userStore.setPhoneNo(
                        "${dialCode ?? countryDail}${mMobileNumberCont.text}");
                    //  userStore.setPhoneNo(mMobileNumberCont.text);
                    userStore.setUserPassword(mPassCont.text);
                  }
                  userStore.setUserEmail(mEmailCont.text);
                  appStore.signUpIndex = 1;
                  setState(() {});
                }
              },
            ),
            24.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(languages.lblAlreadyAccount, style: primaryTextStyle()),
                GestureDetector(
                    child: Text(
                      languages.lblLogin,
                      style: primaryTextStyle(color: primaryColor),
                    ).paddingLeft(4),
                    onTap: () {
                      SignInScreen().launch(context);
                    })
              ],
            ),
            24.height,
          ],
        ).paddingAll(16),
      ),
    );
  }
}
