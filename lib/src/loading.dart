import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'global/global.dart';
import 'home.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  static const routeName = '/';

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SharedPreferences.getInstance().then(
        (sp) {
          context.read<ValueNotifier<SharedPreferences?>>().value = sp;
          final theme = _getTheme(sp);
          final controller = context.read<ThemeModeController>();
          final mode = controller.fromJson({'themeMode': theme});
          switch (mode) {
            case ThemeMode.light:
              controller.setLight();
              break;
            case ThemeMode.dark:
              controller.setDark();
              break;
            case ThemeMode.system:
            default:
              controller.setSystem();
              break;
          }
          context.go(HomePage.routeName);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  String? _getTheme(SharedPreferences sp) {
    try {
      return sp.getString('themeMode');
    } catch (e) {
      return null;
    }
  }
}
