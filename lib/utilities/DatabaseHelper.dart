import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:myTranslator/models/Quiz.dart';
import 'package:myTranslator/models/Translation.dart';
import 'package:myTranslator/models/Verb.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter/services.dart' show rootBundle;

//See https://medium.com/@abeythilakeudara3/to-do-list-in-flutter-with-sqlite-as-local-database-8b26ba2b060e
class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  final String translationTable = "translation";
  final String verbTable = "verb";
  final String quizTable = "quiz";

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }

    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await _initializeDatabase();
    }

    return _database;
  }

  Future<Database> _initializeDatabase() async {
    String databasePath =
        join(await getDatabasesPath(), "my_translator_database.db");

    var appDatabase =
        await openDatabase(databasePath, version: 1, onCreate: _createDatabase);

    return appDatabase;
  }

  /// Create the different tables within the database
  void _createDatabase(Database database, int newVersion) async {
    //Create a table for the translations
    await database.execute("CREATE TABLE $translationTable("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "originalSentence TEXT,"
        "translatedSentence TEXT,"
        "type TEXT)");

    //Create a table for the verbs
    await database.execute("CREATE TABLE $verbTable("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "originalTitle TEXT,"
        "originalFirstPerson TEXT,"
        "originalSecondPerson TEXT,"
        "originalThirdPerson TEXT,"
        "originalFourthPerson TEXT,"
        "originalFifthPerson TEXT,"
        "originalSixthPerson TEXT,"
        "translatedTitle TEXT,"
        "translatedFirstPerson TEXT,"
        "translatedSecondPerson TEXT,"
        "translatedThirdPerson TEXT,"
        "translatedFourthPerson TEXT,"
        "translatedFifthPerson TEXT,"
        "translatedSixthPerson TEXT)");

    await database.execute("CREATE TABLE $quizTable("
    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
    "title TEXT,"
    "questions TEXT)");
  }

  // VERB LOGIC

  Future<int> saveVerb(Verb verb) async {
    Database db = await this.database;
    var results = db.insert(verbTable, verb.toMap());
    return results;
  }

  Future<List<Verb>> fetchVerbs() async {
    Database db = await this.database;
    var results = await db.query(this.verbTable);

    if (results.isEmpty && kDebugMode) {
      saveVerb(Verb.BE());
      saveVerb(Verb.HAVE());
      saveVerb(Verb.CAN());
      saveVerb(Verb.WANT());
      saveVerb(Verb.TAKE());
      saveVerb(Verb.GO());
      return fetchVerbs();
    }

    return List.generate(results.length, (index) {
      return Verb.fromDatabase(json: results[index]);
    });
  }

  Future<int> editVerb(Verb verb) async {
    Database db = await this.database;
    var results = db
        .update(verbTable, verb.toMap(), where: "id = ?", whereArgs: [verb.id]);
    return results;
  }

  Future<int> deleteVerb(Verb verb) async {
    Database db = await this.database;
    var result = db.delete(verbTable, where: 'id = ?', whereArgs: [verb.id]);
    return result;
  }

  // TRANSLATION LOGIC

  Future<int> saveTranslation(Translation translation) async {
    Database db = await this.database;
    var results = db.insert(translationTable, translation.toMap());
    return results;
  }

  Future<List<Translation>> fetchTranslations() async {
    Database db = await this.database;
    var result = await db.query(translationTable);
    //TODO: Refactor the logic to sort the translations
    return List.generate(result.length, (index) {
      return Translation.fromDatabase(result[index]);
    });
  }

  Future<int> deleteTranslation(Translation translation) async {
    Database db = await this.database;
    var results = db.delete(translationTable, where: 'id = ?', whereArgs: [translation.id]);
    return results;
  }

  // QUIZ LOGIC

  Future<int> saveQuiz(Quiz quiz) async {

    Database db = await this.database;
    var results = db.insert(quizTable, quiz.toMap());
    return results;
  }

  Future<int> deleteQuiz(Quiz quiz) async {
    Database db = await this.database;
    var results = db.delete(quizTable, where: 'id = ?', whereArgs: [quiz.id]);
    return results;
  }

  Future<List<Quiz>> fetchQuizzes() async {
    Database db = await this.database;
    var result = await db.query(quizTable);

    if (result.isEmpty && kDebugMode) {
      var file1String = await rootBundle.loadString('assets/basic_verbs_quiz.json');
      var file2String = await rootBundle.loadString('assets/house_sentences.json');
      var quizJson = json.decode(file1String);
      var houseQuizJson = json.decode(file2String);
      saveQuiz(Quiz.fromJson(quizJson));
      saveQuiz(Quiz.fromJson(houseQuizJson));
      return fetchQuizzes();
    }

    return List.generate(result.length, (index) {
      return Quiz.fromDatabase(result[index]);
    });
  }
}
