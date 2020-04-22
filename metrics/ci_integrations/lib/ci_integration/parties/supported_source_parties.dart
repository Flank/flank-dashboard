import 'package:ci_integration/ci_integration/parties/parties.dart';
import 'package:ci_integration/common/party/source_party.dart';
import 'package:ci_integration/jenkins/party/jenkins_source_party.dart';

/// A class providing all the supported source integrations.
class SupportedSourceParties implements Parties<SourceParty> {
  @override
  final List<SourceParty> parties = List.unmodifiable([
    JenkinsSourceParty(),
  ]);
}
