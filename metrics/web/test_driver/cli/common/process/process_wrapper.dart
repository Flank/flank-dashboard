import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';

/// Base class for [Process] wrappers.
///
/// Providers the [stderrBroadcast] and [stdinBroadcast] streams to allow multi subscriptions.
/// We need to wrap the [Process] because it contains external static methods to start/run
/// the processes, that are not inheriting in Dart.
abstract class ProcessWrapper implements Process {
  final Process _process;
  final StreamController<List<int>> _stderrController = StreamController();
  final StreamController<List<int>> _stdoutController = StreamController();
  final StreamController<int> _exitCodeController = StreamController();

  Stream<List<int>> _stderrBroadcast;
  Stream<List<int>> _stdoutBroadcast;
  Stream<int> _exitCodeBroadcast;

  StreamSubscription _stdoutSubscription;
  StreamSubscription _stderrSubscription;
  StreamSubscription _exitCodeSubscription;

  /// Creates the [ProcessWrapper] that delegates to the [_process].
  ProcessWrapper(this._process) {
    _stdoutSubscription = _process.stdout.listen(_stdoutController.add);
    _stdoutBroadcast = _stdoutController.stream.asBroadcastStream();

    _stderrSubscription = _process.stderr.listen(_stderrController.add);
    _stderrBroadcast = _stderrController.stream.asBroadcastStream();

    _exitCodeSubscription = exitCode.asStream().listen(_exitCodeController.add);
    _exitCodeBroadcast = _exitCodeController.stream.asBroadcastStream();
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

  Stream<int> get exitCodeBroadcast => _exitCodeBroadcast;

  @override
  IOSink get stdin => _process.stdin;

  @override
  Stream<List<int>> get stdout => _stdoutController.stream;

  /// The broadcast stream of the process output.
  Stream<List<int>> get stdoutBroadcast => _stdoutBroadcast;

  /// Cancels creates subscriptions and closes the [StreamController]s.
  @mustCallSuper
  void dispose() {
    _stdoutSubscription?.cancel();
    _stderrSubscription?.cancel();
    _exitCodeSubscription?.cancel();

    _stderrController?.close();
    _stdoutController?.close();
    _exitCodeController?.close();
  }
}
