import '../utils/shared_import.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyOTPScreen extends StatefulWidget {
  final String? verificationId;
  final String? phoneNumber;
  final String? mobileNo;
  final bool? isCodeSent;
  final PhoneAuthCredential? credential;

  VerifyOTPScreen(
      {this.verificationId,
      this.isCodeSent,
      this.phoneNumber,
      this.mobileNo,
      this.credential});

  @override
  _VerifyOTPScreenState createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  String otpCode = '';

  Future<void> submit() async {
    hideKeyboard(context);
    appStore.setLoading(true);

    AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId!, smsCode: otpCode);

    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((result) async {
      Map req = {
        "email": "",
        "username": widget.phoneNumber!.replaceAll('+', ''),
        "first_name": "",
        "last_name": "",
        "login_type": LoginTypeOTP,
        "user_type": LoginUser,
        "accessToken": widget.phoneNumber!.replaceAll('+', ''),
        "phone_number": widget.phoneNumber!.replaceAll('+', ''),
        'player_id': getStringAsync(PLAYER_ID).validate(),
      };

      await socialOtpLogInApi(req).then((value) async {
        await setValue(IS_OTP, true);
        await setValue(IS_SOCIAL, true);
        userStore.setPhoneNo(widget.phoneNumber!.replaceAll('+', ''));
        userStore.setUserPassword(widget.phoneNumber!.replaceAll('+', ''));
        await removeKey(IS_REMEMBER);
        appStore.setLoading(false);
        print(widget.phoneNumber!.replaceAll('+', ''));
        if (value.isUserExist == false) {
          finish(context);
          SignUpScreen(phoneNumber: widget.phoneNumber!.replaceAll('+', ''))
              .launch(context);
        } else {
          await setValue(TOKEN, value.data?.apiToken.validate());
          userStore.setToken(value.data?.apiToken ?? '');
          await getUSerDetail(context, value.data!.id.validate())
              .whenComplete(() {
            setValue(IS_REMEMBER, false);
            DashboardScreen().launch(context, isNewTask: true);
          });
        }
      }).catchError((e) {
        appStore.setLoading(false);
        if (e.toString().contains('invalid_username')) {
          finish(context);
          SignUpScreen(phoneNumber: widget.phoneNumber!.replaceAll('+', ''))
              .launch(context);
        } else {
          toast(e.toString());
        }
        setState(() {});
      });
    }).catchError((e) {
      log("error->" + e.toString());
      toast(e.toString());
      appStore.setLoading(false);
      setState(() {});
    });
  }

  @override
  void initState() {
    appStore.setLoading(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("", context: context),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(languages.lblVerifyOTP, style: boldTextStyle(size: 22)),
                Text('${languages.lblCode} ${widget.phoneNumber}',
                    style: secondaryTextStyle()),
                30.height,
                Pinput(
                  cursor: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 2,
                        height: 20,
                        color: primaryColor,
                      ),
                    ],
                  ),
                  defaultPinTheme: PinTheme(
                    width: context.width() * 0.1,
                    height: 50,
                    textStyle: primaryTextStyle(size: 20),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ).copyWith(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                  ),
                  focusedPinTheme: PinTheme(
                    width: context.width() * 0.1,
                    height: 50,
                    textStyle: primaryTextStyle(size: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: primaryColor, width: 2),
                    ),
                  ).copyWith(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                  ),
                  length: 6,
                  onChanged: (s) {
                    otpCode = s;
                  },
                  onCompleted: (pin) {
                    otpCode = pin;
                    submit();
                  },
                ).center(),
                /* OTPTextField(
                  pinLength: 6,
                  fieldWidth: context.width() * 0.1,
                  onChanged: (s) {
                    otpCode = s;
                  },
                  onCompleted: (pin) {
                    otpCode = pin;
                    submit();
                  },
                ).center(),*/
                30.height,
                AppButton(
                  text: languages.lblVerifyProceed,
                  width: context.width(),
                  color: primaryColor,
                  onTap: () {
                    submit();
                  },
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
          ),
          Observer(
            builder: (context) {
              return Loader().center().visible(appStore.isLoading);
            },
          )
        ],
      ),
    );
  }
}
