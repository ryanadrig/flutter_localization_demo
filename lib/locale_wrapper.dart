import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';


class TLocalWrapper extends InheritedWidget {
  final TLocal tlocal;

  TLocalWrapper({Key? key,
    required this.tlocal,
    required Widget child}) : super(key: key, child: child);

  @override
  bool updateShouldNotify(TLocalWrapper oldWidget) {
    return tlocal != oldWidget.tlocal;
  }
}

class TLocal {
  TLocal(this.locale);
  Locale locale = Locale("en");

  static TLocal of(BuildContext context) {
    // return Localizations.of<TLocal>(context, TLocal)!;
    return context.dependOnInheritedWidgetOfExactType<TLocalWrapper>()!.tlocal;
  }

  Map<String, String>? localizedValues;

  Future loadLanguage() async {
    print("load language called");
    print("load language with locale ~ " + locale.languageCode);

    String jsonTransValues = await rootBundle.loadString(
        "assets/lang/${locale.languageCode}.json"
    );

    Map <String, dynamic> mappedValues = json.decode(jsonTransValues);

    print("mapped vals ~ " + mappedValues.toString());

    localizedValues = mappedValues.map((key,value) =>
        MapEntry(key, value.toString()));

    print("local vals ~ " + localizedValues.toString());
  }

  String? getTranslatedValue(String key){
    return localizedValues![key];
  }

}


// might be needed for more complex widget trees
// class LocaleNotifier extends ChangeNotifier {
//   Locale _locale = Locale("en");
//
//   Locale get locale => _locale;
//
//   void setLocale(Locale locale) async {
//     _locale = locale;
//     notifyListeners();
//   }
// }
