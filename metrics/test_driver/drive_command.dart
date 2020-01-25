import 'package:collection/collection.dart';

import 'browser_name.dart';

/// Wrapper class for the 'flutter drive' command
/// https://github.com/flutter/flutter/blob/f0a175f41d67c28312025a78278d4498ee488e4e/packages/flutter_tools/lib/src/commands/drive.dart#L116
/// flutter drive --help
class DriveCommand extends DelegatingList<String> {
  DriveCommand() : super([]) {
    add("drive");
  }

  ///  --debug
  ///  Build a debug version of your app (default mode).
  DriveCommand debug() {
    add("--debug");
    return this;
  }

  ///  --profile
  ///  Build a version of your app specialized for performance profiling.
  DriveCommand profile() {
    add("--profile");
    return this;
  }

  ///  --release
  ///  Build a release version of your app.
  DriveCommand release() {
    add("--release");
    return this;
  }

  ///  --flavor
  ///  Build a custom app flavor as defined by platform-specific build setup.
  ///  Supports the use of product flavors in Android Gradle scripts, and the
  ///  use of custom Xcode schemes.
  DriveCommand flavor() {
    add("--flavor");
    return this;
  }

  ///  --trace-startup
  ///  Trace application startup, then exit, saving the trace to a file.
  DriveCommand traceStartup() {
    add("--trace-startup");
    return this;
  }

  ///  --verbose-system-logs
  ///  Include verbose logging from the flutter engine.
  DriveCommand verboseSystemLogs() {
    add("--verbose-system-logs");
    return this;
  }

  ///  --cache-sksl
  ///  Only cache the shader in SkSL instead of binary or GLSL.
  DriveCommand cacheSksl() {
    add("--cache-sksl");
    return this;
  }

  ///  --dump-skp-on-shader-compilation
  ///  Automatically dump the skp that triggers new shader compilations.
  ///  This is useful for wrting custom ShaderWarmUp to reduce jank. By
  ///  default, this is not enabled to reduce the overhead. This is only
  ///  available in profile or debug build.
  DriveCommand dumpSkpOnShaderCompilation() {
    add("--dump-skp-on-shader-compilation");
    return this;
  }

  ///  --route
  ///  Which route to load when running the app.
  DriveCommand route(String route) {
    add("--route=$route");
    return this;
  }

  ///  --vmservice-out-file=<project/example/out.txt>
  ///  A file to write the attached vmservice uri to after an
  ///  application is started.
  DriveCommand vmserviceOutFile(String file) {
    add("--vmservice-out-file=$file");
    return this;
  }

  ///  -t, --target=<path>
  ///  The main entry-point file of the application, as run on the device.
  ///  If the --target option is omitted, but a file name is provided on the
  ///  command line, then that is used instead.
  ///  (defaults to "lib/main.dart")
  DriveCommand target(String path) {
    add("--target=$path");
    return this;
  }

  ///  --device-vmservice-port
  ///  Look for vmservice connections only from the specified port.
  ///  Specifying port 0 (the default) will accept the first vmservice discovered.
  DriveCommand deviceVmservicePort(int port) {
    add("--device-vmservice-port=$port");
    return this;
  }

  ///  --host-vmservice-port
  ///  When a device-side vmservice port is forwarded to a host-side port,
  ///  use this value as the host port.
  ///  Specifying port 0 (the default) will find a random free host port.
  DriveCommand hostVmservicePort(int port) {
    add("--host-vmservice-port=$port");
    return this;
  }

  ///  --[no-]pub
  ///  Whether to run "flutter pub get" before executing this command.
  ///  (defaults to on)
  DriveCommand pub() {
    add("--pub");
    return this;
  }

  ///  --[no-]pub
  ///  Whether to run "flutter pub get" before executing this command.
  ///  (defaults to on)
  DriveCommand noPub() {
    add("--no-pub");
    return this;
  }

  ///  --[no-]track-widget-creation
  ///  Track widget creation locations. This enables features such as the
  ///  widget inspector. This parameter is only functional in debug mode (i.e.
  ///  when compiling JIT, not AOT).
  ///  (defaults to on)
  DriveCommand trackWidgetCreation() {
    add("--track-widget-creation");
    return this;
  }

  ///  --[no-]track-widget-creation
  ///  Track widget creation locations. This enables features such as the
  ///  widget inspector. This parameter is only functional in debug mode (i.e.
  ///  when compiling JIT, not AOT).
  ///  (defaults to on)
  DriveCommand noTrackWidgetCreation() {
    add("--no-track-widget-creation");
    return this;
  }

  ///  --[no-]keep-app-running
  ///  Will keep the Flutter application running when done testing.
  ///  By default, "flutter drive" stops the application after tests are
  ///  finished, and --keep-app-running overrides this. On the other hand,
  ///  if --use-existing-app is specified, then "flutter drive" instead
  ///  defaults to leaving the application running, and --no-keep-app-running
  ///  overrides it.
  DriveCommand keepAppRunning() {
    add("--keep-app-running");
    return this;
  }

  ///  --[no-]keep-app-running
  ///  Will keep the Flutter application running when done testing.
  ///  By default, "flutter drive" stops the application after tests are
  ///  finished, and --keep-app-running overrides this. On the other hand,
  ///  if --use-existing-app is specified, then "flutter drive" instead
  ///  defaults to leaving the application running, and --no-keep-app-running
  ///  overrides it.
  DriveCommand noKeepAppRunning() {
    add("--no-keep-app-running");
    return this;
  }

  ///  --use-existing-app=<url>
  ///  Connect to an already running instance via the given observatory
  ///  URL. If this option is given, the application will not be
  ///  automatically started, and it will only be stopped if
  ///  --no-keep-app-running is explicitly set.
  DriveCommand useExistingApp(String url) {
    add("--use-existing-app=$url");
    return this;
  }

  ///  --driver=<path>
  ///  The test file to run on the host (as opposed to the target file to
  ///  run on the device). By default, this file has the same
  ///  base name as the target file, but in the "test_driver/" directory
  ///  instead, and with "_test" inserted just before the extension, so e.g.
  ///  if the target is "lib/main.dart", the driver will be
  ///  "test_driver/main_test.dart".
  DriveCommand driver(String path) {
    add("--driver=$path");
    return this;
  }

  ///  --[no-]build
  ///  Build the app before running. (defaults to on)
  DriveCommand build() {
    add("--build");
    return this;
  }

  ///  --[no-]build
  ///  Build the app before running. (defaults to on)
  DriveCommand noBuild() {
    add("--no-build");
    return this;
  }

  ///  --driver-port=<4444>
  ///  The port where Webdriver server is launched at. Defaults to 4444.
  ///  (defaults to "4444")
  DriveCommand driverPort(int port) {
    add("--driver-port=$port");
    return this;
  }

  ///  --[no-]headless
  ///  Whether the driver browser is going to be launched in headless mode.
  ///  Defaults to true.
  ///  (defaults to on)
  DriveCommand headless() {
    add("--headless");
    return this;
  }

  ///  --[no-]headless
  ///  Whether the driver browser is going to be launched in headless mode.
  ///  Defaults to true.
  ///  (defaults to on)
  DriveCommand noHeadless() {
    add("--no-headless");
    return this;
  }

  ///  --browser-name
  ///  Name of browser where tests will be executed.
  ///  Following browsers are supported: Chrome, Firefox, Safari (macOS and
  ///  iOS) and Edge. Defaults to Chrome. [chrome (default), edge, firefox,
  ///  ios-safari, safari]
  DriveCommand browserName(BrowserName browserName) {
    add("--browser-name=$browserName");
    return this;
  }

  ///  --browser-dimension
  ///  The dimension of browser when running Flutter Web test.
  ///  This will affect screenshot and all offset-related actions.
  ///  By default. it is set to 1600,1024 (1600 by 1024).
  ///  (defaults to "1600,1024")
  DriveCommand browserDimension(String browserDimension) {
    add("--browser-dimension=$browserDimension");
    return this;
  }
}
