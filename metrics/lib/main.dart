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
        builder: (context, store) {
          final isDark = store?.isDark ?? true;

          return MaterialApp(
            title: 'Flutter Demo',
            routes: {
              '/dashboard': (context) => DashboardPage(),
            },
            theme: ThemeData(
              textTheme: const TextTheme(
                bodyText2: TextStyle(color: Colors.white),
              ),
              brightness: isDark ? Brightness.dark : Brightness.light,
              scaffoldBackgroundColor: _getScaffoldBackgroundColor(isDark),
              primarySwatch: Colors.blue,
              fontFamily: 'Bebas Neue',
            ),
            home: DashboardPage(),
          );
        },
      ),
    );
  }

  Color _getScaffoldBackgroundColor(bool isDark) {
    if (isDark) return Colors.grey[850];

    return const Color(0xFF334678);
  }
}
