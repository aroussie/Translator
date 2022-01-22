import 'package:flutter/material.dart';
import 'package:myTranslator/models/Language.dart';

class PickLanguageArguments {
  List<Language> languages;
  bool selectOriginalLanguage;

  PickLanguageArguments(this.languages, this.selectOriginalLanguage);

}

class PickLanguagePage extends StatefulWidget {
  final List<Language> languages;
  final bool selectOriginalLanguage;

  PickLanguagePage(
      {Key key, this.languages, this.selectOriginalLanguage = true})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _PickLanguageState();
  }
}

class _PickLanguageState extends State<PickLanguagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context)),
        title: Text(widget.selectOriginalLanguage
            ? "Select Original Language"
            : "Select what to translate to"),
      ),
      body: SafeArea(
          child: ListView.builder(
              itemCount: widget.languages == null ? 0 : widget.languages.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    title: Text(widget.languages[index].name),
                    onTap: () {
                      Navigator.pop(context, widget.languages[index]);
                    });
              },
              padding: EdgeInsets.all(8))),
    );
  }
}
