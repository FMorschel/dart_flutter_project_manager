import 'package:process_run/cmd_run.dart';
import 'package:process_run/process_run.dart';

import 'classes.dart';

class Pub implements CommandClass {
  const Pub._();

  static const instance = Pub._();

  @override
  Future<String> help() async {
    final processResult = await runCmd(
      ProcessCmd(Dart.instance.which(), ['pub', '--help']),
    );
    return processResult.outText;
  }
}
