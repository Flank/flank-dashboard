// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:meta/meta.dart';

/// A base class for [Process] wrappers.
///
/// Provides the [stdoutBroadcast] and [stderrBroadcast] streams to allow multi subscriptions.
/// We need to wrap the [Process] because it contains external static methods to start/run
/// the processes, that are not inheriting in Dart.
abstract class ProcessWrapper implements Process {
  /// An original [Process], wrapped by this class.
  final Process _process;

  /// A [StreamController] of the process errors.
  final StreamController<List<int>> _stderrController = StreamController();

  /// A [StreamController] of the process output.
  final StreamController<List<int>> _stdoutController = StreamController();

  /// A [StreamController] of the process exit code.
  final StreamController<int> _exitCodeController =
      StreamController.broadcast();

  /// A broadcast [Stream] of the process errors.
  Stream<List<int>> _stderrBroadcast;

  /// A broadcast [Stream] of the process output.
  Stream<List<int>> _stdoutBroadcast;

  /// A [StreamSubscription] of the process errors.
  StreamSubscription _stderrSubscription;

  /// A [StreamSubscription] of the process output.
  StreamSubscription _stdoutSubscription;

  /// A [StreamSubscription] of the process exit code.
  StreamSubscription _exitCodeSubscription;

  @override
  Future<int> get exitCode => _process.exitCode;

  @override
  int get pid => _process.pid;

  @override
  IOSink get stdin => _process.stdin;

  @override
  Stream<List<int>> get stdout => _stdoutController.stream;

  @override
  Stream<List<int>> get stderr => _stderrController.stream;

  /// Provides the broadcast [Stream] of the process errors.
  Stream<List<int>> get stderrBroadcast => _stderrBroadcast;

  /// Provides the broadcast [Stream] of the process output.
  Stream<List<int>> get stdoutBroadcast => _stdoutBroadcast;

  /// Provides the broadcast [Stream] of the process exit code.
  Stream<int> get exitCodeBroadcast => _exitCodeController.stream;

  /// Creates a new instance of the [ProcessWrapper] with the given [Process].
  ProcessWrapper(this._process) {
    _stdoutSubscription = _process.stdout.listen(_stdoutController.add);
    _stdoutBroadcast = _stdoutController.stream.asBroadcastStream();

    _stderrSubscription = _process.stderr.listen(_stderrController.add);
    _stderrBroadcast = _stderrController.stream.asBroadcastStream();

    _exitCodeSubscription = exitCode.asStream().listen(_exitCodeController.add);
  }

  @override
  bool kill([ProcessSignal signal = ProcessSignal.sigterm]) {
    return _process.kill(signal);
  }

  /// Cancels [StreamSubscription]s and closes the [StreamController]s.
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
