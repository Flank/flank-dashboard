part of command;

/// Wrapper class for the 'flutter run' command
/// `flutter run --help`
class RunCommand extends _RunCommandBase {
  RunCommand() {
    _add('run');
  }

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

  /// --web-port
  ///
  /// The host port to serve the web application from.
  /// If not provided, the tool will select a random open port on the host.
  void webPort(int port) => _add('--web-port=$port');
}
