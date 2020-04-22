import 'package:ci_integration/jenkins/client_factory/jenkins_source_client_factory.dart';
import 'package:ci_integration/jenkins/config/parser/jenkins_config_parser.dart';
import 'package:ci_integration/jenkins/party/jenkins_source_party.dart';
import 'package:test/test.dart';

void main() {
  group("JenkinsSourceParty", () {
    final jenkinsSourceParty = JenkinsSourceParty();

    test("should use JenkinsSourceClientFactory as a client factory", () {
      final clientFactory = jenkinsSourceParty.clientFactory;

      expect(clientFactory, isA<JenkinsSourceClientFactory>());
    });

    test("should use JenkinsConfigParser as a config parser", () {
      final configParser = jenkinsSourceParty.configParser;

      expect(configParser, isA<JenkinsConfigParser>());
    });
  });
}
