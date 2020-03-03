import 'dart:async';
import 'dart:io';

import '../../common/process/process_wrapper.dart';
import '../command/selenium_command.dart';

/// Represents the selenium server process.
///
/// Selenium process writes all its outputs into stderr stream,
/// so we should merge the stderr and stdout streams into one [stdout]
/// and create a new empty stream for stderr to be sure that logs from
/// selenium server won't fail our app.
class SeleniumProcess extends ProcessWrapper {
  final Stream<List<int>> _stderr = const Stream.empty();
  final StreamController<List<int>> _stdoutController = StreamController();

  StreamSubscription _stderrSubscription;
  StreamSubscription _stdoutSubscription;

  Stream<List<int>> _stdoutBroadcast;

  /// Wraps the [process] and represents is as a [SeleniumProcess].
  SeleniumProcess._(Process process) : super(process) {
    _stderrSubscription = super.stderr.listen(_stdoutController.add);
    _stdoutSubscription = super.stdout.listen(_stdoutController.add);

    _stdoutBroadcast = _stdoutController.stream.asBroadcastStream();
  }

  /// Starts the selenium server in separate process.
  static Future<SeleniumProcess> start(
    SeleniumCommand args, {
    String workingDir,
  }) async {
    final process = await Process.start(
      SeleniumCommand.executableName,
      args.buildArgs(),
      workingDirectory: workingDir,
    );

    return SeleniumProcess._(process);
  }

  @override
  Stream<List<int>> get stderr => _stderr;

  @override
  Stream<List<int>> get stderrBroadcast => _stderr;

  @override
  Stream<List<int>> get stdout => _stdoutController.stream;

  @override
  Stream<List<int>> get stdoutBroadcast => _stdoutBroadcast;

  @override
  void dispose() {
    _stderrSubscription?.cancel();
    _stdoutSubscription?.cancel();
    _stdoutController.close();
    super.dispose();
  }
}
