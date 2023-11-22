import 'package:flutter/material.dart';

import 'serializable.dart';

class ThemeModeController
    with ChangeNotifier
    implements Serializable<ThemeMode> {
  ThemeModeController() {
    _controller.addListener(notifyListeners);
  }

  final _controller = ValueNotifier<ThemeMode>(ThemeMode.system);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void setLight() => _controller.value = ThemeMode.light;

  void setDark() => _controller.value = ThemeMode.dark;

  void setSystem() => _controller.value = ThemeMode.system;

  @override
  ThemeMode fromJson(Map<String, dynamic> json) {
    switch (json['themeMode']) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'themeMode': _controller.value.name,
    };
  }

  ThemeMode get value => _controller.value;
}
