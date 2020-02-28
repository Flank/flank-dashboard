import 'dart:async';
import 'dart:io';

/// Base class for [Process] wrappers.
///
/// Providers the [stderrBroadcast] and [stdinBroadcast] streams to allow multi subscriptions.
/// We need to wrap the [Process] because it contains external static methods to start/run
/// the processes, that are not inheriting in Dart.
abstract class ProcessWrapper implements Process {
  final Process _process;
  final StreamController<List<int>> _stderrController = StreamController();
  final StreamController<List<int>> _stdoutController = StreamController();
  Stream<List<int>> _stderrBroadcast;
  Stream<List<int>> _stdoutBroadcast;

  /// Creates the [ProcessWrapper] that delegates to the [_process].
  ProcessWrapper(this._process) {
    _process.stdout.listen(_stdoutController.add);
    _stdoutBroadcast = _stdoutController.stream.asBroadcastStream();

    _process.stderr.listen(_stderrController.add);
    _stderrBroadcast = _stderrController.stream.asBroadcastStream();
  }

  @override
  Future<int> get exitCode => _process.exitCode;

  @override
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]) {
    return _process.kill(signal);
  }

  @override
  int get pid => _process.pid;

  @override
  Stream<List<int>> get stderr => _stderrController.stream;

  /// The broadcast stream of the process errors.
  Stream<List<int>> get stderrBroadcast => _stderrBroadcast;

  @override
  IOSink get stdin => _process.stdin;

  @override
  Stream<List<int>> get stdout => _stdoutController.stream;

  /// The broadcast stream of the process output.
  Stream<List<int>> get stdoutBroadcast => _stdoutBroadcast;
}
