import 'package:flutter/material.dart';
import 'package:metrics/ui/home.dart';
import 'package:metrics/utils/app_strings.dart';
import 'package:metrics/utils/app_theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {  
   MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appNameForOs,
      theme: basicTheme(),
      home: HomePage(),
    );
  }
}

