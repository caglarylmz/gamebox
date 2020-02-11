import 'dart:math';

import 'package:game_box/pages/2048/entities/tile.dart';

class Board {
  final int row;
  final int column;
  int score;

  Board(this.row, this.column);

  List<List<Tile>> _boardTiles;

  // Board'u oluşturuyoruz. (4X4 matris)
  void initBoard() {
    _boardTiles = List.generate(
        4,
        (r) => List.generate(
            4,
            (c) => Tile(
                row: r, column: c, value: 0, isNew: false, canMerge: false)));
    score = 0;
    resetCanMerge();
    randomEmptyTile();
    randomEmptyTile();
  }

  //sola kayma
  void moveLeft() {
    if (!canMoveLeft()) {
      print("cant move left");
      return;
    }
    print("move left");
    for (var r = 0; r < this.row; ++r) {
      for (var c = 0; c < this.column; ++c) {
        mergeLeft(r, c);
      }
    }
    randomEmptyTile();
    resetCanMerge();
  }

  //sağa kayma
  void moveRight() {
    if (!canMoveRight()) {
      print("cant move right");
      return;
    }
    print("move right");
    for (var r = 0; r < this.row; ++r) {
      for (var c = this.column - 2; c >= 0; --c) {
        mergeRight(r, c);
      }
    }
    randomEmptyTile();
    resetCanMerge();
  }

  //yukarı kayma
  void moveUp() {
    if (!canMoveUp()) {
      print("cant move up");
      return;
    }
    print("move up");
    for (var r = 0; r < this.row; ++r) {
      for (var c = 0; c < this.column; ++c) {
        mergeUp(r, c);
      }
    }
    randomEmptyTile();
    resetCanMerge();
  }

//aşağı kayma
  void moveDown() {
    if (!canMoveDown()) {
      print("cant move down");
      return;
    }
    print("move down");
    for (var r = this.row - 2; r >= 0; --r) {
      for (var c = 0; c < this.column; ++c) {
        mergeDown(r, c);
      }
    }
    randomEmptyTile();
    resetCanMerge();
  }

  //sola kaydırıldığında Tile'ın gidebilir olduğunu kontrol ediyoruz
  bool canMoveLeft() {
    for (int r = 0; r < this.row; ++r) {
      for (int c = 1; c < this.column; ++c) {
        if (canMerge(_boardTiles[r][c], _boardTiles[r][c - 1])) return true;
      }
    }
    return false;
  }

  //sağa kaydırıldığında Tile'ın gidebilir olduğunu kontrol ediyoruz
  bool canMoveRight() {
    for (int r = 0; r < this.row; ++r) {
      for (int c = this.column - 2; c >= 0; --c) {
        if (canMerge(_boardTiles[r][c], _boardTiles[r][c + 1])) return true;
      }
    }
    return false;
  }

  //Yukarı kaydırıldığında Tile'ın gidebilir olduğunu kontrol ediyoruz
  bool canMoveUp() {
    for (int r = 1; r < this.row; ++r) {
      for (int c = 0; c < this.column; ++c) {
        if (canMerge(_boardTiles[r][c], _boardTiles[r - 1][c])) return true;
      }
    }
    return false;
  }

  //Aşağı kaydırıldığında Tile'ın gidebilir olduğunu kontrol ediyoruz
  bool canMoveDown() {
    for (int r = this.row - 2; r >= 0; --r) {
      for (int c = 0; c < this.column; ++c) {
        if (canMerge(_boardTiles[r][c], _boardTiles[r + 1][c])) return true;
      }
    }
    return false;
  }

  //sola doğru kaydırma halinde sütunlarda merge edilebilir tile'ları kontrol ediyoruz
  void mergeLeft(int r, int c) {
    while (c > 0) {
      merge(_boardTiles[r][c], _boardTiles[r][c - 1]);
      // print("merged left $r,$c");
      c--;
    }
  }

  //sağa doğru kaydırma halinde sütunlarda merge edilebilir tile'ları kontrol ediyoruz
  void mergeRight(int r, int c) {
    while (c < this.column - 1) {
      merge(_boardTiles[r][c], _boardTiles[r][c + 1]);
      //print("merged right $r,$c");
      c++;
    }
  }

  //yukarı doğru kaydırma halinde satırlarda merge edilebilir tile'ları kontrol ediyoruz
  void mergeUp(int r, int c) {
    while (r > 0) {
      merge(_boardTiles[r][c], _boardTiles[r - 1][c]);
      //print("merged up $r,$c");

      r--;
    }
  }

  //aşağı doğru kaydırma halinde satırlarda merge edilebilir tile'ları kontrol ediyoruz
  void mergeDown(int r, int c) {
    while (r < this.row - 1) {
      merge(_boardTiles[r][c], _boardTiles[r + 1][c]);
      //print("merged down $r,$c");

      r++;
    }
  }

  //İki Tile birleştirilebilir mi kontrol ediyoruz
  bool canMerge(Tile a, Tile b) {
    //print("a_merge : ${a.canMerge}, a_value:${a.value}, a_isEmpty : ${a.isEmpty()}");
    return !a.canMerge &&
        ((b.value == 0 && a.value != 0) || (a.value != 0 && a.value == b.value));
  }

  //İki Tile'ı birleştiriyoruz
  void merge(Tile a, Tile b) {
    if (!canMerge(a, b)) {
      if (a.value != 0 && !b.canMerge) {
        b.canMerge = true;
      }
      return;
    }
    if (b.value != 0 && (a.value == b.value)) {
      b.value = b.value * 2;
      a.value = 0;
      b.canMerge = true;
      score += b.value;
      print("a=b");
    } else if (b.value == 0) {
      b.value = a.value;
      a.value = 0;
      print("b.isEmpty");
    } else {
      b.canMerge = true;
      print("b.canMerge");
    }
  }

//Board üzerinde row ve column'u verile tile'ı seçmek için
  Tile getTile(int row, int column) => _boardTiles[row][column];

  //Board üzerinde boş Tile'ların rastgele birine 2 değerini atıyoruz
  void randomEmptyTile() {
    List<Tile> emptyTiles = List<Tile>();
    //board üzerindeki tüm boş tile'ları emptyTiles listesine ekliyoruz
    _boardTiles.forEach((rows) {
      emptyTiles.addAll(rows.where((tile) => tile.isEmpty()));
    });
    //Eğer boş tile yoksa çıkıyoruz
    if (emptyTiles.isEmpty) {
      return;
    }

    //emptyTiles listesinde rastgele bir tile seçip ilk değer atıyoruz
    Random rnd = Random();

    int index = rnd.nextInt(emptyTiles.length);
    emptyTiles[index].value = rnd.nextInt(9) == 0 ? 4 : 2;
    emptyTiles[index].isNew = true;
    emptyTiles.removeAt(index);
    //print("r:${emptyTiles[index].row}, c: ${emptyTiles[index].column}");
  }

  //Tile'ları istediğimizde merge edilemez yapmak için
  void resetCanMerge() {
    _boardTiles.forEach((rows) {
      rows.forEach((tile) {
        tile.canMerge = false;
      });
    });
  }

  bool gameOver(){
    return !canMoveLeft() && !canMoveRight() && !canMoveUp() && !canMoveDown();
  }
}
