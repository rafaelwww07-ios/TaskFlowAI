import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app.dart';
import 'injection.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Configure dependency injection
  await di.configureDependencies();

  runApp(const App());
}
