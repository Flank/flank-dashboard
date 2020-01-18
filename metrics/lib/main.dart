import 'package:flutter/material.dart';
import 'package:metrics/injection_container.dart';
import 'package:metrics/features/dashboard/presentation/pages/dashboard_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Bebas Neue',
      ),
      home: InjectionContainer(
        child: DashboardPage(),
      ),
    );
  }
}
