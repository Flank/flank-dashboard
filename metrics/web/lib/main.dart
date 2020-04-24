import 'package:flutter/material.dart';
import 'package:metrics/features/auth/presentation/state/auth_store.dart';
import 'package:metrics/features/common/presentation/injector/widget/injection_container.dart';
import 'package:metrics/features/common/presentation/metrics_theme/widgets/metrics_theme_builder.dart';
import 'package:metrics/features/common/presentation/routes/route_generator.dart';
import 'package:metrics/features/common/presentation/strings/common_strings.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

import 'features/common/presentation/metrics_theme/config/color_config.dart';

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
            title: CommonStrings.metrics,
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            onGenerateRoute: (settings) => RouteGenerator.generateRoute(
              settings: settings,
              isLoggedIn: Injector.get<AuthStore>().isLoggedIn,
            ),
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
          );
        },
      ),
    );
  }
}
