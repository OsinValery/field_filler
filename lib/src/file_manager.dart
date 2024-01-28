import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class FileManager {
  static final _inst = FileManager._();
  FileManager._();
  factory FileManager() => _inst;

  var _rooPath = "";

  Future initManager() async {
    _rooPath = (await getApplicationDocumentsDirectory()).path;
    print(_rooPath);
  }

  String _resolvePath(String path, bool isInternal) {
    if (!isInternal) return path;
    return join(_rooPath, path);
  }

  String joinPaths(List<String> paths) => joinAll(paths);

  Future writeFile(
    String path,
    String content, {
    bool isInternal = true,
  }) async {
    String fullPath = _resolvePath(path, isInternal);
    File file = File(fullPath);
    if (await file.exists()) await file.delete();
    await file.create();
    return await file.writeAsString(content);
  }

  Future<String?> readFile(String path, {bool isInternal = true}) async {
    String fullPath = _resolvePath(path, isInternal);
    File file = File(fullPath);
    if (!file.existsSync()) return null;
    return file.readAsString();
  }

  void createDirectory(String path, {bool isInternal = true}) {
    var dir = Directory(_resolvePath(path, isInternal));
    if (!dir.existsSync()) dir.createSync();
  }

  Future<bool> haveFile(String path, {bool isInternal = true}) {
    var file = File(_resolvePath(path, isInternal));
    return file.exists();
  }

  void deleteFile(String path, {bool isInternal = true}) {
    var file = File(_resolvePath(path, isInternal));
    if (file.existsSync()) file.deleteSync();
  }
}
