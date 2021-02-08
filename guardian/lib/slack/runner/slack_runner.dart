// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:args/command_runner.dart';
import 'package:guardian/slack/command/message_command.dart';
import 'package:guardian/slack/command/slack_config_command.dart';

/// A class representing the `slack` group of commands.
class SlackRunner extends Command {
  @override
  String get description => 'Slack integration';

  @override
  String get name => 'slack';

  /// Creates `slack` command and registers sub commands of it.
  SlackRunner() {
    addSubcommand(MessageCommand());
    addSubcommand(SlackConfigCommand());
  }
}
