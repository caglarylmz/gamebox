import 'package:flutter/material.dart';
import 'package:game_box/pages/2048/components/board_widget.dart';
import 'package:game_box/pages/2048/components/tile_box.dart';
import 'package:game_box/pages/2048/entities/tile.dart';
import 'package:game_box/pages/2048/utils/tile_colors.dart';

class AnimatedTileWidget extends AnimatedWidget {
  final Tile tile;
  final BoardWidgetState boardWidgetState;

  AnimatedTileWidget(
      {Key key, this.tile, this.boardWidgetState, Animation<double> animation})
      : super(key: key, listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    double animationValue = animation.value;
    Size boardSize = boardWidgetState.boardSize();
    double width = (boardSize.width -
            (boardWidgetState.column + 1) * boardWidgetState.tilePadding) /
        boardWidgetState.column;

    if (tile.value == 0) {
      return Container(
      );
    } else {
      return TileBox(
        left: (tile.column * width +
                boardWidgetState.tilePadding * (tile.column + 1)) +
            width / 2 * (1 - animationValue),
        top: tile.row * width +
            boardWidgetState.tilePadding * (tile.row + 1) +
            width / 2 * (1 - animationValue),
        size: width * animationValue,
        color: tileColors.containsKey(tile.value)
            ? tileColors[tile.value]
            : Colors.orange[50],
        text: Text("${tile.value}"),
      );
    }
  }
}
