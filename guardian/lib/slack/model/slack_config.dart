// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:args/args.dart';
import 'package:guardian/config/model/config.dart';

/// A class representing user's configurations for Slack.
class SlackConfig extends Config {
  /// Creates Slack configurations with `slack.yaml` filename.
  SlackConfig({
    this.webhookUrl,
  }) : super('slack.yaml');

  String webhookUrl;

  @override
  List<ConfigField> get fields => [
        ConfigField<String>(
          name: 'webhookUrl',
          description: 'Slack Webhook URL',
          setter: (value) => webhookUrl = value,
          value: webhookUrl,
        ),
      ];

  @override
  void readFromMap(Map<String, dynamic> map) {
    if (map != null) {
      webhookUrl = map['webhookUrl'] as String;
    }
  }

  @override
  void readFromArgs(ArgResults argResults) {
    if (argResults != null) {
      webhookUrl = argResults['webhookUrl'] as String;
    }
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'webhookUrl': webhookUrl,
    };
  }

  @override
  SlackConfig copy() {
    return SlackConfig(
      webhookUrl: webhookUrl,
    );
  }
}
