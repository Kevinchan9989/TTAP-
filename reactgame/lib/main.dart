import 'dart:io';

import 'package:flutter/material.dart';
import 'package:reactgame/ui/theme/color.dart';
import 'package:reactgame/utils/homePage.dart';
import 'utils/gamePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TTAP',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
