import 'package:flutter/material.dart';
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

  void gameOver() {
    setState(() {
      if (_board.gameOver()) {
        isGameOver = true;
      }
    });
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
              Container(
                color: Colors.orange[100],
                width: 120,
                height: 60,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Score: "),
                    Text("${_board.score}"),
                  ],
                )),
              )
            ],
          ),
        ),
        FlatButton(
          child: Container(
            alignment: Alignment.center,
            width: 120,
            height: 60,
            decoration: BoxDecoration(
                color: Colors.orange[100],
                border: Border.all(color: Colors.grey)),
            child: Text("New Game"),
          ),
          onPressed: () {
            setState(() {
              newgame();
            });
          },
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
                  gameOver();
                });
              } else {
                setState(() {
                  _board.moveUp();
                  gameOver();
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
                  gameOver();
                });
              } else {
                setState(() {
                  _board.moveRight();
                  gameOver();
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
