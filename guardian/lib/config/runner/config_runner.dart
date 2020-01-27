import 'package:args/command_runner.dart';
import 'package:guardian/config/command/create_config_command.dart';
import 'package:guardian/config/command/delete_config_command.dart';
import 'package:guardian/config/command/print_config_command.dart';
import 'package:guardian/config/command/update_config_command.dart';
import 'package:guardian/config/model/config.dart';

abstract class ConfigRunner extends Command {
  @override
  String get name => 'config';

  @override
  String get description;

  Config configFactory();

  ConfigRunner() {
    addSubcommand(CreateConfigCommand(configFactory));
    addSubcommand(UpdateConfigCommand(configFactory));
    addSubcommand(DeleteConfigCommand(configFactory));
    addSubcommand(PrintConfigCommand(configFactory));
  }
}
