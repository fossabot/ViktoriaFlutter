import 'package:flutter/foundation.dart' show SynchronousFuture;
import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'de': {
      'title': 'Viktoria',
      'unitPlan': 'Stundenplan',
      'replacementPlan': 'Vertretungsplan',
      'pupil': 'Schüler*In',
      'teacher': 'Lehrer*In',
      'pleaseSelect': 'Bitte auswählen',
      'login': 'Anmelden',
      'fieldCantBeEmpty': 'Das Feld darf nicht leer sein',
      'username': 'Nutzername',
      'password': 'Passwort',
      'notImplementedYet': 'Diese Funktion gibt es bislang noch nicht',
      'credentialsNotCorrect': 'Nutzername oder Passwort falsch',
      'lunchBreak': 'Mittagspause',
      'settings': 'Einstellungen',
      'personalData': 'PERSÖNLICHE DATEN',
      'appSettings': 'APPEINSTELLUNGEN',
      'logout': 'Abmelden',
      'freeLesson': 'Freistunde',
      'sortReplacementPlan': 'Vertretungsplan sortieren',
      'showReplacementPlanInUnitPlan':
      'Vertretungsplan im Stundenplan anzeigen',
      'getReplacementPlanNotifications':
      'Benachrichtigungen für Änderungen auf dem Vertretungsplan',
      'nUnit': '. Stunde',
      'myChanges': 'Meine Vertretungen',
      'undefChanges': 'Eventuell meine Vertretungen',
      'otherChanges': 'Weitere Vertretungen',
      'writeExams': 'Schriftlich',
    },
  };

  String get writeExams {
    return _localizedValues[locale.languageCode]['writeExams'];
  }

  String get myChanges {
    return _localizedValues[locale.languageCode]['myChanges'];
  }

  String get undefChanges {
    return _localizedValues[locale.languageCode]['undefChanges'];
  }

  String get otherChanges {
    return _localizedValues[locale.languageCode]['otherChanges'];
  }

  String get nUnit {
    return _localizedValues[locale.languageCode]['nUnit'];
  }

  String get sortReplacementPlan {
    return _localizedValues[locale.languageCode]['sortReplacementPlan'];
  }

  String get showReplacementPlanInUnitPlan {
    return _localizedValues[locale.languageCode]
    ['showReplacementPlanInUnitPlan'];
  }

  String get getReplacementPlanNotifications {
    return _localizedValues[locale.languageCode]
    ['getReplacementPlanNotifications'];
  }

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }

  String get unitPlan {
    return _localizedValues[locale.languageCode]['unitPlan'];
  }

  String get replacementPlan {
    return _localizedValues[locale.languageCode]['replacementPlan'];
  }

  String get pupil {
    return _localizedValues[locale.languageCode]['pupil'];
  }

  String get teacher {
    return _localizedValues[locale.languageCode]['teacher'];
  }

  String get pleaseSelect {
    return _localizedValues[locale.languageCode]['pleaseSelect'];
  }

  String get login {
    return _localizedValues[locale.languageCode]['login'];
  }

  String get fieldCantBeEmpty {
    return _localizedValues[locale.languageCode]['fieldCantBeEmpty'];
  }

  String get username {
    return _localizedValues[locale.languageCode]['username'];
  }

  String get password {
    return _localizedValues[locale.languageCode]['password'];
  }

  String get notImplementedYet {
    return _localizedValues[locale.languageCode]['notImplementedYet'];
  }

  String get credentialsNotCorrect {
    return _localizedValues[locale.languageCode]['credentialsNotCorrect'];
  }

  String get lunchBreak {
    return _localizedValues[locale.languageCode]['lunchBreak'];
  }

  String get settings {
    return _localizedValues[locale.languageCode]['settings'];
  }

  String get personalData {
    return _localizedValues[locale.languageCode]['personalData'];
  }

  String get appSettings {
    return _localizedValues[locale.languageCode]['appSettings'];
  }

  String get logout {
    return _localizedValues[locale.languageCode]['logout'];
  }

  String get freeLesson {
    return _localizedValues[locale.languageCode]['freeLesson'];
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['de'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
}
