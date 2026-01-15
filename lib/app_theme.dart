import '../utils/shared_import.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
      useMaterial3: false,
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: Colors.transparent),
      scaffoldBackgroundColor: whiteColor,
      primaryColor: primaryColor,
      iconTheme: IconThemeData(color: Colors.black),
      dividerColor: viewLineColor,
      cardColor: cardLightColor,
      colorScheme: ColorScheme(
        primary: primaryColor,
        secondary: primaryColor,
        surface: Colors.white,
        // background: Colors.white,
        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.black,
        // onBackground: Colors.black,
        onError: Colors.redAccent,
        brightness: Brightness.light,
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
            borderRadius: radius(20),
            side: BorderSide(width: 1, color: primaryColor)),
        checkColor: WidgetStateProperty.all(Colors.white),
        fillColor: WidgetStateProperty.all(primaryColor),
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
      textTheme: GoogleFonts.interTextTheme(),
      pageTransitionsTheme: PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ));

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: false,
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
    scaffoldBackgroundColor: scaffoldColorDark,
    iconTheme: IconThemeData(color: Colors.white),
    cardColor: cardDarkColor,
    colorScheme: ColorScheme(
      primary: primaryColor,
      secondary: primaryColor,
      surface: Colors.black,
      //  background: Colors.black,
      error: Colors.red,
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      // onBackground: Colors.white,
      onError: Colors.redAccent,
      brightness: Brightness.dark,
    ),
    dividerColor: Colors.white24,
    textTheme: GoogleFonts.interTextTheme(),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
          borderRadius: radius(20),
          side: BorderSide(width: 1, color: primaryColor)),
      checkColor: WidgetStateProperty.all(Colors.white),
      fillColor: WidgetStateProperty.all(primaryColor),
      materialTapTargetSize: MaterialTapTargetSize.padded,
    ),
    pageTransitionsTheme: PageTransitionsTheme(
      builders: <TargetPlatform, PageTransitionsBuilder>{
        TargetPlatform.android: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: OpenUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
  );
}
