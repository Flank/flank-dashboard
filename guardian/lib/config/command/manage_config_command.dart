// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:args/command_runner.dart';
import 'package:guardian/config/helper/config_helper.dart';
import 'package:guardian/config/model/config.dart';

abstract class ManageConfigCommand extends Command {
  ManageConfigCommand(
    this.configFactory,
  ) : assert(configFactory != null);

  final Config Function() configFactory;
  final ConfigHelper configHelper = ConfigHelper();

  bool checkExists() {
    final exists = configHelper.checkExists(configFactory().filename);

    if (!exists) {
      print('');
      print('Cofigurations are not found!\n'
          'You can create new with <create> command.');
      print('');
    }

    return exists;
  }
}
