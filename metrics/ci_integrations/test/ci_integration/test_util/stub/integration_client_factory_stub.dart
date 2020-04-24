import 'package:ci_integration/common/client/destination_client.dart';
import 'package:ci_integration/common/client/source_client.dart';
import 'package:ci_integration/common/client_factory/destination_client_factory.dart';
import 'package:ci_integration/common/client_factory/source_client_factory.dart';
import 'package:ci_integration/common/config/model/destination_config.dart';
import 'package:ci_integration/common/config/model/source_config.dart';

/// A stub class for the [SourceClientFactory] providing test
/// implementation that allows to return the given [SourceClient].
class SourceClientFactoryStub<T extends SourceConfig, K extends SourceClient>
    implements SourceClientFactory<T, K> {
  final K _client;

  SourceClientFactoryStub(this._client);

  @override
  K create(T config) {
    ArgumentError.checkNotNull(config);

    return _client;
  }
}

/// A stub class for the [DestinationClientFactory] providing test
/// implementation that allows to return the given [DestinationClient].
class DestinationClientFactoryStub<T extends DestinationConfig,
    K extends DestinationClient> implements DestinationClientFactory<T, K> {
  final K _client;

  DestinationClientFactoryStub(this._client);

  @override
  K create(T config) {
    ArgumentError.checkNotNull(config);

    return _client;
  }
}
