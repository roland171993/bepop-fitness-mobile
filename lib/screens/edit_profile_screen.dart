import '../utils/shared_import.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with TickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController mFNameCont = TextEditingController();
  TextEditingController mLNameCont = TextEditingController();
  TextEditingController mEmailCont = TextEditingController();
  TextEditingController mAgeCont = TextEditingController();
  TextEditingController mMobileNumberCont = TextEditingController();
  TextEditingController mWeightCont = TextEditingController();
  TextEditingController mHeightCont = TextEditingController();

  FocusNode mEmailFocus = FocusNode();
  FocusNode mFNameFocus = FocusNode();
  FocusNode mLNameFocus = FocusNode();
  FocusNode mMobileNumberFocus = FocusNode();
  FocusNode mAgeFocus = FocusNode();
  FocusNode mWeightFocus = FocusNode();
  FocusNode mHeightFocus = FocusNode();

  List<String> item = [languages.lblFemale, languages.lblMale];
  List<GenderModel> GenderList = [];

  String mGender = languages.lblFemale;
  String? profileImg = '';
  String? countryCode = '';

  int? mHeight;
  int? mWeight;

  XFile? image;

  double inputValue = 0.0;
  int selectGender = 0;

  bool isKGClicked = false;
  bool isLBSClicked = false;
  bool isFeetClicked = false;
  bool isCMClicked = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    getGender();
    //
    mFNameCont.text = userStore.fName;
    mLNameCont.text = userStore.lName;
    mEmailCont.text = userStore.email;
    mAgeCont.text = userStore.age;
    mMobileNumberCont.text = userStore.phoneNo;
    mWeightCont.text = '${userStore.weight} ${userStore.weightUnit}';
    profileImg = userStore.profileImage;
    if (!userStore.height.isEmptyOrNull) {
      mHeightCont.text = '${userStore.height} ${userStore.heightUnit}';
    }
    //userStore.heightUnit == FEET ? mHeight = 0 : mHeight = 1;
    //userStore.weightUnit == LBS ? mWeight = 0 : mWeight = 1;
    mGender = userStore.gender.isEmptyOrNull
        ? "female"
        : userStore.gender.capitalizeFirstLetter();
    userStore.displayName = userStore.fName + userStore.lName;
  }

  getGender() {
    GenderList.add(GenderModel(0, languages.lblMale, MALE));
    GenderList.add(GenderModel(1, languages.lblFemale, FEMALE));
    GenderList.forEach((element) {
      print('userStore.gender' + userStore.gender.toString());
      if (element.key == userStore.gender) {
        selectGender = element.id.validate();
      }
    });
  }

  Future save() async {
    hideKeyboard(context);
    appStore.setLoading(true);
    print("type ==> ${userStore.weightUnit}");

    MultipartRequest multiPartRequest =
        await getMultiPartRequest('update-profile');
    multiPartRequest.fields['id'] = userStore.userId.toString();
    multiPartRequest.fields['first_name'] = mFNameCont.text;
    multiPartRequest.fields['last_name'] = mLNameCont.text;
    multiPartRequest.fields['email'] = mEmailCont.text;
    multiPartRequest.fields['username'] = mEmailCont.text;
    multiPartRequest.fields['phone_number'] = mMobileNumberCont.text;
    multiPartRequest.fields['gender'] = mGender.toLowerCase();
    multiPartRequest.fields['user_profile[age]'] = mAgeCont.text;
    multiPartRequest.fields['user_profile[weight]'] =
        mWeightCont.text.validate().split(' ')[0];
    multiPartRequest.fields['user_profile[height]'] =
        mHeightCont.text.validate().split(' ')[0];
    multiPartRequest.fields['user_profile[height_unit]'] = userStore.heightUnit;
    multiPartRequest.fields['user_profile[weight_unit]'] = userStore.weightUnit;

    if (image != null) {
      multiPartRequest.files.add(await MultipartFile.fromPath(
          'profile_image', image!.path.toString()));
    }

    multiPartRequest.headers.addAll(buildHeaderTokens());
    sendMultiPartRequest(
      multiPartRequest,
      onSuccess: (data) async {
        if ((data as String).isJson()) {
          UserResponse res = UserResponse.fromJson(jsonDecode(data));
          print(res.toJson().toString());
          setValue(COUNTRY_CODE, countryCode);
          await userStore.weight.isEmpty;
          await userStore.weightUnit.isEmpty;
          await userStore.height.isEmpty;
          await userStore.heightUnit.isEmpty;
          await userStore.setUserEmail(res.data!.email.validate());
          await userStore.setFirstName(res.data!.firstName.validate());
          await userStore.setLastName(res.data!.lastName.validate());
          await userStore.setUsername(res.data!.username.validate());
          await userStore.setGender(res.data!.gender.validate());
          await userStore.setUserImage(res.data!.profileImage.validate());
          await userStore.setDisplayName(res.data!.displayName.validate());
          await userStore.setPhoneNo(res.data!.phoneNumber.validate());

          if (res.data?.userProfile != null) {
            await userStore.setAge(res.data?.userProfile?.age ?? '');
            await userStore.setHeight(res.data?.userProfile?.height ?? '');
            await userStore
                .setHeightUnit(res.data?.userProfile?.heightUnit ?? '');
            await userStore.setWeight(res.data?.userProfile?.weight ?? '');
            await userStore
                .setWeightUnit(res.data?.userProfile?.weightUnit ?? '');
          } else {
            await userStore.setAge(mAgeCont.text.validate());
            await userStore.setHeight(mHeightCont.text.validate());
            await userStore.setHeightUnit(mHeight == 0 ? FEET : METRICS_CM);
            await userStore.setWeight(weight.toString());
            await userStore.setWeightUnit(weightType.name);
          }

          await getUSerDetail(context, userStore.userId).whenComplete(() {
            print("gfdgfgdfgdfg");
            LiveStream().emit(PROGRESS);
            finish(context, true);
            appStore.setLoading(false);
            if (mounted) setState(() {});
          });
        }
      },
      onError: (error) {
        log(multiPartRequest.toString());
        toast(error.toString());
        appStore.setLoading(false);
      },
    ).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }


  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
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
      child: Text(value.toString(),
          style: secondaryTextStyle(
              color: mHeight == index ? Colors.white : textColor)),
    ).onTap(() {
      mHeight = index;
      hideKeyboard(context);
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

  WeightType weightType =
      userStore.weightUnit == 'kg' ? WeightType.lb : WeightType.kg;

  double weight = 0;

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
                ? Colors.black
                : Color(0xffD9D9D9),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Text(value!,
          style: secondaryTextStyle(
              color: mWeight == index ? Colors.white : textColor)),
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
  }

  Future getImage() async {
    image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 100);
    setState(() {});
  }

  Widget profileImage() {
    if (image != null) {
      return Container(
        padding: EdgeInsets.all(1),
        decoration: boxDecorationWithRoundedCorners(
            boxShape: BoxShape.circle,
            border: Border.all(
                width: 2, color: primaryColor.withValues(alpha: 0.5))),
        child: Image.file(File(image!.path),
                height: 90, width: 90, fit: BoxFit.cover)
            .cornerRadiusWithClipRRect(65),
      );
    } else if (!profileImg.isEmptyOrNull) {
      return Container(
        padding: EdgeInsets.all(1),
        decoration: boxDecorationWithRoundedCorners(
            boxShape: BoxShape.circle,
            border: Border.all(
                width: 2, color: primaryColor.withValues(alpha: 0.5))),
        child: cachedImage(profileImg, width: 90, height: 90, fit: BoxFit.cover)
            .cornerRadiusWithClipRRect(65),
      );
    } else {
      return Container(
        padding: EdgeInsets.all(1),
        decoration: boxDecorationWithRoundedCorners(
            boxShape: BoxShape.circle,
            border: Border.all(
                width: 2, color: primaryColor.withValues(alpha: 0.5))),
        child: CircleAvatar(
            maxRadius: 60,
            backgroundColor: Colors.white,
            backgroundImage: AssetImage(ic_logo)),
      );
    }
  }

  int mSelectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            appStore.isDarkMode ? Brightness.light : Brightness.light,
        systemNavigationBarIconBrightness:
            appStore.isDarkMode ? Brightness.light : Brightness.light,
      ),
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
                child: Stack(
              children: [
                Container(height: context.height() * 0.4, color: primaryColor),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Icon(
                              appStore.selectedLanguageCode == 'ar'
                                  ? MaterialIcons.arrow_forward_ios
                                  : Octicons.chevron_left,
                              color: white,
                              size: 28)
                          .onTap(() {
                        Navigator.pop(context);
                      }),
                      16.width,
                      Text(languages.lblEditProfile,
                          style: boldTextStyle(size: 20, color: white)),
                    ],
                  ).paddingOnly(
                      top: context.statusBarHeight + 16,
                      left: 16,
                      right: appStore.selectedLanguageCode == 'ar' ? 16 : 0),
                ),
                Container(
                  margin: EdgeInsets.only(top: context.height() * 0.2),
                  height: context.height() * 0.4,
                  decoration: boxDecorationWithRoundedCorners(
                      borderRadius: radiusOnly(topRight: 16, topLeft: 16),
                      backgroundColor: appStore.isDarkMode
                          ? context.scaffoldBackgroundColor
                          : Colors.white),
                ),
                Column(children: [
                  16.height,
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      profileImage(),
                      Container(
                              decoration: boxDecorationWithRoundedCorners(
                                  boxShape: BoxShape.circle,
                                  backgroundColor: primaryOpacity),
                              padding: EdgeInsets.all(6),
                              child: Image.asset(ic_camera,
                                  color: primaryColor, height: 20, width: 20))
                          .onTap(() {
                        getImage();
                      }) /*.visible(!getBoolAsync(IS_SOCIAL))*/
                    ],
                  ).paddingOnly(top: context.height() * 0.11).center(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      20.height,
                      Text(languages.lblFirstName, style: secondaryTextStyle()),
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
                      Text(languages.lblLastName, style: secondaryTextStyle()),
                      4.height,
                      AppTextField(
                        controller: mLNameCont,
                        textFieldType: TextFieldType.NAME,
                        isValidationRequired: true,
                        focus: mLNameFocus,
                        nextFocus: mMobileNumberFocus,
                        suffix: mSuffixTextFieldIconWidget(ic_user),
                        decoration: defaultInputDecoration(context,
                            label: languages.lblEnterLastName),
                      ),
                      16.height,
                      Text(languages.lblEmail, style: secondaryTextStyle()),
                      4.height,
                      AppTextField(
                        controller: mEmailCont,
                        textFieldType: TextFieldType.EMAIL,
                        isValidationRequired: true,
                        focus: mEmailFocus,
                        readOnly: true,
                        nextFocus: mMobileNumberFocus,
                        suffix: mSuffixTextFieldIconWidget(ic_mail),
                        decoration: defaultInputDecoration(context,
                            label: languages.lblEnterEmail),
                      ),
                      16.height,
                      Text(languages.lblPhoneNumber,
                          style: secondaryTextStyle()),
                      4.height,
                      AppTextField(
                        controller: mMobileNumberCont,
                        textFieldType: TextFieldType.PHONE,
                        isValidationRequired: true,
                        focus: mMobileNumberFocus,
                        readOnly: true,
                        //  readOnly: getBoolAsync(IS_OTP) != true ? false : true,
                        nextFocus: mAgeFocus,
                        suffix: mSuffixTextFieldIconWidget(ic_call),
                        decoration: defaultInputDecoration(
                          context,
                          label: languages.lblEnterPhoneNumber,
                          /* mPrefix: IntrinsicHeight(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  CountryCodePicker(
                                    initialSelection: getStringAsync(COUNTRY_CODE, defaultValue: countryCode!),
                                    showCountryOnly: false,
                                    showFlag: false,
                                    boxDecoration: BoxDecoration(borderRadius: radius(defaultRadius), color: appStore.isDarkMode ? context.cardColor : GreyLightColor),
                                    showFlagDialog: true,
                                    showOnlyCountryWhenClosed: false,
                                    alignLeft: false,
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
                                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    textStyle: primaryTextStyle(),
                                    onInit: (c) {
                                      countryCode = c!.code;
                                    },
                                    onChanged: (c) {
                                      countryCode = c.code;
                                    },
                                  ),
                                  VerticalDivider(color: Colors.grey.withOpacity(0.5)),
                                  16.width,
                                ],
                              ),
                            )*/
                        ),
                      ),
                      16.height,
                      Text(languages.lblAge, style: secondaryTextStyle()),
                      4.height,
                      AppTextField(
                        readOnly: true,
                        onTap: () {
                          _openAgePickerBottomSheet(context);
                        },
                        controller: mAgeCont,
                        textFieldType: TextFieldType.NUMBER,
                        isValidationRequired: true,
                        focus: mAgeFocus,
                        nextFocus: mWeightFocus,
                        keyboardType: TextInputType.number,
                        /*  inputFormatters: [
                          FilteringTextInputFormatter.deny(RegExp(r'[ ]')), // Block space
                          FilteringTextInputFormatter.deny(RegExp(r'[!@#\$%^&*(),.?":{}|<>-]')), // Block special characters
                        ],*/
                        suffix: mSuffixTextFieldIconWidget(ic_user),
                        decoration: defaultInputDecoration(context,
                            label: languages.lblEnterAge),
                      ),
                      16.height,
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(languages.lblWeight,
                                style: secondaryTextStyle()),
                            4.height,
                            AppTextField(
                              readOnly: true,
                              onTap: () {
                                _openWightPickerBottomSheet(context);
                              },
                              controller: mWeightCont,
                              textFieldType: TextFieldType.NUMBER,
                              focus: mWeightFocus,
                              nextFocus: mHeightFocus,
                              decoration: defaultInputDecoration(context,
                                  label: languages.lblEnterWeight),
                            ),
                            16.height,
                            Text(languages.lblHeight,
                                style: secondaryTextStyle()),
                            4.height,
                            AppTextField(
                              readOnly: true,
                              onTap: () {
                                customHeightPicker(
                                  heightSelected: (val) {
                                    mHeightCont.text =
                                        "${val} ${userStore.heightUnit.validate()}";
                                    print(
                                        "----------------------->>>${mHeightCont.text}");
                                  },
                                ).launch(context);
                              },
                              controller: mHeightCont,
                              textFieldType: TextFieldType.NUMBER,
                              // keyboardType: TextInputType.number,
                              focus: mHeightFocus,
                              decoration: defaultInputDecoration(context,
                                  label: languages.lblEnterHeight),
                            ),
                          ],
                        ),
                      ),
                      16.height,
                      Text(languages.lblGender, style: secondaryTextStyle()),
                      4.height,
                      DropdownButtonFormField<GenderModel>(
                        items: GenderList.map((e) {
                          return DropdownMenuItem<GenderModel>(
                            child: Text(
                                e.name.validate().capitalizeFirstLetter(),
                                style: primaryTextStyle()),
                            value: e,
                          );
                        }).toList(),
                        isExpanded: false,
                        value: GenderList.isNotEmpty
                            ? GenderList[selectGender]
                            : null,
                        isDense: true,
                        borderRadius: radius(),
                        decoration: defaultInputDecoration(context),
                        onChanged: (GenderModel? value) {
                          setState(() {
                            mGender = value!.key.toString();
                          });
                        },
                      ),
                      24.height,
                      AppButton(
                          text: languages.lblSave,
                          width: context.width(),
                          color: primaryColor,
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              save();
                            }
                          }),
                      24.height,
                    ],
                  ).paddingSymmetric(horizontal: 16),
                ])
              ],
            )),
            Observer(
              builder: (context) {
                return Loader().center().visible(appStore.isLoading);
              },
            )
          ],
        ),
      ),
    );
  }

  void _openWightPickerBottomSheet(BuildContext context) async {
    final res = await showModalBottomSheet<Tuple2<WeightType, double>>(
      context: context,
      isDismissible: false,
      elevation: 0,
      enableDrag: false,
      transitionAnimationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 0)),
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            decoration: BoxDecoration(
              color: appStore.isDarkMode ? Colors.black : Color(0xffD9D9D9),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
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
                    /*  Navigator.pop(context);
                    _openWightPickerBottomSheet(context);
                    setState(() => weightType = type);*/
                    setState(() {
                      weightType = type;
                    });
                    if (type.name == languages.lblKg && weight > 200) {
                      weight = 200;
                    } else if (type.name != languages.lblKg && weight > 400) {
                      weight = 400;
                    }
                  },
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: DivisionSlider(
                    key: ValueKey(weightType.name),
                    from: weightType.name == "KG"? 40 : 90,
                    max: weightType.name == "KG" ? 200 : 400,
                    initialValue: userStore.weight.toDouble().clamp(
                      weightType.name == "KG" ? 40 : 90,
                      weightType.name == "KG" ? 200 : 400,
                    ),
                    type: weightType,
                    onChanged: (value) {
                      setState(() => weight = value);
                    },
                  ),
                )
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
        userStore.setWeightUnit(res.item1.name.toString().toLowerCase());
        weightType = res.item1;
        weight = res.item2;
      });
    }
  }

  void _openAgePickerBottomSheet(BuildContext context) async {
    await showModalBottomSheet<Tuple2<WeightType, double>>(
      context: context,
      isDismissible: false,
      elevation: 0,
      transitionAnimationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 500)),
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: appStore.isDarkMode ? scaffoldColorDark : Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          height: 300,
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: appStore.isDarkMode ? Colors.black : Color(0xffD9D9D9),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        color: appStore.isDarkMode
                            ? Color(0xffD9D9D9)
                            : Colors.black,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.close),
                      ),
                      Text(languages.lblAge,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: appStore.isDarkMode
                                  ? Color(0xffD9D9D9)
                                  : Colors.black)),
                      IconButton(
                        color: appStore.isDarkMode
                            ? Color(0xffD9D9D9)
                            : Colors.black,
                        onPressed: () {
                          mAgeCont.text = mSelectedIndex.toString();
                          Navigator.of(context).pop();
                        },
                        icon: const Icon(Icons.check),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CupertinoPicker(
                      magnification: 1.4,
                      squeeze: 0.8,
                      useMagnifier: true,
                      selectionOverlay: SizedBox(),
                      itemExtent: 32.0,
                      scrollController: FixedExtentScrollController(
                          initialItem: userStore.age.validate().toInt() - 17),
                      onSelectedItemChanged: (int selectedItem) {
                        setState(() {
                          mSelectedIndex = selectedItem + 17;
                        });
                      },
                      children: List<Widget>.generate(99 - 17 + 1, (int index) {
                        int actualIndex = index + 17;
                        return Text(actualIndex.toString(),
                                style: boldTextStyle(size: 30))
                            .center();
                      }),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(height: 2, width: 100, color: primaryColor),
                        50.height,
                        Container(height: 2, width: 100, color: primaryColor),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
    /* if (res != null) {
      setState(() {
        mWeightCont.text = "${res.item2.toString()}  ${res.item1.name.toString().toLowerCase()}";
        userStore.setWeightUnit(res.item1.name.toString().toLowerCase());
        weightType = res.item1;
        weight = res.item2;
      });
    }*/
  }
}
