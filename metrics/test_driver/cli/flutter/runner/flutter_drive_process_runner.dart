import '../../../common/config/browser_name.dart';
import '../../../common/config/device.dart';
import '../../common/runner/process_runner.dart';
import '../command/drive_command.dart';
import '../command/flutter_command.dart';
import '../process/flutter_process.dart';

/// Runs the flutter driver tests in separate process.
class FlutterDriveProcessRunner implements ProcessRunner {
  final _driveCommand = DriveCommand()
    ..target('lib/app.dart')
    ..driver('test_driver/app_test.dart')
    ..device(Device.chrome)
    ..noKeepAppRunning();

  /// Creates the [FlutterDriveProcessRunner].
  ///
  /// [port] is the port in which the application is running.
  /// [browserName] is the name of the browser which will be used to test the app.
  /// [verbose] specifies whether print the advanced logs from
  /// the 'flutter drive' command or not.
  FlutterDriveProcessRunner({
    int port,
    BrowserName browserName,
    bool verbose = true,
  }) {
    _driveCommand
      ..useExistingApp('http://localhost:$port/#')
      ..browserName(browserName);

    if (verbose) {
      _driveCommand.verbose();
    }
  }

  @override
  Future<FlutterProcess> run({
    String workingDir,
  }) async {
    return FlutterProcess.start(
      _driveCommand,
      workingDir: workingDir,
    );
  }

  @override
  Future<void> get started async {}

  @override
  List<String> get args => _driveCommand.buildArgs();

  @override
  String get executableName => FlutterCommand.executableName;
}
