import 'package:args/args.dart';
import 'package:guardian/config/model/config.dart';

class SlackConfig extends Config {
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
