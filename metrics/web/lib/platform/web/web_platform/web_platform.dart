import 'package:universal_html/js.dart';

/// A class that represents the information about the environment in which the
/// current application is running.
class WebPlatform {
  /// Creates a new instance of the [WebPlatform].
  const WebPlatform();

  /// Indicates whether this application's instance uses the SKIA renderer.
  bool get isSkia => context['flutterCanvasKit'] != null;
}
