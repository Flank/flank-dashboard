// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/auth/domain/entities/theme_type.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("ThemeNotifier", () {
    const lightTheme = ThemeType.light;
    const darkTheme = ThemeType.dark;

    test(
      "creates an instance with the dark selected theme if the brightness is not specified",
      () {
        final themeNotifier = ThemeNotifier();

        expect(themeNotifier.selectedTheme, equals(darkTheme));
      },
    );

    test(
      "creates an instance with the dark selected theme if the given brightness is null",
      () {
        final themeNotifier = ThemeNotifier(brightness: null);

        expect(themeNotifier.selectedTheme, darkTheme);
      },
    );

    test(
      "creates an instance with the dark selected theme that corresponds to the given system's theme dark brightness",
      () {
        final themeNotifier = ThemeNotifier(brightness: Brightness.dark);

        expect(themeNotifier.selectedTheme, equals(darkTheme));
      },
    );

    test(
      "creates an instance with the light selected theme that corresponds to the given light brightness",
      () {
        final themeNotifier = ThemeNotifier(brightness: Brightness.light);

        expect(themeNotifier.selectedTheme, equals(lightTheme));
      },
    );

    test(".isDark is true if the selected theme is dark", () {
      final themeNotifier = ThemeNotifier();
      themeNotifier.changeTheme(darkTheme);

      expect(themeNotifier.isDark, isTrue);
    });

    test(".isDark is false if the selected theme is light", () {
      final themeNotifier = ThemeNotifier();
      themeNotifier.changeTheme(lightTheme);

      expect(themeNotifier.isDark, isFalse);
    });

    test(".changeTheme() changes the theme to the given value", () {
      final themeNotifier = ThemeNotifier();
      themeNotifier.changeTheme(lightTheme);

      expect(themeNotifier.selectedTheme, equals(lightTheme));
    });

    test(
      ".changeTheme() does not notify listeners if the given value is null",
      () {
        final themeNotifier = ThemeNotifier();

        themeNotifier.changeTheme(null);

        expect(themeNotifier.selectedTheme, equals(darkTheme));
      },
    );

    test(
      ".changeTheme() does not notify listeners if the given value is the same",
      () {
        bool isCalled = false;
        final themeNotifier = ThemeNotifier();

        themeNotifier.addListener(() => isCalled = true);
        themeNotifier.changeTheme(darkTheme);

        expect(isCalled, isFalse);
      },
    );

    test(
      ".toggleTheme() changes the selected theme to the opposite",
      () {
        final themeNotifier = ThemeNotifier();
        final initialTheme = themeNotifier.selectedTheme;

        themeNotifier.toggleTheme();

        expect(themeNotifier.selectedTheme, isNot(initialTheme));
      },
    );

    test(
      ".toggleTheme() notifies listeners about theme change",
      () {
        final themeNotifier = ThemeNotifier();

        themeNotifier.addListener(expectAsync0(() {}));

        themeNotifier.toggleTheme();
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
      ".setTheme() sets the dark theme mode if the given brightness is null",
      () {
        final themeNotifier = ThemeNotifier();

        themeNotifier.setTheme(null);

        expect(themeNotifier.isDark, isTrue);
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
