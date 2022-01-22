import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:myTranslator/customWidget/PlatformWidget.dart';

class PlatformDialog extends PlatformWidget {
  final Widget titleWidget;
  final Widget content;
  final Function defaultAction;
  final Function negativeAction;
  final String defaultActionText;
  final String negativeActionText;

  PlatformDialog(
      {@required this.titleWidget,
      @required this.content,
      @required this.defaultAction,
      @required this.defaultActionText,
      this.negativeAction,
      this.negativeActionText});

  Future<bool> show(BuildContext context) async {
    return Platform.isIOS ?
    await showCupertinoDialog(
        context: context, builder: (BuildContext context) => this) :
    await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) => this);
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: titleWidget,
      content: content,
      actions: _buildActions(),
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: titleWidget,
      content: content,
      actions: _buildActions(),
    );
  }

  List<Widget> _buildActions() {
    List<Widget> actions = [];

    if (this.negativeAction != null) {
      actions.add(PlatformDialogAction(
          actionWidget: Text(this.negativeActionText),
          actionMethod: this.negativeAction));
    }

    actions.add(PlatformDialogAction(
        actionWidget: Text(this.defaultActionText),
        actionMethod: this.defaultAction));
    
    return actions;
  }
}

class PlatformDialogAction extends PlatformWidget {
  final Widget actionWidget;
  final Function actionMethod;

  PlatformDialogAction({this.actionWidget, this.actionMethod});

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoDialogAction(child: actionWidget, onPressed: actionMethod);
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return FlatButton(child: actionWidget, onPressed: actionMethod);
  }
}
