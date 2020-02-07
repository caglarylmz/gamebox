import 'package:flutter/material.dart';
import 'package:game_box/pages/home_page.dart';

void main() => runApp(Main());

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        "/": (context)=>HomePage(),
      },
      
      
    );
  }
}
