import '../../../common/config/device.dart';
import '../../common/runner/process_runner.dart';
import '../command/flutter_command.dart';
import '../command/run_command.dart';
import '../process/flutter_process.dart';

/// Runs the flutter application.
class FlutterRunProcessRunner implements ProcessRunner {
  final RunCommand _arguments = RunCommand()
    ..device(Device.webServer)
    ..target('lib/app.dart');

  FlutterProcess _process;
  Future _isAppStarted;

  /// Creates the [FlutterRunProcessRunner].
  ///
  /// [port] is the port to run the application on.
  /// [useSkia] describes whether run the application with
  /// the SKIA renderer or nor.
  /// [verbose] specifies whether print detailed logs from
  /// the 'flutter run' command or nor.
  FlutterRunProcessRunner({
    int port,
    bool useSkia = false,
    bool verbose = true,
  }) {
    _arguments
      ..webPort(port)
      ..useSkia(value: useSkia);

    if (verbose) {
      _arguments.verbose();
    }
  }

  @override
  Future<FlutterProcess> run({String workingDir}) async {
    _process = await FlutterProcess.start(
      _arguments,
      workingDir: workingDir,
    );

    _isAppStarted = _process.stdoutBroadcast.firstWhere((out) {
      if (out == null || out.isEmpty) return false;
      final consoleOut = String.fromCharCodes(out);
      return consoleOut.contains('is being served at');
    }, orElse: () => null);

    return _process;
  }

  @override
  Future<void> isAppStarted() => _isAppStarted;

  @override
  List<String> get args => _arguments.buildArgs();

  @override
  String get executableName => FlutterCommand.executableName;
}
