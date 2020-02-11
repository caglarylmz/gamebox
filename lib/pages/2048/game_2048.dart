import 'package:flutter/material.dart';
import 'package:game_box/pages/2048/components/board_widget.dart';
import 'package:game_box/pages/2048/components/tile_box.dart';


/**
 * @ToDo: en yüksek Skor kaydetme eklenecek
 * @Todo . Score ve Gameover daha güzel bir şekle getirilecek
 * -New Game butonu kaldırıldı, artık FAB ile bu işlem sağlanıyor
 */
class Game2048 extends StatelessWidget {
  final BoardWidgetState boardWidgetState;

  const Game2048({this.boardWidgetState});
  @override
  Widget build(BuildContext context) {
    double width = (boardWidgetState.boardSize().width -
            (boardWidgetState.column + 1) * boardWidgetState.tilePadding) /
        boardWidgetState.column;

    List<TileBox> backgroundBox = List<TileBox>();
    for (var r = 0; r < boardWidgetState.row; ++r) {
      for (var c = 0; c < boardWidgetState.column; ++c) {
        TileBox tile = TileBox(
          left: c * width * boardWidgetState.tilePadding * (c + 1),
          top: r * width * boardWidgetState.tilePadding * (r + 1),
          size: width,
        );
        backgroundBox.add(tile);
      }
    }
    return Positioned(
      left: 0,
      top: 0,
      child: Container(
        width: boardWidgetState.boardSize().width,
        height: boardWidgetState.boardSize().width,
        decoration: BoxDecoration(
            color: Colors.grey, borderRadius: BorderRadius.circular(6)),
        child: Stack(children: backgroundBox),
      ),
    );
  }
}

class MyGame2048 extends StatefulWidget {
  @override
  _MyGame2048State createState() => _MyGame2048State();
}

class _MyGame2048State extends State<MyGame2048> {
  final GlobalKey<BoardWidgetState> _boardWidgetState =
      GlobalKey<BoardWidgetState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: BoardWidget(
        key: _boardWidgetState,
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _boardWidgetState.currentState.newgame();
          });
        },
        tooltip: 'Restart',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
