import 'package:flutter/foundation.dart';
import 'player.dart';

//Dies ist der Ort, wo die Spieler als globale Liste entstehen, da ja jeder Screen auf diese Liste zugreifen muss, egal, an welcher Stelle im Widget-Tree

class PlayerData extends ChangeNotifier {
  List<Player> players = [];

  int get playerCount {
    return players.length;
  }

  void addPlayer(String newPlayerName) {
    final player = Player(name: newPlayerName);
    players.add(player);
    notifyListeners();
    //notifyListeners() ist die zentrale Funktion. Durch den Changenotifier (s. oben) werden alle Änderungen, die an der globalen Liste vorgenommen werden, an diejenigen weitergegeben, die die globale Spielerliste verwenden
  }

  void deleteTask(Player player) {
    players.remove(player);
    notifyListeners();
  }
}
