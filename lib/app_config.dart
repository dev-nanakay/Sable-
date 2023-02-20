import 'package:flutter/material.dart';
import 'package:sac_wallet/util/api_config.dart';

class AppConfig extends InheritedWidget {
  final ApiConfig config;

  AppConfig({required this.config, required Widget child}) : super(child: child);

  static AppConfig of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppConfig>()!;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}
