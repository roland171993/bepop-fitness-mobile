import '../../utils/shared_import.dart';

class BaseLanguage {
  static BaseLanguage? of(BuildContext context) {
    try {
      return Localizations.of<BaseLanguage>(context, BaseLanguage);
    } catch (e) {
      throw e;
    }
  }

  String get lblGetStarted => getContentValueFromKey(4);
  String get lblNext => getContentValueFromKey(5);
  String get lblWelcomeBack => getContentValueFromKey(8);
  String get lblWelcomeBackDesc => getContentValueFromKey(9);
  String get lblLogin => getContentValueFromKey(7);
  String get lblEmail => getContentValueFromKey(10);
  String get lblEnterEmail => getContentValueFromKey(11);
  String get lblPassword => getContentValueFromKey(12);
  String get lblEnterPassword => getContentValueFromKey(13);
  String get lblRememberMe => getContentValueFromKey(14);
  String get lblForgotPassword => getContentValueFromKey(15);
  String get lblNewUser => getContentValueFromKey(17);
  String get lblHome => getContentValueFromKey(46);
  String get lblDiet => getContentValueFromKey(47);
  String get lblReport => getContentValueFromKey(232);
  String get lblProfile => getContentValueFromKey(49);
  String get lblAboutUs => getContentValueFromKey(120);
  String get lblBlog => getContentValueFromKey(110);
  String get lblChangePassword => getContentValueFromKey(128);
  String get lblEnterCurrentPwd => getContentValueFromKey(134);
  String get lblEnterNewPwd => getContentValueFromKey(137);
  String get lblCurrentPassword => getContentValueFromKey(133);
  String get lblNewPassword => getContentValueFromKey(135);
  String get lblConfirmPassword => getContentValueFromKey(27);
  String get lblEnterConfirmPwd => getContentValueFromKey(28);
  String get errorPwdLength => getContentValueFromKey(29);
  String get errorPwdMatch => getContentValueFromKey(30);
  String get lblSubmit => getContentValueFromKey(139);
  String get lblEditProfile => getContentValueFromKey(58);
  String get lblFirstName => getContentValueFromKey(21);
  String get lblEnterFirstName => getContentValueFromKey(22);
  String get lblEnterLastName => getContentValueFromKey(24);
  String get lblLastName => getContentValueFromKey(23);
  String get lblPhoneNumber => getContentValueFromKey(25);
  String get lblEnterPhoneNumber => getContentValueFromKey(26);
  String get lblEnterAge => getContentValueFromKey(60);
  String get lblAge => getContentValueFromKey(59);
  String get lblWeight => getContentValueFromKey(37);
  String get lblLbs => getContentValueFromKey(42);
  String get lblKg => getContentValueFromKey(43);
  String get lblEnterWeight => getContentValueFromKey(38);
  String get lblHeight => getContentValueFromKey(39);
  String get lblFeet => getContentValueFromKey(45);
  String get lblCm => getContentValueFromKey(44);
  String get lblEnterHeight => getContentValueFromKey(40);
  String get lblGender => getContentValueFromKey(61);
  String get lblSave => getContentValueFromKey(62);
  String get lblForgotPwdMsg => getContentValueFromKey(200);
  String get lblContinue => getContentValueFromKey(233);
  String get lblSelectLanguage => getContentValueFromKey(126);
  String get lblNoInternet => getContentValueFromKey(181);
  String get lblContinueWithPhone => getContentValueFromKey(190);
  String get lblRcvCode => getContentValueFromKey(191);
  String get lblYear => getContentValueFromKey(73);
  String get lblFavourite => getContentValueFromKey(234);
  String get lblSelectTheme => getContentValueFromKey(132);
  String get lblDeleteAccount => getContentValueFromKey(109);
  String get lblPrivacyPolicy => getContentValueFromKey(118);
  String get lblLogout => getContentValueFromKey(116);
  String get lblLogoutMsg => getContentValueFromKey(117);
  String get lblVerifyOTP => getContentValueFromKey(192);
  String get lblVerifyProceed => getContentValueFromKey(193);
  String get lblCode => getContentValueFromKey(194);
  String get lblTellUsAboutYourself => getContentValueFromKey(20);
  String get lblAlreadyAccount => getContentValueFromKey(31);
  String get lblWhtGender => getContentValueFromKey(32);
  String get lblMale => getContentValueFromKey(33);
  String get lblFemale => getContentValueFromKey(34);
  String get lblHowOld => getContentValueFromKey(35);
  String get lblLetUsKnowBetter => getContentValueFromKey(36);
  String get lblLight => getContentValueFromKey(129);
  String get lblDark => getContentValueFromKey(130);
  String get lblSystemDefault => getContentValueFromKey(131);
  String get lblStore => getContentValueFromKey(235);
  String get lblPlan => getContentValueFromKey(113);
  String get lblAboutApp => getContentValueFromKey(115);
  String get lblPasswordMsg => getContentValueFromKey(136);
  String get lblDelete => getContentValueFromKey(106);
  String get lblCancel => getContentValueFromKey(236);
  String get lblSettings => getContentValueFromKey(114);
  String get lblHeartRate => getContentValueFromKey(101);
  String get lblMonthly => getContentValueFromKey(195);
  String get lblNoFoundData => getContentValueFromKey(68);
  String get lblTermsOfServices => getContentValueFromKey(119);
  String get lblFollowUs => getContentValueFromKey(124);
  String get lblWorkouts => getContentValueFromKey(56);
  String get lblChatConfirmMsg => getContentValueFromKey(143);
  String get lblYes => getContentValueFromKey(144);
  String get lblNo => getContentValueFromKey(145);
  String get lblClearConversion => getContentValueFromKey(147);
  String get lblChatHintText => getContentValueFromKey(148);
  String get lblTapBackAgainToLeave => getContentValueFromKey(50);
  String get lblPro => getContentValueFromKey(237);
  String get lblCalories => getContentValueFromKey(173);
  String get lblCarbs => getContentValueFromKey(174);
  String get lblFat => getContentValueFromKey(175);
  String get lblProtein => getContentValueFromKey(176);
  String get lblKcal => getContentValueFromKey(178);
  String get lblIngredients => getContentValueFromKey(179);
  String get lblInstruction => getContentValueFromKey(180);
  String get lblStartExercise => getContentValueFromKey(85);
  String get lblDuration => getContentValueFromKey(69);
  String get lblBodyParts => getContentValueFromKey(86);
  String get lblEquipments => getContentValueFromKey(87);
  String get lblHomeWelMsg => getContentValueFromKey(52);
  String get lblBodyPartExercise => getContentValueFromKey(54);
  String get lblEquipmentsExercise => getContentValueFromKey(55);
  String get lblLevels => getContentValueFromKey(57);
  String get lblBuyNow => getContentValueFromKey(201);
  String get lblSearchExercise => getContentValueFromKey(65);
  String get lblAll => getContentValueFromKey(67);
  String get lblTips => getContentValueFromKey(202);
  String get lblDietCategories => getContentValueFromKey(94);
  String get lblSkip => getContentValueFromKey(6);
  String get lblWorkoutType => getContentValueFromKey(92);
  String get lblLevel => getContentValueFromKey(238);
  String get lblBmi => getContentValueFromKey(203);
  String get lblCopiedToClipboard => getContentValueFromKey(149);
  String get lblFullBodyWorkout => getContentValueFromKey(204);
  String get lblTypes => getContentValueFromKey(205);
  String get lblClearAll => getContentValueFromKey(206);
  String get lblSelectAll => getContentValueFromKey(207);
  String get lblShowResult => getContentValueFromKey(208);
  String get lblSelectLevels => getContentValueFromKey(209);
  String get lblUpdate => getContentValueFromKey(103);
  String get lblSteps => getContentValueFromKey(239);
  String get lblPackageTitle => getContentValueFromKey(70);
  String get lblPackageTitle1 => getContentValueFromKey(71);
  String get lblSubscriptionPlans => getContentValueFromKey(76);
  String get lblSubscribe => getContentValueFromKey(74);
  String get lblActive => getContentValueFromKey(77);
  String get lblHistory => getContentValueFromKey(78);
  String get lblSubscriptionMsg => getContentValueFromKey(79);
  String get lblCancelSubscription => getContentValueFromKey(82);
  String get lblViewPlans => getContentValueFromKey(80);
  String get lblHey => getContentValueFromKey(51);
  String get lblRepeat => getContentValueFromKey(210);
  String get lblEveryday => getContentValueFromKey(211);
  String get lblReminderName => getContentValueFromKey(212);
  String get lblDescription => getContentValueFromKey(213);
  String get lblSearch => getContentValueFromKey(53);
  String get lblTopFitnessReads => getContentValueFromKey(121);
  String get lblTrendingBlogs => getContentValueFromKey(122);
  String get lblBestDietDiscoveries => getContentValueFromKey(95);
  String get lblDietaryOptions => getContentValueFromKey(96);
  String get lblFav => getContentValueFromKey(214);

  String get lblBreak => getContentValueFromKey(100);

  String get lblProductCategory => getContentValueFromKey(98);

  String get lblProductList => getContentValueFromKey(99);

  String get lblTipsInst => getContentValueFromKey(215);

  String get lblContactAdmin => getContentValueFromKey(19);

  String get lblOr => getContentValueFromKey(16);

  String get lblRegisterNow => getContentValueFromKey(18);

  String get lblDailyReminders => getContentValueFromKey(112);

  String get lblPayments => getContentValueFromKey(91);

  String get lblPay => getContentValueFromKey(92);

  String get lblAppThemes => getContentValueFromKey(127);

  String get lblTotalSteps => getContentValueFromKey(142);

  String get lblDate => getContentValueFromKey(105);

  String get lblDeleteAccountMSg => getContentValueFromKey(107);

  String get lblHint => getContentValueFromKey(104);

  String get lblAdd => getContentValueFromKey(216);

  String get lblNotifications => getContentValueFromKey(63);

  String get lblNotificationEmpty => getContentValueFromKey(64);

  String get lblQue1 => getContentValueFromKey(150);

  String get lblQue2 => getContentValueFromKey(151);

  String get lblQue3 => getContentValueFromKey(152);

  String get lblFitBot => getContentValueFromKey(146);

  String get lblG => getContentValueFromKey(153);

  String get lblEnterText => getContentValueFromKey(217);

  String get lblYourPlanValid => getContentValueFromKey(81);

  String get lblTo => getContentValueFromKey(83);

  String get lblSets => getContentValueFromKey(218);

  String get lblSuccessMsg => getContentValueFromKey(89);

  String get lblPaymentFailed => getContentValueFromKey(90);

  String get lblSuccess => getContentValueFromKey(88);

  String get lblDone => getContentValueFromKey(41);

  String get lblWorkoutLevel => getContentValueFromKey(93);

  String get lblReps => getContentValueFromKey(219);

  String get lblSecond => getContentValueFromKey(220);

  String get lblFavoriteWorkoutAndNutristions => getContentValueFromKey(111);

  String get lblShop => getContentValueFromKey(48);

  String get lblDeleteMsg => getContentValueFromKey(108);

  String get lblSelectPlanToContinue => getContentValueFromKey(75);

  String get lblResultNoFound => getContentValueFromKey(97);

  String get lblExerciseNoFound => getContentValueFromKey(66);

  String get lblBlogNoFound => getContentValueFromKey(123);

  String get lblWorkoutNoFound => getContentValueFromKey(221);

  String get lblTenSecondRemaining => getContentValueFromKey(222);

  String get lblThree => getContentValueFromKey(223);

  String get lblTwo => getContentValueFromKey(224);

  String get lblOne => getContentValueFromKey(225);

  String get lblExerciseDone => getContentValueFromKey(240);

  String get lblMonth => getContentValueFromKey(72);

  String get lblDay => getContentValueFromKey(241);

  String get lblPushUp => getContentValueFromKey(102);

  String get lblEnterReminderName => getContentValueFromKey(226);

  String get lblEnterDescription => getContentValueFromKey(227);

  String get lblMetricsSettings => getContentValueFromKey(125);

  String get lblIdealWeight => getContentValueFromKey(140);

  String get lblBmr => getContentValueFromKey(141);

  String get lblErrorThisFiledIsRequired => getContentValueFromKey(228);

  String get lblSomethingWentWrong => getContentValueFromKey(229);

  String get lblErrorInternetNotAvailable => getContentValueFromKey(230);

  String get lblErrorNotAllow => getContentValueFromKey(170);

  String get lblPleaseTryAgain => getContentValueFromKey(171);

  String get lblInvalidUrl => getContentValueFromKey(172);

  String get lblUsernameShouldNotContainSpace => getContentValueFromKey(165);

  String get lblMinimumPasswordLengthShouldBe => getContentValueFromKey(166);

  String get lblInternetIsConnected => getContentValueFromKey(167);

  String get lblNoSetsMsg => getContentValueFromKey(84);

  String get lblNoDurationMsg => getContentValueFromKey(168);

  String get lblWalkTitle1 => getContentValueFromKey(1);

  String get lblWalkTitle2 => getContentValueFromKey(2);

  String get lblWalkTitle3 => getContentValueFromKey(3);

  String get lblEmailIsInvalid => getContentValueFromKey(231);

  String get lblMainGoal => getContentValueFromKey(154);

  String get lblHowExperienced => getContentValueFromKey(155);

  String get lblHoweEquipment => getContentValueFromKey(157);

  String get lblHoweOftenWorkout => getContentValueFromKey(158);

  String get lblFinish => getContentValueFromKey(245);

  String get lblProgression => getContentValueFromKey(160);

  String get lblEasyHabit => getContentValueFromKey(161);

  String get lblRecommend => getContentValueFromKey(162);

  String get lblTimesWeek => getContentValueFromKey(163);

  String get lblOnlyTimesWeek => getContentValueFromKey(164);

  String get lblSchedule => getContentValueFromKey(242);
  String get lblChangeView => getContentValueFromKey(243);
  String get lblJoin => getContentValueFromKey(244);
  String get lblUpdateNow => getContentValueFromKey(246);
  String get lblUpdateAvailable => getContentValueFromKey(247);
  String get lblUpdateNote => getContentValueFromKey(248);
  String get lblGameOver => getContentValueFromKey(249);

  ///Samir Changes
  String get lblMainMenu => getContentValueFromKey(250);
  String get lblBetterLuckNextTime => getContentValueFromKey(251);
  String get lblExit => getContentValueFromKey(252);
  String get lblMightyBrainWorkout => getContentValueFromKey(253);
  String get lblGameTitle => getContentValueFromKey(254);
  String get lblStart => getContentValueFromKey(255);
  String get lblPleaseWait => getContentValueFromKey(256);
  String get lblHoursAfterPlayAgain => getContentValueFromKey(257);
  String get lblBuildMuscle => getContentValueFromKey(258);
  String get lblKeepFit => getContentValueFromKey(259);
  String get lblLoseWeight => getContentValueFromKey(260);

  String get lblFirstDescriptions1 => getContentValueFromKey(261);
  String get lblFirstDescriptions2 => getContentValueFromKey(262);
  String get lblFirstDescriptions3 => getContentValueFromKey(263);

  String get lblTotallyNewbie => getContentValueFromKey(264);
  String get lblBeginner => getContentValueFromKey(265);
  String get lblIntermediate => getContentValueFromKey(266);
  String get lblAdvanced => getContentValueFromKey(267);

  String get LblSecDesc1 => getContentValueFromKey(268);
  String get LblSecDesc2 => getContentValueFromKey(269);
  String get LblSecDesc3 => getContentValueFromKey(270);
  String get LblSecDesc4 => getContentValueFromKey(271);

  String get lblNoEquipment => getContentValueFromKey(272);
  String get lblDumbbells => getContentValueFromKey(273);
  String get lblGarageGym => getContentValueFromKey(274);
  String get lblFullGym => getContentValueFromKey(275);
  String get lblCustom => getContentValueFromKey(276);
  String get lblThirdDescriptions1 => getContentValueFromKey(277);
  String get lblThirdDescriptions2 => getContentValueFromKey(278);
  String get lblThirdDescriptions3 => getContentValueFromKey(279);
  String get lblThirdDescriptions4 => getContentValueFromKey(280);
  String get lblThirdDescriptions5 => getContentValueFromKey(281);

  String get lblHomeScreenTitle => getContentValueFromKey(282);

  String get lblNoConversationFound => getContentValueFromKey(283);

  String get lblViewContact => getContentValueFromKey(284);
  String get lblUnblock => getContentValueFromKey(285);
  String get lblBlock => getContentValueFromKey(286);
  String get lblClearChat => getContentValueFromKey(287);
  String get lblChatCleared => getContentValueFromKey(288);
  String get lblBlockMsg => getContentValueFromKey(289);
  String get lblOnline => getContentValueFromKey(290);
  String get lblLastSeen => getContentValueFromKey(291);
  String get lblSearchHere => getContentValueFromKey(292);
  String get lblNewChat => getContentValueFromKey(293);

  String get lblFailed => getContentValueFromKey(294);
  String get lblPaymentSuccessful => getContentValueFromKey(295);
  String get lblPaymentCancelled => getContentValueFromKey(296);

  String get lblDeleteChat => getContentValueFromKey(297);
  String get lblDeleteDialogTitle => getContentValueFromKey(298);
  String get lblChatDeleted => getContentValueFromKey(299);
  String get lblDeleteMessage => getContentValueFromKey(300);

  String get lblChat => getContentValueFromKey(301);
  String get lblMinRead => getContentValueFromKey(302);

  String get lblFree => getContentValueFromKey(303);
  String get lblPurchases => getContentValueFromKey(304);
  String get lblToSendMsg => getContentValueFromKey(305);
  String get lblMsg => getContentValueFromKey(306);
  String get lblRepsWeight => getContentValueFromKey(307);
  String get lblRest => getContentValueFromKey(308);

  String get lblLeaderboard => getContentValueFromKey(309);

  String get lblCommunity => getContentValueFromKey(310);
  String get lblReportPost => getContentValueFromKey(311);
  String get lblEditPost => getContentValueFromKey(312);
  String get lblDeletePost => getContentValueFromKey(313);
  String get lblDelPost => getContentValueFromKey(314);
  String get gotoProfile => getContentValueFromKey(315);
  String get lblNoPost => getContentValueFromKey(316);
  String get lblComments => getContentValueFromKey(317);
  String get lblupdate => getContentValueFromKey(318);
  String get lblReply => getContentValueFromKey(319);
  String get lblViewR => getContentValueFromKey(320);
  String get lblHideR => getContentValueFromKey(321);
  String get lblUpComments => getContentValueFromKey(322);
  String get lblAddComments => getContentValueFromKey(323);
  String get lblReports => getContentValueFromKey(324);
  String get lblRepoDes => getContentValueFromKey(325);
  String get lblRepo => getContentValueFromKey(327);
  String get finishProfileSetting => getContentValueFromKey(328);
  String get lblChoseVideo => getContentValueFromKey(326);
  String get lblMaxVideoMsg => getContentValueFromKey(329);
  String get lblNewPost => getContentValueFromKey(330);
  String get WriteSomeThing => getContentValueFromKey(331);
  String get lblEditImg => getContentValueFromKey(332);
  String get lblEditVid => getContentValueFromKey(333);
  String get lblSelectImg => getContentValueFromKey(334);
  String get lblSelectVid => getContentValueFromKey(335);
  String get lblEmptyMsg => getContentValueFromKey(336);
  String get lblAddImg => getContentValueFromKey(337);
  String get lblAddVid => getContentValueFromKey(338);
  String get lblSharePost => getContentValueFromKey(339);
  String get lblCamera => getContentValueFromKey(340);
  String get lblChoseImg => getContentValueFromKey(341);
  String get lblRecord => getContentValueFromKey(342);
  String get lblPost => getContentValueFromKey(343);
  String get edtCmt => getContentValueFromKey(344);
  String get edtRpl => getContentValueFromKey(345);
  String get dltRpl => getContentValueFromKey(346);
  String get dltCmt => getContentValueFromKey(347);
  String get share => getContentValueFromKey(348);
  String get posted => getContentValueFromKey(349);
  String get lblCmt => getContentValueFromKey(350);
  String get lblLike => getContentValueFromKey(351);
  String get lblLikes => getContentValueFromKey(352);
  String get lblUMedia => getContentValueFromKey(353);
  String get lblPostBmk => getContentValueFromKey(354);
  String get lblWOHtr => getContentValueFromKey(355);
  String get lblOpen => getContentValueFromKey(356);
  String get lblPermissionDescription => getContentValueFromKey(357);
  String get confirmDeleteComment => getContentValueFromKey(358);
  String get confirmDeleteCommentReply => getContentValueFromKey(359);
  String get checkOutPost => getContentValueFromKey(360);
  String get readMore => getContentValueFromKey(361);
  String get readLess => getContentValueFromKey(362);
  String get disclaimer => getContentValueFromKey(363);
  String get viewSourceReference => getContentValueFromKey(364);
  String get sourceReference => getContentValueFromKey(365);
  String get close => getContentValueFromKey(366);
  String get dietDesclaimerNote => getContentValueFromKey(367);
  String get dietDesclaimerNote2 => getContentValueFromKey(368);
  String get dietDesclaimerNote3 => getContentValueFromKey(369);
}
