/// A strategy class that provides the information about the current
/// application's instance renderer.
class SvgImageStrategy {
  /// Creates a new instance of the [SvgImageStrategy].
  const SvgImageStrategy();

  /// Indicates whether the current application instance uses SKIA renderer.
  bool get isSkia => const bool.fromEnvironment('FLUTTER_WEB_USE_SKIA');
}
