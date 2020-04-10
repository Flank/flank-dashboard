// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/common/presentation/drawer/widget/metrics_drawer.dart';
import 'package:metrics/features/common/presentation/metrics_theme/store/theme_store.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

void main() {
  testWidgets(
    "Changes theme store state on tap on checkbox",
    (WidgetTester tester) async {
      final themeStore = ThemeStore();

      await tester.pumpWidget(MetricsDrawerTestbed(
        themeStore: themeStore,
      ));

      expect(themeStore.isDark, isFalse);

      await tester.tap(find.byType(Checkbox));
      await tester.pumpAndSettle();

      expect(themeStore.isDark, isTrue);
    },
  );
}

class MetricsDrawerTestbed extends StatelessWidget {
  final ThemeStore themeStore;

  const MetricsDrawerTestbed({
    Key key,
    this.themeStore,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Injector(
      inject: [Inject<ThemeStore>(() => themeStore ?? ThemeStore())],
      initState: _initInjectorState,
      builder: (context) {
        return MaterialApp(
          home: Scaffold(
            body: MetricsDrawer(),
          ),
        );
      },
    );
  }

  void _initInjectorState() {
    Injector.getAsReactive<ThemeStore>()
        .setState((model) => model.isDark = false);
  }
}
