import '../config/device.dart';

/// Wrapper class for the 'flutter run' command
/// `flutter run --help`
class RunCommand {
  final List<String> _args = [];

  RunCommand() {
    _add('run');
  }

  /// Creates the [List] of args from the [RunCommand] class instance
  List<String> buildArgs() => List.unmodifiable(_args);

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

  /// --target=<[targetPath]>
  ///
  /// The main entry-point file of the application, as run on the device.
  void target(String targetPath) => _add('--target=$targetPath');

  /// --device-vmservice-port
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

  /// --start-paused
  ///
  /// Start in a paused mode and wait for a debugger to connect.
  void startPaused() => _add('--start-paused');

  /// --enable-software-rendering
  ///
  /// Enable rendering using the Skia software backend.
  /// This is useful when testing Flutter on emulators.
  /// By default, Flutter will attempt to either use OpenGL or Vulkan
  /// and fall back to software when neither is available.
  void enableSoftwareRendering() => _add('--enable-software-rendering');

  /// --skia-deterministic-rendering
  ///
  /// When combined with --enable-software-rendering,
  /// provides 100% deterministic Skia rendering.
  void skiaDeterministicRendering() => _add('--skia-deterministic-rendering');

  /// --trace-skia
  ///
  /// Enable tracing of Skia code.
  /// This is useful when debugging the GPU thread.
  /// By default, Flutter will not log skia code.
  void traceSkia() => _add('--trace-skia');

  /// --trace-systrace
  ///
  /// Enable tracing to the system tracer.
  /// This is only useful on platforms where such
  /// a tracer is available (Android and Fuchsia).
  void traceSystrace() => _add('--trace-systrace ');

  /// --await-first-frame-when-tracing
  ///
  /// Whether to wait for the first frame when tracing startup ("--trace-startup"),
  /// or just dump the trace as soon as the application is running.
  /// The first frame is detected by looking for a Timeline event with the name
  /// "Rasterized first useful frame".
  /// By default, the widgets library's binding takes care of sending this event.
  /// (defaults to on)
  void awaitFirstFrameWhenTracing() => _add('--await-first-frame-when-tracing');

  void noAwaitFirstFrameWhenTracing() =>
      _add('--no-await-first-frame-when-tracing');

  /// --[no-]use-test-fonts
  ///
  /// Enable (and default to) the "Ahem" font.
  /// This is a special font used in tests to remove any dependencies
  /// on the font metrics. It is enabled when you use "flutter test".
  /// Set this flag when running a test using "flutter run"
  /// for debugging purposes. This flag is only available when
  /// running in debug mode.
  void userTestFonts() => _add('--use-test-fonts ');

  void noUserTestFonts() => _add('--no-use-test-fonts ');

  /// --build
  ///
  /// If necessary, build the app before running.
  /// (defaults to on)
  void build() => _add('--build');

  void noBuild() => _add('--no-build');

  /// --[no-]hot
  ///
  /// Run with support for hot reloading. Only available for debug mode.
  /// Not available with "--trace-startup".
  /// (defaults to on)
  void hot() => _add('--hot');

  void noHot() => _add('--no-hot');

  /// --pid-file=[filePath]
  ///
  /// Specify a file to write the process id to. You can send SIGUSR1
  /// to trigger a hot reload and SIGUSR2 to trigger a hot restart.
  void pidFile(String filePath) => _add('--pid-file=$filePath');

  /// --[no-]fast-start
  ///
  /// Whether to quickly bootstrap applications with a minimal app.
  /// Currently this is only supported on Android devices.
  /// This option cannot be paired with --use-application-binary.
  /// (defaults to on)
  void fastStart() => _add('--fast-start');

  void noFastStart() => _add('--no-fast-start');

  ///  --device-id
  ///
  ///  Target device id or name (prefixes allowed).
  void device(Device device) => _add('--device-id=${device.deviceId}');

  /// --verbose
  ///
  /// Noisy logging, including all shell commands executed.
  void verbose() => _add('--verbose');

  /// --web-port
  ///
  /// The host port to serve the web application from.
  /// If not provided, the tool will select a random open port on the host.
  void webPort(int port) => _add('--web-port=$port');

  /// Private method to add the arg to [_args] list
  void _add(String value) {
    _args.add(value);
  }
}
