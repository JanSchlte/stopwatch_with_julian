import 'package:flutter/material.dart';
import 'package:stopwatch_with_julian/widgets/player_tile.dart';
import 'package:provider/provider.dart';
import 'package:stopwatch_with_julian/components/data.dart';

class PlayerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerData>(
      //Das Consumer Widget ist im Prinzip ein Konsument der Daten von der globalen Playerliste. Daher ist die PlayerList von der globalen Liste abhängig (Provider-Plugin-Funktionalität)
      builder: (context, playerData, child) {
        return ListView.builder(
          //Ein Listview ist im Prinzip eine scrollbare Liste, die unendlich viele Items haben kann (vgl. Chat in einem Messenger)
          //https://api.flutter.dev/flutter/widgets/ListView-class.html
          itemBuilder: (context, index) {
            final player = playerData.players[index];
            return PlayerTile(
                //Die Playerlist basiert auf dem PlayerTile. Dafür: lib\widgets\player_tile.dart
                name: player.name,
                onIconPress: () => playerData.deleteTask(player));
          },
          itemCount: playerData.playerCount,
          //Der itemCount sagt, wie viele Items der Listview Builder erstellen soll
        );
      },
    );
  }
}
