import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class TLocal {
  Locale _locale;

  TLocal(this._locale);

  static TLocal of(BuildContext context) {
    return Localizations.of<TLocal>(context, TLocal)!;
  }

  late Map<String, String> _localizedValues;

  Future loadLanguage() async {
    String jsonTransValues = await rootBundle.loadString(
        "assets/lang/${_locale.languageCode}.json"
    );

    Map <String, dynamic> mappedValues = json.decode(jsonTransValues);

    _localizedValues = mappedValues.map((key,value) =>
        MapEntry(key, value.toString()));

  }

  String? getTranslatedValue(String key){
    return _localizedValues[key];
  }

}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    TLocal tl = TLocal(Locale("en","US"));


    return MaterialApp(
      title: 'Flutter Localize Demo',
        // localizationsDelegates: [
        //   GlobalMaterialLocalizations.delegate,
        //   GlobalWidgetsLocalizations.delegate,
        //   GlobalCupertinoLocalizations.delegate,
        // ],
        // supportedLocales: [
        //   Locale('en'), // English
        //   Locale('es'), // Spanish
        // ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Localize_Home()
    );
  }
}

class Localize_Home extends StatefulWidget {
  const Localize_Home({Key? key}) : super(key: key);

  @override
  State<Localize_Home> createState() => _Localize_HomeState();
}

class _Localize_HomeState extends State<Localize_Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TLocal.of(context)
            .getTranslatedValue("home_title")
            .toString(),),
      ),
    );
  }
}
