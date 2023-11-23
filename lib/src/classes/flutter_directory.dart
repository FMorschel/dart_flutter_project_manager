import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:yaml/yaml.dart';

import 'dart_directory.dart';

extension type FlutterDirectory._(DartDirectory dir) implements DartDirectory {

  static bool isValid(Directory dir) {
    if (!DartDirectory.isValid(dir)) return false;
    final innerData = dir.listSync();
    if (!_pubspecContainsFlutter(innerData: innerData)) return false;
    return true;
  }

  static bool _pubspecContainsFlutter({
    Directory? dir,
    List<FileSystemEntity>? innerData,
  }) {
    assert((innerData != null) || (dir != null));
    innerData ??= dir!.listSync();
    final pubspec = innerData
        .whereType<File>()
        .singleWhere((fse) => p.basename(fse.path) == 'pubspec.yaml');
    final yaml = loadYaml(
      pubspec.readAsStringSync(), 
      sourceUrl: pubspec.uri,
    ) as YamlMap;
    return yaml['flutter'] != null;
  }
}
