// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/client_factory/integration_client_factory.dart';
import 'package:ci_integration/integration/interface/source/client/source_client.dart';
import 'package:ci_integration/integration/interface/source/config/model/source_config.dart';

/// An abstract class providing method for creating [SourceClient]s.
abstract class SourceClientFactory<T extends SourceConfig,
    K extends SourceClient> extends IntegrationClientFactory<T, K> {}
