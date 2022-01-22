class Verb{

  int id;
  String original_title;
  String original_firstPerson;
  String original_secondPerson;
  String original_thirdPerson;
  String original_fourthPerson;
  String original_fifthPerson;
  String original_sixthPerson;

  String translated_title;
  String translated_firstPerson;
  String translated_secondPerson;
  String translated_thirdPerson;
  String translated_fourthPerson;
  String translated_fifthPerson;
  String translated_sixthPerson;

  Verb({this.id, this.original_title, this.original_firstPerson, this.original_secondPerson, this.original_thirdPerson,
      this.original_fourthPerson, this.original_fifthPerson, this.original_sixthPerson,
    this.translated_title, this.translated_firstPerson, this.translated_secondPerson, this.translated_thirdPerson,
    this.translated_fourthPerson, this.translated_fifthPerson, this.translated_sixthPerson});

  Verb.BE(){
    original_title = "BE";
    original_firstPerson = "I am";
    original_secondPerson = "You are";
    original_thirdPerson = "He/She is";
    original_fourthPerson = "We are";
    original_fifthPerson = "You are";
    original_sixthPerson = "They are";

    translated_title = "ÊTRE";
    translated_firstPerson = "Je suis";
    translated_secondPerson = "Tu es";
    translated_thirdPerson = "Il/Elle/On est";
    translated_fourthPerson = "Nous sommes";
    translated_fifthPerson = "Vous êtes";
    translated_sixthPerson = "Ils/Elles sont";
  }

  Verb.HAVE() {
    original_title = "HAVE";
    original_firstPerson = "I have";
    original_secondPerson = "You have";
    original_thirdPerson = "He/She has";
    original_fourthPerson = "We have";
    original_fifthPerson = "You have";
    original_sixthPerson = "They have";

    translated_title = "AVOIR";
    translated_firstPerson = "J'ai";
    translated_secondPerson = "Tu as";
    translated_thirdPerson = "Il/Elle/On a";
    translated_fourthPerson = "Nous avons";
    translated_fifthPerson = "Vous avez";
    translated_sixthPerson = "Ils/Elles ont";
  }

  Verb.CAN() {
    original_title = "CAN";
    original_firstPerson = "I can";
    original_secondPerson = "You can";
    original_thirdPerson = "He/She can";
    original_fourthPerson = "We can";
    original_fifthPerson = "You can";
    original_sixthPerson = "They can";

    translated_title = "POUVOIR";
    translated_firstPerson = "Je peux";
    translated_secondPerson = "Tu peux";
    translated_thirdPerson = "Il/Elle/On peut";
    translated_fourthPerson = "Nous pouvons";
    translated_fifthPerson = "Vous pouvez";
    translated_sixthPerson = "Ils/Elles peuvent";
  }

  Verb.WANT() {
    original_title = "WANT";
    original_firstPerson = "I want";
    original_secondPerson = "You want";
    original_thirdPerson = "He/She wants";
    original_fourthPerson = "We want";
    original_fifthPerson = "You want";
    original_sixthPerson = "They want";

    translated_title = "VOULOIR";
    translated_firstPerson = "Je veux";
    translated_secondPerson = "Tu veux";
    translated_thirdPerson = "Il/Elle/On veut";
    translated_fourthPerson = "Nous voulons";
    translated_fifthPerson = "Vous voulez";
    translated_sixthPerson = "Ils/Elles veulent";
  }

  Verb.TAKE() {
    original_title = "TAKE";
    original_firstPerson = "I take";
    original_secondPerson = "You take";
    original_thirdPerson = "He/She takes";
    original_fourthPerson = "We take";
    original_fifthPerson = "You take";
    original_sixthPerson = "They take";

    translated_title = "PRENDRE";
    translated_firstPerson = "Je prends";
    translated_secondPerson = "Tu prends";
    translated_thirdPerson = "Il/Elle/On prend";
    translated_fourthPerson = "Nous prenons";
    translated_fifthPerson = "Vous prenez";
    translated_sixthPerson = "Ils/Elles prennent";
  }

  Verb.GO() {
    original_title = "GO";
    original_firstPerson = "I go";
    original_secondPerson = "You go";
    original_thirdPerson = "He/She goes";
    original_fourthPerson = "We go";
    original_fifthPerson = "You go";
    original_sixthPerson = "They go";

    translated_title = "ALLER";
    translated_firstPerson = "Je vais";
    translated_secondPerson = "Tu vas";
    translated_thirdPerson = "Il/Elle/On va";
    translated_fourthPerson = "Nous allons";
    translated_fifthPerson = "Vous allez";
    translated_sixthPerson = "Ils/Elles vont";
  }

  Verb.fromDatabase({Map<String, dynamic> json}) {
    this.id = json['id'];
    this.original_title = json['originalTitle'];
    this.original_firstPerson = json['originalFirstPerson'];
    this.original_secondPerson = json['originalSecondPerson'];
    this.original_thirdPerson = json['originalThirdPerson'];
    this.original_fourthPerson = json['originalFourthPerson'];
    this.original_fifthPerson = json['originalFifthPerson'];
    this.original_sixthPerson = json['originalSixthPerson'];

    this.translated_title = json['translatedTitle'];
    this.translated_firstPerson = json['translatedFirstPerson'];
    this.translated_secondPerson = json['translatedSecondPerson'];
    this.translated_thirdPerson = json['translatedThirdPerson'];
    this.translated_fourthPerson = json['translatedFourthPerson'];
    this.translated_fifthPerson = json['translatedFifthPerson'];
    this.translated_sixthPerson = json['translatedSixthPerson'];

  }

  Map<String, dynamic> toMap(){

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = id;
    }

    map['originalTitle'] = original_title;
    map['originalFirstPerson'] = original_firstPerson;
    map['originalSecondPerson'] = original_secondPerson;
    map['originalThirdPerson'] = original_thirdPerson;
    map['originalFourthPerson'] = original_fourthPerson;
    map['originalFifthPerson'] = original_fifthPerson;
    map['originalSixthPerson'] = original_sixthPerson;
    map['translatedTitle'] = translated_title;
    map['translatedFirstPerson'] = translated_firstPerson;
    map['translatedSecondPerson'] = translated_secondPerson;
    map['translatedThirdPerson'] = translated_thirdPerson;
    map['translatedFourthPerson'] = translated_fourthPerson;
    map['translatedFifthPerson'] = translated_fifthPerson;
    map['translatedSixthPerson'] = translated_sixthPerson;

    return map;
  }

}