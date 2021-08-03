// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:provider/provider.dart';

/// A widget that observer the platform brightness
/// and sets the current theme to the [ThemeNotifier]
/// correspondingly to the current platform brightness.
class PlatformBrightnessObserver extends StatefulWidget {
  /// A child widget to display.
  final Widget child;

  /// Creates a new instance of the [PlatformBrightnessObserver].
  ///
  /// The [child] must not be null.
  const PlatformBrightnessObserver({
    Key key,
    @required this.child,
  })  : assert(child != null),
        super(key: key);

  @override
  _PlatformBrightnessObserverState createState() =>
      _PlatformBrightnessObserverState();
}

class _PlatformBrightnessObserverState extends State<PlatformBrightnessObserver>
    with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updatePlatformBrightness();
    });

    super.initState();
  }

  @override
  void didChangePlatformBrightness() {
    _updatePlatformBrightness();
    super.didChangePlatformBrightness();
  }

  /// Changes the theme according to the operating system's brightness if user
  /// is not logged in.
  void _updatePlatformBrightness() {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    final isLoggedIn = authNotifier.authState;

    if (isLoggedIn != null && isLoggedIn != AuthState.loggedOut) return;

    final brightness = WidgetsBinding.instance.window.platformBrightness;
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);

    themeNotifier.setTheme(brightness);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
