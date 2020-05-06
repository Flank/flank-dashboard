import 'package:ci_integration/integration/interface/base/party/integration_party.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:ci_integration/integration/interface/source/config/model/source_config.dart';

/// An abstract class representing an integration party
/// for a source integration.
abstract class SourceParty<T extends SourceConfig, K extends SourceClient>
    extends IntegrationParty<T, K> {}
