import 'dart:ui';

import 'package:fill_field/src/field.dart';
import 'package:fill_field/src/game_pattern.dart';

class GameField {
  GameField(this._size) {
    _field = [];
    for (int x = 0; x < width; x++) {
      _field.add([]);
      for (int y = 0; y < height; y++) {
        _field.last.add(OneField(const Color.fromARGB(0, 0, 0, 0), true));
      }
    }
  }

  GameField.fromField(GameField field) {
    _field = List.generate(
        field.width, (x) => List.generate(field.height, (y) => field[x][y]));
    _size = field._size;
  }

  List<int> _size = [0, 0];
  List<List<OneField>> _field = [];

  bool canAdd(int dx, int dy, GamePattern pattern) {
    if (dx < 0 || dy < 0) return false;
    if (dx + pattern.width - 1 >= width) return false;
    if (dy + pattern.height - 1 >= height) return false;

    for (int x = 0; x < pattern.width; x++) {
      for (int y = 0; y < pattern.height; y++) {
        if (!pattern[x][y].free) {
          if (!_field[x + dx][y + dy].free) return false;
        }
      }
    }
    return true;
  }

  GameField addField(int dx, int dy, GamePattern pattern) {
    var newField = GameField.fromField(this);

    for (int x = 0; x < pattern.width; x++) {
      for (int y = 0; y < pattern.height; y++) {
        if (!pattern[x][y].free) {
          newField[x + dx][y + dy] = pattern[x][y];
        }
      }
    }

    return newField;
  }

  RemoveFilter checkFullLines() {
    var filter = RemoveFilter([width, height]);

    for (var x = 0; x < width; x++) {
      bool haveFree = false;
      for (var y = 0; y < height; y++) {
        if (this[x][y].free) haveFree = true;
      }
      if (!haveFree) filter.addVertical(x);
    }

    for (var y = 0; y < height; y++) {
      bool haveFree = false;
      for (var x = 0; x < width; x++) {
        if (this[x][y].free) haveFree = true;
      }
      if (!haveFree) filter.addHorisontal(y);
    }

    return filter;
  }

  void removeByFilter(RemoveFilter filter) {
    for (var x = 0; x < width; x++) {
      for (var y = 0; y < height; y++) {
        if (filter.shouldRemove(x, y)) this[x][y] = OneField.empty();
      }
    }
  }

  void paintByFilter(Color color, RemoveFilter filter) {
    for (var x = 0; x < width; x++) {
      for (var y = 0; y < height; y++) {
        if (filter.shouldRemove(x, y)) {
          this[x][y] = OneField(color, this[x][y].free);
        }
      }
    }
  }

  bool canAddPatterns(List<GamePattern> patterns) {
    for (var pattern in patterns) {
      for (var x = 0; x < width; x++) {
        for (var y = 0; y < height; y++) {
          if (canAdd(x, y, pattern)) return true;
        }
      }
    }
    return false;
  }

  GameLine operator [](index) => GameLine(_field[index]);
  int get width => _size[0];
  int get height => _size[1];
  List<int> get size => [width, height];
  bool get isClear {
    for (var line in _field) {
      for (var field in line) {
        if (!field.free) return false;
      }
    }
    return true;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {"size": _size, "field": {}};

    for (int x = 0; x < width; x++) {
      result['field'][x.toString()] = {};
      for (int y = 0; y < height; y++) {
        result['field'][x.toString()][y.toString()] = this[x][y].toMap();
      }
    }
    return result;
  }

  GameField.fromMap(Map<String, dynamic> data) {
    var size = data['size'];
    _size = [size[0], size[1]];

    _field = List.generate(
      _size[0],
      (x) => List.generate(
        _size[1],
        (y) => OneField.fromMap(data['field'][x.toString()][y.toString()]),
      ),
    );
  }
}

class RemoveFilter {
  RemoveFilter(this._fieldSize) {
    verticals = {};
    horisontals = {};
  }

  late Set<int> verticals;
  late Set<int> horisontals;
  final List<int> _fieldSize;

  bool get isNotEmpty => verticals.isNotEmpty || horisontals.isNotEmpty;
  bool get isEmpty => !isNotEmpty;
  void addVertical(int line) => verticals.add(line);
  void addHorisontal(int line) => horisontals.add(line);
  bool shouldRemove(int x, int y) =>
      verticals.contains(x) | horisontals.contains(y);

  int get area =>
      verticals.length * _fieldSize[1] +
      _fieldSize[0] * horisontals.length -
      verticals.length * horisontals.length;
}
