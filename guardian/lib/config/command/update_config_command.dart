// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/config/command/manage_config_command.dart';
import 'package:guardian/config/model/config.dart';

class UpdateConfigCommand extends ManageConfigCommand {
  UpdateConfigCommand(
    Config Function() configFactory,
  ) : super(configFactory);

  @override
  String get name => 'update';

  @override
  String get description => 'Updates local configs';

  @override
  void run() {
    if (!checkExists()) return;

    final configBase = configFactory();
    final currentConfig = configBase
      ..readFromMap(
        configHelper.readConfigs(configBase.filename),
      );
    final newConfig = configHelper.build(currentConfig);
    final file = configHelper.writeConfigs(newConfig);

    print('');
    print('Configurations are updated succesfully!\n'
        '${configHelper.yamlFormatter.format(newConfig.toMap())}\n'
        'Check at ${file.path}');
    print('');
  }
}
