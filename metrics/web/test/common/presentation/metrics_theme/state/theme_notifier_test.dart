import 'package:flutter/cupertino.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("ThemeNotifier", () {
    test(
      "creates an instance with the default is dark value if the brightness is not specified",
      () {
        final themeNotifier = ThemeNotifier();

        expect(themeNotifier.isDark, isNotNull);
      },
    );

    test(
      "creates an instance with the default is dark value if the given brightness is null",
      () {
        final themeNotifier = ThemeNotifier(brightness: null);

        expect(themeNotifier.isDark, isNotNull);
      },
    );

    test(
      "creates an instance with the is dark value that corresponds to the given system's theme dark brightness",
      () {
        final themeNotifier = ThemeNotifier(brightness: Brightness.dark);

        expect(themeNotifier.isDark, isTrue);
      },
    );

    test(
      "creates an instance with the light theme mode that corresponds to the given light brightness",
      () {
        final themeNotifier = ThemeNotifier(brightness: Brightness.light);

        expect(themeNotifier.isDark, isFalse);
      },
    );

    test(
      ".changeTheme() changes the theme",
      () {
        final themeNotifier = ThemeNotifier();
        final initialTheme = themeNotifier.isDark;

        themeNotifier.changeTheme();

        expect(themeNotifier.isDark, isNot(initialTheme));
      },
    );

    test(
      ".changeTheme() notifies listeners about theme change",
      () {
        final themeNotifier = ThemeNotifier();

        themeNotifier.addListener(expectAsync0(() {}));

        themeNotifier.changeTheme();
      },
    );

    test(
      ".setTheme() notifies listeners about theme change",
      () {
        final themeNotifier = ThemeNotifier();

        themeNotifier.addListener(expectAsync0(() {}));

        const newBrightness = Brightness.light;
        themeNotifier.setTheme(newBrightness);
      },
    );

    test(
      ".setTheme() sets the light theme mode if the given brightness is light",
      () {
        final themeNotifier = ThemeNotifier();

        themeNotifier.setTheme(Brightness.light);

        expect(themeNotifier.isDark, isFalse);
      },
    );

    test(
      ".setTheme() sets the light theme mode if the given brightness is null",
      () {
        final themeNotifier = ThemeNotifier();

        themeNotifier.setTheme(null);

        expect(themeNotifier.isDark, isFalse);
      },
    );

    test(
      ".setTheme() sets the dark theme mode if the given brightness is dark",
      () {
        final themeNotifier = ThemeNotifier();

        themeNotifier.setTheme(Brightness.dark);

        expect(themeNotifier.isDark, isTrue);
      },
    );
  });
}
