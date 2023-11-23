import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/directory_searching.dart';
import 'src/global/theme_mode_controller.dart';
import 'src/home.dart';
import 'src/loading.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final sp = ValueNotifier<SharedPreferences?>(null);
  final controller = ThemeModeController();
  final router = GoRouter(
    initialLocation: LoadingPage.routeName,
    routes: [
      GoRoute(
        path: LoadingPage.routeName,
        builder: (context, state) => const LoadingPage(),
      ),
      GoRoute(
        path: HomePage.routeName,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: DirectorySearchingPage.routeName,
        builder: (context, state) => const DirectorySearchingPage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiProvider(
        providers: [
          ListenableProvider.value(value: controller),
          ListenableProvider.value(value: sp),
        ],
        builder: (context, _) {
          return AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              return MaterialApp.router(
                title: 'Dart/Flutter Project Manager',
                routerConfig: router,
                themeMode: controller.value,
                darkTheme: ThemeData.from(
                  colorScheme: ColorScheme.fromSeed(
                    brightness: Brightness.dark,
                    seedColor: Colors.teal,
                  ),
                ),
                theme: ThemeData.from(
                  colorScheme: ColorScheme.fromSeed(
                    brightness: Brightness.light,
                    seedColor: Colors.teal,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
