// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'flutter_command.dart';

/// Base class for wrappers of the 'flutter run' commands.
///
/// Contains all common command parameters for flutter run and drive commands.
abstract class RunCommandBase extends FlutterCommand {
  /// --debug
  ///
  /// Build a debug version of your app (default mode).
  void debug() => add('--debug');

  /// --profile
  ///
  /// Build a version of your app specialized for performance profiling.
  void profile() => add('--profile');

  /// --release
  ///
  /// Build a release version of your app.
  void release() => add('--release');

  /// --flavor
  ///
  /// Build a custom app flavor as defined by platform-specific build setup.
  /// Supports the use of product flavors in Android Gradle scripts,
  /// and the use of custom Xcode schemes.
  void flavor(String flavor) => add('--flavor=$flavor');

  /// --target=<[targetPath]>
  ///
  /// The main entry-point file of the application, as run on the device.
  void target(String targetPath) => add('--target=$targetPath');

  /// --trace-startup
  ///
  /// Trace application startup, then exit, saving the trace to a file.
  void traceStartup() => add('--trace-startup');

  /// --verbose-system-logs
  ///
  /// Include verbose logging from the flutter engine.
  void verboseSystemLogs() => add('--verbose-system-logs');

  /// --cache-sksl
  ///
  /// Only cache the shader in SkSL instead of binary or GLSL.
  void cacheSksl() => add('--cache-sksl');

  /// --dump-skp-on-shader-compilation
  ///
  /// Automatically dump the skp that triggers new shader compilations.
  /// This is useful for wrting custom ShaderWarmUp to reduce jank.
  /// By default, this is not enabled to reduce the overhead.
  /// This is only available in profile or debug build.
  void dumpSkpOnSharedCompilation() => add('--dump-skp-on-shader-compilation');

  /// --route
  ///
  /// Which route to load when running the app.
  void route(String routeName) => add('--route=$routeName');

  /// --vmservice-out-file=<[filePath]>
  ///
  /// A file to write the attached vmservice uri
  /// to after an application is started.
  void vmServiceOutFile(String filePath) {
    add('--vmservice-out-file=$filePath');
  }

  /// --device-vmservice-port=<[port]>
  ///
  /// Look for vmservice connections only from the specified port.
  /// Specifying port 0 (the default) will accept the first vmservice discovered.
  void deviceVmServicePort(int port) => add('--device-vmservice-port=$port');

  /// --host-vmservice-port
  ///
  /// When a device-side vmservice port is forwarded to a host-side port,
  /// use this value as the host port.
  /// Specifying port 0 (the default) will find a random free host port.
  void hostVmServicePort(int port) => add('--host-vmservice-port=$port');

  /// --[no-]pub
  ///
  /// Whether to run "flutter pub get" before executing this command.
  void pub() => add('--pub');

  void noPub() => add('--no-pub');

  /// --[no-]track-widget-creation
  ///
  /// Track widget creation locations. This enables features such as
  /// the widget inspector. This parameter is only functional in debug mode
  /// (i.e. when compiling JIT, not AOT).
  /// (defaults to on)
  void trackWidgetCreation() => add('--track-widget-creation');

  void noTrackWidgetCreation() => add('--no-track-widget-creation');

  /// --dart-define=FLUTTER_WEB_USE_SKIA=[value]
  ///
  /// Specifies whether to use Skia for rendering or not.
  void useSkia({bool value = true}) =>
      add('--dart-define=FLUTTER_WEB_USE_SKIA=$value');

  /// --dart-define
  ///
  /// Additional key-value pairs that will be available as constants from the
  /// String.fromEnvironment, bool.fromEnvironment, int.fromEnvironment,
  /// and double.fromEnvironment constructors.
  void dartDefine({String key, Object value}) =>
      add('--dart-define=$key=$value');
}
