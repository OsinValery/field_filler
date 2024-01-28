import 'dart:math';
import 'dart:ui';

import 'field.dart';

class GamePattern {
  List<List<OneField>> pattern = [];

  GamePattern(List<List<int>> template) {
    pattern = [];
    int w = template.length;
    int h = template.first.length;
    var rand = Random();
    var color = const Color.fromARGB(255, 255, 255, 255);
    const orange = Color.fromARGB(255, 243, 167, 15);
    const yellow = Color.fromARGB(255, 255, 255, 0);

    do {
      color = Color.fromARGB(
        255,
        rand.nextInt(256),
        rand.nextInt(256),
        rand.nextInt(256),
      );
    } while ((color.difference(orange) < 100) ||
        (color.computeLuminance() > 0.4) ||
        (color.difference(yellow) < 200));

    for (int x = 0; x < w; x++) {
      pattern.add([]);
      for (int y = 0; y < h; y++) {
        pattern.last.add(OneField(color, template[x][y] == 0));
      }
    }
  }

  GameLine operator [](index) => GameLine(pattern[index]);
  List<int> get size => [pattern.length, pattern.first.length];
  int get width => pattern.length;
  int get height => pattern.first.length;
  int get area {
    int area = 0;
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        if (!this[x][y].free) area++;
      }
    }
    return area;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> result = {"size": size, "field": {}};

    for (int x = 0; x < width; x++) {
      result['field'][x.toString()] = {};
      for (int y = 0; y < height; y++) {
        result['field'][x.toString()][y.toString()] = this[x][y].toMap();
      }
    }
    return result;
  }

  GamePattern.fromMap(Map<String, dynamic> data) {
    var size = data['size'];
    pattern = List.generate(
      size[0],
      (x) => List.generate(
        size[1],
        (y) => OneField.fromMap(data['field'][x.toString()][y.toString()]),
      ),
    );
  }
}

class GameLine {
  GameLine(this._line);
  final List<OneField> _line;

  OneField operator [](index) => _line[index];
  operator []=(index, OneField value) => _line[index] = value;
}

extension ColorWithDifference on Color {
  double difference(Color other) {
    int r = red - other.red;
    int g = green - other.green;
    int b = blue - other.blue;
    return (sqrt(r * r + g * g) + sqrt(g * g + b * b) + sqrt(b * b + r * r)) /
        3;
  }
}
