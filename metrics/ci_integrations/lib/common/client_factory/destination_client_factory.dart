import 'package:ci_integration/common/client/destination_client.dart';
import 'package:ci_integration/common/client_factory/integration_client_factory.dart';
import 'package:ci_integration/common/config/model/destination_config.dart';

abstract class DestinationClientFactory<T extends DestinationConfig,
    K extends DestinationClient> extends IntegrationClientFactory<T, K> {}
