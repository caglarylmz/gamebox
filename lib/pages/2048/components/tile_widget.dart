import 'package:flutter/material.dart';
import 'package:game_box/pages/2048/components/animated_tile_widget.dart';
import 'package:game_box/pages/2048/components/board_widget.dart';
import 'package:game_box/pages/2048/entities/tile.dart';

class TileWidget extends StatefulWidget {
  final Tile tile;
  final BoardWidgetState state;

  const TileWidget({Key key, this.tile, this.state}) : super(key: key);
  @override
  _TileWidgetState createState() => _TileWidgetState();
}

class _TileWidgetState extends State<TileWidget>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(duration: Duration(microseconds: 200), vsync: this);
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    widget.tile.isNew = false;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tile.isNew && !widget.tile.isEmpty()) {
      _controller.reset();
      _controller.forward();
      widget.tile.isNew = false;
    } else
      _controller.animateTo(1.0);

    return AnimatedTileWidget(
      tile: widget.tile,
      boardWidgetState: widget.state,
      animation: _animation,
    );
  }
}
