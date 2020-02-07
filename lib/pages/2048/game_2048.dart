import 'package:flutter/material.dart';

class Game2048 extends StatefulWidget {
  @override
  _Game2048State createState() => _Game2048State();
}

class _Game2048State extends State<Game2048> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text("2048"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info),
            tooltip: 'About',
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(color: Colors.blue[500]),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
        
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
        
          });
        },
        tooltip: 'Restart',
        child: Icon(Icons.refresh),
      ),
      
    );
  }
}