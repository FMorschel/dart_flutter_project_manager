import 'package:process_run/cmd_run.dart';
import 'package:process_run/process_run.dart';

import 'classes.dart';

class Flutter implements BaseCommand {
  const Flutter._();

  static const instance = Flutter._();

  @override
  String which() => whichSync('flutter') ?? '';

  @override
  Future<String> help() async {
    final processResult = await runCmd(ProcessCmd(which(), ['--help']));
    return processResult.outText;
  }
}
