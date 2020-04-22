import 'package:ci_integration/common/client/source_client.dart';
import 'package:ci_integration/common/client_factory/integration_client_factory.dart';
import 'package:ci_integration/common/config/model/source_config.dart';

/// An abstract class providing method for creating [SourceClient]s.
abstract class SourceClientFactory<T extends SourceConfig,
    K extends SourceClient> extends IntegrationClientFactory<T, K> {}
