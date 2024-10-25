import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hospital_management/app/app.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  runApp(const MyApp());
}
