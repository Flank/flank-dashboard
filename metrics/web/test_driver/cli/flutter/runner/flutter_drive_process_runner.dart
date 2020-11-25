import '../../../common/config/browser_name.dart';
import '../../../common/model/device.dart';
import '../../common/runner/process_runner.dart';
import '../command/drive_command.dart';
import '../command/flutter_command.dart';
import '../model/flutter_drive_environment.dart';
import '../process/flutter_process.dart';

/// Runs the flutter driver tests.
class FlutterDriveProcessRunner implements ProcessRunner {
  final FlutterDriveEnvironment environment;

  final _driveCommand = DriveCommand()
    ..target('test_driver/app.dart')
    ..driver('test_driver/app_test.dart')
    ..device(Device.webServer)
    ..profile()
    ..noKeepAppRunning();

  /// Creates the [FlutterDriveProcessRunner].
  ///
  /// [browserName] is the name of the browser which will be used to test the app.
  /// [verbose] specifies whether print the detailed logs from
  /// the 'flutter drive' command or not.
  /// The [environment] contains relevant to driver tests information.
  FlutterDriveProcessRunner({
    this.environment,
    BrowserName browserName,
    bool useSkia = false,
    bool verbose = true,
  }) {
    _driveCommand
      ..browserName(browserName)
      ..useSkia(value: useSkia);

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
      environment: environment,
    );
  }

  @override
  Future<void> isAppStarted() async {}

  @override
  List<String> get args => _driveCommand.buildArgs();

  @override
  String get executableName => FlutterCommand.executableName;
}
