import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:metrics/features/common/presentation/injector/widget/injection_container.dart';
import 'package:metrics/features/common/presentation/metrics_theme/config/color_config.dart';
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
        builder: (context, store) {
          final isDark = store?.isDark ?? true;

          return MaterialApp(
            title: 'Metrics',
            debugShowCheckedModeBanner: false,
            routes: {
              '/dashboard': (context) => DashboardPage(),
            },
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.teal,
              primaryColorBrightness: Brightness.light,
              cardColor: ColorConfig.lightScaffoldColor,
              fontFamily: 'Roboto',
              appBarTheme: const AppBarTheme(
                color: ColorConfig.lightScaffoldColor,
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.teal,
              primaryColorBrightness: Brightness.dark,
              scaffoldBackgroundColor: ColorConfig.darkScaffoldColor,
              cardColor: ColorConfig.darkScaffoldColor,
              fontFamily: 'Roboto',
              appBarTheme: const AppBarTheme(
                color: ColorConfig.darkScaffoldColor,
              ),
            ),
            home: DashboardPage(),
          );
        },
      ),
    );
  }
}
