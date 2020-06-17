import 'package:flutter/material.dart';

class PlayerTile extends StatelessWidget {
  final String name;
  final Function onIconPress;
  PlayerTile({this.name, this.onIconPress});

  @override
  Widget build(BuildContext context) {
    return Card(
      //https://api.flutter.dev/flutter/material/Card-class.html
      //Einfach eine Material-Design Karte
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        //https://api.flutter.dev/flutter/material/ListTile-class.html
        //Im Prinzip eine single-fixed Row, welche in der Regel ein Text-Widget hat
        title: Text(
          name,
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.black87, fontSize: 20),
        ),
        trailing: IconButton(
          //Trailing ist der hintere Teil des ListTiles
          //Dies ist der Lösch-Button, so dass man die Spieler auch wieder entfernen kann
          icon: Icon(
            Icons.delete,
            color: Colors.black87,
          ),
          onPressed: onIconPress,
        ),
      ),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        //Abrundung
        borderRadius: new BorderRadius.circular(30.0),
      ),
    );
  }
}
