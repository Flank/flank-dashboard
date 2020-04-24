import 'package:ci_integration/common/client/destination_client.dart';
import 'package:ci_integration/common/client/source_client.dart';
import 'package:ci_integration/common/client_factory/integration_client_factory.dart';
import 'package:ci_integration/common/config/model/destination_config.dart';
import 'package:ci_integration/common/config/model/source_config.dart';
import 'package:ci_integration/common/config/parser/config_parser.dart';
import 'package:ci_integration/common/party/destination_party.dart';
import 'package:ci_integration/common/party/source_party.dart';

/// A stub class for the [DestinationParty] providing a test implementation.
class DestinationPartyStub<T extends DestinationConfig,
    K extends DestinationClient> implements DestinationParty<T, K> {
  final IntegrationClientFactory<T, K> _clientFactory;
  final ConfigParser<T> _configParser;

  DestinationPartyStub(this._clientFactory, this._configParser);

  @override
  // TODO: implement clientFactory
  IntegrationClientFactory<T, K> get clientFactory => _clientFactory;

  @override
  // TODO: implement configParser
  ConfigParser<T> get configParser => _configParser;
}

/// A stub class for the [SourceParty] providing a test implementation.
class SourcePartyStub<T extends SourceConfig, K extends SourceClient>
    implements SourceParty<T, K> {
  final IntegrationClientFactory<T, K> _clientFactory;
  final ConfigParser<T> _configParser;

  SourcePartyStub(this._clientFactory, this._configParser);

  @override
  // TODO: implement clientFactory
  IntegrationClientFactory<T, K> get clientFactory => _clientFactory;

  @override
  // TODO: implement configParser
  ConfigParser<T> get configParser => _configParser;
}
