// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/config/command/manage_config_command.dart';
import 'package:guardian/config/model/config.dart';

class CreateConfigCommand extends ManageConfigCommand {
  CreateConfigCommand(
    Config Function() configFactory,
  ) : super(configFactory);

  @override
  String get name => 'create';

  @override
  String get description => 'Creates config file and stores it locally';

  @override
  void run() {
    final configBase = configFactory();
    final config = configHelper.build(configBase);
    final file = configHelper.writeConfigs(config);

    print('');
    print('File with configurations is created successfully!\n'
        'Path: ${file.path}');
    print('');
  }
}
