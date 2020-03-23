import 'package:ci_integration/jenkins/client/model/jenkins_result.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsResult", () {
    const errorMessage = 'Error';
    const successMessage = 'Hooray';

    const failed = JenkinsResult.error(message: errorMessage, result: -1);
    const success = JenkinsResult.success(message: successMessage, result: 1);

    test(
      ".error() should create an instance describing the failed interaction",
      () {
        expect(failed.isError, isTrue);
        expect(failed.message, equals(errorMessage));
        expect(failed.result, equals(-1));
      },
    );

    test(
      ".success() should create an instance describing the success interaction",
      () {
        expect(success.isSuccess, isTrue);
        expect(success.message, equals(successMessage));
        expect(success.result, equals(1));
      },
    );
  });
}
