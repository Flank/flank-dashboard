/// A class that helps to get the information about the current application's 
/// instance renderer.
class RendererHelper {
  /// Creates a new instance of the [RendererHelper].
  const RendererHelper();

  /// Returns `true` if the current application instance uses SKIA renderer,   
  /// otherwise returns `false`.
  bool get isSkia => const bool.fromEnvironment('FLUTTER_WEB_USE_SKIA');
}
