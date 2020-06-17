import 'package:flutter/material.dart';

class StatisticTile extends StatelessWidget {
  final String name;
  final Duration duration;
  final int rounds;
  StatisticTile({this.name, this.duration, this.rounds});

  String printDuration(Duration duration) {
    //Hier wird wieder die korrekte twodigit Formatierung von Zeitangaben programmiert. Diese ist auch abhängig von der Länge. Stunden sollen nur im Notfall angegeben werden
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours < 1) {
      return '$twoDigitMinutes:$twoDigitSeconds';
    } else {
      return '${twoDigits(duration.inHours)}:$twoDigitMinutes:${twoDigitSeconds}h';
    }
  }

  String printAverage(Duration duration) {
    //Der Durchschnitt wird gesondert formatiert, da normal ein Unterschied zwischen dem Durchschnitt und der Spielsumme existieren sollte
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours >= 1) {
      return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds h';
    } else if (duration.inMinutes < 1) {
      return '${twoDigitSeconds}s';
    } else {
      return '${twoDigitSeconds + (duration.inMinutes).toString()}s';
    }
  }

  //Das Statistic-Tile ist ähnlich aufgebaut wie ein PlayerTile. Lediglich die Inhalte sind etwas verschieden
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          name,
          textAlign: TextAlign.left,
          style: TextStyle(color: Colors.black87, fontSize: 20),
        ),
        trailing: Text(
          '${rounds}r      Σ: ${printDuration(duration)}      Ø: ${printDuration((duration ~/ rounds))}',
          // Der Operator ~/ erschafft ein int-Ergebnis aus einer Dividierung
          style: TextStyle(color: Colors.black87, fontSize: 20),
        ),
      ),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
    );
  }
}
