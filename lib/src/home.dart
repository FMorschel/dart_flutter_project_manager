import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'classes/classes.dart';
import 'global/global.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  static const routeName = '/home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final completer = ValueNotifier<Completer<void>>(Completer()..complete());
  final controller = TextEditingController();

  late ThemeData theme;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    theme = Theme.of(context);
  }

  @override
  void dispose() {
    completer.value.complete();
    completer.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dart/Flutter Project Manager'),
        ),
        body: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: ChangeTheme()),
            ),
            const Gap(32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final command
                    in Commands.values.where((c) => c.instance is BaseCommand))
                  FilledButton(
                    onPressed: () {
                      controller.text =
                          (command.instance as BaseCommand).which();
                    },
                    child: Text('Which ${command.name}'),
                  ),
              ],
            ),
            const Gap(32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final command in Commands.values)
                  FilledButton(
                    onPressed: () async {
                      completer.value = Completer();
                      controller.text = await command.help();
                      completer.value.complete();
                    },
                    child: Text('Help ${command.name}'),
                  ),
              ],
            ),
            ValueListenableBuilder(
              valueListenable: completer,
              builder: (context, completer, _) {
                return FutureBuilder(
                  future: completer.future,
                  builder: (context, asyncSnapshot) {
                    if (!completer.isCompleted) {
                      return const CircularProgressIndicator();
                    }
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Stack(
                        children: [
                          TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            controller: controller,
                            readOnly: true,
                            maxLines: 12,
                          ),
                          const Positioned(
                            bottom: 0,
                            top: 0,
                            right: 0,
                            left: 0,
                            child: MouseRegion(
                              cursor: SystemMouseCursors.basic,
                              hitTestBehavior: HitTestBehavior.translucent,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChangeTheme extends StatefulWidget {
  const ChangeTheme({
    this.direction = Axis.horizontal,
    super.key,
  });

  final Axis direction;

  @override
  State<ChangeTheme> createState() => _ChangeThemeState();
}

class _ChangeThemeState extends State<ChangeTheme> {
  late ThemeModeController controller;
  late SharedPreferences sp;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = context.watch();
    sp = context.read<ValueNotifier<SharedPreferences?>>().value!;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: widget.direction,
      child: Flex(
        direction: widget.direction,
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final mode in ThemeMode.values) ...[
            FilledButton(
              onPressed: () => _setMode(mode),
              child: Text(mode.name.capitalize()),
            ),
            const Gap(32),
          ],
        ],
      ),
    );
  }

  void _setMode(ThemeMode mode) {
    final _ = switch (mode) {
      ThemeMode.light => controller.setLight(),
      ThemeMode.dark => controller.setDark(),
      ThemeMode.system => controller.setSystem(),
    };
    final json = controller.toJson();
    sp.setString('themeMode', json['themeMode'] as String);
  }
}
