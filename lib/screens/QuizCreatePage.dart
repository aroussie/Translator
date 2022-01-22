import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myTranslator/models/Quiz.dart';
import 'package:myTranslator/providers/QuizQuestionProvider.dart';
import 'package:myTranslator/utilities/Constants.dart';
import 'package:provider/provider.dart';

class QuizCreatePageBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QuizQuestionProvider>(
        builder: (_) => QuizQuestionProvider(),
        child: Consumer<QuizQuestionProvider>(
          builder: (_, QuizQuestionProvider provider, __) =>
              QuizCreatePage(model: provider),
        ));
  }
}

class QuizCreatePage extends StatefulWidget {
  final QuizQuestionProvider model;

  QuizCreatePage({Key key, @required this.model}) : super(key: key);

  @override
  _QuizCreatePageState createState() {
    return _QuizCreatePageState();
  }
}

class _QuizCreatePageState extends State<QuizCreatePage> {
  QuizQuestionProvider get provider => widget.model;
  TextEditingController _questionController;
  TextEditingController _saveQuizTitleController;

  List<GlobalKey<QuizAnswerTileState>> _answersList = [];

  @override
  void initState() {
    super.initState();
    _saveQuizTitleController = TextEditingController();
    _questionController =
        TextEditingController(text: provider.getQuizQuestion.question);
    _answersList = [GlobalKey(), GlobalKey(), GlobalKey(), GlobalKey()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Create a Quiz")),
        body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Question ${provider.currentQuestionIndex + 1}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _questionController,
                decoration: InputDecoration(
                    labelText: "Question", border: OutlineInputBorder()),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                    "Answers:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: provider.getQuizQuestion.answers
                  .asMap()
                  .map((int index, QuizAnswer answer) {
                    QuizAnswerTile tile = QuizAnswerTile(
                        key: _answersList[index], answer: answer);
                    return MapEntry(
                        index,
                        Padding(
                            padding: const EdgeInsets.all(8.0), child: tile));
                  })
                  .values
                  .toList(),
            ),
            AnimatedCrossFade(
                firstChild: _buildSaveQuestionButton(context),
                secondChild: _buildSaveQuizQuestionButtons(context),
                crossFadeState: provider.isQuestionSaved == true
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300))
          ],
        ))));
  }

  Widget _buildSaveQuestionButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: RaisedButton.icon(
            icon: Icon(Icons.save),
            label: Text("Save question"),
            color: provider.isQuestionValid == true ? Colors.green : Colors.grey,
            onPressed: provider.isQuestionValid == true
                ? () => provider.saveQuestion(_questionController.text)
                : null),
      ),
    );
  }

  Widget _buildSaveQuizQuestionButtons(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            RaisedButton.icon(
              icon: Icon(Icons.save),
              label: Text("Save Quiz"),
              color: Colors.blue,
              onPressed: () => _showSaveQuizDialog(context),
            ),
            RaisedButton.icon(
              icon: Icon(Icons.save),
              label: Text("Add a question"),
              color: Colors.amber,
              onPressed: () => _addAQuestion(),
            ),
          ],
        ));
  }

  Future<bool> _showSaveQuizDialog(BuildContext context) async {
    return await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) =>
            AlertDialog(
              title: Text("How do you want to name your quiz?"),
              content: TextField(
                controller: _saveQuizTitleController,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                    hintText: "Enter a title",
                    border: OutlineInputBorder()
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("Cancel"),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                    child: Text("Save"),
                    onPressed: () {
                      provider.saveQuiz(
                          _saveQuizTitleController.text);
                      //Push back to MyQuizzes and clear the stack
                      Navigator.of(context).pushNamedAndRemoveUntil
                        (myQuizzesRoute, (Route<dynamic> route) => false);
                    }
                )
              ],
            ));
  }

  void _addAQuestion() {
    _cleanQuestion();
    provider.goNextQuestion();
  }

  void _cleanQuestion() {
    _questionController.clear();
    _answersList.forEach((GlobalKey<QuizAnswerTileState> key) {
      key.currentState.clear();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _questionController.dispose();
    _saveQuizTitleController.dispose();
  }
}

class QuizAnswerTile extends StatefulWidget {
  final QuizAnswer answer;

  QuizAnswerTile({Key key, @required this.answer}) : super(key: key);

  @override
  QuizAnswerTileState createState() {
    return QuizAnswerTileState();
  }
}

class QuizAnswerTileState extends State<QuizAnswerTile> {
  QuizAnswer get answer => widget.answer;
  TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: answer.answer);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
            child: TextField(
          controller: _textController,
          style: TextStyle(fontSize: 18),
          decoration:
              InputDecoration(hintText: "Answer", border: OutlineInputBorder()),
          onChanged: (String text) => Provider.of<QuizQuestionProvider>(context)
              .updateAnswerText(answer, text),
        )),
        IconButton(
            icon: Icon(Icons.check),
            color: answer.isRightAnswer == true ? Colors.green : Colors.grey,
            onPressed: () {
              answer.isRightAnswer = !answer.isRightAnswer;
              if (answer.isRightAnswer) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "${_textController.text} set as correct Answer",
                    style: TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 1),
                ));
              }
              Provider.of<QuizQuestionProvider>(context).updateAnswer(answer);
            })
      ],
    );
  }

  void clear() {
    _textController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
  }
}
