import 'package:flutter/material.dart';

import 'Language.dart';

//TODO: CREATE A PREFERENCES PAGE
class PreferencesModel extends ChangeNotifier{

  Language originalLanguage;
  Language translatedLanguage;

  PreferencesModel.FrenchToEnglish(){
    this.originalLanguage = Language(isoCode: "fr", name: "French");
    this.translatedLanguage = Language(isoCode: "en", name: "English");
  }

  PreferencesModel({this.originalLanguage, this.translatedLanguage});

  void updateOriginalLanguage(Language newOriginalLanguage){
    _updateWith(original: newOriginalLanguage);
  }

  void updateTranslatedLanguage(Language newTranslatedLanguage){
    _updateWith(translated: newTranslatedLanguage);
  }

  void switchLanguages(){
    _updateWith(original: translatedLanguage, translated: originalLanguage);
  }

  void _updateWith({ Language original, Language translated}){
   this.originalLanguage = original ?? this.originalLanguage;
   this.translatedLanguage = translated ?? this.translatedLanguage;
   notifyListeners();
  }

}