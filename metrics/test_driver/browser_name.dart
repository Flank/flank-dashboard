/// TODO: Is there better way to have type saftey around strings in Dart?
///  Name of browser where tests will be executed.
///  Following browsers are supported: Chrome, Firefox, Safari (macOS and
///  iOS) and Edge. Defaults to Chrome. [chrome (default), edge, firefox,
///  ios-safari, safari]
class BrowserName {
  static const chrome = BrowserName("chrome");
  static const edge = BrowserName("edge");
  static const firefox = BrowserName("firefox");
  static const iosSafari = BrowserName("ios-safari");
  static const safari = BrowserName("safari");

  final String value;
  const BrowserName(this.value);

  @override
  String toString() {
    return value;
  }
}
