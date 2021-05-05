// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/deploy/deployer.dart';
import 'package:cli/deploy/model/deploy_paths.dart';

/// A class providing method for creating a [DeployPaths] instance.
class DeployPathsFactory {
  /// Creates a new instance of the [Deployer] with the given [rootPath].
  DeployPaths create(String rootPath) {
    return DeployPaths(rootPath);
  }
}
