class GameMode {
  GameMode(this.size, {this.loadOld = false});

  bool loadOld;
  List<int> size;

  String get encode {
    return "${size[0]}_${size[1]}";
  }
}
