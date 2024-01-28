import 'package:fill_field/src/file_manager.dart';
import 'package:fill_field/src/game_mode.dart';

class BestScoreLoader {
  static const filename = "scores";

  void saveScore(int points, GameMode mode) {
    var fileManager = FileManager();
    fileManager.createDirectory(filename);

    String filePath = fileManager.joinPaths([filename, mode.encode]);
    fileManager.writeFile(filePath, points.toString());
  }

  Future<int> getScore(GameMode mode) async {
    var fileManager = FileManager();
    String filePath = fileManager.joinPaths([filename, mode.encode]);
    String? content = await fileManager.readFile(filePath);
    if (content == null) return 0;
    return int.tryParse(content) ?? 0;
  }
}
