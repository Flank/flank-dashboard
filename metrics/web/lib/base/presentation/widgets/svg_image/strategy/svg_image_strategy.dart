/// A strategy class that provides the information about the current 
/// application's instance renderer.
class SvgImageStrategy {
  /// Creates a new instance of the [SvgImageStrategy].
  const SvgImageStrategy();

  /// Returns `true` if the current application instance uses SKIA renderer,   
  /// otherwise returns `false`.
  bool get isSkia => const bool.fromEnvironment('FLUTTER_WEB_USE_SKIA');
}
