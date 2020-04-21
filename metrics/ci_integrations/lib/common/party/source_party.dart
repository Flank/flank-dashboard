import 'package:ci_integration/common/client/source_client.dart';
import 'package:ci_integration/common/config/model/source_config.dart';
import 'package:ci_integration/common/party/integration_party.dart';

abstract class SourceParty<T extends SourceConfig, K extends SourceClient>
    extends IntegrationParty<T, K> {}
