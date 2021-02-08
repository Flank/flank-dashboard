// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import '../../../arguments/model/user_credentials.dart';
import '../../../common/config/browser_name.dart';
import '../../../common/model/device.dart';
import '../../common/runner/process_runner.dart';
import '../command/drive_command.dart';
import '../command/flutter_command.dart';
import '../model/flutter_drive_environment.dart';
import '../process/flutter_process.dart';

/// Runs the flutter driver tests.
class FlutterDriveProcessRunner implements ProcessRunner {
  /// A [DriveCommand] which defines the parameters to run the driver tests with.
  final _driveCommand = DriveCommand()
    ..target('test_driver/app_test.dart')
    ..driver('test_driver/app.dart')
    ..device(Device.webServer)
    ..profile()
    ..noKeepAppRunning();

  /// Creates the [FlutterDriveProcessRunner].
  ///
  /// [useSkia] defaults to 'false'.
  /// [verbose] defaults to 'true'.
  ///
  /// [browserName] is the name of the browser which will be used to test the app.
  /// [useSkia] defines whether to run application under test using
  /// SKIA renderer or not.
  /// [verbose] specifies whether print the detailed logs from
  /// the 'flutter drive' command or not.
  FlutterDriveProcessRunner({
    FlutterDriveEnvironment environment,
    BrowserName browserName,
    bool useSkia = false,
    bool verbose = true,
  }) {
    final credentials = environment.userCredentials;

    _driveCommand
      ..browserName(browserName)
      ..useSkia(value: useSkia)
      ..dartDefine(
        key: UserCredentials.emailEnvVariableName,
        value: credentials.email,
      )
      ..dartDefine(
        key: UserCredentials.passwordEnvVariableName,
        value: credentials.password,
      );

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
  Future<void> isAppStarted() async {}

  @override
  List<String> get args => _driveCommand.buildArgs();

  @override
  String get executableName => FlutterCommand.executableName;
}
