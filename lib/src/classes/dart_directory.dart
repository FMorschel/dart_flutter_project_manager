import 'dart:io';

import 'package:collection/collection.dart';
import 'package:path/path.dart' as p;

extension type DartDirectory._(Directory dir) implements Directory {
  factory DartDirectory(Directory dir) {
    if (!dir.existsSync()) {
      throw ArgumentError.value(dir, 'dir', 'Directory does not exist');
    }
    final innerData = dir.listSync();
    if (innerData.isEmpty) {
      throw ArgumentError.value(dir, 'dir', 'Directory is empty');
    }
    if (_containsPubspec(innerData: innerData)) {
      throw ArgumentError.value(dir, 'dir', 'Directory missing pubspec.yaml');
    }
    if (_containsLibFolder(innerData: innerData)) {
      throw ArgumentError.value(dir, 'dir', 'Directory missing lib directory');
    }
    return DartDirectory._(dir);
  }

  static bool isValid(Directory dir) {
    if (!dir.existsSync()) return false;
    final innerData = dir.listSync();
    if (innerData.isEmpty) return false;
    if (!_containsPubspec(innerData: innerData)) return false;
    if (!_containsLibFolder(innerData: innerData)) return false;
    return true;
  }

  static bool _containsPubspec({
    Directory? dir,
    List<FileSystemEntity>? innerData,
  }) {
    assert((innerData != null) || (dir != null));
    innerData ??= dir!.listSync();
    return innerData.whereType<File>().singleWhereOrNull(
              (fse) => p.basename(fse.path) == 'pubspec.yaml',
            ) !=
        null;
  }

  static bool _containsLibFolder({
    Directory? dir,
    List<FileSystemEntity>? innerData,
  }) {
    assert((innerData != null) || (dir != null));
    innerData ??= dir!.listSync();
    return innerData
            .whereType<Directory>()
            .singleWhereOrNull((fse) => p.basename(fse.path) == 'lib') !=
        null;
  }
}
