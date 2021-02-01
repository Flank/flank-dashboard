import 'package:cli/doctor/doctor_command.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../test_util/called_once_verification_result.dart';
import '../test_util/mocks.dart';

void main() {
  group("DoctorCommand", () {
    final firebaseMock = FirebaseCommandMock();
    final gcloudMock = GCloudCommandMock();
    final gitMock = GitCommandMock();
    final flutterMock = FlutterCommandMock();
    final npmMock = NpmCommandMock();

    final command = DoctorCommand(
      firebase: firebaseMock,
      gcloud: gcloudMock,
      git: gitMock,
      flutter: flutterMock,
      npm: npmMock,
    );

    tearDown(() {
      reset(firebaseMock);
      reset(gcloudMock);
      reset(gitMock);
      reset(flutterMock);
      reset(npmMock);
    });

    test(".name equals to the 'doctor' command name", () {
      final doctorCommand = DoctorCommand();

      final name = doctorCommand.name;

      expect(name, equals('doctor'));
    });

    test(".description is non-empty string with command desctiption", () {
      final doctorCommand = DoctorCommand();

      final description = doctorCommand.description;

      expect(description, isNotEmpty);
    });

    test(".run() executes flutter version", () async {
      await command.run();

      verify(flutterMock.version()).calledOnce();
    });

    test(".run() executes firebase version", () async {
      await command.run();

      verify(firebaseMock.version()).calledOnce();
    });

    test(".run() executes gcloud version", () async {
      await command.run();

      verify(gcloudMock.version()).calledOnce();
    });

    test(".run() executes git version", () async {
      await command.run();

      verify(gitMock.version()).calledOnce();
    });

    test(".run() executes npm version", () async {
      await command.run();

      verify(npmMock.version()).calledOnce();
    });
  });
}
