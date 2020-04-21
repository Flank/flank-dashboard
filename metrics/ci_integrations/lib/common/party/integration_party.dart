import 'package:ci_integration/common/client/integration_client.dart';
import 'package:ci_integration/common/client_factory/integration_client_factory.dart';
import 'package:ci_integration/common/config/model/config.dart';
import 'package:ci_integration/common/config/parser/config_parser.dart';

abstract class IntegrationParty<T extends Config, K extends IntegrationClient> {
  IntegrationClientFactory<T, K> get clientFactory;
  ConfigParser<T> get configParser;
}
