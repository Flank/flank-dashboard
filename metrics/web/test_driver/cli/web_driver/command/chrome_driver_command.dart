// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'dart:io';

import '../../common/command/command_builder.dart';
import '../model/chrome_driver_log_level.dart';

/// A wrapper class for the `./chromedriver` command.
class ChromeDriverCommand extends CommandBuilder {
  /// An executable name of this command.
  static const String executableName = './chromedriver';

  /// --port=[port]
  ///
  /// Port to listen on.
  void port(int port) {
    add('--port=$port');
  }

  /// --adb-port=[port]
  ///
  /// ADB server port.
  void adbPort(int port) {
    add('--adb-port=$port');
  }

  /// --log-path=[filePath]
  ///
  /// Sets the [filePath] to write the server logs instead of [stderr].
  /// Increases log level to [ChromeDriverLogLevel.info].
  void logPath(String filePath) {
    add('--log-path=$filePath');
  }

  /// --log-level=[logLevel]
  ///
  /// Sets the log level to the given one.
  void logLevel(ChromeDriverLogLevel logLevel) {
    add('--log-level${logLevel.value}');
  }

  /// --verbose
  ///
  /// Log verbosely (equivalent to [ChromeDriverLogLevel.all] log level).
  void verbose() {
    add('--verbose');
  }

  /// --silent
  ///
  /// Log nothing (equivalent to [ChromeDriverLogLevel.off] log level).
  void silent() {
    add('--silent');
  }

  /// --append-log
  ///
  /// Append log file instead of rewriting.
  void appendLog() {
    add('--append-log');
  }

  /// --replayable
  ///
  /// Log verbosely and don't truncate long strings so that the log
  /// can be replayed. (experimental)
  void replayable() {
    add('--replayable');
  }

  /// --version
  ///
  /// Print the version number and exit.
  void version() {
    add('--version');
  }

  /// --url-base=[urlBase]
  ///
  /// Base URL path prefix for commands, e.g. `wd/url`.
  void urlBase(String urlBase) {
    add('--url-base=$urlBase');
  }

  /// --readable-timestamp
  ///
  /// Add readable timestamps to log.
  void readableTimestamp() {
    add('--readable-timestamp');
  }

  /// --whitelisted-ips=[whitelist]
  ///
  /// List of remote IP addresses which are allowed to connect to ChromeDriver.
  void whitelistedIps(List<String> whitelist) {
    add('--whitelisted-ips${whitelist.join(',')}');
  }
}
