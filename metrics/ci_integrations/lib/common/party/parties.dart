
import 'package:ci_integration/common/party/integration_party.dart';

abstract class Parties<T extends IntegrationParty> {
  List<T> get parties;
}