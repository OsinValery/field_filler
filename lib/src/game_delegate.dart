import 'dart:convert';

import 'package:fill_field/src/file_manager.dart';
import 'package:fill_field/src/game_field.dart';
import 'package:fill_field/src/game_mode.dart';
import 'package:fill_field/src/game_pattern.dart';
import 'package:fill_field/src/pattern_generator.dart';

class GameDelegate {
  static final _inst = GameDelegate._();
  factory GameDelegate() => _inst;
  GameDelegate._();

  var gameField = GameField([6, 6]);
  GameField? tmpField;
  List<GamePattern> patterns = [];
  int points = 0;
  var patternsGenerator = PatternGenerator();

  Future initGameState(GameMode gameMode) async {
    gameField = GameField(gameMode.size);
    patterns = List.generate(3, (index) => patternsGenerator.getPattern());
    points = 0;
    if (gameMode.loadOld) await loadState();
  }

  checkCanRemove(removeColor) {
    var removeFilter = tmpField!.checkFullLines();
    tmpField!.paintByFilter(removeColor, removeFilter);
    return removeFilter;
  }

  GameField applyGamePattern(int dx, int dy, GamePattern pattern) {
    tmpField = gameField.addField(dx, dy, pattern);
    patterns.remove(pattern);

    points += pattern.area;
    return tmpField!;
  }

  int finishMovement(RemoveFilter filter, GamePattern pattern) {
    tmpField?.removeByFilter(filter);
    if (filter.isNotEmpty) {
      points += filter.area;
    }

    gameField = tmpField!;
    tmpField = null;
    int status = 0;
    if (gameField.isClear) {
      status = 1;
      points += 50;
    }

    if (patterns.isEmpty) {
      patterns = List.generate(3, (index) => patternsGenerator.getPattern());
    }
    if (!gameField.canAddPatterns(patterns)) status = 2;
    saveState();
    return status;
  }

  Future saveState() async {
    Map<String, dynamic> data = {
      'points': points,
      "size": gameField.size,
      "field": gameField.toMap(),
      "patterns": patterns.map((e) => e.toMap()).toList(),
    };

    return await FileManager().writeFile(
      'lastGame.json',
      const JsonEncoder().convert(data),
    );
  }

  Future loadState() async {
    var content = await FileManager().readFile('lastGame.json');
    if (content != null) {
      try {
        Map<String, dynamic> data = const JsonDecoder().convert(content);
        patterns = (data["patterns"] as List)
            .map((e) => GamePattern.fromMap(e))
            .toList();
        gameField = GameField.fromMap(data['field']);

        points = data['points'];
      } catch (_) {
        saveState();
      }
    }
  }

  Future<bool> haveSavedGame() async {
    return FileManager().haveFile('lastGame.json');
  }

  void deleteLastGame() {
    return FileManager().deleteFile('lastGame.json');
  }
}
