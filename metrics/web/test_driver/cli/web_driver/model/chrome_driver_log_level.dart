// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics_core/metrics_core.dart';

import '../command/chrome_driver_command.dart';

/// A class that holds the [ChromeDriverCommand] log levels.
class ChromeDriverLogLevel extends Enum<String> {
  /// A log level representing the verbose logging.
  static const ChromeDriverLogLevel all = ChromeDriverLogLevel._('ALL');

  /// A log level providing the debug information.
  static const ChromeDriverLogLevel debug = ChromeDriverLogLevel._('DEBUG');

  /// A log level providing a generally useful information.
  static const ChromeDriverLogLevel info = ChromeDriverLogLevel._('INFO');

  /// A log level providing an information about warnings.
  static const ChromeDriverLogLevel warning = ChromeDriverLogLevel._(
    'WARNING',
  );

  /// A log level providing the information about failures.
  static const ChromeDriverLogLevel severe = ChromeDriverLogLevel._('SEVERE');

  /// A log level representing the silenced logs.
  static const ChromeDriverLogLevel off = ChromeDriverLogLevel._('OFF');

  /// Create a new instance of the [ChromeDriverLogLevel]
  /// with the given [value].
  const ChromeDriverLogLevel._(String value) : super(value);
}
