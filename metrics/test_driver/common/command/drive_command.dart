import '../config/browser_name.dart';

/// Wrapper class for the 'flutter drive' command.
///
/// https://github.com/flutter/flutter/blob/f0a175f41d67c28312025a78278d4498ee488e4e/packages/flutter_tools/lib/src/commands/drive.dart#L116
/// flutter drive --help
class DriveCommand {
  final List<String> _args = [];

  DriveCommand() {
    _add("drive");
  }

  /// Method to create the [List] of args from the [DriveCommand] class instance
  List<String> buildArgs() => List.unmodifiable(_args);

  ///  --debug
  ///
  ///  Build a debug version of your app (default mode).
  void debug() => _add("--debug");

  ///  --profile
  ///
  ///  Build a version of your app specialized for performance profiling.
  void profile() => _add("--profile");

  ///  --release
  ///
  ///  Build a release version of your app.
  void release() => _add("--release");

  ///  --flavor
  ///
  ///  Build a custom app flavor as defined by platform-specific build setup.
  ///  Supports the use of product flavors in Android Gradle scripts, and the
  ///  use of custom Xcode schemes.
  void flavor() => _add("--flavor");

  ///  --trace-startup
  ///
  ///  Trace application startup, then exit, saving the trace to a file.
  void traceStartup() => _add("--trace-startup");

  ///  --verbose-system-logs
  ///
  ///  Include verbose logging from the flutter engine.
  void verboseSystemLogs() => _add("--verbose-system-logs");

  ///  --cache-sksl
  ///
  ///  Only cache the shader in SkSL instead of binary or GLSL.
  void cacheSksl() => _add("--cache-sksl");

  ///  --dump-skp-on-shader-compilation
  ///
  ///  Automatically dump the skp that triggers new shader compilations.
  ///  This is useful for wrting custom ShaderWarmUp to reduce jank. By
  ///  default, this is not enabled to reduce the overhead. This is only
  ///  available in profile or debug build.
  void dumpSkpOnShaderCompilation() => _add("--dump-skp-on-shader-compilation");

  ///  --route
  ///
  ///  Which route to load when running the app.
  void route(String route) => _add("--route=$route");

  ///  --vmservice-out-file=<project/example/out.txt>
  ///
  ///  A file to write the attached vmservice uri to after an
  ///  application is started.
  void vmserviceOutFile(String file) => _add("--vmservice-out-file=$file");

  ///  -t, --target=<path>
  ///
  ///  The main entry-point file of the application, as run on the device.
  ///  If the --target option is omitted, but a file name is provided on the
  ///  command line, then that is used instead.
  ///  (defaults to "lib/main.dart")
  void target(String path) => _add("--target=$path");

  ///  --device-vmservice-port
  ///
  ///  Look for vmservice connections only from the specified port.
  ///  Specifying port 0 (the default) will accept the first vmservice discovered.
  void deviceVmservicePort(int port) => _add("--device-vmservice-port=$port");

  ///  --host-vmservice-port
  ///
  ///  When a device-side vmservice port is forwarded to a host-side port,
  ///  use this value as the host port.
  ///  Specifying port 0 (the default) will find a random free host port.
  void hostVmservicePort(int port) => _add("--host-vmservice-port=$port");

  ///  --[no-]pub
  ///
  ///  Whether to run "flutter pub get" before executing this command.
  ///  (defaults to on)
  void pub() => _add("--pub");

  ///  --[no-]pub
  ///
  ///  Whether to run "flutter pub get" before executing this command.
  ///  (defaults to on)
  void noPub() => _add("--no-pub");

  ///  --[no-]track-widget-creation
  ///
  ///  Track widget creation locations. This enables features such as the
  ///  widget inspector. This parameter is only functional in debug mode (i.e.
  ///  when compiling JIT, not AOT).
  ///  (defaults to on)
  void trackWidgetCreation() => _add("--track-widget-creation");

  ///  --[no-]track-widget-creation
  ///
  ///  Track widget creation locations. This enables features such as the
  ///  widget inspector. This parameter is only functional in debug mode (i.e.
  ///  when compiling JIT, not AOT).
  ///  (defaults to on)
  void noTrackWidgetCreation() => _add("--no-track-widget-creation");

  ///  --[no-]keep-app-running
  ///
  ///  Will keep the Flutter application running when done testing.
  ///  By default, "flutter drive" stops the application after tests are
  ///  finished, and --keep-app-running overrides this. On the other hand,
  ///  if --use-existing-app is specified, then "flutter drive" instead
  ///  defaults to leaving the application running, and --no-keep-app-running
  ///  overrides it.
  void keepAppRunning() => _add("--keep-app-running");

  ///  --[no-]keep-app-running
  ///
  ///  Will keep the Flutter application running when done testing.
  ///  By default, "flutter drive" stops the application after tests are
  ///  finished, and --keep-app-running overrides this. On the other hand,
  ///  if --use-existing-app is specified, then "flutter drive" instead
  ///  defaults to leaving the application running, and --no-keep-app-running
  ///  overrides it.
  void noKeepAppRunning() => _add("--no-keep-app-running");

  ///  --use-existing-app=<url>
  ///
  ///  Connect to an already running instance via the given observatory
  ///  URL. If this option is given, the application will not be
  ///  automatically started, and it will only be stopped if
  ///  --no-keep-app-running is explicitly set.
  void useExistingApp(String url) => _add("--use-existing-app=$url");

  ///  --driver=<path>
  ///
  ///  The test file to run on the host (as opposed to the target file to
  ///  run on the device). By default, this file has the same
  ///  base name as the target file, but in the "test_driver/" directory
  ///  instead, and with "_test" inserted just before the extension, so e.g.
  ///  if the target is "lib/main.dart", the driver will be
  ///  "test_driver/main_test.dart".
  void driver(String path) => _add("--driver=$path");

  ///  --[no-]build
  ///
  ///  Build the app before running. (defaults to on)
  void build() => _add("--build");

  ///  --[no-]build
  ///
  ///  Build the app before running. (defaults to on)
  void noBuild() => _add("--no-build");

  ///  --driver-port=<4444>
  ///
  ///  The port where Webdriver server is launched at. Defaults to 4444.
  ///  (defaults to "4444")
  void driverPort(int port) => _add("--driver-port=$port");

  ///  --[no-]headless
  ///
  ///  Whether the driver browser is going to be launched in headless mode.
  ///  Defaults to true.
  ///  (defaults to on)
  void headless() => _add("--headless");

  ///  --[no-]headless
  ///
  ///  Whether the driver browser is going to be launched in headless mode.
  ///  Defaults to true.
  ///  (defaults to on)
  void noHeadless() => _add("--no-headless");

  ///  --browser-name
  ///
  ///  Name of browser where tests will be executed.
  ///  Following browsers are supported: Chrome, Firefox, Safari (macOS and
  ///  iOS) and Edge. Defaults to Chrome. [chrome (default), edge, firefox,
  ///  ios-safari, safari]
  void browserName(BrowserName browserName) {
    _add("--browser-name=$browserName");
  }

  ///  --browser-dimension
  ///
  ///  The dimension of browser when running Flutter Web test.
  ///  This will affect screenshot and all offset-related actions.
  ///  By default. it is set to 1600,1024 (1600 by 1024).
  ///  (defaults to "1600,1024")
  void browserDimension(String browserDimension) {
    _add("--browser-dimension=$browserDimension");
  }

  /// Private method to add the arg to [_args] list
  void _add(String value) => _args.add(value);
}
