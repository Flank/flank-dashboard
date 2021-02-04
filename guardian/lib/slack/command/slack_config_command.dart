// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/config/model/config.dart';
import 'package:guardian/config/runner/config_runner.dart';
import 'package:guardian/slack/model/slack_config.dart';

/// A class providing commands for managing configurations related to Slack.
class SlackConfigCommand extends ConfigRunner {
  @override
  String get description => 'Manages Slack configs stored locally';

  @override
  Config configFactory() {
    return SlackConfig();
  }
}
