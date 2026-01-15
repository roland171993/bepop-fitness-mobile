import '../../utils/shared_import.dart';

class AppLocalizations extends LocalizationsDelegate<BaseLanguage> {
  const AppLocalizations();

  @override
  Future<BaseLanguage> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'en':
        return BaseLanguage();
      default:
        return BaseLanguage();
    }
  }

  @override
  bool isSupported(Locale locale) {
    return getSupportedLocales().any((supportedLocale) =>
        supportedLocale.languageCode == locale.languageCode);
  }

  @override
  bool shouldReload(LocalizationsDelegate<BaseLanguage> old) => false;
}
