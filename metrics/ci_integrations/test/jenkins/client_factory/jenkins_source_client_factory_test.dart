import 'package:ci_integration/jenkins/client_factory/jenkins_source_client_factory.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsSourceClientFactory", () {
    const jenkinsSourceParty = JenkinsSourceClientFactory();

    test(
      ".create() should throw ArgumentError if the given config is null",
      () {
        expect(() => jenkinsSourceParty.create(null), throwsArgumentError);
      },
    );
  });
}
