// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/common/factory/services_factory.dart';
import 'package:cli/deploy/deployer.dart';
import 'package:cli/deploy/paths/deploy_paths.dart';
import 'package:cli/helper/file_helper.dart';
import 'package:cli/prompt/prompter.dart';
import 'package:cli/prompt/writer/io_prompt_writer.dart';

/// A class providing method for creating a [Deployer] instance.
class DeployerFactory {
  /// A [ServicesFactory] class this factory uses to create the services.
  final ServicesFactory _servicesFactory;

  /// Creates a new instance of the [DeployerFactory]
  /// with the given [ServicesFactory].
  ///
  /// The services factory defaults to the [ServicesFactory] instance.
  ///
  /// Throws an [ArgumentError] if the given services factory is `null`.
  DeployerFactory([this._servicesFactory = const ServicesFactory()]) {
    ArgumentError.checkNotNull(_servicesFactory, 'servicesFactory');
  }

  /// Creates a new instance of the [Deployer].
  Deployer create() {
    final services = _servicesFactory.create();
    final fileHelper = FileHelper();
    final promptWriter = IOPromptWriter();
    final prompter = Prompter(promptWriter);
    final deployPaths = DeployPaths();

    return Deployer(
      services: services,
      fileHelper: fileHelper,
      prompter: prompter,
      deployPaths: deployPaths,
    );
  }
}
