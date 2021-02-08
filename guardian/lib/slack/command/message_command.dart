// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:io';

import 'package:args/args.dart';
import 'package:guardian/slack/client/slack_webhook_client.dart';
import 'package:guardian/slack/command/slack_command.dart';
import 'package:guardian/slack/model/slack_config.dart';
import 'package:guardian/slack/model/slack_message.dart';

/// A class representing the `message` command for Slack. Provides interface
/// for sending [SlackMessage] using [SlackWebhookClient].
class MessageCommand extends SlackCommand {
  @override
  String get name => 'message';

  @override
  String get description => 'Sends message to the Slack';

  /// Creates [MessageCommand] instance and provides [SlackConfig] properties
  /// to [ArgParser] to include in command-line interface.
  MessageCommand() {
    addConfigOptionByNames(['webhookUrl']);
  }

  /// Performs the `slack message` command.
  ///
  /// If [SlackConfig.webhookUrl] hasn't been set neither in configuration nor
  /// in [ArgParser.options] of the command then prints to [stderr]
  /// and stops execution.
  @override
  Future<void> run() async {
    final url = argResults['webhookUrl'] as String;

    if (url == null || url.isEmpty) {
      stderr.writeln('Webhook URL is required');
      return;
    }

    final body = stdin.readLineSync();

    final slack = SlackWebhookClient(webhookUrl: url);

    final message = SlackMessage(text: body);
    final validation = message.validate();

    if (validation.isValid) {
      final result = await slack.sendMessage(message);
      stdout.writeln(result.message);
    } else {
      stderr.writeln('Message payload is invalid: ${validation.message}');
    }

    slack.close();
  }
}
