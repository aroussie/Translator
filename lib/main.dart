import 'package:flutter/material.dart';
import 'package:myTranslator/screens/TranslatePage.dart';
import 'package:myTranslator/screens/TranslationListPage.dart';
import 'package:myTranslator/utilities/Constants.dart';
import 'package:myTranslator/utilities/Router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/Language.dart';
import 'models/PreferencesModel.dart';
import 'screens/HomePage.dart';

void main() async {
  const String SHARED_PREF_ORIGINAL_LANGUAGE_NAME =
      "SHARED_PREF_ORIGINAL_LANGUAGE_NAME";
  const String SHARED_PREF_ORIGINAL_LANGUAGE_ISO =
      "SHARED_PREF_ORIGINAL_LANGUAGE_ISO";
  const String SHARED_PREF_TRANSLATED_LANGUAGE_NAME =
      "SHARED_PREF_TRANSLATED_LANGUAGE_NAME";
  const String SHARED_PREF_TRANSLATED_LANGUAGE_ISO =
      "SHARED_PREF_TRANSLATED_LANGUAGE_ISO";

  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();

  String originalLanguageName =
  prefs.getString(SHARED_PREF_ORIGINAL_LANGUAGE_NAME);
  String translatedLanguageName =
  prefs.getString(SHARED_PREF_TRANSLATED_LANGUAGE_NAME);

  Language originalLanguage = originalLanguageName != null
      ? new Language(
      isoCode: prefs.getString(SHARED_PREF_ORIGINAL_LANGUAGE_ISO),
      name: originalLanguageName)
      : null;
  Language languageToTranslateTo = translatedLanguageName != null
      ? new Language(
      isoCode: prefs.getString(SHARED_PREF_TRANSLATED_LANGUAGE_ISO),
      name: translatedLanguageName)
      : null;

  if (originalLanguage != null && languageToTranslateTo != null) {
    return runApp(MyApp(PreferencesModel(originalLanguage: originalLanguage,
        translatedLanguage: languageToTranslateTo)));
  } else {
    return runApp(MyApp(PreferencesModel.FrenchToEnglish()));
  }
}

class MyApp extends StatelessWidget {

  PreferencesModel preferencesModel;


  MyApp(this.preferencesModel);


  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider.value(value: preferencesModel)],
        child: MaterialApp(
          home: HomePage(),
          title: 'Flutter Demo',
          onGenerateRoute: Router.generateRoute,
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blue,
          ),
        ));
  }
}

