// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/analytics/presentation/state/analytics_notifier.dart';
import 'package:metrics/common/presentation/injector/widget/injection_container.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/metrics_theme/config/metrics_colors.dart';
import 'package:metrics/common/presentation/metrics_theme/config/text_field_config.dart';
import 'package:metrics/common/presentation/metrics_theme/config/text_style_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/dark_metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/light_metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme_builder.dart';
import 'package:metrics/common/presentation/navigation/metrics_route_information_parser.dart';
import 'package:metrics/common/presentation/navigation/metrics_router_delegate.dart';
import 'package:metrics/common/presentation/navigation/route_configuration/route_configuration_factory.dart';
import 'package:metrics/common/presentation/navigation/state/navigation_notifier.dart';
import 'package:metrics/common/presentation/routes/observers/firebase_analytics_route_observer.dart';
import 'package:metrics/common/presentation/routes/observers/overlay_entry_route_observer.dart';
import 'package:metrics/common/presentation/routes/observers/toast_route_observer.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/metrics_fps_monitor.dart';
import 'package:metrics/common/presentation/widgets/metrics_scroll_behavior.dart';
import 'package:metrics_core/metrics_core.dart';
import 'package:provider/provider.dart';

/// The root widget of the application.
class MetricsApp extends StatefulWidget {
  /// A [MetricsConfig] to use within this application.
  final MetricsConfig metricsConfig;

  /// Creates a new instance of the [MetricsApp].
  ///
  /// The [metricsConfig] must not be `null`.
  const MetricsApp({
    Key key,
    @required this.metricsConfig,
  })  : assert(metricsConfig != null),
        super(key: key);

  @override
  _MetricsAppState createState() => _MetricsAppState();
}

class _MetricsAppState extends State<MetricsApp> {
  /// A route observer used to dismiss all opened toasts
  /// when the page route changes.
  final _toastRouteObserver = ToastRouteObserver();

  /// A route observer used to close all opened overlay entries
  /// when the page route changes.
  final _userMenuRouteObserver = OverlayEntryRouteObserver();

  @override
  Widget build(BuildContext context) {
    return InjectionContainer(
      metricsConfig: widget.metricsConfig,
      child: Builder(
        builder: (context) {
          final navigationNotifier = Provider.of<NavigationNotifier>(
            context,
            listen: false,
          );
          final analyticsNotifier = Provider.of<AnalyticsNotifier>(
            context,
            listen: false,
          );

          final analyticsObserver = FirebaseAnalyticsRouteObserver(
            analyticsNotifier: analyticsNotifier,
          );

          final routerDelegate = MetricsRouterDelegate(
            navigationNotifier,
            navigatorObservers: [
              _toastRouteObserver,
              _userMenuRouteObserver,
              analyticsObserver,
            ],
          );

          final routeInformationParser = MetricsRouteInformationParser(
            RouteConfigurationFactory(),
          );

          return MetricsFPSMonitor(
            child: MetricsThemeBuilder(
              builder: (context, themeNotifier) {
                final isDark = themeNotifier?.isDark ?? true;

                return MaterialApp.router(
                  routeInformationParser: routeInformationParser,
                  routerDelegate: routerDelegate,
                  title: CommonStrings.metrics,
                  debugShowCheckedModeBanner: false,
                  builder: (context, child) {
                    return ScrollConfiguration(
                      behavior: MetricsScrollBehavior(),
                      child: child,
                    );
                  },
                  themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                  theme: ThemeData(
                    fontFamily: TextStyleConfig.defaultFontFamily,
                    brightness: Brightness.light,
                    primarySwatch: Colors.teal,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    primaryColorBrightness: Brightness.light,
                    buttonTheme: const ButtonThemeData(
                      height: DimensionsConfig.buttonHeight,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    scaffoldBackgroundColor: MetricsColors.white,
                    inputDecorationTheme: InputDecorationTheme(
                      filled: true,
                      fillColor: MetricsColors.gray[100],
                      hoverColor: MetricsColors.gray[100],
                      border: TextFieldConfig.border,
                      enabledBorder: TextFieldConfig.border,
                      focusedBorder: LightMetricsThemeData.inputFocusedBorder,
                      errorStyle: TextFieldConfig.errorStyle,
                      errorBorder: TextFieldConfig.errorBorder,
                      focusedErrorBorder: TextFieldConfig.errorBorder,
                      hintStyle: LightMetricsThemeData.hintStyle,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                    ),
                    dialogTheme: const DialogTheme(elevation: 0.0),
                  ),
                  darkTheme: ThemeData(
                    fontFamily: TextStyleConfig.defaultFontFamily,
                    brightness: Brightness.dark,
                    primarySwatch: Colors.teal,
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    primaryColorBrightness: Brightness.dark,
                    buttonTheme: const ButtonThemeData(
                      height: DimensionsConfig.buttonHeight,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    scaffoldBackgroundColor: MetricsColors.gray[800],
                    inputDecorationTheme: InputDecorationTheme(
                      filled: true,
                      fillColor: MetricsColors.gray[900],
                      hoverColor: MetricsColors.black,
                      border: TextFieldConfig.border,
                      enabledBorder: TextFieldConfig.border,
                      focusedBorder: DarkMetricsThemeData.inputFocusedBorder,
                      errorStyle: TextFieldConfig.errorStyle,
                      errorBorder: TextFieldConfig.errorBorder,
                      focusedErrorBorder: TextFieldConfig.errorBorder,
                      hintStyle: DarkMetricsThemeData.hintStyle,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                    ),
                    dialogTheme: const DialogTheme(elevation: 0.0),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
