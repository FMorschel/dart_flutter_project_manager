import 'dart.dart';
import 'firebase.dart';
import 'flutter.dart';
import 'pub.dart';

export 'dart.dart';
export 'firebase.dart';
export 'flutter.dart';
export 'pub.dart';

enum Commands<T extends CommandClass> implements CommandClass {
  flutter(instance: Flutter.instance),
  pub(instance: Pub.instance),
  firebase(instance: Firebase.instance),
  dart(instance: Dart.instance);

  const Commands({required this.instance});

  final T instance;

  @override
  Future<String> help() => instance.help();
}

abstract class BaseCommand implements CommandClass {
  const BaseCommand();
  String which();
}

abstract class CommandClass {
  const CommandClass();
  Future<String> help();
}
