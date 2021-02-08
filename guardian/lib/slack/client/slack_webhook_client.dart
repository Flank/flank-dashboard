// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:guardian/slack/model/slack_message.dart';
import 'package:guardian/slack/model/slack_result.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

/// An adapter that makes calls to Slack API using Slack Incoming Webhooks.
class SlackWebhookClient {
  /// The HTTP client for making requests to Slack API.
  final Client _client;

  /// The Incoming Webhook URL that can be used to post messages.
  final String webhookUrl;

  /// Creates Slack Webhook Client (https://api.slack.com/messaging/webhooks).
  ///
  /// [webhookUrl] is required. Throws [ArgumentError] if [webhookUrl] is `null`.
  SlackWebhookClient({
    @required this.webhookUrl,
  }) : _client = Client() {
    if (webhookUrl == null) {
      throw ArgumentError.value(webhookUrl, 'webhookUrl');
    }
  }

  /// Sends [message] to the Slack using [webhookUrl].
  Future<SlackResult> sendMessage(SlackMessage message) async {
    try {
      final response = await _client.post(
        webhookUrl,
        body: jsonEncode(message),
      );

      if (response.statusCode == HttpStatus.ok) {
        return SlackResult.success('Message has been sent successfully');
      } else {
        return SlackResult.error('Failed to send a message: ${response.body}');
      }
    } catch (error) {
      return SlackResult.error('Something went wrong: $error');
    }
  }

  /// Closes the client and cleans up any resources associated with it.
  /// Similar to [Client.close].
  void close() {
    _client.close();
  }
}
