// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/config/command/manage_config_command.dart';
import 'package:guardian/config/model/config.dart';

class DeleteConfigCommand extends ManageConfigCommand {
  DeleteConfigCommand(
    Config Function() configFactory,
  ) : super(configFactory);

  @override
  String get name => 'delete';

  @override
  String get description => 'Deletes local configs if exists';

  @override
  void run() {
    if (!checkExists()) return;

    final config = configFactory();
    configHelper.removeConfigs(config.filename);

    print('');
    print('Cofigurations are removed.\n'
        'You can create new with <create> command.');
    print('');
  }
}
