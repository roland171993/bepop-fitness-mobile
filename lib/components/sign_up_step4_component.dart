import '../utils/shared_import.dart';

class SignUpStep4Component extends StatefulWidget {
  @override
  _SignUpStep4ComponentState createState() => _SignUpStep4ComponentState();
}

class _SignUpStep4ComponentState extends State<SignUpStep4Component>
    with TickerProviderStateMixin {
  GlobalKey<FormState> mFormKey = GlobalKey<FormState>();

  TextEditingController mWeightCont = TextEditingController();
  TextEditingController mHeightCont = TextEditingController();

  FocusNode mWeightFocus = FocusNode();
  FocusNode mHeightFocus = FocusNode();
  int height = 170;

  int? mHeight = 0;
  int? mWeight = 0;

  double? mFeetValue = 0.0328084;
  double? mCMValue = 30.48;

  bool isKGClicked = false;
  bool isLBSClicked = false;
  bool isFeetClicked = false;
  bool isCMClicked = false;

  //List<String> get _listWeightText => ["kg", "lbs"];

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  void dispose() {
    super.dispose();
    mWeightCont.dispose();
    mHeightCont.dispose();
  }

  init() async {
    mWeightCont.text = userStore.weight.validate().isNotEmpty
        ? "${userStore.weight.validate()} ${userStore.weightUnit}"
        : "";
    mHeightCont.text = userStore.height.validate().isNotEmpty
        ? "${userStore.height.validate()} ${userStore.heightUnit}"
        : "";

    mWeight = userStore.weightUnit == LBS ? 0 : 1;
    mHeight = userStore.heightUnit == FEET ? 0 : 1;

    appStore.setLoading(false);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Widget mHeightOption(String? value, int? index) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(6),
          backgroundColor: mHeight == index
              ? primaryColor
              : appStore.isDarkMode
                  ? context.cardColor
                  : GreyLightColor),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(value!,
          style: secondaryTextStyle(
              color:
                  mHeight == index ? Colors.white : textSecondaryColorGlobal)),
    ).onTap(() {
      hideKeyboard(context);
      mHeight = index;
      if (index == 1) {
        if (!isFeetClicked) {
          convertFeetToCm();
          isFeetClicked = true;
          isCMClicked = false;
        }
      } else {
        if (!isCMClicked) {
          convertCMToFeet();
          isCMClicked = true;
          isFeetClicked = false;
        }
      }
      setState(() {});
    });
  }

  //Convert Feet to Cm
  void convertFeetToCm() {
    double a = double.parse(mHeightCont.text.isEmptyOrNull
            ? "0.0"
            : mHeightCont.text.validate()) *
        30.48;
    if (!mHeightCont.text.isEmptyOrNull) {
      mHeightCont.text = a.toStringAsFixed(2).toString();
    }
    mHeightCont.selection = TextSelection.fromPosition(
        TextPosition(offset: mHeightCont.text.length));
    print(a.toStringAsFixed(2).toString());
  }

  //Convert CM to Feet
  void convertCMToFeet() {
    double a = double.parse(mHeightCont.text.isEmptyOrNull
            ? "0.0"
            : mHeightCont.text.validate()) *
        0.0328;
    if (!mHeightCont.text.isEmptyOrNull) {
      mHeightCont.text = a.toStringAsFixed(2).toString();
    }
    mHeightCont.selection = TextSelection.fromPosition(
        TextPosition(offset: mHeightCont.text.length));
    print(a.toStringAsFixed(2).toString());
  }

  Widget mWeightOption(String? value, int? index) {
    return Container(
      decoration: boxDecorationWithRoundedCorners(
          borderRadius: radius(6),
          backgroundColor: mWeight == index
              ? primaryColor
              : appStore.isDarkMode
                  ? context.cardColor
                  : GreyLightColor),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(value!,
          style: secondaryTextStyle(
              color:
                  mWeight == index ? Colors.white : textSecondaryColorGlobal)),
    ).onTap(() {
      mWeight = index;
      hideKeyboard(context);
      if (index == 0) {
        if (!isLBSClicked) {
          convertKgToLbs();
          isLBSClicked = true;
          isKGClicked = false;
        }
      } else {
        if (!isKGClicked) {
          convertLbsToKg();
          isKGClicked = true;
          isLBSClicked = false;
        }
      }
      setState(() {});
    });
  }

//Convert lbs to kg
  void convertLbsToKg() {
    double a = double.parse(mWeightCont.text.isEmptyOrNull
            ? "0.0"
            : mWeightCont.text.validate()) *
        0.45359237;
    if (!mWeightCont.text.isEmptyOrNull) {
      mWeightCont.text = a.toStringAsFixed(2).toString();
    }
    mWeightCont.selection = TextSelection.fromPosition(
        TextPosition(offset: mWeightCont.text.length));
    print(a.toStringAsFixed(0).toString());
  }

  void convertKgToLbs() {
    double a = double.parse(mWeightCont.text.isEmptyOrNull
            ? "0.0"
            : mWeightCont.text.validate()) *
        2.2046;
    if (!mWeightCont.text.isEmptyOrNull) {
      mWeightCont.text = a.toStringAsFixed(2).toString();
    }
    mWeightCont.selection = TextSelection.fromPosition(
        TextPosition(offset: mWeightCont.text.length));
    print(a.round().toString());
  }

  Future<void> saveData() async {
    hideKeyboard(context);
    UserProfile userProfile = UserProfile();
    userProfile.age = userStore.age.validate();
    userProfile.heightUnit = userStore.heightUnit.validate();
    userProfile.height = userStore.height.validate();
    userProfile.weight = userStore.weight.validate();
    userProfile.weightUnit = userStore.weightUnit.validate();
    Map<String, dynamic> req;

    req = {
      'first_name': userStore.fName.validate(),
      'last_name': userStore.lName.validate(),
      'username': getBoolAsync(IS_OTP) != true
          ? userStore.email.validate()
          : userStore.phoneNo.validate(),
      'email': userStore.email.validate(),
      'password': userStore.password.validate(),
      'user_type': LoginUser,
      'status': statusActive,
      'phone_number': userStore.phoneNo.validate(),
      'gender': userStore.gender.validate().toLowerCase(),
      'user_profile': userProfile,
      "player_id": getStringAsync(PLAYER_ID).validate(),
      if (getBoolAsync(IS_OTP) != false) "login_type": LoginTypeOTP,
    };

    appStore.setLoading(true);
    await registerApi(req).then((value) async {
      appStore.setLoading(false);
      userStore.setLogin(true);
      userStore.setToken(value.data!.apiToken.validate());
      getUSerDetail(context, value.data!.id).then((value) {
        DashboardScreen().launch(context, isNewTask: true);
      }).catchError((e) {
        print("error=>" + e.toString());
      });
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
    setState(() {});
  }

  WeightType weightType = WeightType.kg;

  double weight = 0;

  @override
  Widget build(BuildContext context) {
    print("----------sociallogin>>>${getBoolAsync(IS_OTP)}");
    return Stack(
      children: [
        SingleChildScrollView(
          child: Form(
            key: mFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(languages.lblLetUsKnowBetter,
                    style: boldTextStyle(size: 22)),
                24.height,
                Text(languages.lblWeight,
                    style: secondaryTextStyle(color: textPrimaryColorGlobal)),
                4.height,
                AppTextField(
                  readOnly: true,
                  onTap: () {
                    _openWightPickerBottomSheet(context);
                  },
                  onChanged: (_) {
                    /* setState(() {
                      isLBSClicked = false;
                      isKGClicked = false;
                    });*/
                  },
                  controller: mWeightCont,
                  textFieldType: TextFieldType.NUMBER,
                  isValidationRequired: true,
                  focus: mWeightFocus,
                  nextFocus: mHeightFocus,
                  decoration: defaultInputDecoration(context,
                      label: languages.lblEnterWeight),
                ),
                16.height,
                Text(languages.lblHeight,
                    style: secondaryTextStyle(color: textPrimaryColorGlobal)),
                4.height,
                AppTextField(
                  onTap: () {
                    customHeightPicker(
                      heightSelected: (val) {
                        mHeightCont.text =
                            "${val} ${userStore.heightUnit.validate()}";
                      },
                    ).launch(context);
                  },
                  readOnly: true,
                  onChanged: (_) {
                    /* setState(() {
                      isFeetClicked = false;
                      isCMClicked = false;
                    });*/
                  },
                  controller: mHeightCont,
                  textFieldType: TextFieldType.NUMBER,
                  isValidationRequired: true,
                  focus: mHeightFocus,
                  decoration: defaultInputDecoration(context,
                      label: languages.lblEnterHeight),
                ),
                24.height,
                AppButton(
                  text: languages.lblDone,
                  width: context.width(),
                  color: primaryColor,
                  onTap: () async {
                    if (mFormKey.currentState!.validate()) {
                      /* userStore.setHeight(mHeightCont.text.validate().split(' ')[0]);
                      userStore.setWeight(mWeightCont.text.validate().split(' ')[0]);
                      userStore.setWeightUnit(mWeight == 0 ? LBS : METRICS_WEIGHT_UNIT);
                      userStore.setHeightUnit(mHeight == 0 ? FEET : METRICS_CM);*/
                      userStore.setIsSTEP('newUser');

                      userStore
                          .setWeight(mWeightCont.text.validate().split(' ')[0]);

                      saveData();
                      setState(() {});
                    }
                  },
                ),
              ],
            ).paddingSymmetric(horizontal: 16),
          ),
        ),
        Loader().visible(appStore.isLoading)
      ],
    );
  }

  void _openWightPickerBottomSheet(BuildContext context) async {
    final res = await showModalBottomSheet<Tuple2<WeightType, double>>(
      context: context,
      isDismissible: false,
      elevation: 0,
      enableDrag: false,
      transitionAnimationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 800)),
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            decoration: bottomSheetDecoration,
            height: 250,
            child: Column(
              children: [
                Header(
                  weightType: weightType,
                  inKg: weight,
                ),
                Switcher(
                  weightType: weightType,
                  onChanged: (type) {
                    setState(() {
                      weightType = type;
                      if (type.name == languages.lblKg && weight > 200) {
                        weight = 200;
                      } else if (type.name != languages.lblKg && weight > 400) {
                        weight = 400;
                      }
                    });
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                    child: DivisionSlider(
                  key: ValueKey(weightType.name),
                      from: weightType.name == "KG"? 40 : 90,
                      max: weightType.name == "KG" ? 200 : 400,
                      initialValue: weight.clamp(
                        weightType.name == "KG" ? 40 : 90,
                        weightType.name == "KG" ? 200 : 400,
                      ),
                  type: weightType,
                  onChanged: (value) {
                    setState(() => weight = value);
                  },
                ))
              ],
            ),
          );
        });
      },
    );
    if (res != null) {
      setState(() {
        mWeightCont.text =
            "${res.item2.toString()}  ${res.item1.name.toString().toLowerCase()}";
        userStore.setWeight(res.item2.toString());
        userStore.setWeightUnit(res.item1.name.toString().toLowerCase());
        weightType = res.item1;
        weight = res.item2;
      });
    }
  }
}
