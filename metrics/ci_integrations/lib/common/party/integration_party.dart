import 'package:ci_integration/common/client/integration_client.dart';
import 'package:ci_integration/common/client_factory/integration_client_factory.dart';
import 'package:ci_integration/common/config/model/config.dart';
import 'package:ci_integration/common/config/parser/config_parser.dart';

/// An abstract class representing an integration party.
abstract class IntegrationParty<T extends Config, K extends IntegrationClient> {
  /// A client factory for this integration party.
  ///
  /// Used to create [IntegrationClient]s for this integration party.
  IntegrationClientFactory<T, K> get clientFactory;

  /// A configuration parser for this integration party.
  ///
  /// Used to parse configurations related to this integration party.
  ConfigParser<T> get configParser;
}
