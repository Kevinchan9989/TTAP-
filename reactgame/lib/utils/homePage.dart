import 'dart:ffi';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:reactgame/utils/leaderBoard.dart';
import 'package:reactgame/utils/Player.dart';

import '../ui/theme/color.dart';
import 'gamePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textController = TextEditingController();

  String username = '';
  final _formKey = GlobalKey<FormState>();
  late String _textValue;

  @override
  void initState() {
    super.initState();
    _formKey.currentState?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainColor.primaryColor,
      appBar: AppBar(
        backgroundColor: MainColor.primaryColor,
        title: Text(
          'Try Tap As quick as Possible',
          style: TextStyle(
            color: MainColor.lightColor,
          ),
        ),
      ),
      body: Container(
        height: 600,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'TTAP',
              style: TextStyle(
                fontSize: 90,
                color: MainColor.lightColor,
                fontWeight: FontWeight.w800,
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _textController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Enter Your Name',
                          labelStyle: TextStyle(color: MainColor.lightColor),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: MainColor.lightColor),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: MainColor.accentColor),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Start Game Button
                          ElevatedButton(
                            onPressed: () {
                              username = _textController.text;
                              Player currPlayer = Player(
                                  name: username,
                                  totalScores: 0); //Create new player
                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => GamePage(
                                      level: 2,
                                      player: currPlayer,
                                    ),
                                  ),
                                );
                              }
                            },
                            style: ButtonStyle(backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return MainColor.primaryColor;
                                }
                                return MainColor.accentColor;
                              },
                            )),
                            child: Icon(Icons.play_arrow_rounded),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          //Leaderboard Button
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => Leaderboard(),
                                ),
                              );
                            },
                            style: ButtonStyle(backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return MainColor.primaryColor;
                                }
                                return MainColor.accentColor;
                              },
                            )),
                            child: Icon(Icons.emoji_events_rounded),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          //Quit Game Button
                          ElevatedButton(
                            onPressed: () {
                              exit(0);
                            },
                            style: ButtonStyle(backgroundColor:
                                MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return MainColor.primaryColor;
                                }
                                return MainColor.accentColor;
                              },
                            )),
                            child: Icon(Icons.exit_to_app_rounded),
                          ),
                        ],
                      ),
                    ],
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
