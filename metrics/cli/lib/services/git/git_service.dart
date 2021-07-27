// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/services/common/info_service.dart';
import 'package:cli/services/common/service/model/service_name.dart';

/// An abstract class for Git service that provides methods for working with Git.
abstract class GitService extends InfoService {
  @override
  ServiceName get serviceName => ServiceName.git;

  /// Checkouts a Git repository from the given [repoUrl]
  /// into the given [targetDirectory].
  Future<void> checkout(String repoUrl, String targetDirectory);
}
