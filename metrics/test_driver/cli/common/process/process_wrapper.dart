import 'dart:io';

/// Base class for [Process] wrappers.
///
/// Overrides the [stderr] and [stdin] streams and makes it broadcast.
/// We need to wrap the [Process] because it contains static methods to start/run
/// the processes which could not be inherited.
abstract class ProcessWrapper implements Process {
  final Process _process;
  final Stream<List<int>> _stderr;
  final Stream<List<int>> _stdout;

  /// Creates the [ProcessWrapper] that delegates to the [_process].
  ProcessWrapper(this._process)
      : _stdout = _process.stdout.asBroadcastStream(),
        _stderr = _process.stderr.asBroadcastStream();

  @override
  Future<int> get exitCode => _process.exitCode;

  @override
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]) {
    return _process.kill(signal);
  }

  @override
  int get pid => _process.pid;

  @override
  Stream<List<int>> get stderr => _process.stderr;

  /// The broadcast stream of the process errors.
  Stream<List<int>> get stderrBroadcast => _stderr;

  @override
  IOSink get stdin => _process.stdin;

  @override
  Stream<List<int>> get stdout => _stdout;

  /// The broadcast stream of the process output.
  Stream<List<int>> get stdoutBroadcast => _stdout;
}
