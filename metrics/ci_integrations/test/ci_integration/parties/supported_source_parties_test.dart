import 'package:ci_integration/ci_integration/parties/supported_source_parties.dart';
import 'package:ci_integration/jenkins/party/jenkins_source_party.dart';
import 'package:test/test.dart';

void main() {
  group("SupportedSourceParties", () {
    final supportedSourceParties = SupportedSourceParties();

    test(".parties should contain a Jenkins source party", () {
      final parties = supportedSourceParties.parties;

      expect(parties, contains(isA<JenkinsSourceParty>()));
    });

    test(".parties should be an unmodifiable list", () {
      final parties = supportedSourceParties.parties;

      expect(() => parties.add(null), throwsUnsupportedError);
      expect(() => parties.removeAt(0), throwsUnsupportedError);
    });
  });
}
