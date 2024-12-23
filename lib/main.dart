import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/app_module.dart';
import 'app/app_widget.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.getInstance();
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}