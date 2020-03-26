import 'package:ci_integration/jenkins/client/model/jenkins_result.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsResult", () {
    const errorMessage = 'Error';
    const successMessage = 'Hooray';
    const errorResult = -1;
    const successResult = 1;

    const failed = JenkinsResult.error(
      message: errorMessage,
      result: errorResult,
    );
    const success = JenkinsResult.success(
      message: successMessage,
      result: successResult,
    );

    test(
      ".error() should create an instance describing the failed interaction",
      () {
        expect(failed.isError, isTrue);
        expect(failed.message, equals(errorMessage));
        expect(failed.result, equals(errorResult));
      },
    );

    test(
      ".success() should create an instance describing the success interaction",
      () {
        expect(success.isSuccess, isTrue);
        expect(success.message, equals(successMessage));
        expect(success.result, equals(successResult));
      },
    );
  });
}
