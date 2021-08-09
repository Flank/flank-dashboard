// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:args/command_runner.dart';
import 'package:cli/cli/deployer/deployer.dart';
import 'package:cli/cli/deployer/factory/deployer_factory.dart';

/// A [Command] that deploys the Metrics Web application.
class DeployCommand extends Command {
  @override
  final name = 'deploy';
  @override
  final description = '''
Creates GCloud and Firebase projects for Metrics components and deploys the Metrics Web Application.
      
NOTE: The Metrics CLI does not collect and store any personal data during the deployment process.''';

  /// A [DeployerFactory] this command uses to create a [Deployer].
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
