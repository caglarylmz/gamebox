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
    if (!canMoveLeft()) return;

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
    if (!canMoveRight()) return;

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
    if (!canMoveUp()) return;

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
    if (!canMoveDown()) return;

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
  void mergeLeft(int row, int col) {
    while (col > 0) {
      merge(_boardTiles[row][col], _boardTiles[row][col - 1]);
      col--;
    }
  }

  //sağa doğru kaydırma halinde sütunlarda merge edilebilir tile'ları kontrol ediyoruz
  void mergeRight(int row, int col) {
    while (col < this.column - 1) {
      merge(_boardTiles[row][col], _boardTiles[row][col + 1]);
      col++;
    }
  }

  //yukarı doğru kaydırma halinde satırlarda merge edilebilir tile'ları kontrol ediyoruz
  void mergeUp(int row, int col) {
    while (row > 0) {
      merge(_boardTiles[row][col], _boardTiles[row - 1][col]);
      row--;
    }
  }

  //aşağı doğru kaydırma halinde satırlarda merge edilebilir tile'ları kontrol ediyoruz
  void mergeDown(int row, int col) {
    while (row < this.row - 1) {
      merge(_boardTiles[row][col], _boardTiles[row + 1][col]);
      row++;
    }
  }

  //İki Tile birleştirilebilir mi kontrol ediyoruz
  bool canMerge(Tile a, Tile b) {
    return !a.canMerge &&
        ((b.isEmpty() && !a.isEmpty()) || (!a.isEmpty() && a == b));
  }

  //İki Tile'ı birleştiriyoruz
  void merge(Tile a, Tile b) {
    if (!canMerge(a, b)) {
      if (!a.isEmpty() && !b.canMerge) {
        b.canMerge = true;
      }
      return;
    }
    if (b.isEmpty()) {
      b.value = a.value;
      a.value = 0;
    } else if (a == b) {
      b.value = b.value * 2;
      a.value = 0;
      b.canMerge = true;
    } else {
      b.canMerge = true;
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
    for (int i = 0; i < 4; i++) {
      int index = rnd.nextInt(emptyTiles.length);
      emptyTiles[index].value = rnd.nextInt(9) == 0 ? 4 : 2;
      emptyTiles[index].isNew = true;
      emptyTiles.removeAt(index);
    }
  }

  //Tile'ları istediğimizde merge edilemez yapmak için
  void resetCanMerge() {
    _boardTiles.forEach((rows) {
      rows.forEach((tile) {
        tile.canMerge = false;
      });
    });
  }
}
