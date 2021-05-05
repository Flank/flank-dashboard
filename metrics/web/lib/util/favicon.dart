// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:universal_html/html.dart';

/// A class that sets the favicon of the application depending on the OS theme.
class Favicon {
  /// A favicon for light mode.
  final Element _lightModeIcon =
      document?.querySelector('link#light-mode-icon');

  /// A favicon for dark mode.
  final Element _darkModeIcon = document?.querySelector('link#dark-mode-icon');

  /// A [MediaQueryList] object representing the results of the
  /// media query string passed to matchMedia.
  final MediaQueryList _colorSchemeMedia =
      window?.matchMedia('(prefers-color-scheme:light)');

  /// Adds a listener to the [MediaQueryList] that will
  /// run a onUpdate function in response to the color scheme changing.
  void setup() {
    _colorSchemeMedia
        .addListener((_) => _onColorSchemeUpdate(_colorSchemeMedia));
    _onColorSchemeUpdate(_colorSchemeMedia);
  }

  /// Sets favicon for light mode.
  void setLightModeIcon() {
    _darkModeIcon?.remove();
    document?.head?.append(_lightModeIcon);
  }

  /// Sets favicon for dark mode.
  void setDarkModeIcon() {
    _lightModeIcon?.remove();
    document?.head?.append(_darkModeIcon);
  }

  /// Calls the appropriate method
  /// depending on the mode to display the favicon.
  void _onColorSchemeUpdate(MediaQueryList matcher) {
    if (matcher.matches) {
      setLightModeIcon();
    } else {
      setDarkModeIcon();
    }
  }
}
