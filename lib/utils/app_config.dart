import 'shared_import.dart';

const APP_NAME = "Bepop Fitness";
//endregion
var initialSteps = 0;

//region baseurl
const mBackendURL = "https://sagar.test.roland.net";

//endregion
//region Default Language Code
const DEFAULT_LANGUAGE = 'en';
//endregion

//region Change Walk Through Text
String WALK1_TITLE = languages.lblWalkTitle1;
String WALK2_TITLE = languages.lblWalkTitle2;
String WALK3_TITLE = languages.lblWalkTitle3;
//endregion

//region onesignal
const mOneSignalID = 'BEPOP_FITNESS_ONE_SIGNAL_ID';
//endregion

//region country

String? countryCode = "BEPOP_FITNESS_COUNTRY_CODE";
String? countryDail = "BEPOP_FITNESS_COUNTRY_DAIL";
//endregion

//region logins
const ENABLE_SOCIAL_LOGIN = true;
const ENABLE_GOOGLE_SIGN_IN = true;
const ENABLE_OTP = true;
const ENABLE_APPLE_SIGN_IN = true;
//endregion

//region perPage value
const EQUIPMENT_PER_PAGE = 10;
const LEVEL_PER_PAGE = 10;
const WORKOUT_TYPE_PAGE = 10;
//endregion

//region payment description and identifier
const mRazorDescription = 'BEPOP_FITNESS_PAYMENT_DESCRIPTION';
const mStripeIdentifier = 'BEPOP_FITNESS_PAYMENT_IDENTIFIER';
//endregion

//region urls
const mBaseUrl = '$mBackendURL/api/';
//endregion

//region Manage Ads
// const showAdOnDietDetail = false;
// const showAdOnBlogDetail = false;
// const showAdOnExerciseDetail = false;
// const showAdOnProductDetail = false;
// const showAdOnWorkoutDetail = false;
// const showAdOnProgressDetail = false;

// const showBannerAdOnDiet = false;
// const showBannerOnProduct = false;
// const showBannerOnBodyPart = false;
// const showBannerOnEquipment = false;
// const showBannerOnLevel = false;
// const showBannerOnWorkouts = false;
//endregion

List<String> firstTitles = [
  languages.lblBuildMuscle,
  languages.lblKeepFit,
  languages.lblLoseWeight
];
List<String> firstDescriptions = [
  languages.lblFirstDescriptions1,
  languages.lblFirstDescriptions2,
  languages.lblFirstDescriptions3,
];
final List<String> firstIcons = [
  ic_build,
  ic_keep,
  ic_lose,
];

List<String> secondTitles = [
  languages.lblTotallyNewbie,
  languages.lblBeginner,
  languages.lblIntermediate,
  languages.lblAdvanced
];
List<String> secondDescriptions = [
  languages.LblSecDesc1,
  languages.LblSecDesc2,
  languages.LblSecDesc3,
  languages.LblSecDesc4,
];
final List<String> secondIcons = [
  empty_graph,
  one_graph,
  two_graph,
  full_graph,
];

List<String> thirdTitles = [
  languages.lblNoEquipment,
  languages.lblDumbbells,
  languages.lblGarageGym,
  languages.lblFullGym,
  languages.lblCustom
];
List<String> thirdDescriptions = [
  languages.lblThirdDescriptions1,
  languages.lblThirdDescriptions2,
  languages.lblThirdDescriptions3,
  languages.lblThirdDescriptions4,
  languages.lblThirdDescriptions5,
];
final List<String> thirdIcons = [
  ic_noequpment,
  ic_dumbbell,
  garage_gym,
  full_gym,
  custom,
];

const mOneSignalAppId = 'BEPOP_FITNESS_ONE_SIGNAL_ID';
const mOneSignalRestKey = 'BEPOP_FITNESS_ONE_SIGNAL_REST_KEY';
const mOneSignalChannelId = 'BEPOP_FITNESS_ONE_SIGNAL__CHANNEL_ID';


const FIREBASE_KEY = "BEPOP_FITNESS_FIREBASE_KEY";
const FIREBASE_APP_ID = "BEPOP_FITNESS_FIREBASE_APP_ID";
const FIREBASE_MESSAGE_SENDER_ID = "BEPOP_FITNESS_FIREBASE_MESSAGE_SENDER_ID";
const FIREBASE_PROJECT_ID = "BEPOP_FITNESS_FIREBASE_PROJECT_ID";
const FIREBASE_STORAGE_BUCKET_ID = "BEPOP_FITNESS_FIREBASE_STORAGE_BUCKET_ID";
