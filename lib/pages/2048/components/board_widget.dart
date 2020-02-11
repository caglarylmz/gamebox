import 'package:flutter/material.dart';
import 'package:game_box/pages/2048/components/score_component.dart';
import 'package:game_box/pages/2048/components/tile_widget.dart';
import 'package:game_box/pages/2048/entities/board.dart';
import 'package:game_box/pages/2048/game_2048.dart';

class BoardWidget extends StatefulWidget {
  BoardWidget({Key key}) : super(key: key);

  @override
  BoardWidgetState createState() => BoardWidgetState();
}

class BoardWidgetState extends State<BoardWidget> {
  Board _board;
  int row;
  int column;
  bool isGameOver;
  bool _isMoving;
  final double tilePadding = 5.0;
  MediaQueryData _queryData;

  Size boardSize() {
    //Size size = _queryData.size;
    return Size(400, 400);
  }

  @override
  void initState() {
    super.initState();
    row = 4;
    column = 4;
    _isMoving = false;
    isGameOver = false;
    _board = Board(row, column);
    newgame();
  }

  void newgame() {
    _board.initBoard();
    isGameOver = false;
  }

  void gameOver(BuildContext context)  {
    setState(()  {
      if (_board.gameOver()) {
        isGameOver = true;
      }
      if (isGameOver) {
      _showAlertBox(context);
      }
    });
  }

  _showAlertBox(BuildContext context){
    return showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext _context) => AlertDialog(
              title: Text("Score"),
              content: Text("${_board.score}"),
              actions: <Widget>[
                RaisedButton(
                  color: Colors.white,
                  child: Text("Exit"),
                  onPressed: () {
                    Navigator.popAndPushNamed(context, "/");
                  },
                ),
                RaisedButton(
                  color: Colors.white,
                  child: Text("New Game"),
                  onPressed: () {
                    newgame();
                  },
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    _queryData = MediaQuery.of(context);

    List<TileWidget> _tileWidgets = List<TileWidget>();
    for (var r = 0; r < this.row; ++r) {
      for (var c = 0; c < this.column; ++c) {
        _tileWidgets.add(TileWidget(
          tile: _board.getTile(r, c),
          state: this,
        ));
      }
    }

    List<Widget> children = List<Widget>();
    children.add(Game2048(boardWidgetState: this));
    children.addAll(_tileWidgets);
    return Column(
      children: <Widget>[
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              ScoreComponent(
                playerScore: _board.score,
              ),
            ],
          ),
        ),
        Container(
          height: 40,
          child: Opacity(
            opacity: isGameOver ? 1.0 : 0.0,
            child: Center(
              child: Text("Game Over!"),
            ),
          ),
        ),
        Container(
          width: boardSize().width,
          height: boardSize().width,
          child: GestureDetector(
            onVerticalDragUpdate: (detail) {
              if (detail.delta.distance == 0 || _isMoving) return;
              _isMoving = true;
              if (detail.delta.direction > 0) {
                setState(() {
                  _board.moveDown();
                  gameOver(context);
                });
              } else {
                setState(() {
                  _board.moveUp();
                  gameOver(context);
                });
              }
            },
            onVerticalDragEnd: (d) {
              _isMoving = false;
            },
            onVerticalDragCancel: () {
              _isMoving = false;
            },
            onHorizontalDragUpdate: (detail) {
              if (detail.delta.distance == 0 || _isMoving) return;
              _isMoving = true;
              if (detail.delta.direction > 0) {
                setState(() {
                  _board.moveLeft();
                  gameOver(context);
                });
              } else {
                setState(() {
                  _board.moveRight();
                  gameOver(context);
                });
              }
            },
            onHorizontalDragEnd: (d) {
              _isMoving = false;
            },
            onHorizontalDragCancel: () {
              _isMoving = false;
            },
            child: Stack(
              children: children,
            ),
          ),
        )
      ],
    );
  }
}
