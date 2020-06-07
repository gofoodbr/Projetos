import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_food_br/src/app-widget.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}