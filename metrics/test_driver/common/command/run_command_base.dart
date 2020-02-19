part of command;

/// Base class for wrappers of the 'flutter run' commands.
///
/// Contains all common command parameters for flutter run and drive commands.
abstract class _RunCommandBase extends _FlutterCommand {
  /// --debug
  ///
  /// Build a debug version of your app (default mode).
  void debug() => _add('--debug');

  /// --profile
  ///
  /// Build a version of your app specialized for performance profiling.
  void profile() => _add('--profile');

  /// --release
  ///
  /// Build a release version of your app.
  void release() => _add('--release');

  /// --flavor
  ///
  /// Build a custom app flavor as defined by platform-specific build setup.
  /// Supports the use of product flavors in Android Gradle scripts,
  /// and the use of custom Xcode schemes.
  void flavor(String flavor) => _add('--flavor=$flavor');

  /// --target=<[targetPath]>
  ///
  /// The main entry-point file of the application, as run on the device.
  void target(String targetPath) => _add('--target=$targetPath');

  /// --trace-startup
  ///
  /// Trace application startup, then exit, saving the trace to a file.
  void traceStartup() => _add('--trace-startup');

  /// --verbose-system-logs
  ///
  /// Include verbose logging from the flutter engine.
  void verboseSystemLogs() => _add('--verbose-system-logs');

  /// --cache-sksl
  ///
  /// Only cache the shader in SkSL instead of binary or GLSL.
  void cacheSksl() => _add('--cache-sksl');

  /// --dump-skp-on-shader-compilation
  ///
  /// Automatically dump the skp that triggers new shader compilations.
  /// This is useful for wrting custom ShaderWarmUp to reduce jank.
  /// By default, this is not enabled to reduce the overhead.
  /// This is only available in profile or debug build.
  void dumpSkpOnSharedCompilation() => _add('--dump-skp-on-shader-compilation');

  /// --route
  ///
  /// Which route to load when running the app.
  void route(String routeName) => _add('--route=$routeName');

  /// --vmservice-out-file=<[filePath]>
  ///
  /// A file to write the attached vmservice uri
  /// to after an application is started.
  void vmServiceOutFile(String filePath) {
    _add('--vmservice-out-file=$filePath');
  }

  ///
  /// Look for vmservice connections only from the specified port.
  /// Specifying port 0 (the default) will accept the first vmservice discovered.
  void deviceVmServicePort(int port) => _add('--device-vmservice-port=$port');

  /// --host-vmservice-port
  ///
  /// When a device-side vmservice port is forwarded to a host-side port,
  /// use this value as the host port.
  /// Specifying port 0 (the default) will find a random free host port.
  void hostVmServicePort(int port) => _add('--host-vmservice-port=$port');

  /// --[no-]pub
  ///
  /// Whether to run "flutter pub get" before executing this command.
  void pub() => _add('--pub');

  void noPub() => _add('--no-pub');

  /// --[no-]track-widget-creation
  ///
  /// Track widget creation locations. This enables features such as
  /// the widget inspector. This parameter is only functional in debug mode
  /// (i.e. when compiling JIT, not AOT).
  /// (defaults to on)
  void trackWidgetCreation() => _add('--track-widget-creation');

  void noTrackWidgetCreation() => _add('--no-track-widget-creation');
}
