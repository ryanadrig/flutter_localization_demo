import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'locale_wrapper.dart';
import 'helpers.dart';

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
      await tl.loadLanguage().then((res){
        setState(() {
          tl = tl;
        });
      });
    });
    super.initState();
  }

  Widget build(BuildContext context) {

      return
      tl.localizedValues == null?Container():
      TLocalWrapper(tlocal: tl,
      child:
          MaterialApp(
          title: 'Flutter Localize Demo',
          theme: ThemeData(
          primarySwatch: Colors.blue,
          ),
              supportedLocales: [
            Locale('en', 'US'),
            Locale('es', 'AR'),
            Locale('zh', 'CN'),
          ],
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                TLocal.delegate
              ],
          // Doesn't seem neccessary or useful
          // localeResolutionCallback: (deviceLocale, supportedLocales) {
          //   for (var locale in supportedLocales) {
          //     if (locale.languageCode == deviceLocale!.languageCode &&
          //         locale.countryCode == deviceLocale.countryCode) {
          //       return deviceLocale;
          //     }
          //   }
          //   return supportedLocales.elementAt(0);
          // },
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
            hint:Text(TLocal.of(context)
            .getTranslatedValue("select_language")!) ,
            // value: get_disp_lang_for_lang_code(TLocal.of(context)._locale.languageCode),
              items: [
            DropdownMenuItem(child: Text("English"), value: "en",),
            DropdownMenuItem(child: Text("Spanish"), value: "es",),
                DropdownMenuItem(child: Text("中国人"), value: "zh",)
          ], onChanged: (val){
            TLocal.of(context).locale = Locale(val!);
            TLocal.of(context).loadLanguage();
            setState(() {});
          }),

        const SizedBox(height: 40,),
         MainTextWidget(),
          const SizedBox(height: 40,),
          Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
         ElevatedButton(
         onPressed: () {
         showDatePicker(
         context: context,
         locale: TLocal.of(context).locale,
         initialDate: DateTime(2021, 1, 1),
         firstDate: DateTime(2021, 1, 1),
         lastDate: DateTime(2021, 1, 31),
         );
         },
         child: Text(
           TLocal.of(context)
               .getTranslatedValue("pick_date")!,
         ),
         ),
         SizedBox(
         width: 10,
         ),
         ElevatedButton(
         onPressed: () {
         showTimePicker(
         context: context,
           helpText:  TLocal.of(context)
               .getTranslatedValue("time_pick_help_text")!,
           confirmText:TLocal.of(context)
             .getTranslatedValue("time_pick_confirm_text")!,
           cancelText: TLocal.of(context)
               .getTranslatedValue("time_pick_cancel_text")!,
           hourLabelText: TLocal.of(context)
               .getTranslatedValue("time_pick_hour_label")!,
           minuteLabelText: TLocal.of(context)
               .getTranslatedValue("time_pick_minute_label")!,
           initialTime: TimeOfDay.now(),
         );
         },
         child: Text(
           TLocal.of(context)
               .getTranslatedValue("pick_time")!,
         ),
         ),
         ],
         )
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


