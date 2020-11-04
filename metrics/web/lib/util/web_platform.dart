/// A class that represents the information about the environment in which the
/// current program is running.
class WebPlatform {
  /// Creates a new instance of the [WebPlatform].
  const WebPlatform();

  /// Indicates whether this application's instance uses the SKIA renderer.
  bool get isSkia => const bool.fromEnvironment('FLUTTER_WEB_USE_SKIA');
}
