import 'package:ci_integration/common/client/integration_client.dart';
import 'package:ci_integration/common/client_factory/integration_client_factory.dart';
import 'package:ci_integration/common/config/model/config.dart';
import 'package:ci_integration/common/config/parser/config_parser.dart';
import 'package:ci_integration/common/party/integration_party.dart';

/// A stub class for the [IntegrationParty] providing a test implementation.
class IntegrationPartyStub<T extends Config, K extends IntegrationClient>
    implements IntegrationParty<T, K> {
  final IntegrationClientFactory<T, K> _clientFactory;
  final ConfigParser<T> _configParser;

  IntegrationPartyStub(this._clientFactory, this._configParser);

  @override
  IntegrationClientFactory<T, K> get clientFactory => _clientFactory;

  @override
  ConfigParser<T> get configParser => _configParser;
}
