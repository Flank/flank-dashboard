import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/injector/widget/injection_container.dart';
import 'package:metrics/common/presentation/metrics_theme/config/text_field_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/dark_metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme_builder.dart';
import 'package:metrics/common/presentation/routes/route_generator.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:provider/provider.dart';

import 'common/presentation/metrics_theme/config/color_config.dart';

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
        builder: (context, themeNotifier) {
          final isDark = themeNotifier?.isDark ?? true;

          return MaterialApp(
            title: CommonStrings.metrics,
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            onGenerateRoute: (settings) => RouteGenerator.generateRoute(
              settings: settings,
              isLoggedIn:
                  Provider.of<AuthNotifier>(context, listen: false).isLoggedIn,
            ),
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.teal,
              primaryColorBrightness: Brightness.light,
              textTheme: GoogleFonts.robotoTextTheme(
                Typography.blackMountainView,
              ),
              scaffoldBackgroundColor: ColorConfig.lightScaffoldColor,
              inputDecorationTheme: const InputDecorationTheme(
                filled: true,
                fillColor: Colors.white,
                border: TextFieldConfig.border,
                hintStyle: TextFieldConfig.hintStyle,
                contentPadding: EdgeInsets.all(16.0),
              ),
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.teal,
              primaryColorBrightness: Brightness.dark,
              textTheme: GoogleFonts.robotoTextTheme(
                Typography.whiteMountainView,
              ),
              scaffoldBackgroundColor: ColorConfig.darkScaffoldColor,
              inputDecorationTheme: const InputDecorationTheme(
                filled: true,
                fillColor: DarkMetricsThemeData.inputColor,
                border: TextFieldConfig.border,
                hintStyle: TextFieldConfig.hintStyle,
                contentPadding: EdgeInsets.all(16.0),
              ),
            ),
          );
        },
      ),
    );
  }
}
