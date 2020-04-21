import 'dart:async';

import 'package:ci_integration/common/client/integration_client.dart';
import 'package:ci_integration/common/config/model/config.dart';

abstract class IntegrationClientFactory<T extends Config,
    K extends IntegrationClient> {
  FutureOr<K> create(T config);
}
