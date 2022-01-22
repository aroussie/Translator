import 'package:flutter/material.dart';

//SEE https://medium.com/flutter/getting-to-the-bottom-of-navigation-in-flutter-b3e440b9386
class TabDestination {
  const TabDestination({this.position, this.title, this.icon, this.color, this.initialRoute});
  final int position;
  final String title;
  final IconData icon;
  final Color color;
  final String initialRoute;
}
