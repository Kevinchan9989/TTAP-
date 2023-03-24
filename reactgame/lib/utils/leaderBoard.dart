import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reactgame/ui/theme/color.dart';
import 'package:reactgame/utils/Player.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'game.dart';

class Leaderboard extends StatefulWidget {
  final List<Player> players;
  const Leaderboard({Key? key, this.players = const []}) : super(key: key);

  @override
  State<Leaderboard> createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  List<Player> players = [];

  @override
  void initState() {
    super.initState();
    LoadList();
  }

  Future<void> LoadList() async {
    final prefs = await SharedPreferences.getInstance();
    players = [];
    for (int i = 0; i < 25; i++) {
      final playerScore = prefs.getInt('score$i');
      final playerName = prefs.getString('name$i');
      if (playerScore != null && playerName != null) {
        players.add(Player(name: playerName, totalScores: playerScore));
      }
    }
    players.sort((a, b) => b.totalScores
        .compareTo(a.totalScores)); // sort in descending order of score
    setState(() {
      players = players;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MainColor.primaryColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.emoji_events_rounded,
              color: MainColor.lightColor,
            ),
            SizedBox(width: 10),
            Text('Leaderboard'),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: MainColor.primaryColor,
        ),
        padding:
            EdgeInsetsDirectional.only(top: 30, bottom: 30, start: 20, end: 20),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: MainColor.primaryColor10,
            borderRadius: BorderRadius.circular(30),
          ),
          //color: MainColor.primaryColor,
          child: ListView.builder(
            itemCount: players.length,
            itemBuilder: (BuildContext context, int index) {
              final player = players[index];
              return ListTile(
                leading: Text(
                  '${index + 1}',
                  style: TextStyle(
                      fontSize: 20,
                      color: index == 0
                          ? MainColor.goldColor
                          : index == 1
                              ? MainColor.silverColor
                              : index == 2
                                  ? MainColor.bronzeColor
                                  : Colors.white),
                ),
                title: Text(
                  player.name,
                  style: TextStyle(
                      fontSize: 20,
                      color: index == 0
                          ? MainColor.goldColor
                          : index == 1
                              ? MainColor.silverColor
                              : index == 2
                                  ? MainColor.bronzeColor
                                  : Colors.white),
                ),
                trailing: Text(
                  '${player.totalScores}',
                  style: TextStyle(
                      fontSize: 20,
                      color: index == 0
                          ? MainColor.goldColor
                          : index == 1
                              ? MainColor.silverColor
                              : index == 2
                                  ? MainColor.bronzeColor
                                  : Colors.white),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
