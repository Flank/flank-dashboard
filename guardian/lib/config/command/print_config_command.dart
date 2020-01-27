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
