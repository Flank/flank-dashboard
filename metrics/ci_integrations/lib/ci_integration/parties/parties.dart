import 'package:ci_integration/common/party/integration_party.dart';

/// An abstract class providing th list of integrations.
abstract class Parties<T extends IntegrationParty> {
  /// The list of [IntegrationParty] used to define integrations.
  /// 
  /// This is preferably to be an unmodifiable list.
  List<T> get parties;
}
