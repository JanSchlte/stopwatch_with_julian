import 'package:flutter/material.dart';
import 'package:stopwatch_with_julian/components/data.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch_with_julian/components/translations.dart';

//Erstellung des Screens, auf welchem die showModalBottomSheet-Methode später basiert

class AddPlayerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String newPlayerName;
    return Container(
      //https://api.flutter.dev/flutter/widgets/Container-class.html
      padding: EdgeInsets.all(20),
      child: Column(
        //https://api.flutter.dev/flutter/widgets/Column-class.html
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            Translations.of(context).text('add_players'),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 30.0,
            ),
          ),
          TextField(
              //https://api.flutter.dev/flutter/material/TextField-class.html
              autofocus: true,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black87, fontSize: 20),
              cursorColor: Colors.red.shade900,
              //Maximale Charakter-Länge
              maxLength: 11,
              maxLengthEnforced: true,
              decoration: InputDecoration(
                //Textfeld-Styling
                focusColor: Colors.red.shade900,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              onChanged: (newText) {
                newPlayerName = newText;
              }),
          FlatButton(
              color: Colors.red.shade900,
              child: Text(
                Translations.of(context).text('add'),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                if (newPlayerName != null) {
                  //Hiermit wird sichergestellt, dass kein non-String erschaffen wird
                  Provider.of<PlayerData>(context, listen: false)
                      .addPlayer(newPlayerName);
                  //Der Spieler wird der globalen Variablen-Liste der Spieler zugeordnet
                  Navigator.pop(context);
                  //Der Screen wird wieder gelöscht
                }
              }),
        ],
      ),
    );
  }
}
