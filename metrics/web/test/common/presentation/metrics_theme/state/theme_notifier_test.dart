import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:test/test.dart';

// https://github.com/software-platform/monorepo/issues/140
// ignore_for_file: prefer_const_constructors, avoid_redundant_argument_values

void main() {
  group("ThemeNotifier", () {
    test(
      "creates an instance with the default is dark value if the is dark parameter is not specified",
      () {
        final themeNotifier = ThemeNotifier();

        expect(themeNotifier.isDark, isNotNull);
      },
    );

    test(
      "creates an instance with the default is dark value if the given is dark parameter is null",
      () {
        final themeNotifier = ThemeNotifier(isDark: null);

        expect(themeNotifier.isDark, isNotNull);
      },
    );

    test(
      "creates an instance with the given is dark parameter",
      () {
        const isDark = false;
        final themeNotifier = ThemeNotifier(isDark: isDark);

        expect(themeNotifier.isDark, equals(isDark));
      },
    );

    test(
      ".changeTheme() changes the theme",
      () {
        final themeNotifier = ThemeNotifier(isDark: true);
        final initialTheme = themeNotifier.isDark;

        themeNotifier.changeTheme();

        expect(themeNotifier.isDark, isNot(initialTheme));
      },
    );

    test(
      ".changeTheme() notifies listeners about theme change",
      () {
        final themeNotifier = ThemeNotifier(isDark: true);

        themeNotifier.addListener(expectAsync0(() {}));

        themeNotifier.changeTheme();
      },
    );

    test(
      ".setTheme() notifies listeners about theme change",
      () {
        final themeNotifier = ThemeNotifier(isDark: true);

        themeNotifier.addListener(
          expectAsync0(() {}),
        );

        themeNotifier.setTheme(isDark: false);
      },
    );

    test(
      ".setTheme() changes the theme",
      () {
        final themeNotifier = ThemeNotifier(isDark: true);

        const expectedIsDark = false;
        themeNotifier.setTheme(isDark: expectedIsDark);

        expect(themeNotifier.isDark, equals(expectedIsDark));
      },
    );

    test(
      ".setTheme() does not throw the exception when the given is dark parameter is null",
      () {
        final themeNotifier = ThemeNotifier(isDark: true);

        expect(
          () => themeNotifier.setTheme(isDark: null),
          returnsNormally,
        );
      },
    );
  });
}
