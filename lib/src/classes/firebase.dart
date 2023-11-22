import 'package:process_run/cmd_run.dart';
import 'package:process_run/process_run.dart';

import 'classes.dart';

class Firebase implements BaseCommand {
  const Firebase._();

  static const instance = Firebase._();

  @override
  String which() => whichSync('firebase') ?? '';

  @override
  Future<String> help() async {
    final processResult = await runCmd(ProcessCmd(which(), ['--help']));
    return processResult.outText;
  }
}
