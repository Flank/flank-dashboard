import 'package:universal_html/html.dart';

/// A class that setups favicon of the application.
class Favicon {
  /// A favicon for light mode.
  final Element lightModeIcon = document?.querySelector('link#light-mode-icon');

  /// A favicon for dark mode.
  final Element darkModeIcon = document?.querySelector('link#dark-mode-icon');

  /// A [MediaQueryList] object representing the results of the
  /// media query string passed to matchMedia.
  final MediaQueryList matcher =
      window?.matchMedia('(prefers-color-scheme:light)');

  /// Adds a listener to the [MediaQueryListener] that will
  /// run a onUpdate function in response to the color scheme changing.
  void setupFavicon() {
    matcher.addListener((_) => onUpdate(matcher));
    onUpdate(matcher);
  }

  /// Sets favicon for light mode
  void setLightModeIcon() {
    darkModeIcon?.remove();
    document?.head?.append(lightModeIcon);
  }

  /// Sets favicon for dark mode
  void setDarkModeIcon() {
    lightModeIcon?.remove();
    document?.head?.append(darkModeIcon);
  }

  /// Calls the appropriate method
  /// depending on the mode to display the favicon.
  void onUpdate(MediaQueryList matcher) {
    if (matcher.matches) {
      setLightModeIcon();
    } else {
      setDarkModeIcon();
    }
  }
}
