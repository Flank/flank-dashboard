import 'dart:convert';

import 'package:guardian/slack/model/slack_message.dart';
import 'package:guardian/slack/model/slack_result.dart';
import 'package:http/http.dart';

class SlackClient {
  final Client _client;
  final String webhookUrl;

  SlackClient({
    this.webhookUrl,
    Client client,
  }) : _client = client ?? Client();

  Future<SlackResult> sendMessage(SlackMessage message) async {
    try {
      final response = await _client.post(
        webhookUrl,
        body: jsonEncode(message),
      );

      if (response.statusCode >= 400) {
        return SlackResult.error('Failed to send a message: ${response.body}');
      } else {
        return SlackResult.success();
      }
    } catch (error) {
      return SlackResult.error('Something went wrong: $error');
    }
  }
}
