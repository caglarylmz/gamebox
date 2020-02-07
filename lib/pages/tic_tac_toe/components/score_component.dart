import 'package:flutter/material.dart';
import 'package:game_box/pages/tic_tac_toe/tic_tac_toe.dart';

class ScoreComponent extends StatefulWidget {
  final int playerScore;
  final int botScore;

  const ScoreComponent({Key key, this.playerScore, this.botScore})
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
                width: 90,
                height: 60,
                child: Icon(
                  Icons.account_box,
                  color: Colors.white,
                ),
              ),
              Text(
                playerScore.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              )
            ],
          ),
        ),
        Container(
          color: Colors.transparent,
          margin: EdgeInsets.all(10),
          child: Column(
            children: <Widget>[
              Container(
                color: Colors.transparent,
                width: 90,
                height: 60,
                child: Icon(
                  Icons.android,
                  color: Colors.white,
                ),
              ),
              Text(
                botScore.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
