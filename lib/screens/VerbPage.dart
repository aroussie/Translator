import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myTranslator/models/Verb.dart';
import 'package:myTranslator/utilities/DatabaseHelper.dart';

class VerbPageArguments {
  Key key;
  final Verb originalVerb;

  VerbPageArguments(this.key, [this.originalVerb]);
}

class VerbPage extends StatefulWidget {
  final Verb originalVerb;

  VerbPage(Key key, [this.originalVerb]) : super(key: key);

  @override
  _VerbState createState() {
    return _VerbState();
  }
}

class _VerbState extends State<VerbPage> {
  var _verbTitleTextStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  var _verbTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.normal);

  var _originalTitleController = TextEditingController();
  var _originalFirstPersonController = TextEditingController();
  var _originalSecondPersonController = TextEditingController();
  var _originalThirdPersonController = TextEditingController();
  var _originalFourthPersonController = TextEditingController();
  var _originalFifthPersonController = TextEditingController();
  var _originalSixthPersonController = TextEditingController();

  var _translatedTitleController = TextEditingController();
  var _translatedFirstPersonController = TextEditingController();
  var _translatedSecondPersonController = TextEditingController();
  var _translatedThirdPersonController = TextEditingController();
  var _translatedFourthPersonController = TextEditingController();
  var _translatedFifthPersonController = TextEditingController();
  var _translatedSixthPersonController = TextEditingController();

  FocusNode _originalTitleFocus;
  FocusNode _originalFirstPersonFocus;
  FocusNode _originalSecondPersonFocus;
  FocusNode _originalThirdPersonFocus;
  FocusNode _originalFourthPersonFocus;
  FocusNode _originalFifthPersonFocus;
  FocusNode _originalSixthPersonFocus;

  FocusNode _translatedTitleFocus;
  FocusNode _translatedFirstPersonFocus;
  FocusNode _translatedSecondPersonFocus;
  FocusNode _translatedThirdPersonFocus;
  FocusNode _translatedFourthPersonFocus;
  FocusNode _translatedFifthPersonFocus;
  FocusNode _translatedSixthPersonFocus;

  var _listOriginalControllers = <TextEditingController>[];
  var _listTranslatedControllers = <TextEditingController>[];
  var _listOriginalNodes = <FocusNode>[];
  var _listTranslatedNodes = <FocusNode>[];
  var _listHints = [
    "1st person",
    "2nd person",
    "3rd person",
    "4th person",
    "5th person",
    "6th person",
  ];

  @override
  void initState() {
    super.initState();
    _originalTitleFocus = FocusNode();
    _originalFirstPersonFocus = FocusNode();
    _originalSecondPersonFocus = FocusNode();
    _originalThirdPersonFocus = FocusNode();
    _originalFourthPersonFocus = FocusNode();
    _originalFifthPersonFocus = FocusNode();
    _originalSixthPersonFocus = FocusNode();

    _translatedTitleFocus = FocusNode();
    _translatedFirstPersonFocus = FocusNode();
    _translatedSecondPersonFocus = FocusNode();
    _translatedThirdPersonFocus = FocusNode();
    _translatedFourthPersonFocus = FocusNode();
    _translatedFifthPersonFocus = FocusNode();
    _translatedSixthPersonFocus = FocusNode();

    if (widget.originalVerb != null) {
      _setOriginalVerb(widget.originalVerb);
    }

    _listOriginalControllers = [
      _originalFirstPersonController,
      _originalSecondPersonController,
      _originalThirdPersonController,
      _originalFourthPersonController,
      _originalFifthPersonController,
      _originalSixthPersonController
    ];

    _listTranslatedControllers = [
      _translatedFirstPersonController,
      _translatedSecondPersonController,
      _translatedThirdPersonController,
      _translatedFourthPersonController,
      _translatedFifthPersonController,
      _translatedSixthPersonController
    ];

    _listOriginalNodes = [
      _originalFirstPersonFocus,
      _originalSecondPersonFocus,
      _originalThirdPersonFocus,
      _originalFourthPersonFocus,
      _originalFifthPersonFocus,
      _originalSixthPersonFocus
    ];

    _listTranslatedNodes = [
      _translatedFirstPersonFocus,
      _translatedSecondPersonFocus,
      _translatedThirdPersonFocus,
      _translatedFourthPersonFocus,
      _translatedFifthPersonFocus,
      _translatedSixthPersonFocus
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title:
                Text(widget.originalVerb == null ? "Add Verb" : "Edit Verb")),
        body: SafeArea(
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: <Widget>[
              Table(
                  border: TableBorder.all(width: 1, color: Colors.black),
                  children: [
                    _buildTableRowTitle(context),
                    _buildTableRow(context, 0),
                    _buildTableRow(context, 1),
                    _buildTableRow(context, 2),
                    _buildTableRow(context, 3),
                    _buildTableRow(context, 4),
                    _buildTableRow(context, 5),
                  ]),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, right: 12.0),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: RaisedButton.icon(
                      icon: Icon(Icons.save),
                      label:
                          Text(widget.originalVerb == null ? "SAVE" : "UPDATE"),
                      textColor: Colors.white,
                      color: Colors.green,
                      onPressed: _validateData()
                          ? () => _onSavedClicked(context)
                          : null,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                    )),
              ),
            ]),
          )),
        ));
  }


  /// Build the a normal row for the table
  TableRow _buildTableRow(BuildContext context, int position) {
    return TableRow(children: [
      TableCell(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: _listOriginalControllers[position],
              focusNode: _listOriginalNodes[position],
              style: _verbTextStyle,
              maxLength: 20,
              maxLines: null,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                hintText: _listHints[position],
              ),
              onSubmitted: (text) {
                _validateData();
                _defineFocus(context, _listTranslatedNodes[position]);
              },
            )),
      ),
      TableCell(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: _listTranslatedControllers[position],
              focusNode: _listTranslatedNodes[position],
              style: _verbTextStyle,
              maxLength: 20,
              maxLines: null,
              textInputAction:
                  position == 5 ? TextInputAction.done : TextInputAction.next,
              decoration: InputDecoration(
                hintText: _listHints[position],
              ),
              onSubmitted: (text) {
                _validateData();
                if (position != 5) {
                  _defineFocus(context, _listOriginalNodes[position + 1]);
                }
              },
            )),
      ),
    ]);
  }

  /// Build the row for the Verb Title
  TableRow _buildTableRowTitle(BuildContext context) {
    return TableRow(children: [
      TableCell(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              focusNode: _originalTitleFocus,
              controller: _originalTitleController,
              style: _verbTitleTextStyle,
              maxLength: 20,
              maxLines: null,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.next,
              onSubmitted: (text) {
                _validateData();
                _defineFocus(context, _translatedTitleFocus);
              },
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: "infinitive",
              ),
            )),
      ),
      TableCell(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              focusNode: _translatedTitleFocus,
              controller: _translatedTitleController,
              style: _verbTitleTextStyle,
              maxLength: 20,
              maxLines: null,
              textCapitalization: TextCapitalization.characters,
              textInputAction: TextInputAction.next,
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                _validateData();
                _defineFocus(context, _originalFirstPersonFocus);
              },
              decoration: InputDecoration(
                hintText: "infinitive",
              ),
            )),
      ),
    ]);
  }

  /// Save or Edit the verb within the Database
  void _onSavedClicked(BuildContext context) async {
    var verb = Verb(
      id: widget.originalVerb != null ? widget.originalVerb.id : null,
      original_title: _originalTitleController.text,
      original_firstPerson: _originalFirstPersonController.text,
      original_secondPerson: _originalSecondPersonController.text,
      original_thirdPerson: _originalThirdPersonController.text,
      original_fourthPerson: _originalFourthPersonController.text,
      original_fifthPerson: _originalFifthPersonController.text,
      original_sixthPerson: _originalSixthPersonController.text,
      translated_title: _translatedTitleController.text,
      translated_firstPerson: _translatedFirstPersonController.text,
      translated_secondPerson: _translatedSecondPersonController.text,
      translated_thirdPerson: _translatedThirdPersonController.text,
      translated_fourthPerson: _translatedFourthPersonController.text,
      translated_fifthPerson: _translatedFifthPersonController.text,
      translated_sixthPerson: _translatedSixthPersonController.text,
    );

    var databaseHelper = DatabaseHelper();
    int result = widget.originalVerb == null
        ? await databaseHelper.saveVerb(verb)
        : await databaseHelper.editVerb(verb);

    // Display a Snackbar to inform user of success or failure
    if (result != 0) {
      final snackBar = SnackBar(
          content: Text(
              widget.originalVerb == null
                  ? "Verb successfully saved"
                  : "Verb updated",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green);
      Scaffold.of(context).showSnackBar(snackBar);
    } else {
      final snackBar = SnackBar(
          content: Text("Something wrong happened",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red);
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  /// Set the table with the data from an existing Verb
  void _setOriginalVerb(Verb verb) {
    _originalTitleController.text = verb.original_title;
    _originalFirstPersonController.text = verb.original_firstPerson;
    _originalSecondPersonController.text = verb.original_secondPerson;
    _originalThirdPersonController.text = verb.original_thirdPerson;
    _originalFourthPersonController.text = verb.original_fourthPerson;
    _originalFifthPersonController.text = verb.original_fifthPerson;
    _originalSixthPersonController.text = verb.original_sixthPerson;

    _translatedTitleController.text = verb.translated_title;
    _translatedFirstPersonController.text = verb.translated_firstPerson;
    _translatedSecondPersonController.text = verb.translated_secondPerson;
    _translatedThirdPersonController.text = verb.translated_thirdPerson;
    _translatedFourthPersonController.text = verb.translated_fourthPerson;
    _translatedFifthPersonController.text = verb.translated_fifthPerson;
    _translatedSixthPersonController.text = verb.translated_sixthPerson;
  }

  void _defineFocus(BuildContext context, FocusNode focusToGoTo) {
    FocusScope.of(context).requestFocus(focusToGoTo);
  }

  bool _validateData() {
    if (_originalTitleController.text.isEmpty) {
      return false;
    }
    if (_translatedTitleController.text.isEmpty) {
      return false;
    }

    for (TextEditingController controller in _listOriginalControllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }

    for (TextEditingController controller in _listTranslatedControllers) {
      if (controller.text.isEmpty) {
        return false;
      }
    }

    return true;
  }

  @override
  void dispose() {
    super.dispose();

    for (FocusNode node in _listTranslatedNodes) {
      node.dispose();
    }

    for (FocusNode node in _listOriginalNodes) {
      node.dispose();
    }

    for (TextEditingController controller in _listOriginalControllers) {
      controller.dispose();
    }

    for (TextEditingController controller in _listTranslatedControllers) {
      controller.dispose();
    }
  }
}
