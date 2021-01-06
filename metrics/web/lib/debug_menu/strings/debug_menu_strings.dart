// ignore_for_file: public_member_api_docs

/// A class that holds debug menu strings.
class DebugMenuStrings {
  static const String debugMenuDisabled =
      'Sorry, the debug menu is currently disabled.';
  static const String performance = 'Performance';
  static const String skia = 'SKIA';
  static const String html = 'HTML';
  static const String fpsMonitor = 'FPS monitor';
  static const String throwException = 'Throw Exception';

  static String getCurrentRenderer(String renderer) =>
      'Current renderer: $renderer';
}
