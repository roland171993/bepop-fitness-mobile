import '../utils/shared_import.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:bepop_fitness/service/user_service.dart';
import '../store/NotificationStore/NotificationStore.dart';
import '../../store/app_store.dart';
import 'app_theme.dart';
import 'screens/no_internet_screen.dart';
import 'screens/splash_screen.dart';
import 'store/UserStore/UserStore.dart';

AppStore appStore = AppStore();
UserStore userStore = UserStore();
NotificationStore notificationStore = NotificationStore();
LanguageJsonData? selectedServerLanguageData;
List<LanguageJsonData>? defaultServerLanguageData = [];
late Size mq;
late SharedPreferences sharedPreferences;
final navigatorKey = GlobalKey<NavigatorState>();
late BaseLanguage languages;
UserService userService = UserService();
bool mIsEnterKey = false;
int? postId;
String appName = "Unknown";
/*List<LanguageDataModel> localeLanguageList = [];
LanguageDataModel? selectedLanguageDataModel;*/

/*Future<void> initialize({
  List<LanguageDataModel>? aLocaleLanguageList,
  String? defaultLanguage,
}) async {
  localeLanguageList = aLocaleLanguageList ?? [];
  selectedLanguageDataModel = getSelectedLanguageModel(defaultLanguage: defaultLanguage);
}*/

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sharedPreferences = await SharedPreferences.getInstance();

  // await initialize(aLocaleLanguageList: languageList());
  appStore.setLanguage(sharedPreferences.getString(SELECTED_LANGUAGE_CODE) ??
      defaultLanguageCode);

  await Firebase.initializeApp().then((value) {
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  });
  initJsonFile();
  /*if (Platform.isIOS) {
    await Firebase.initializeApp().then((value) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    });
  } else {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform).then((value) {
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    });
  }*/

  setLogInValue();
  defaultAppButtonShapeBorder =
      RoundedRectangleBorder(borderRadius: radius(defaultAppButtonRadius));
  oneSignalData();
  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelKey: 'basic_channel',
        channelName: 'Basic Notifications',
        channelDescription: 'Basic Notification Channel',
        defaultColor: primaryColor,
        playSound: true,
        importance: NotificationImportance.High,
        locked: true,
        enableVibration: true,
      ),
      NotificationChannel(
        channelKey: 'scheduled_channel',
        channelName: 'Scheduled Notifications',
        channelDescription: 'Scheduled Notification Channel',
        defaultColor: primaryColor,
        locked: true,
        importance: NotificationImportance.High,
        playSound: true,
        enableVibration: true,
      ),
    ],
  );
  setTheme();
  if (!getStringAsync(PROGRESS_SETTINGS_DETAIL).isEmptyOrNull) {
    userStore.addAllProgressSettingsListItem(
        jsonDecode(getStringAsync(PROGRESS_SETTINGS_DETAIL))
            .map<ProgressSettingModel>((e) => ProgressSettingModel.fromJson(e))
            .toList());
  } else {
    userStore.addAllProgressSettingsListItem(progressSettingList());
  }

  runApp(MyApp());
  // runApp(
  //   DevicePreview(
  //     enabled: !kReleaseMode,
  //     builder: (context) => MyApp(),
  //   ),
  // );
}

Future<void> updatePlayerId(String email) async {
  Map req = {
    "player_id": getStringAsync(PLAYER_ID),
    "username": email, // getStringAsync(USERNAME),
    "email": email, // getStringAsync(EMAIL),
  };
  await updateProfileApi(req).then((value) {
    //
  }).catchError((error) {
    //
  });
}

class MyApp extends StatefulWidget {
  static String tag = '/MyApp';

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool isCurrentlyOnNoInternet = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((e) {
      if (e == ConnectivityResult.none) {
        log('not connected');
        isCurrentlyOnNoInternet = true;
        push(NoInternetScreen());
      } else {
        if (isCurrentlyOnNoInternet) {
          pop();
          isCurrentlyOnNoInternet = false;
          toast(languages.lblInternetIsConnected);
        }
        log('connected');
      }
    });
  }

  @override
  void didChangeDependencies() {
    if (getIntAsync(THEME_MODE_INDEX) == ThemeModeSystem)
      appStore.setDarkMode(
          MediaQuery.of(context).platformBrightness == Brightness.dark);
    super.didChangeDependencies();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return MaterialApp(
        title: APP_NAME,
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        scrollBehavior: SBehavior(),
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: appStore.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        localizationsDelegates: [
          AppLocalizations(),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          //AppLocalizations(),
        ],
        localeResolutionCallback: (locale, supportedLocales) => locale,
        supportedLocales: getSupportedLocales(),
        locale: Locale(
            appStore.selectedLanguageCode.validate(value: DEFAULT_LANGUAGE)),
        home: SplashScreen(),
        onGenerateRoute: (settings) {
          print("--<<<settings>>>--${settings.name ?? ''}");
          print(
              "--<<<settings>>>--${(settings.name?.startsWith('/mightyfitness') == true)}");
          if (settings.name != null) {
            final uri = Uri.parse(settings.name!);
            var PostId = uri.queryParameters['postId'];
            postId = PostId != null ? int.parse('${PostId}') : null;
            if (uri.path.startsWith('/mightyfitness')) {
              return MaterialPageRoute(
                builder: (context) => SplashScreen(
                  isFromLink: true,
                ),
              );
            }
          }
          return null;
        },
      );
    });
  }
}
