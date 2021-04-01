// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:args/command_runner.dart';
import 'package:cli/deploy/factory/deployer_factory.dart';

/// A [Command] implementation that deploy the Metrics Web application.
class DeployCommand extends Command {
  @override
  final name = "deploy";
  @override
  final description =
      "Creates the GCloud and Firebase projects and deploys the Metrics application to the hosting.";

  final DeployerFactory _deployerFactory;

  /// Creates a new instance of the [DeployCommand]
  /// with the given [DeployerFactory].
  ///
  /// Throws an [ArgumentError] if the given [DeployerFactory] is `null`.
  DeployCommand(this._deployerFactory) {
    ArgumentError.checkNotNull(_deployerFactory, 'deployerFactory');
  }

  @override
  Future<void> run() {
    final deployer = _deployerFactory.create();

    return deployer.deploy();
  }
}
