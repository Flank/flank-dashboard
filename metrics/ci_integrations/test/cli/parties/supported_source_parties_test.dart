import 'package:ci_integration/cli/parties/supported_source_parties.dart';
import 'package:ci_integration/source/github_actions/party/github_actions_source_party.dart';
import 'package:ci_integration/source/jenkins/party/jenkins_source_party.dart';
import 'package:test/test.dart';

void main() {
  group("SupportedSourceParties", () {
    final supportedSourceParties = SupportedSourceParties();

    test(".parties contain a Jenkins source party", () {
      final parties = supportedSourceParties.parties;

      expect(parties, contains(isA<JenkinsSourceParty>()));
    });

    test(".parties contain a Github Actions source party", () {
      final parties = supportedSourceParties.parties;

      expect(parties, contains(isA<GithubActionsSourceParty>()));
    });

    test(".parties is an unmodifiable list", () {
      final parties = supportedSourceParties.parties;

      expect(() => parties.add(null), throwsUnsupportedError);
      expect(() => parties.removeAt(0), throwsUnsupportedError);
    });
  });
}
