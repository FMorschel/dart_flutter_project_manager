import 'package:process_run/cmd_run.dart';
import 'package:process_run/process_run.dart';

import 'classes.dart';

class Dart implements BaseCommand {
  const Dart._();

  static const instance = Dart._();

  @override
  String which() => whichSync('dart') ?? '';

  @override
  Future<String> help() async {
    final processResult = await runCmd(ProcessCmd(which(), ['--help']));
    return processResult.outText;
  }
}
