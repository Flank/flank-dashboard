// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:universal_io/io.dart';

/// A class that represents the information about the environment in which the
/// current application is running.
class WebPlatform {
  /// Creates a new instance of the [WebPlatform].
  const WebPlatform();

  /// Indicates whether this application's instance uses auto-detection
  /// for the renderer.
  bool get _autoDetect => const bool.fromEnvironment('FLUTTER_WEB_AUTO_DETECT');

  /// Indicates whether this application's instance forced to use
  /// the SKIA renderer.
  bool get _useSkia => const bool.fromEnvironment('FLUTTER_WEB_USE_SKIA');

  /// Indicates whether this application's instance is launched from
  /// the desktop platform.
  bool get _isDesktop =>
      Platform.isLinux || Platform.isMacOS || Platform.isWindows;

  /// Indicates whether this application's instance uses the SKIA renderer.
  bool get isSkia => _useSkia || (_autoDetect && _isDesktop);
}
