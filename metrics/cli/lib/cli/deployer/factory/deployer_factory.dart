// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/cli/deployer/deployer.dart';
import 'package:cli/cli/deployer/model/factory/deploy_paths_factory.dart';
import 'package:cli/common/model/factory/services_factory.dart';
import 'package:cli/prompter/prompter.dart';
import 'package:cli/prompter/writer/io_prompt_writer.dart';
import 'package:cli/util/file/file_helper.dart';

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
    const fileHelper = FileHelper();

    final services = _servicesFactory.create();
    final promptWriter = IOPromptWriter();
    final prompter = Prompter(promptWriter);
    final deployPathsFactory = DeployPathsFactory();

    return Deployer(
      services: services,
      fileHelper: fileHelper,
      prompter: prompter,
      deployPathsFactory: deployPathsFactory,
    );
  }
}
