import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/injector/widget/injection_container.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme_builder.dart';
import 'package:metrics/features/dashboard/presentation/pages/dashboard_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return InjectionContainer(
      child: MetricsThemeBuilder(
        child: MaterialApp(
          title: 'Flutter Demo',
          routes: {
            '/dashboard': (context) => DashboardPage(),
          },
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Bebas Neue',
          ),
          home: DashboardPage(),
        ),
      ),
    );
  }
}
