import 'package:flutter/material.dart';
import 'package:myTranslator/screens/TranslationListPage.dart';
import 'package:myTranslator/utilities/Constants.dart';
import 'package:myTranslator/utilities/Router.dart';
import 'package:myTranslator/utilities/TabDestination.dart';

import 'NotesListPage.dart';
import 'QuizListPage.dart';
import 'TranslatePage.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> {
  int _currentIndex;
  int _indexToPopOut = 0;

  Map<String, GlobalKey<NavigatorState>> navigatorKeys = {
    "page0": GlobalKey<NavigatorState>(),
    "page1": GlobalKey<NavigatorState>(),
    "page2": GlobalKey<NavigatorState>(),
  };

  List<TabDestination> allTabDestinations = <TabDestination>[
    TabDestination(
        position: 0,
        title: 'Home',
        icon: Icons.home,
        color: Colors.blue,
        initialRoute: translationsRoute),
    TabDestination(
        position: 1,
        title: 'Verbs',
        icon: Icons.receipt,
        color: Colors.blue,
        initialRoute: verbsRoute),
    TabDestination(
        position: 2,
        title: 'Quizzes',
        icon: Icons.school,
        color: Colors.blue,
        initialRoute: myQuizzesRoute)
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBodyWithStateKept(context),
      bottomNavigationBar: BottomNavigationBar(
        items: allTabDestinations.map((TabDestination destination) {
          return BottomNavigationBarItem(
              icon: Icon(destination.icon),
              title: Text(destination.title),
              backgroundColor: destination.color);
        }).toList(),
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _indexToPopOut = _currentIndex;
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Future<bool> _onWillPop() async {
    //Check if the current screen can pop internally
    var canScreenPop =
        await navigatorKeys["page$_currentIndex"].currentState.maybePop();
    // If it can, then do nothing and just let the current screen pop
    if (canScreenPop) {
      return Future.value(false);
      // Otherwise we check if we can back from the BottomNavigationBar
    } else {
      // If we cannot, then we leave the app
      if (_currentIndex == _indexToPopOut) {
        return Future.value(true);
      } else {
        //Otherwise, we just display the previous screen without popping anything
        setState(() {
          _currentIndex = _indexToPopOut;
        });
        return Future.value(false);
      }
    }
  }

//  Widget _buildBody(BuildContext context) {
//    return Scaffold(
//        body: SafeArea(
//            top: false,
//            child: WillPopScope(
//                onWillPop: () => _onWillPop(),
//                child: Navigator(
//                    key: navigatorKeys["page$_currentIndex"],
//                    initialRoute: "/",
//                    onGenerateRoute: (RouteSettings settings) =>
//                        MaterialPageRoute(
//                            builder: (BuildContext context) =>
//                            allTabDestinations[_currentIndex].screen)))));
//  }

  ///This can be used if needed to keep state of each screen.
  ///CAREFUL: This won't refresh each screen when tapped...
  //TODO: SHOULD USE THIS LOGIC COMBINED WITH THE PROVIDER ARCHITECTURE TO MAKE THE PAGE REFRESHED IS SOMETHING GOT ADDED TO IT
  // CAUSE RIGHT NOW THE TRANSITION BETWEEN PAGE IS A BIT LAGGY
  Widget _buildBodyWithStateKept(BuildContext context) {
    {
      return IndexedStack(
          index: _currentIndex,
          children:
              allTabDestinations.map<Widget>((TabDestination destination) {
            //Return a Navigator so we can internal navigation within the tab
            return SafeArea(
                top: false,
                child: WillPopScope(
                    onWillPop: () => _onWillPop(),
                    child: Navigator(
                        key: navigatorKeys["page${destination.position}"],
                        initialRoute: destination.initialRoute,
                        onGenerateRoute: Router.generateRoute)));
          }).toList());
    }
  }
}
