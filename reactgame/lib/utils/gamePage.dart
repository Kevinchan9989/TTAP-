import 'dart:async';

import 'package:flutter/material.dart';
import 'package:reactgame/main.dart';
import 'package:reactgame/ui/theme/color.dart';
import 'package:reactgame/utils/Player.dart';
import 'game.dart';

class GamePage extends StatefulWidget {
  final int level;
  Player player;

  GamePage({required this.level, required this.player});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  late Game _game;
  int secondsRemaining = 5;

  @override
  void initState() {
    _game = Game(widget.level, widget.player);
    super.initState();
  }

  @override
  void dispose() {
    _game.reset();
    super.dispose();
  }

  void _startGame() {
    _game.reset();
    _game.start();
    _startTimer();
    setState(() {});
  }

  void _onBlockTap(int index) {
    _game.tap(index);
    setState(() {});
  }

  void _startTimer() {
    Timer? _timer = _game.timer;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (timer) {
        setState(() {
          if (secondsRemaining < 1) {
            timer.cancel();
            secondsRemaining += 5;
          } else {
            secondsRemaining--;
          }
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> blockWidgets = _game.blocks.map((block) {
      return GestureDetector(
        onTap: () => _onBlockTap(_game.blocks.indexOf(block)),
        child: Container(
          margin: EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: block.isHighlighted
                ? MainColor.lightColor
                : MainColor.secondaryColor,
          ),
        ),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MainColor.primaryColor,
        title: Text('Level ${widget.level - 1}'),
      ),
      body: Container(
        color: MainColor.primaryColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              children: [
                Text(
                  'Player Name: ${_game.player.name}',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                Text(
                  'Total Taps: ${_game.totalTaps}',
                  style: TextStyle(fontSize: 24, color: MainColor.goldColor),
                ),
                Text(
                  'Time Left: ${secondsRemaining} Seconds',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: widget.level,
              children: blockWidgets,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Start Button
                ElevatedButton(
                    onPressed:
                        _game.isRunning || _game.isPassed ? null : _startGame,
                    style: ButtonStyle(backgroundColor:
                        MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return MainColor.primaryColor;
                        }
                        return _game.isRunning
                            ? MainColor.primaryColor
                            : MainColor.accentColor;
                      },
                    )),
                    child: Icon(_game.isRunning
                        ? Icons.hourglass_full
                        : Icons.play_arrow_rounded)),
                SizedBox(
                  width: 10,
                ),
                //Next Level Button
                ElevatedButton(
                  onPressed: _game.isRunning || _game.level >= 6
                      ? null
                      : () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => GamePage(
                                level: ++_game.level,
                                player: _game.player,
                              ),
                            ),
                          );
                        },
                  style: ButtonStyle(backgroundColor:
                      MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return MainColor.primaryColor;
                      }
                      return _game.isRunning
                          ? MainColor.primaryColor
                          : MainColor.accentColor;
                    },
                  )),
                  child: Icon(_game.isRunning
                      ? Icons.hourglass_full
                      : Icons.arrow_forward),
                ),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                  onPressed: _game.isRunning
                      ? null
                      : () async {
                          //save players to sharedpreferences if conditions met
                          _game.player.addTotalScores();
                          List<Player> topPlayers = await _game.getTopPlayers();
                          if (topPlayers.length < 25 ||
                              _game.player.totalScores >
                                  topPlayers.last.totalScores) {
                            _game.addNewPlayer(_game.player);
                          }
                          Navigator.pop(context);
                        },
                  style: ButtonStyle(backgroundColor:
                      MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      if (states.contains(MaterialState.pressed)) {
                        return MainColor.primaryColor;
                      }
                      return _game.isRunning
                          ? MainColor.primaryColor
                          : MainColor.accentColor;
                    },
                  )),
                  child: Icon(_game.isRunning
                      ? Icons.hourglass_full
                      : Icons.exit_to_app_rounded),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
