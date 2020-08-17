import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:test/test.dart';

void main() {
  group("ThemeNotifier", () {
    test(".changeTheme() changes the theme", () {
      final themeNotifier = ThemeNotifier();
      final initialTheme = themeNotifier.isDark;

      themeNotifier.changeTheme();

      expect(themeNotifier.isDark, isNot(initialTheme));
    });

    test(".changeTheme() notifies listeners about theme change", () {
      final themeNotifier = ThemeNotifier();

      themeNotifier.addListener(expectAsync0(() {}));

      themeNotifier.changeTheme();
    });
  });
}
