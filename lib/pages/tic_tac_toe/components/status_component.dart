import 'package:flutter/material.dart';

class StatusComponent extends StatefulWidget {
  final String turn;

  StatusComponent({this.turn});
  @override
  _StatusComponentState createState() => _StatusComponentState();
}

class _StatusComponentState extends State<StatusComponent> {
  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(40),
        child: Container(
          width: 220,
          height: 60,
          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: Text(
            widget.turn,
            style: TextStyle(fontSize: 30),
            textAlign: TextAlign.center,
          ),
        ));
  }
}