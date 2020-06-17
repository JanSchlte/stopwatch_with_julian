import 'package:flutter/material.dart';
import 'package:stopwatch_with_julian/widgets/statistic_tile.dart';
import 'package:stopwatch_with_julian/components/data.dart';
import 'package:provider/provider.dart';

//Die Statistik Liste ist im Prinzip sehr ähnlich zu der PlayerListe. Lediglich der Konstruktur ist etwas anders, da nun konkrete Daten aus dem Spiel benötigt werden
//Sonst ist aber alles identisch

class StatisticList extends StatelessWidget {
  final List<Duration> durations;
  final List<int> individualPlayRounds;
  StatisticList(this.durations, this.individualPlayRounds);
  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerData>(
      builder: (context, playerData, child) {
        return ListView.builder(
          itemBuilder: (context, index) {
            final player = playerData.players[index];
            return StatisticTile(
              name: player.name,
              duration: durations[index],
              rounds: individualPlayRounds[index],
            );
          },
          itemCount: playerData.playerCount,
        );
      },
    );
  }
}
