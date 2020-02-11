class Tile {
  int row;
  int column;
  int value;
  bool canMerge;
  bool isNew;

  Tile({this.row, this.column, this.value = 0, this.canMerge, this.isNew});

  bool isEmpty() => value == 0;

  //a==b için
  @override
  int get hashCode{
    return value.hashCode;
  }

}
