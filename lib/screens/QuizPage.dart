import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:myTranslator/models/Quiz.dart';
import 'package:myTranslator/providers/QuizProvider.dart';
import 'package:provider/provider.dart';

class QuizPageBuilder extends StatelessWidget {
  final Quiz quiz;

  QuizPageBuilder({Key key, @required this.quiz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QuizProvider>(
        builder: (_) => QuizProvider(quiz: quiz),
        child: Consumer<QuizProvider>(
          builder: (_, QuizProvider provider, __) => QuizPage(model: provider),
        ));
  }
}

class QuizPage extends StatefulWidget {
  final QuizProvider model;

  QuizPage({Key key, @required this.model}) : super(key: key);

  @override
  _QuizPageState createState() {
    return _QuizPageState();
  }
}

class _QuizPageState extends State<QuizPage> {
  Quiz _quiz;

  QuizProvider get provider => widget.model;

  final _cardStackKey = GlobalKey<QuizCardStackState>();
  List<QuizCard> _questionCards;

  @override
  void initState() {
    super.initState();
    _quiz = provider.quiz;
    _questionCards = List.generate(provider.quiz.questions.length, (int index) {
      return QuizCard(question: provider.quiz.questions[index], index: index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Quiz: ${_quiz.title}")),
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Expanded(
              flex: 3,
              child: provider.isQuizOver != true
                  ? QuizCardStack(_cardStackKey, _questionCards)
                  : _buildLastScreen()),
          Expanded(
            child: Center(
                child: AnimatedCrossFade(
                    firstChild: _buildNextButton(context),
                    secondChild: _buildDoneButton(context),
                    crossFadeState: provider.isQuizOver
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    duration: Duration(milliseconds: 300))),
            flex: 1,
          )
        ],
      )),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return RaisedButton(
      child: Text("Next"),
      onPressed:
          provider.hasAnswered == true ? () => _onNextClicked(context) : null,
      color: Colors.green,
      textColor: Colors.white,
    );
  }

  Widget _buildDoneButton(BuildContext context) {
    return RaisedButton(
      child: Text("Back to my Quizzes"),
      onPressed: () => Navigator.of(context).pop(),
      color: Theme.of(context).primaryColor,
      textColor: Colors.white,
    );
  }

  void _onNextClicked(BuildContext context) {
    //Go to next question
    _cardStackKey.currentState.animateToNextCard(context);
  }

  Widget _buildLastScreen() {
    return Center(
        child: Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Quiz Done!",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 46),
        ),
        Text(
          "Your score:",
          style: TextStyle(fontSize: 36),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Text(
              "${provider.rightAnswersCount}",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 32),
            ),
            Text(" / ${provider.totalQuestions}",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 32))
          ],
        )
      ],
    ));
  }
}

class QuizCardStack extends StatefulWidget {
  final List<QuizCard> cards;
  final Function animationDoneCallback;

  QuizCardStack(Key key, this.cards, [this.animationDoneCallback])
      : super(key: key);

  @override
  QuizCardStackState createState() {
    return QuizCardStackState();
  }
}

//TODO: LOOK AT https://medium.com/flutterpub/flutter-animation-basics-explained-with-stacked-cards-9d34108403b8 for animation
class QuizCardStackState extends State<QuizCardStack>
    with SingleTickerProviderStateMixin {
  List<QuizCard> _quizCards;

  AnimationController _controller;
  CurvedAnimation _curvedAnimation;
  Animation<Offset> _translateAnimation;
  int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    _quizCards = widget.cards;
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _curvedAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _translateAnimation = Tween(begin: Offset(0, 0), end: Offset(-1000, 0))
        .animate(_curvedAnimation)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: _buildQuizCardsToDisplay(_quizCards));
  }

  List<Widget> _buildQuizCardsToDisplay(List<QuizCard> cards) {
    var reversedList = cards.reversed.toList();
    return reversedList.map<Widget>((QuizCard card) {
      return Center(
          child: Padding(
              padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
              child: Transform.translate(
                  offset: _getTranslateTransformationOffset(card),
                  child: card)));
    }).toList();
  }

  /// Translate the card to the left out of the screen
  Offset _getTranslateTransformationOffset(QuizCard card) {
    if (card.index == currentIndex) {
      return _translateAnimation.value;
    }

    return Offset(0, 0);
  }

  void animateToNextCard(BuildContext context) {
    Provider.of<QuizProvider>(context).updateHasAnswered(false);
    _controller.forward().whenComplete(() {
      setState(() {
        _controller.reset();
        QuizCard removedCard = _quizCards[0];
        _quizCards.remove(removedCard);
        if (_quizCards.isNotEmpty) {
          currentIndex = _quizCards[0].index;
        } else {
          Provider.of<QuizProvider>(context).updateQuizOver(true);
        }
        if (widget.animationDoneCallback != null) {
          widget.animationDoneCallback(_quizCards.isEmpty);
        }
      });
    });
  }
}

class QuizCard extends StatefulWidget {
  final QuizQuestion question;
  final int index;

  QuizCard({@required this.question, this.index});

  @override
  QuizCardState createState() {
    return QuizCardState();
  }
}

class QuizCardState extends State<QuizCard> {
  QuizQuestion _question;
  int _positionButtonClicked;

  @override
  void initState() {
    super.initState();
    _question = widget.question;
    _positionButtonClicked = -1;
  }

  @override
  Widget build(BuildContext context) {
    var hasAnswered = Provider.of<QuizProvider>(context).hasAnswered;

    return SafeArea(
        child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: <Widget>[
                Expanded(
                  child: Center(
                    child: Text(
                      _question.question,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  flex: 1,
                ),
                Expanded(
                  child: StaggeredGridView.countBuilder(
                    itemCount: _question.answers.length,
                    crossAxisCount: 2,
                    itemBuilder: (BuildContext context, int index) {
                      return AnimatedOpacity(
                          duration: Duration(milliseconds: 500),
                          opacity: hasAnswered == true
                              //it's the question is answered, then only keep the right answer
                              //And where the user clicked
                              ? _question.answers[index].isRightAnswer == true
                                  ? 1
                                  : index == _positionButtonClicked ? 1 : 0
                              : 1,
                          child: RaisedButton(
                              child: Text(_question.answers[index].answer),
                              onPressed: () => _onAnswerClicked(context, index),
                              color: hasAnswered
                                  ? _question.answers[index].isRightAnswer ==
                                          true
                                      ? Colors.green
                                      : index == _positionButtonClicked
                                          ? Colors.red
                                          : Colors.grey
                                  : Colors.grey));
                    },
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    staggeredTileBuilder: (int index) {
                      return StaggeredTile.count(1, 0.5);
                    },
                  ),
                  flex: 3,
                ),
                Expanded(
                  child: AnimatedOpacity(
                      opacity: hasAnswered == true ? 1 : 0,
                      duration: Duration(milliseconds: 500),
                      child: Center(
                        child: Text(
                          _positionButtonClicked > -1 &&
                                  _question.answers[_positionButtonClicked]
                                          .isRightAnswer ==
                                      true
                              ? "Correct!!!"
                              : "Wrong answer",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      )),
                  flex: 1,
                )
              ]),
            )));
  }

  void _onAnswerClicked(BuildContext context, int position) {
    Provider.of<QuizProvider>(context).updateHasAnswered(true);
    if (_question.answers[position].isRightAnswer){
      Provider.of<QuizProvider>(context).increaseRightAnswerCount();
    }
    setState(() {
      _positionButtonClicked = position;
    });
  }
}
