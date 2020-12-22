import 'package:flutter/material.dart';
import 'package:metrics/analytics/presentation/state/analytics_notifier.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/injector/widget/injection_container.dart';
import 'package:metrics/common/presentation/metrics_theme/config/color_config.dart';
import 'package:metrics/common/presentation/metrics_theme/config/dimensions_config.dart';
import 'package:metrics/common/presentation/metrics_theme/config/text_field_config.dart';
import 'package:metrics/common/presentation/metrics_theme/config/text_style_config.dart';
import 'package:metrics/common/presentation/metrics_theme/model/dark_metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/model/light_metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme_builder.dart';
import 'package:metrics/common/presentation/routes/observers/firebase_analytics_route_observer.dart';
import 'package:metrics/common/presentation/routes/observers/overlay_entry_route_observer.dart';
import 'package:metrics/common/presentation/routes/observers/toast_route_observer.dart';
import 'package:metrics/common/presentation/routes/route_generator.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/widgets/metrics_fps_monitor.dart';
import 'package:metrics/common/presentation/widgets/metrics_scroll_behavior.dart';
import 'package:metrics/feature_config/presentation/state/feature_config_notifier.dart';
import 'package:metrics/util/favicon.dart';
import 'package:provider/provider.dart';

void main() {
  Favicon().setup();
  runApp(MetricsApp());
}

/// The root widget of the application.
class MetricsApp extends StatefulWidget {
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
      child: MetricsFPSMonitor(
        child: MetricsThemeBuilder(
          builder: (context, themeNotifier) {
            final isDark = themeNotifier?.isDark ?? true;

            return Consumer<AnalyticsNotifier>(
              builder: (context, analyticsNotifier, _) {
                final _analyticsObserver = FirebaseAnalyticsRouteObserver(
                  analyticsNotifier: analyticsNotifier,
                );

                return MaterialApp(
                  title: CommonStrings.metrics,
                  debugShowCheckedModeBanner: false,
                  builder: (context, child) {
                    return ScrollConfiguration(
                      behavior: MetricsScrollBehavior(),
                      child: child,
                    );
                  },
                  initialRoute: '/',
                  onGenerateInitialRoutes: (String initialRoute) {
                    final isLoggedIn = Provider.of<AuthNotifier>(
                      context,
                      listen: false,
                    ).isLoggedIn;

                    final isDebugMenuEnabled =
                        Provider.of<FeatureConfigNotifier>(
                              context,
                              listen: false,
                            ).debugMenuFeatureConfigViewModel?.isEnabled ??
                            false;

                    return [
                      RouteGenerator.generateRoute(
                        settings: RouteSettings(name: initialRoute),
                        isLoggedIn: isLoggedIn,
                        isDebugMenuEnabled: isDebugMenuEnabled,
                      ),
                    ];
                  },
                  onGenerateRoute: (settings) {
                    final isLoggedIn = Provider.of<AuthNotifier>(
                      context,
                      listen: false,
                    ).isLoggedIn;

                    final isDebugMenuEnabled =
                        Provider.of<FeatureConfigNotifier>(
                              context,
                              listen: false,
                            ).debugMenuFeatureConfigViewModel?.isEnabled ??
                            false;

                    return RouteGenerator.generateRoute(
                      settings: settings,
                      isLoggedIn: isLoggedIn,
                      isDebugMenuEnabled: isDebugMenuEnabled,
                    );
                  },
                  navigatorObservers: [
                    _toastRouteObserver,
                    _userMenuRouteObserver,
                    _analyticsObserver,
                  ],
                  themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
                  theme: ThemeData(
                    fontFamily: TextStyleConfig.defaultFontFamily,
                    brightness: Brightness.light,
                    primarySwatch: Colors.teal,
                    splashColor: ColorConfig.inkResponseColor,
                    highlightColor: ColorConfig.inkResponseColor,
                    primaryColorBrightness: Brightness.light,
                    buttonTheme: const ButtonThemeData(
                      height: DimensionsConfig.buttonHeight,
                      splashColor: ColorConfig.inkResponseColor,
                      highlightColor: ColorConfig.inkResponseColor,
                    ),
                    scaffoldBackgroundColor:
                        LightMetricsThemeData.scaffoldColor,
                    inputDecorationTheme: const InputDecorationTheme(
                      filled: true,
                      fillColor: LightMetricsThemeData.inputColor,
                      hoverColor: LightMetricsThemeData.inputHoverColor,
                      border: TextFieldConfig.border,
                      enabledBorder: TextFieldConfig.border,
                      focusedBorder: LightMetricsThemeData.inputFocusedBorder,
                      errorStyle: TextFieldConfig.errorStyle,
                      errorBorder: TextFieldConfig.errorBorder,
                      focusedErrorBorder: TextFieldConfig.errorBorder,
                      hintStyle: LightMetricsThemeData.hintStyle,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    dialogTheme: const DialogTheme(elevation: 0.0),
                  ),
                  darkTheme: ThemeData(
                    fontFamily: TextStyleConfig.defaultFontFamily,
                    brightness: Brightness.dark,
                    primarySwatch: Colors.teal,
                    splashColor: ColorConfig.inkResponseColor,
                    highlightColor: ColorConfig.inkResponseColor,
                    primaryColorBrightness: Brightness.dark,
                    buttonTheme: const ButtonThemeData(
                      height: DimensionsConfig.buttonHeight,
                      splashColor: ColorConfig.inkResponseColor,
                      highlightColor: ColorConfig.inkResponseColor,
                    ),
                    scaffoldBackgroundColor: DarkMetricsThemeData.scaffoldColor,
                    inputDecorationTheme: const InputDecorationTheme(
                      filled: true,
                      fillColor: DarkMetricsThemeData.inputColor,
                      hoverColor: Colors.black,
                      border: TextFieldConfig.border,
                      enabledBorder: TextFieldConfig.border,
                      focusedBorder: DarkMetricsThemeData.inputFocusedBorder,
                      errorStyle: TextFieldConfig.errorStyle,
                      errorBorder: TextFieldConfig.errorBorder,
                      focusedErrorBorder: TextFieldConfig.errorBorder,
                      hintStyle: DarkMetricsThemeData.hintStyle,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    dialogTheme: const DialogTheme(elevation: 0.0),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
