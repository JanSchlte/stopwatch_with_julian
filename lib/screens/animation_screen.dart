import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch_with_julian/components/data.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:stopwatch_with_julian/screens/statistic_screen.dart';
import 'package:stopwatch_with_julian/components/translations.dart';

class SecondScreen extends StatefulWidget {
  final int duration;
  SecondScreen(this.duration);
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  int playerNumber = 0;

  int playRounds = 1;
  List<int> individualPlayRounds = [];

  Animation<double> animation;

  Stopwatch stopwatch = Stopwatch()..start();
  //Diese Stopuhr misst die individuellen Spielerzeiten
  Stopwatch stopwatchSum = Stopwatch()..start();
  //Diese Stopuhr misst die gesamte Spielzeit
  //Beide Stopuhren soll natürlich direkt starten
  List<Duration> playerDurations = [];

  bool isStopped = false;

  @override
  void initState() {
    //InitState ist immer die Methode, welche direkt als erstes ausgeführt wird
    for (int i = 0;
        i < Provider.of<PlayerData>(context, listen: false).playerCount;
        i++) {
      playerDurations.add(Duration(seconds: 0));
      individualPlayRounds.add(0);
      //Hier werden die relevanten Listen auf die benötigte Länge gebracht (die Anzahl der Spieler)
    }
    super.initState();
    createController();
    //Außerdem muss direkt am Start der Controler erstellt werden. Daher ist dies in der InitState Methode enthalten
  }

  void createController() {
    //https://api.flutter.dev/flutter/animation/AnimationController-class.html
    //Hier wird ein Controller erschaffen, welcher während der vorgegebnen duration Werte von 0 bis 1 generiert
    _controller = AnimationController(
      duration: Duration(seconds: widget.duration),
      vsync: this,
    );
    _controller.forward();
    //Mit diesem Befehl läuft der Controller
    _controller.addListener(() {
      setState(() {});
      //Mit diesem Befehl werden die Werte des Controllers aufgezeichnet. Die setState Funktion brauche ich, da der State des Bildschirms sich, basierend auf dem Controlerwert, stets ändern muss
    });
    //Hier wird die Animatino für die Hintergrundfarbenänderung festgestellt
    animation = CurvedAnimation(parent: _controller, curve: Curves.ease);
  }

  void playSound() {
    final audioPlayer = AudioCache();
    audioPlayer.play('note7.wav');
    //Mithilfe des Audio-Plugins (siehe pubspec.yaml) wird hier schlichtweg ein Sound erstellt
  }

  String get timerString {
    //Mit dieser Methode erschaffe ich einen Timer mithilfe des AnimationControllers, so dass ich kein weiteres Plugin brauche
    Duration duration =
        _controller.duration - (_controller.duration * _controller.value);
    //Dies ist die Formel für die verbleibende Zeit, basierend auf den Werten und der Dauer des Controllers
    if (_controller.value.toDouble() != 1) {
      if (duration.inSeconds == 59 ||
          duration.inSeconds == 119 ||
          duration.inSeconds == 179) {
        //Diese If-Abfragen sind ein Bug-Fix der Timeranzeige. Das Problem war, dass der Timer immer 1 Sekunde zu wenig angezeigt hat und am Ende 2 Sekunden lang 0 angezeigt hat. Also habe ich mir
        //dieses recht komplizierte If-Abfragenkonstrukt ausgedacht, um dem Fehler zu entgehen
        return '${duration.inMinutes + 1}:${((duration.inSeconds - 59) % 60).toString().padLeft(2, '0')}';
        //Mit dem padLeft stelle ich sicher, dass der Timer auch immer korrekt formatiert ist (also immer zweistellig ist). Mit den 60% der Sekunden wird zudem sichergestellt, dass der Timer nicht höher als 60s zählt
      } else {
        return '${duration.inMinutes}:${((duration.inSeconds) % 60 + 1).toString().padLeft(2, '0')}';
      }
    } else {
      //Dies spielt sich ab, sobald der Timer bei 0 angekommen ist
      playSound();
      pause();
      return '${duration.inMinutes}:${((duration.inSeconds) % 60).toString().padLeft(2, '0')}';
    }
  }

  void recordTime() {
    //Dies ist die Methode, welche für die Spielmessung tätig ist. Die Zeit wird immer demjenigen zugeschrieben, der gerade am Zug war (was mit der playerNumber Variable erreicht wird)
    playerDurations[playerNumber] =
        playerDurations[playerNumber] + stopwatch.elapsed;
    stopwatch.reset();
  }

  void resetController() {
    //Mit dieser Methode wird der Controller schlichtweg auf 0 gesetzt (was jedes mal passiert, wenn der User den Nächster-Button drückt
    recordTime();
    _controller.value = _controller.lowerBound;
    forward();
  }

  void pause() {
    //Pausen-Funktion
    _controller.stop();
    stopwatchSum.stop();
    stopwatch.stop();
    setState(() {
      isStopped = true;
      //Da die boolean Variable isStopped das Design des Screens ändert, muss sie in einer setState Methode sein, so dass ein automatischer Rebuild des Screens getriggert wird
    });
    recordTime();
  }

  void forward() {
    //Weiter Funktion
    _controller.forward();
    _controller.addListener(() {
      setState(() {});
    });
    stopwatch.start();
    stopwatchSum.start();
    setState(() {
      isStopped = false;
      //Siehe Argumentation bei void pause()
    });
    recordTime();
  }

  showAlertDialog(BuildContext context) {
    //Diese Methode erschafft die Alarm-Meldung, welche bei dem Fertig-Button erscheint
    // Hier werden die Button kreiert
    Widget cancelButton = FlatButton(
      child: Text(
        Translations.of(context).text('yes'),
        style: TextStyle(color: Colors.red.shade900, fontSize: 19.0),
      ),
      onPressed: () {
        //Falls der User das Spiel wirklich beenden möchte, so wird von hier zum Statistik Screen (screens\statistic_screen.dart) navigiert.
        //Für den StatistikScreen sind
        individualPlayRounds[playerNumber]++;
        recordTime();
        //Außerdem wird ein letztes mal alles gemessen, so dass die Messungen auch die letzte Runde inkludieren
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => StatistikScreen(
                      playerDurations,
                      playRounds,
                      individualPlayRounds,
                      stopwatchSum.elapsed,
                    )));
        //Hier wird nun der Controller sowie die Stopuhren gestoppt, um eine flüssige Performance zu gewährleisten. Sie werden ja schließlich nicht mehr gebraucht
        _controller.dispose();
        stopwatch.stop();
        stopwatchSum.stop();
      },
    );
    Widget continueButton = FlatButton(
      child: Text(
        Translations.of(context).text('no'),
        style: TextStyle(color: Colors.red.shade900, fontSize: 19.0),
      ),
      onPressed: () {
        Navigator.pop(context);
        //Falls der Spieler noch nicht aufhören möchte, so wird der AlertDialog einfach wieder entfernt
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      title: Text(
        Translations.of(context).text('alert_title_1'),
        style: TextStyle(fontSize: 20),
      ),
      content: Text(
        Translations.of(context).text('alert_question_1'),
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
    //Dies ist der fertige Alarm-Dialog
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //Erneut stelle ich mich mit diesem Widget sicher, dass der User die Android Buttons nicht benutzen kann
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.red.shade900.withOpacity(animation.value),
        //Hiermit erreiche ich die Animation des Hintergrundes. Animiert wird die Sichtbarkeit der Farbe, abhängig von dem Animation-Controller
        appBar: AppBar(
            backgroundColor: Colors.black87,
            title: Text(
              Translations.of(context).text('title'),
            ),
            automaticallyImplyLeading: false),
        //hiermit wird nur der Zurückbutton des Scaffolds deaktiviert, welche ja eh ohne Funktion wäre in diesem Skript
        body: Column(
          //Alles in dieser Column wird zentriert
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              //Spieler-Name
              //Dieses Padding-Widget schafft Abstand von allen Seiten
              padding: EdgeInsets.all(15),
              child: Text(
                Provider.of<PlayerData>(context).players[playerNumber].name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 50,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              //Timer
              timerString,
              style: TextStyle(
                color: Colors.white,
                fontSize: 80,
              ),
            ),
            SizedBox(height: 10),
            Center(
              //Zentrierung
              child: Text(
                _controller.value.toDouble() != 1
                    ? ''
                    //Der Stop-String soll erst erscheinen, wenn der Controller Value bei 1 und somit am Ende ist
                    //? '${(_controller.value.toDouble() * 100).toStringAsFixed(0)}%'
                    : Translations.of(context).text('stop'),
                style: TextStyle(
                    fontSize: 50,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Opacity(
              opacity: playRounds >=
                      Provider.of<PlayerData>(context, listen: false)
                          .playerCount
                  ? 1
                  : 0,
              //Opacity/Sichtbarkeit: 1 = Komplett sichtbar, 0 = Unsichtbar
              //Der Fertig-Button soll erst erscheinen, wenn jeder Spieler einmal dran war. Somit behebe ich das Problem, dass im Statistik Screen am Ende durch eine Duration mit dem Wert 0 dividert werden muss
              child: ButtonTheme(
                minWidth: 220,
                height: 30,
                child: RaisedButton(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        playRounds >=
                                Provider.of<PlayerData>(context, listen: false)
                                    .playerCount
                            ? Translations.of(context).text('ready_button')
                            : '',
                        //Gleiche Begründung für diese If-Abfrage wie bei dem Opacity Widget oben
                        style: TextStyle(color: Colors.black87, fontSize: 25.0),
                      ),
                    ),
                    color: Colors.white70,
                    shape: RoundedRectangleBorder(
                      //Hiermit runde ich alle Ecken des Buttons ab. Gleiches tue ich bei den Button unten
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    //Der Fertig-Button soll erst erscheinen, wenn jeder Spieler einmal dran war. Somit behebe ich das Problem, dass im Statistik Screen am Ende durch eine Duration mit dem Wert 0 dividert werden muss
                    onPressed: playRounds >=
                            Provider.of<PlayerData>(context, listen: false)
                                .playerCount
                        ? () {
                            showAlertDialog(context);
                            //Wenn der Fertig-Button gedrückt wird erscheint der oben erstellte AlertDialog. Damit gehe ich sicher, dass der Spieler das Spiel nicht nur ausversehen beendet hat
                          }
                        : () {}),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Hero(
              tag: 'button',
              child: ButtonTheme(
                minWidth: 220,
                height: 30,
                child: RaisedButton(
                    //https://api.flutter.dev/flutter/material/RaisedButton-class.html
                    child: Padding(
                      //Padding ist im Grunde einfach eine Abstand-Property
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        //Der Pause-Button muss natürlich immer eine konträre Funktion zum aktuellen Status der isStopped Boolean Variable haben. Dies gilt auch für den Text
                        isStopped == false
                            ? Translations.of(context).text('pause_button')
                            : Translations.of(context).text('continue_button'),
                        style: TextStyle(color: Colors.black87, fontSize: 25.0),
                      ),
                    ),
                    color: Colors.white70,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    onPressed: isStopped == false
                        ? () {
                            pause();
                          }
                        : () {
                            forward();
                          }),
                //Je nachdem ob das Spiel gerade pausiert ist oder nicht hat, hat dieser Button auch unterschiedliche Funktionen und Titel, abängig von der isStopped Boolean Variable
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ButtonTheme(
              minWidth: 220,
              height: 30,
              child: RaisedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      Translations.of(context).text('next_button'),
                      style: TextStyle(color: Colors.black87, fontSize: 25.0),
                    ),
                  ),
                  color: Colors.white70,
                  shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0),
                  ),
                  onPressed: () {
                    //Hier wird ein infinite-Loop erschaffen. Wird dieser Button unendlich gedrückt, so wird auch die Liste mit den Spielern unendlich lang durchgegangen. Unterbrochen wird das ganze nur durch den Fertig-Button
                    if (Provider.of<PlayerData>(context, listen: false)
                            .playerCount !=
                        playerNumber + 1) {
                      //entspricht: Kann ich noch ein Spieler hochgehen? Falls ja:
                      individualPlayRounds[playerNumber]++;
                      resetController();
                      playRounds++;
                      playerNumber++;
                    } else {
                      //Falls nein:
                      individualPlayRounds[playerNumber]++;
                      resetController();
                      playRounds++;
                      playerNumber = 0; //Liste wird resettet
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
