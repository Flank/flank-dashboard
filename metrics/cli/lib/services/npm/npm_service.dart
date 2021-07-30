// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/common/info_service.dart';
import 'package:cli/services/common/service/model/service_name.dart';

/// An abstract class for Npm service that provides methods for working with Npm.
abstract class NpmService extends InfoService {
  @override
  ServiceName get serviceName => ServiceName.npm;

  /// Installs npm dependencies in the given [path].
  Future<void> installDependencies(String path);
}
