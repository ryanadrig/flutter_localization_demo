import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class LocaleNotifier extends ChangeNotifier {
  Locale _locale = Locale("en");

  Locale get locale => _locale;

  void setLocale(Locale locale) async {
    _locale = locale;
    notifyListeners();
  }
}



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
  TLocal(this._locale);
  Locale _locale = Locale("en");

  static TLocal of(BuildContext context) {
    // return Localizations.of<TLocal>(context, TLocal)!;
    return context.dependOnInheritedWidgetOfExactType<TLocalWrapper>()!.tlocal;
  }

  Map<String, String>? _localizedValues;

  Future loadLanguage() async {
    print("load language called");
    print("load language with locale ~ " + _locale.languageCode);

    String jsonTransValues = await rootBundle.loadString(
        "assets/lang/${_locale.languageCode}.json"
    );

    Map <String, dynamic> mappedValues = json.decode(jsonTransValues);

    print("mapped vals ~ " + mappedValues.toString());

    _localizedValues = mappedValues.map((key,value) =>
        MapEntry(key, value.toString()));

  print("local vals ~ " + _localizedValues.toString());
  }

  String? getTranslatedValue(String key){
    return _localizedValues![key];
  }

}

void main() {
  runApp(const LocalizeApp());
}

class LocalizeApp extends StatefulWidget {
  const LocalizeApp({Key? key}) : super(key: key);

  @override
  State<LocalizeApp> createState() => _LocalizeAppState();
}

class _LocalizeAppState extends State<LocalizeApp> {

  TLocal tl = TLocal(Locale("en"));

  @override
  void initState() {
    Future.delayed(Duration.zero,()async{
       tl = TLocal(Locale("en", "US"));
      await tl!.loadLanguage().then((res){
        setState(() {
          tl = tl;
        });
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {

      return
      tl!._localizedValues == null?Container():
      TLocalWrapper(tlocal: tl!,
      child:
          MaterialApp(
          title: 'Flutter Localize Demo',
          theme: ThemeData(
          primarySwatch: Colors.blue,
          ),
          home: Localize_Home()
          ));

        }
}

class Localize_Home extends StatefulWidget {
  Localize_Home({Key? key,
  }) : super(key: key);


  @override
  State<Localize_Home> createState() => _Localize_HomeState();
}

class _Localize_HomeState extends State<Localize_Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(TLocal.of(context)
            .getTranslatedValue("home_title")!),
      ),
      body: SizedBox.expand(
        child:Column(children: [
          DropdownButton(
            // value: get_disp_lang_for_lang_code(TLocal.of(context)._locale.languageCode),
              items: [
            DropdownMenuItem(child: Text("English"), value: "en",),
            DropdownMenuItem(child: Text("Spanish"), value: "es",),
                DropdownMenuItem(child: Text("Chinese"), value: "zh",)
          ], onChanged: (val){
            TLocal.of(context)._locale = Locale(val!);
            TLocal.of(context).loadLanguage();
            setState(() {});
          }),

         MainTextWidget()
        ],)
      )
    );
  }
}

class MainTextWidget extends StatelessWidget {
  const MainTextWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Container(
        child:Text(TLocal.of(context)
            .getTranslatedValue("home_main_text")!)
    );
  }
}


String get_disp_lang_for_lang_code(lc){
  if (lc == "en"){
    return "English";
  }
  if (lc == "es"){
    return "Spanish";
  }
  if (lc == "zh"){
    return "Chinese";
  }
  return "Not Selected";
}