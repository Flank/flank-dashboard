import '../../common/command/command_builder.dart';

/// Wrapper class for the 'java -jar selenium.jar' command.
class SeleniumCommand extends CommandBuilder {
  static const String executableName = 'java';

  SeleniumCommand(String jarName) {
    addAll(['-jar', jarName]);
  }

  /// --debug
  ///
  /// Enables debug log level.
  void debug({bool debug = false}) {
    addAll(['--debug', '$debug']);
  }

  /// --version
  ///
  /// Displays the version and exits.
  void version() {
    add('--version');
  }

  /// --browserTimeout
  ///
  /// [timeout] in seconds : number of seconds a browser session is allowed to
  /// hang while a WebDriver command is running (example: driver.get(url)). If
  /// the timeout is reached while a WebDriver command is still processing,
  /// the session will quit. Minimum value is 60. An unspecified, zero, or
  /// negative value means wait indefinitely.
  void browserTimeout(int timeout) {
    addAll(['--browserTimeout', '$timeout']);
  }

  /// -config
  ///
  /// [filename] JSON configuration file for the standalone server.
  /// Overrides default values
  void config(String filename) {
    addAll(['-config', filename]);
  }

  /// -host
  ///
  /// [hostName] IP or hostname : usually determined automatically. Most
  /// commonly useful in exotic network configurations (e.g. network with VPN).
  void host(String hostName) {
    addAll(['-host', hostName]);
  }

  /// -jettyThreads
  ///
  /// [threads] max number of threads for Jetty. An unspecified, zero, or
  /// negative value means the Jetty default value (200) will be used.
  void jettyThread(int threads) {
    add('-jettyThreads');
  }

  /// -log
  ///
  /// [filename] the filename to use for logging. If omitted, will
  /// log to STDOUT.
  void log(String filename) {
    addAll(['-log', filename]);
  }

  /// -port
  ///
  /// [port] the port number the server will use.
  void port(int port) {
    addAll(['-port', '$port']);
  }

  /// -role
  ///
  /// [role] options are [hub], [node], or [standalone].
  void role(String role) {
    addAll(['-role', role]);
  }

  /// -timeout
  ///
  /// [timeout] in seconds : Specifies the timeout before the server
  /// automatically kills a session that hasn't had any activity in the last X
  /// seconds. The test slot will then be released for another test to use.
  /// This is typically used to take care of client crashes. For grid hub/node
  /// roles, cleanUpCycle must also be set. If a node does not specify it, the
  /// hub value will be used.
  void timeout(int timeout) {
    addAll(['-timeout', '$timeout']);
  }
}
