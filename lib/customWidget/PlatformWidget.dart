import 'dart:io';

import 'package:flutter/widgets.dart';

abstract class PlatformWidget extends StatelessWidget {

  Widget buildMaterialWidget(BuildContext context);
  Widget buildCupertinoWidget(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS){
      return buildCupertinoWidget(context);
    } else {
      return buildMaterialWidget(context);
    }
  }
}