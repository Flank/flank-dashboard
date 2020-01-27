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
