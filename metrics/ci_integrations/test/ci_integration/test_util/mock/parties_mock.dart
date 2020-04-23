import 'package:ci_integration/ci_integration/parties/parties.dart';
import 'package:ci_integration/common/party/integration_party.dart';
import 'package:mockito/mockito.dart';

class PartiesMock<T extends IntegrationParty> extends Mock
    implements Parties<T> {}
