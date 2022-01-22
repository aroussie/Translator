import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:myTranslator/models/Verb.dart';
import 'package:myTranslator/utilities/Constants.dart';
import 'package:myTranslator/utilities/DatabaseHelper.dart';

import 'VerbPage.dart';

class NotesListPage extends StatefulWidget {
  @override
  _NotesListState createState() {
    return _NotesListState();
  }
}

class _NotesListState extends State<NotesListPage> {
  var _verbTitleTextStyle =
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  var _verbTextStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.normal);
  List<Verb> _verbs = [];

  var _verbPageKey = GlobalKey();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("My Verbs")),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
            future: _fetchVerbs(),
            builder: (context, snapshot) {
              _verbs = snapshot.data;
              return _verbs == null
                  ? Center(child: CircularProgressIndicator())
                  : _verbs.isNotEmpty
                      ? StaggeredGridView.countBuilder(
                          mainAxisSpacing: 24.0,
                          crossAxisCount: 1,
                          itemCount: _verbs.length,
                          itemBuilder: (BuildContext context, int index) {
                            var verb = _verbs[index];
                            return new Column(
                              children: <Widget>[
                                _buildIconsRow(context, verb),
                                Table(
                                  border: TableBorder.all(
                                      color: Colors.black, width: 1.0),
                                  children: [
                                    _buildTableRowTitle(verb.original_title,
                                        verb.translated_title),
                                    _buildTableRow(verb.original_firstPerson,
                                        verb.translated_firstPerson),
                                    _buildTableRow(verb.original_secondPerson,
                                        verb.translated_secondPerson),
                                    _buildTableRow(verb.original_thirdPerson,
                                        verb.translated_thirdPerson),
                                    _buildTableRow(verb.original_fourthPerson,
                                        verb.translated_fourthPerson),
                                    _buildTableRow(verb.original_fifthPerson,
                                        verb.translated_fifthPerson),
                                    _buildTableRow(verb.original_sixthPerson,
                                        verb.translated_sixthPerson)
                                  ],
                                )
                              ],
                            );
                          },
                          staggeredTileBuilder: (int index) {
                            return StaggeredTile.fit(2);
                          },
                        )
                      : Center(
                          child: Text(
                              "You don't have any saved verbs."
                              "You can add some by clicking on the + at the bottom of the screen!",
                              textAlign: TextAlign.center,
                              textScaleFactor: 2));
            }),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onAddButtonClicked(context),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildIconsRow(BuildContext context, Verb verb) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        height: 40,
        width: 100,
        decoration: BoxDecoration(
            border: BorderDirectional(
                top: BorderSide(color: Colors.black, width: 1),
                start: BorderSide(color: Colors.black, width: 1),
                end: BorderSide(color: Colors.black, width: 1))),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _showDialog(context, verb)),
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _onEditIconClicked(context, verb))
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String firstCellString, String secondCellString) {
    return TableRow(children: [
      TableCell(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(firstCellString, style: _verbTextStyle),
      )),
      TableCell(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(secondCellString, style: _verbTextStyle),
      ))
    ]);
  }

  TableRow _buildTableRowTitle(String originalTitle, String translatedTitle) {
    return TableRow(children: [
      TableCell(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Text(originalTitle, style: _verbTitleTextStyle)),
      )),
      TableCell(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: Text(translatedTitle, style: _verbTitleTextStyle)),
      ))
    ]);
  }

  void _onAddButtonClicked(BuildContext context) {
    Navigator.pushNamed(context, addVerbRoute, arguments: VerbPageArguments(_verbPageKey));
  }

  void _onDeleteClicked(BuildContext context, Verb verb) async {
    final databaseHelper = DatabaseHelper();
    var result = await databaseHelper.deleteVerb(verb);

    if (result != 0) {
      final snackBar = SnackBar(
          content: Text("Verb deleted", style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
      duration: Duration(seconds: 2));
      Scaffold.of(context).showSnackBar(snackBar);
      //TODO: Look to use Provider to do that instead of refreshing the entire screen?
      setState(() {});
    } else {
      final snackBar = SnackBar(
          content: Text("Something wrong happened",
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red);
      Scaffold.of(context).showSnackBar(snackBar);
    }
  }

  void _onEditIconClicked(BuildContext context, Verb verb) {
    Navigator.pushNamed(context, addVerbRoute,
        arguments: VerbPageArguments(_verbPageKey, verb));
  }

  void _showDialog(BuildContext mainContext, Verb verb) {
    showDialog(
        context: mainContext,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Delete Verb"),
            content: Text(
                "Are you sure you want to delete the verb ${verb.original_title}?"),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                textColor: Colors.red,
              ),
              FlatButton(
                child: Text("Delete"),
                onPressed: () {
                  Navigator.of(context).pop();
                  _onDeleteClicked(mainContext, verb);
                },
                textColor: Theme.of(mainContext).primaryColor,
              )
            ],
          );
        });
  }

  ///Fetch verbs from the database
  Future<List<Verb>> _fetchVerbs() {
    var databaseHelper = DatabaseHelper();
    return databaseHelper.fetchVerbs();
  }
}
