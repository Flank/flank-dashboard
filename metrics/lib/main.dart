import 'package:flutter/material.dart';
import 'package:metrics/circle_progress_store.dart';
import 'package:metrics/ui/home.dart';
import 'package:metrics/utils/app_strings.dart';
import 'package:metrics/utils/app_theme.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'repository/circle_progress_repository.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {  
   MyApp({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appNameForOs,
      theme: basicTheme(),
      home: Injector(
        inject: [
          Inject<CircleProgressStore>(() => CircleProgressStore(FakeCircleProgressRepository())),
          
        ],
        builder: (_) => HomePage(),
      ),
    );
  }
}

