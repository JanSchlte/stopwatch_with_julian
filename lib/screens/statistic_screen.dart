import 'package:flutter/material.dart';
import 'package:stopwatch_with_julian/components/data.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:stopwatch_with_julian/widgets/statistic_list.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch_with_julian/components/translations.dart';

class StatistikScreen extends StatefulWidget {
  final List<Duration> playerDurations;
  final int rounds;
  final List<int> individualPlayerDurations;
  final Duration allTime;
  StatistikScreen(this.playerDurations, this.rounds,
      this.individualPlayerDurations, this.allTime);
  //Dies sind die relevanten Variablen und Listen des Animations-Screens, welche benötigt werden, um die Statistiken erstellen zu können
  @override
  _StatistikScreenState createState() => _StatistikScreenState();
}

class _StatistikScreenState extends State<StatistikScreen> {
  String printDuration(Duration duration) {
    //Dies ist eine Formatierung, um die duration-Strings im korrekten Format wiedergeben zu können
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
      //Diese Methode sichert ab, dass nie eine Zahl alleine stehen wird, sondern bspw. 07s bei 7s
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours < 1) {
      //Hier wird sichergestellt, dass die Stunden nur angezeigt werden, wenn das Spiel auch länger als eine Stunde ging. Dies hat v. A. design-technische Gründe
      return '$twoDigitMinutes:$twoDigitSeconds';
    } else {
      return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds h';
    }
  }

  Duration calculateAverage() {
    //Hier wird der Durchschnitt aller Runden berechnet
    double average = widget.allTime.inSeconds / widget.rounds;
    Duration averageDuration = Duration(seconds: average.toInt());
    return averageDuration;
  }

  @override
  void initState() {
    super.initState();
  }

  showAlertDialog(BuildContext context) {
    //Dieser AlertDialog erscheint, wenn der Spieler auf dem Statistik-Screen auf "Neues Spiel" drückt
    // Die Button werden erstellt
    Widget cancelButton = FlatButton(
      child: Text(
        Translations.of(context).text('yes'),
        style: TextStyle(color: Colors.red.shade900, fontSize: 19.0),
      ),
      onPressed: () {
        Phoenix.rebirth(context);
        //Mit dem Phoenix-Plugin wird die gesamte App von vorne gestartet
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        Translations.of(context).text('no'),
        style: TextStyle(color: Colors.red.shade900, fontSize: 19.0),
      ),
      onPressed: () {
        //Will der Spieler doch kein neues Spiel starten, so passiert nichts und der AlertDialog verschwindet wieder
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      //Hier wird der AlertDialog an den Ecken abgerundet
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      title: Text(
        Translations.of(context).text('alert_title_2'),
        style: TextStyle(fontSize: 20),
      ),
      content: Text(
        Translations.of(context).text('alert_question_2'),
        style: TextStyle(fontSize: 20),
      ),
      actions: [
        continueButton,
        cancelButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.red.shade900,
        appBar: AppBar(
            title: Text(
              Translations.of(context).text('title'),
            ),
            backgroundColor: Colors.black87,
            automaticallyImplyLeading: false),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              Translations.of(context).text('statistics'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 55),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Text(
                  '${widget.rounds} ${Translations.of(context).text('rounds_plural')}',
                  //Hier wird die Gesamtzahl aller Runden angezeigt
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                Hero(
                  tag: 'players',
                  child: Text(
                    '${Provider.of<PlayerData>(context).playerCount} ${Translations.of(context).text('player')}',
                    //Hier wird nochmal die Anzahl aller Spieler gezeigt
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 7,
            ),
            //Diese 3-Text Widgets stellen so etwas wie die Legende des Statistik-Screens da. Für die Strings: siehe die Json Datein unter lib\locale\
            Text(
              Translations.of(context).text('rounds'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            Text(
              Translations.of(context).text('sum'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            Text(
              Translations.of(context).text('average'),
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15),
            ),
            SizedBox(
              height: 7,
            ),
            Expanded(
              //https://api.flutter.dev/flutter/widgets/Expanded-class.html
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 50),
                child: StatisticList(
                    //Hier wird das Kernstück des Screens erstellt: Die Statistiklist (siehe lib\widgets\statistic_list.dart)
                    widget.playerDurations,
                    widget.individualPlayerDurations),
              ),
            ),
            Text(
              'Σ: ${printDuration(widget.allTime)}',
              //Hier wird die Zeit angezeigt, welche das gesamte Spiel aufgezeichnet hat (also die StopwatchSum von dem AnimationsScreen)
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 7),
            Text(
              //Hier wird der Durschschnitt aller Runden angezeigt
              'Ø: ${printDuration(calculateAverage())}',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 7),
            Center(
              child: Hero(
                tag: 'button',
                child: ButtonTheme(
                  minWidth: 900,
                  child: RaisedButton(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        Translations.of(context).text('new_game'),
                        style: TextStyle(color: Colors.white, fontSize: 40.0),
                      ),
                    ),
                    color: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                    ),
                    onPressed: () {
                      //Da man somit alle Statistiken löscht, erscheint beim "Neues Spiel" Button ein AlertDialog, um sicherzugehen, dass der User sich nicht vertippt hat
                      showAlertDialog(context);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
