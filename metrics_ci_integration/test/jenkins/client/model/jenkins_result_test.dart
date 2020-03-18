import 'package:ci_integration/jenkins/client/model/jenkins_result.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsResult", () {
    const failed = JenkinsResult.error(message: 'Error');
    const success = JenkinsResult.success(message: 'Hooray!');

    test(
      ".error() should create an instance describing the failed interaction",
      () {
        expect(failed.isError, isTrue);
        expect(failed.message, equals('Error'));
      },
    );

    test(
      ".success() should create an instance describing the success interaction",
      () {
        expect(success.isSuccess, isTrue);
        expect(success.message, equals('Hooray!'));
      },
    );
  });
}
