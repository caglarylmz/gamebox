import 'package:flutter/material.dart';
import 'package:game_box/pages/2048/game_2048.dart';
import 'package:game_box/pages/home_page.dart';
import 'package:game_box/pages/tic_tac_toe/tic_tac_toe.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context)=>HomePage(),
        "/tictactoe":(context)=>TicTacToe(),
        "/2048":(context)=>MyGame2048()
      },
      
      
    );
  }
}
