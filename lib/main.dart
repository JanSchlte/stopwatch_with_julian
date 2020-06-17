import 'package:flutter/material.dart';
import 'package:stopwatch_with_julian/screens/choose_screen.dart';
import 'package:provider/provider.dart';
import 'components/data.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter/services.dart';
import 'package:wakelock/wakelock.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'components/translations.dart';

/*
* Für Fr. Michels:
*
* Am besten das Projekt nach dieser Reihenfolge ansehen:
* 1. main.dart
* 2. lib\components
* 3. lib\screens
* 4. lib\widgets
* 5. pubspec.yaml
*
* Oft habe ich auf Stellen in der Flutter-Dokumentation referriert, da die Erklärungen sonst wirklich zu umfangreich werden würden.
* Ich hoffe, dass die Kommentare beim Nachvollziehen des Codes helfen können. Wenn Sie Fehler entdecken oder ich etwas unklar ausgedrückt habe,
* so würde ich mich freuen, wenn sie mich diesbezüglich kontaktieren würden.
*
* Mit freundlichen Grüßen
*
* Jan Schulte
* */

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    //Hier wird sichergestellt, dass das Smartphone bei der App nur hochkant sein kann
    Wakelock.enable();
    //Mit diesem Plugin wird sichergestellt, dass der Screen des Handys nicht "einschlafen" kann
    return Phoenix(
      //Phoenix ist ein weiteres Plugin, welches mir später ermöglichen wird, die ganze App von neu zu starten. Daher muss das Plugin auch ganz nach oben in den Widget-Tree
      child: ChangeNotifierProvider(
        //Mit dem Provider Plugin, das hier initialisiert wird, kann ich Variablen in dem Widget-Tree nach ganz oben packen, so dass ich sie von überall her erreichen kann
        create: (_) => PlayerData(),
        child: MaterialApp(
          localizationsDelegates: [
            //Dies ist der Part, wo ich die Billingualität meiner App initalisiere. Die App ist in Deutsch und Englisch verfügbar. Hauptsächlich verantwortlich dafür ist die Translations.dart class
            //Die App ist dadurch immer in der vom System des Nutzers präferierten Sprache
            const TranslationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', ''),
            const Locale('de', ''),
          ],
          theme: ThemeData(
            //Dies sind bloß einige Design-Programmierungen, welche später das Bottomsheet Styling erleichtern
            textSelectionHandleColor: Colors.black87,
            bottomSheetTheme: BottomSheetThemeData(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30.0),
                ),
              ),
            ),
          ),
          home: FirstScreen(),
          //Hier wird der erste Screen als "home" der App deklariert (lib\screens\choose_screen)
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
