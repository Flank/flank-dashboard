import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/injector/widget/injection_container.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/metrics_theme/config/text_field_config.dart';
import 'package:metrics/common/presentation/metrics_theme/config/text_style_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/dark_metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/light_metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme_builder.dart';
import 'package:metrics/common/presentation/routes/observers/toast_route_observer.dart';
import 'package:metrics/common/presentation/routes/route_generator.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:provider/provider.dart';

void main() => runApp(MetricsApp());

class MetricsApp extends StatefulWidget {
  @override
  _MetricsAppState createState() => _MetricsAppState();
}

class _MetricsAppState extends State<MetricsApp> {
  /// A route observer used to dismiss all opened toasts
  /// when the page route changes.
  final _toastRouteObserver = ToastRouteObserver();

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
            navigatorObservers: [_toastRouteObserver],
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              fontFamily: TextStyleConfig.defaultFontFamily,
              brightness: Brightness.light,
              primarySwatch: Colors.teal,
              primaryColorBrightness: Brightness.light,
              buttonTheme: const ButtonThemeData(
                height: DimensionsConfig.buttonHeight,
              ),
              scaffoldBackgroundColor: LightMetricsThemeData.scaffoldColor,
              inputDecorationTheme: const InputDecorationTheme(
                filled: true,
                fillColor: Colors.white,
                hoverColor: Colors.black,
                border: TextFieldConfig.border,
                focusedBorder: LightMetricsThemeData.inputFocusedBorder,
                errorStyle: TextFieldConfig.errorStyle,
                errorBorder: TextFieldConfig.errorBorder,
                focusedErrorBorder: TextFieldConfig.errorBorder,
                hintStyle: TextFieldConfig.hintStyle,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
            darkTheme: ThemeData(
              fontFamily: TextStyleConfig.defaultFontFamily,
              brightness: Brightness.dark,
              primarySwatch: Colors.teal,
              primaryColorBrightness: Brightness.dark,
              buttonTheme: const ButtonThemeData(
                height: DimensionsConfig.buttonHeight,
              ),
              scaffoldBackgroundColor: DarkMetricsThemeData.scaffoldColor,
              inputDecorationTheme: const InputDecorationTheme(
                filled: true,
                fillColor: DarkMetricsThemeData.inputColor,
                hoverColor: Colors.black,
                border: TextFieldConfig.border,
                focusedBorder: DarkMetricsThemeData.inputFocusedBorder,
                errorStyle: TextFieldConfig.errorStyle,
                errorBorder: TextFieldConfig.errorBorder,
                focusedErrorBorder: TextFieldConfig.errorBorder,
                hintStyle: TextFieldConfig.hintStyle,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          );
        },
      ),
    );
  }
}
