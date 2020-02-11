import 'package:flutter/material.dart';

class ScoreComponent extends StatefulWidget {
  final int playerScore;

  const ScoreComponent({Key key, this.playerScore})
      : super(key: key);

  @override
  _ScoreComponentState createState() => _ScoreComponentState();
}

class _ScoreComponentState extends State<ScoreComponent> {
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          color: Colors.transparent,
          margin: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.transparent,
                width: 100,
                child: Icon(
                  Icons.account_box,
                  size: 70,
                  color: Colors.white,
                ),
              ),
              Text(
                widget.playerScore.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
