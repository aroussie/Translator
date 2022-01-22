import 'dart:convert';

import 'dart:math';

class Quiz {
  int id;
  String title;
  List<QuizQuestion> questions = [];

  Quiz({this.id, this.title, this.questions});

  Quiz.initiate({this.title});

  Quiz.dummy() {
    id = Random.secure().nextInt(20);
    title = "Dummy Quiz";
    for (int i = 0; i < 5; i++) {
      questions.add(QuizQuestion(question: "Question $i", answers: [
        QuizAnswer(answer: "First answer", isRightAnswer: false),
        QuizAnswer(answer: "second answer", isRightAnswer: false),
        QuizAnswer(answer: "third answer", isRightAnswer: true),
        QuizAnswer(answer: "fourth answer", isRightAnswer: false)
      ]));
    }
  }

  Map<String, dynamic> toMap() {
    //We need to encode the hashmap into a json String to be able to store it
    return {
      'title': this.title,
      'questions': json.encode(
          questions.map((QuizQuestion question) => question.toJson()).toList())
    };
  }

  factory Quiz.fromDatabase(Map<String, dynamic> map) {
    //We need to decode the String first to get the hashMap from it
    var questionsList = json.decode(map['questions']);
    return Quiz(
        id: map['id'],
        title: map['title'],
        questions: questionsList
            .map<QuizQuestion>((question) => QuizQuestion.fromJson(question))
            .toList());
  }

  factory Quiz.fromJson(Map<String, dynamic> map) {
    //We need to decode the String first to get the hashMap from it
    var questionsList = map['questions'];
    return Quiz(
        id: map['id'],
        title: map['title'],
        questions: questionsList
            .map<QuizQuestion>((question) => QuizQuestion.fromJson(question))
            .toList());
  }
}

class QuizQuestion {
  String question;
  List<QuizAnswer> answers = [];

  QuizQuestion({this.question, this.answers});

  QuizQuestion.empty() {
    this.question = "";
    this.answers = [QuizAnswer(), QuizAnswer(), QuizAnswer(), QuizAnswer()];
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answers': answers.map((QuizAnswer answer) => answer.toJson()).toList()
    };
  }

  factory QuizQuestion.fromJson(Map<String, dynamic> map) {
    var listAnswers = map["answers"];
    return QuizQuestion(
        question: map['question'],
        answers: listAnswers
            .map<QuizAnswer>((answer) => QuizAnswer.fromJson(answer))
            .toList());
  }
}

class QuizAnswer {
  String answer;
  bool isRightAnswer;

  QuizAnswer({this.answer = "", this.isRightAnswer = false});

  Map<String, dynamic> toJson() {
    return {'answer': answer, 'isRightAnswer': isRightAnswer};
  }

  QuizAnswer.fromJson(Map<String, dynamic> map) {
    this.answer = map['answer'];
    this.isRightAnswer = map['isRightAnswer'];
  }
}
