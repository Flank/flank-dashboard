import 'dart:convert';

import 'package:guardian/slack/model/slack_message.dart';
import 'package:guardian/slack/model/slack_result.dart';
import 'package:http/http.dart';

/// An adapter that makes calls to Slack API using Slack Incoming Webhooks.
class SlackWebhookClient {
  /// The HTTP client for making requests to Slack API.
  final Client _client;

  /// The Incoming Webhook URL that can be used to post messages.
  final String webhookUrl;

  SlackWebhookClient({
    this.webhookUrl,
    Client client,
  }) : _client = client ?? Client();

  /// Sends [message] to the Slack using [webhookUrl].
  Future<SlackResult> sendMessage(SlackMessage message) async {
    try {
      final response = await _client.post(
        webhookUrl,
        body: jsonEncode(message),
      );

      if (response.statusCode == 200) {
        return SlackResult.success('Message has been sent successfully');
      } else {
        return SlackResult.error('Failed to send a message: ${response.body}');
      }
    } catch (error) {
      return SlackResult.error('Something went wrong: $error');
    }
  }

  void close() {
    _client.close();
  }
}
