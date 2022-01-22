import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:myTranslator/models/Translation.dart';
import 'package:myTranslator/utilities/Constants.dart';
import 'package:myTranslator/utilities/DatabaseHelper.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'TranslatePage.dart';

class TranslationListPage extends StatefulWidget {
  @override
  _TranslationListState createState() {
    return _TranslationListState();
  }
}

class _TranslationListState extends State<TranslationListPage> {
  GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<Translation> _translations = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Translations"),
        ),
        body: SafeArea(
            child: FutureBuilder(
                future: _fetchTranslations(),
                builder: (context, snapshot) {
                  if (snapshot.data == null ||
                      snapshot.connectionState != ConnectionState.done) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    _translations = snapshot.data;
                    if (_translations.isNotEmpty) {
                      return AnimatedList(
                          key: _listKey,
                          initialItemCount: _translations.length,
                          itemBuilder: (context, index, animation) {
                            return _buildListTile(
                                _translations[index], animation);
                          });
                    } else {
                      return Center(
                          child: Text(
                              "You don't have any saved translations",
                              textAlign: TextAlign.center,
                              textScaleFactor: 2));
                    }
                  }
                })),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => _goToTranslatePage(context)));
  }

  void _goToTranslatePage(BuildContext context) {
    Navigator.of(context).pushNamed(translateRoute);
  }

  ///Build an item with animation that will be given by the AnimatedList
  Widget _buildListTile(Translation translation, Animation animation) {
    return SizeTransition(
        sizeFactor: animation,
        child: ListTile(
            title: Text(translation.originalSentence),
            subtitle: Text(translation.translatedSentence),
            trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _deleteListItem(translation);
                })));
  }

  ///Delete an item with a nice animation
  void _deleteListItem(Translation itemToDelete) async {
    int indexToDelete = _translations.indexOf(itemToDelete);
    _translations.remove(itemToDelete);
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return _buildListTile(itemToDelete, animation);
    };

    _listKey.currentState.removeItem(indexToDelete, builder);
    var databaseHelper = DatabaseHelper();
    databaseHelper.deleteTranslation(itemToDelete);
  }

  ///Open or create a Database and fetch the exising translations
  Future<List<Translation>> _fetchTranslations() async {
    var databaseHelper = DatabaseHelper();
    return databaseHelper.fetchTranslations();
  }
}
