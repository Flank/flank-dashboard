import 'package:ci_integration/command/parties/parties.dart';
import 'package:ci_integration/integration/interface/base/party/integration_party.dart';
import 'package:mockito/mockito.dart';

class PartiesMock<T extends IntegrationParty> extends Mock
    implements Parties<T> {}
