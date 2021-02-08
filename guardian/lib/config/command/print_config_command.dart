// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/config/command/manage_config_command.dart';
import 'package:guardian/config/model/config.dart';

class PrintConfigCommand extends ManageConfigCommand {
  PrintConfigCommand(
    Config Function() configFactory,
  ) : super(configFactory);

  @override
  String get name => 'print';

  @override
  String get description => 'Prints current local configs';

  @override
  void run() {
    if (!checkExists()) return;

    final config = configFactory();
    final contents = configHelper.readConfigs(config.filename);

    print('');
    print(configHelper.yamlFormatter.format(contents));
    print('');
  }
}
