import 'package:ci_integration/common/client/integration_client.dart';
import 'package:ci_integration/common/client_factory/integration_client_factory.dart';
import 'package:ci_integration/common/config/model/config.dart';

/// A stub class for the [IntegrationClientFactory] providing test
/// implementation that allows to return the given [IntegrationClient].
class ClientFactoryStub<T extends Config, K extends IntegrationClient>
    implements IntegrationClientFactory<T, K> {
  final K _client;

  ClientFactoryStub(this._client);

  @override
  K create(T config) {
    ArgumentError.checkNotNull(config);

    return _client;
  }
}
