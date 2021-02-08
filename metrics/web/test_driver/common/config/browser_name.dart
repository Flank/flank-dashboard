// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

///  Name of browser where tests will be executed.
///
///  Following browsers are supported: Chrome, Firefox, Safari (macOS and
///  iOS) and Edge. Defaults to Chrome. [chrome (default), edge, firefox,
///  ios-safari, safari]
class BrowserName {
  static const chrome = BrowserName._("chrome");
  static const edge = BrowserName._("edge");
  static const firefox = BrowserName._("firefox");
  static const iosSafari = BrowserName._("ios-safari");
  static const safari = BrowserName._("safari");

  final String value;

  const BrowserName._(this.value);

  @override
  String toString() {
    return value;
  }

  static const List<BrowserName> values = [
    chrome,
    edge,
    firefox,
    iosSafari,
    safari,
  ];

  /// Get the [BrowserName] from it's value string
  static BrowserName fromValue(String browserName) {
    return values.firstWhere(
      (element) => element.value == browserName,
      orElse: () => null,
    );
  }
}
