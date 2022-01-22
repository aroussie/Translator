import 'package:flutter/material.dart';
import 'package:myTranslator/models/Quiz.dart';

class QuizProvider extends ChangeNotifier {

  bool isQuizOver = false;
  bool hasAnswered = false;
  final Quiz quiz;

  int rightAnswersCount = 0;

  QuizProvider({this.quiz});

  int get totalQuestions => quiz.questions.length;

  void updateQuizOver(bool isOver){
    isQuizOver = isOver;
    notifyListeners();
  }

  void updateHasAnswered(bool didAnswer){
    hasAnswered = didAnswer;
    notifyListeners();
  }

  void increaseRightAnswerCount(){
    rightAnswersCount++;
    notifyListeners();
  }

}