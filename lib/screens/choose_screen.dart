import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'animation_screen.dart';
import 'package:stopwatch_with_julian/widgets/player_list.dart';
import 'package:stopwatch_with_julian/screens/add_player_screen.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch_with_julian/components/data.dart';
import 'package:stopwatch_with_julian/components/translations.dart';

class FirstScreen extends StatefulWidget {
  //Der Auswahlscreen ist ein Stateful-Widget, da sich der State des Screens immer ändern muss. Wäre der Screen nur statisch, so hätte ich ein Stateless Screen ausgewählt (gleiches gilt übrigens auch bei allen anderen Screens)
  @override
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  int duration = 90;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      //Mit diesem Widget stelle ich sicher, dass der User nicht mithilfe der Android-Buttons zurückgehen kann. Dies verhindert in erster Linie Bugs
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        //Diesen Befehl brauchte ich, um einen Bug mit dem Bottomsheet zu verhindern, in welchem dieses den ganzen Screen nach oben verschoben hat
        backgroundColor: Colors.red.shade900,
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: Text(
            Translations.of(context).text('title'),
            //So sehen alle meine Design-Strings aufgrund der Billingualität aus. Die tatsächlichen Strings (sowohl Deutsch als auch Englisch) befinden sich in den json Dateien, welche von der Translator class decodet werden (siehe locale\)
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          //Hier werden alle Kinder der Column zentralisiert
          children: <Widget>[
            SizedBox(
              height: 8,
              //Alle meine SizedBoxes haben die Funktion eines Platzhalters, um etwas Abstand zu schaffen. Sie sind alle unsichtbar
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Hero(
                  //Die Hero Animation sorgt für einen smoothen Übergang
                  tag: 'players',
                  child: Text(
                    //Den Player-Count holt sich das Provider-Plugin global von der components\player.dart class
                    Provider.of<PlayerData>(context).playerCount != 1
                        ? '${Provider.of<PlayerData>(context).playerCount} ${Translations.of(context).text('player')}'
                        : '${Provider.of<PlayerData>(context).playerCount} ${Translations.of(context).text('player_singular')}',
                    //Mit dieser kleinen If-Abfrage wird das Problem im Englischen umgangen, in welchem die Zeile "1 Players" heißen würde
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                    textAlign: TextAlign.left,
                  ),
                ),
                FloatingActionButton(
                  //Dies ist der Button, den man drücken muss, um Spieler hinzuzufügen
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.add,
                    color: Colors.black87,
                    size: 35,
                  ),
                  onPressed: () {
                    //https://api.flutter.dev/flutter/material/showModalBottomSheet.html
                    //Dieses ModalBottomSheet basiert auf screens\add_player.dart ... Dort gibt man alle Spieler ein
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: AddPlayerScreen(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 15, right: 50),
                child: PlayerList(),
                //Hier ist der Kern des Screens: Die Liste alle bisher eingefügten Spieler. Hiefür habe ich die Klasse widgets\player_list.dart erstellt
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline
                  .alphabetic, //Somit sind Zahl und Einheit auf der gleichen Ebene
              children: <Widget>[
                Text(
                  duration.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                  ),
                ),
                Text(
                  's',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            SliderTheme(
              //Hier wird der Slider designt
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.white,
                inactiveTrackColor: Colors.black87,
                thumbColor: Colors.white,
                overlayColor: Colors.white70,
                thumbShape: RoundSliderThumbShape(
                  enabledThumbRadius: 15.0,
                ),
                overlayShape: RoundSliderOverlayShape(
                  overlayRadius: 30.0,
                ),
              ),
              child: Container(
                width: 350,
                child: Slider(
                    value: duration.toDouble(),
                    min: 10,
                    max: 180,
                    //Ich nehme hier an, dass alle Spielrunden in dem Bereich von 10-180 liegen. Also sind das die Slider-Grenzwerte
                    onChanged: (double newValue) {
                      setState(() {
                        //Dies ist in einer setState Funktion, da setState Funktionen einen Rebuild des Stateful Widgets veranlassen. Ohne würde sich der Screen nicht richtigerweise ändern, sondern wäre statisch
                        duration = newValue.toInt();
                        //Der Wert des Sliders wird hier stets der duration-Variable zugeteilt
                      });
                    }),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Center(
              child: Hero(
                //Erneut soll die Hero Animation für einen smoothen Übergang machen. Bei dieser verschiebt sich das Objekt hier zu einem identischen Objekt mit dem gleichen tag
                tag: 'button',
                child: ButtonTheme(
                  minWidth: 900,
                  child: RaisedButton(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        Provider.of<PlayerData>(context, listen: false)
                                    .players
                                    .length <
                                2
                            ? Translations.of(context).text('min_player')
                            : Translations.of(context).text('start'),
                        //Mit dieser if-Abfrage stelle ich sicher, dass, solange noch nicht 2 Spieler konfiguriert wurden, das Spiel nicht startbereit ist. Dies wird hier mit dem Text signalisiert
                        style: TextStyle(color: Colors.white, fontSize: 40.0),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    color: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.only(
                        topLeft: Radius.circular(40.0),
                        topRight: Radius.circular(40.0),
                      ),
                    ),
                    onPressed: Provider.of<PlayerData>(context, listen: false)
                                .players
                                .length <
                            2
                        ////Mit dieser if-Abfrage stelle ich sicher, dass, solange noch nicht 2 Spieler konfiguriert wurden, das Spiel nicht startbereit ist
                        ? () {}
                        : () {
                            //Der Navigator "navigiert" praktisch zwischen den einzelnen Screens. Mit pushReplacement wird wortwörtlich erreicht, dass dieser Screen gelöscht wird und mit dem neuen ersetzt wird
                            Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                builder: (context) =>
                                    //Hier wird zum Animationsscreen weitergeleitet (screens\animation_screen), welcher die duration im Konstruktor benötigt
                                    new SecondScreen(duration),
                              ),
                            );
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
