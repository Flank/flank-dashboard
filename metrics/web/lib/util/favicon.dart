import 'package:universal_html/html.dart' as html;

/// A class that setups favicon of the application.
class Favicon {
  /// A favicon for light mode.
  final html.Element lightModeIcon =
      html.document?.querySelector('link#light-mode-icon');

  /// A favicon for dark mode.
  final html.Element darkModeIcon =
      html.document?.querySelector('link#dark-mode-icon');

  /// A [MediaQueryList] object representing the results of the
  /// media query string passed to matchMedia.
  final html.MediaQueryList matcher =
      html.window?.matchMedia('(prefers-color-scheme:light)');

  /// Adds a listener to the [MediaQueryListener] that will
  /// run a onUpdate function in response to the color scheme changing.
  void setupFavicon() {
    matcher.addListener(onUpdate);
    onUpdate(matcher);
  }

  /// Sets favicon for light mode
  void setLightModeIcon() {
    darkModeIcon.remove();
    html.document?.head?.append(lightModeIcon);
  }

  /// Sets favicon for dark mode
  void setDarkModeIcon() {
    lightModeIcon.remove();
    html.document?.head?.append(darkModeIcon);
  }

  /// Calls the appropriate method
  /// depending on the mode to display the favicon.
  void onUpdate(dynamic matcher) {
    if (matcher.matches == true) {
      setLightModeIcon();
    } else {
      setDarkModeIcon();
    }
  }
}
