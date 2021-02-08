// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import '../../../common/config/browser_name.dart';
import 'run_command_base.dart';

/// Wrapper class for the 'flutter drive' command.
///
/// https://github.com/flutter/flutter/blob/f0a175f41d67c28312025a78278d4498ee488e4e/packages/flutter_tools/lib/src/commands/drive.dart#L116
/// flutter drive --help
/// The [DriveCommand] extends the [RunCommandBase] because we can run
/// the flutter app and start the driver tests at once.
/// Unfortunately, this feature is not working with web applications,
/// but, in case of running tests on android/ios, we can run the `flutter drive`
/// command without the 'use-existing-app' parameter and it will run
/// the `flutter run` command internally and run the driver tests on
/// this application.
class DriveCommand extends RunCommandBase {
  DriveCommand() {
    add("drive");
  }

  ///  --[no-]keep-app-running
  ///
  ///  Will keep the Flutter application running when done testing.
  ///  By default, "flutter drive" stops the application after tests are
  ///  finished, and --keep-app-running overrides this. On the other hand,
  ///  if --use-existing-app is specified, then "flutter drive" instead
  ///  defaults to leaving the application running, and --no-keep-app-running
  ///  overrides it.
  void keepAppRunning() => add("--keep-app-running");

  ///  --[no-]keep-app-running
  ///
  ///  Will keep the Flutter application running when done testing.
  ///  By default, "flutter drive" stops the application after tests are
  ///  finished, and --keep-app-running overrides this. On the other hand,
  ///  if --use-existing-app is specified, then "flutter drive" instead
  ///  defaults to leaving the application running, and --no-keep-app-running
  ///  overrides it.
  void noKeepAppRunning() => add("--no-keep-app-running");

  ///  --use-existing-app=<url>
  ///
  ///  Connect to an already running instance via the given observatory
  ///  URL. If this option is given, the application will not be
  ///  automatically started, and it will only be stopped if
  ///  --no-keep-app-running is explicitly set.
  void useExistingApp(String url) => add("--use-existing-app=$url");

  ///  --driver=<path>
  ///
  ///  The test file to run on the host (as opposed to the target file to
  ///  run on the device). By default, this file has the same
  ///  base name as the target file, but in the "test_driver/" directory
  ///  instead, and with "_test" inserted just before the extension, so e.g.
  ///  if the target is "lib/main.dart", the driver will be
  ///  "test_driver/main_test.dart".
  void driver(String path) => add("--driver=$path");

  ///  --[no-]build
  ///
  ///  Build the app before running. (defaults to on)
  void build() => add("--build");

  ///  --[no-]build
  ///
  ///  Build the app before running. (defaults to on)
  void noBuild() => add("--no-build");

  ///  --driver-port=<4444>
  ///
  ///  The port where Webdriver server is launched at. Defaults to 4444.
  ///  (defaults to "4444")
  void driverPort(int port) => add("--driver-port=$port");

  ///  --[no-]headless
  ///
  ///  Whether the driver browser is going to be launched in headless mode.
  ///  Defaults to true.
  ///  (defaults to on)
  void headless() => add("--headless");

  ///  --[no-]headless
  ///
  ///  Whether the driver browser is going to be launched in headless mode.
  ///  Defaults to true.
  ///  (defaults to on)
  void noHeadless() => add("--no-headless");

  ///  --browser-name
  ///
  ///  Name of browser where tests will be executed.
  ///  Following browsers are supported: Chrome, Firefox, Safari (macOS and
  ///  iOS) and Edge. Defaults to Chrome. [chrome (default), edge, firefox,
  ///  ios-safari, safari]
  void browserName(BrowserName browserName) {
    add("--browser-name=$browserName");
  }

  ///  --browser-dimension
  ///
  ///  The dimension of browser when running Flutter Web test.
  ///  This will affect screenshot and all offset-related actions.
  ///  By default. it is set to 1600,1024 (1600 by 1024).
  ///  (defaults to "1600,1024")
  void browserDimension(String browserDimension) {
    add("--browser-dimension=$browserDimension");
  }
}
