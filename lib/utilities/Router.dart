import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myTranslator/models/Quiz.dart';
import 'package:myTranslator/screens/NotesListPage.dart';
import 'package:myTranslator/screens/PickLanguagePage.dart';
import 'package:myTranslator/screens/QuizCreatePage.dart';
import 'package:myTranslator/screens/QuizListPage.dart';
import 'package:myTranslator/screens/QuizPage.dart';
import 'package:myTranslator/screens/TranslatePage.dart';
import 'package:myTranslator/screens/TranslationListPage.dart';
import 'package:myTranslator/screens/VerbPage.dart';
import 'package:myTranslator/utilities/Constants.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homeRoute:
        // "/" is only hit at initialization by the HomePage Navigator
        // so it's safe to simply return the translations list
        return MaterialPageRoute(builder: (_) => TranslationListPage());
      case translationsRoute:
        return MaterialPageRoute(builder: (_) => TranslationListPage());
      case translateRoute:
        return MaterialPageRoute(builder: (_) => TranslatePage());
      case pickLanguageRoute:
        var arguments = settings.arguments as PickLanguageArguments;
        return MaterialPageRoute(
            builder: (_) => PickLanguagePage(
                languages: arguments.languages,
                selectOriginalLanguage: arguments.selectOriginalLanguage));
      case verbsRoute:
        return MaterialPageRoute(builder: (_) => NotesListPage());
      case addVerbRoute:
        var arguments = settings.arguments as VerbPageArguments;
        return MaterialPageRoute(
            builder: (_) => VerbPage(arguments.key, arguments.originalVerb));
      case myQuizzesRoute:
        return MaterialPageRoute(builder: (_) => QuizListPage());
      case createQuizRoute:
        return MaterialPageRoute(builder: (_) => QuizCreatePageBuilder());
      case quizRoute:
        var quiz = settings.arguments as Quiz;
        return MaterialPageRoute(builder: (_) => QuizPageBuilder(quiz: quiz));
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text("No route found for that path"),
                  ),
                ));
    }
  }
}
