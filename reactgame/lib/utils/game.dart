import 'dart:async';
import 'dart:convert';
import 'package:reactgame/utils/Player.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'block.dart';

class Game {
  int level;
  Player player;
  late int totalTaps;
  late bool isRunning;
  late bool isPassed;
  late List<Block> blocks;
  Timer? timer;

  Game(this.level, this.player) {
    totalTaps = 0;
    isPassed = false;
    isRunning = false;
    blocks = List.generate(level * level, (_) => Block());
  }

  void start() {
    totalTaps = 0;
    isRunning = true;
    blocks[Block.randomHighlightedIndex(level)].highlight();
    timer = Timer(Duration(seconds: 5), () {
      end();
      isPassed = true;
    });
  }

  void end() {
    player.scores.add(totalTaps);
    print(player.scores);
    isRunning = false;
    timer?.cancel();
  }

  void tap(int index) {
    if (isRunning) {
      if (blocks[index].isHighlighted) {
        totalTaps++;
        blocks[index].tap();
        blocks[index].unhighlight();
        blocks[Block.randomHighlightedIndex(level)].highlight();
      }
    }
  }

  void reset() {
    totalTaps = 0;
    isRunning = false;
    timer?.cancel();
    blocks.forEach((block) => block.reset());
  }

  Future<List<Player>> getTopPlayers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //retrieve list of top players
    List<String>? playerList = prefs.getStringList('topPlayers');

    //return blank list if the list is blank
    if (playerList == null) {
      return [];
    }

    //convert each Player String to Player Object
    List<Player> topPlayers = playerList
        .map((playerString) => Player.fromJson(jsonDecode(playerString)))
        .toList();

    //return the topPlayers list
    return topPlayers;
  }

  Future<void> addNewPlayer(Player player) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    //get list of topPlayers
    List<Player> topPlayers = await getTopPlayers();

    //add newPlayer
    topPlayers.add(player);

    //sort the newPlayer and topPlayers together
    topPlayers.sort((a, b) => b.totalScores.compareTo(a.totalScores));

    //Make sure the list only until 25
    if (topPlayers.length > 25) {
      topPlayers = topPlayers.sublist(0, 25);
    }

    //map as Player Object
    List<String> playerList =
        topPlayers.map((player) => jsonEncode(player.toJson())).toList();

    //saved to sharedPreferences
    for (int i = 0; i < 25 && i < topPlayers.length; i++) {
      await prefs.setInt('score$i', topPlayers[i].totalScores);
      await prefs.setString('name$i', topPlayers[i].name);
    }
    await prefs.setStringList('topPlayers', playerList);
  }
}
