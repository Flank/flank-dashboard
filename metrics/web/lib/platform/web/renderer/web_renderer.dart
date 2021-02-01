import 'package:universal_html/js.dart';

/// A class that provides information about the renderer that
/// current application uses.
class Renderer {
  /// Creates a new instance of the [Renderer].
  const Renderer();

  /// Indicates whether this application's instance uses the SKIA renderer.
  bool get isSkia => context['flutterCanvasKit'] != null;
}
