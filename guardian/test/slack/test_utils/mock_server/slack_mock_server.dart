// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:guardian/slack/model/slack_message.dart';

import '../../../test_utils/api_mock_server/api_mock_server.dart';

/// A mock server for Slack Incoming Webhooks API.
class SlackMockServer extends ApiMockServer {
  @override
  List<RequestHandler> get handlers => [
        RequestHandler.post(
          pathPattern: RegExp(r"\/?services\/[\w]+\/[\w]+\/[\w]+"),
          dispatcher: _handlePost,
        ),
      ];

  /// Handles a 'POST' requests with [SlackMessage].
  Future<void> _handlePost(HttpRequest request) async {
    final slackMessage = await _messageFromRequest(request);

    request.response.statusCode =
        _validateMessage(slackMessage) ? HttpStatus.ok : HttpStatus.badRequest;

    await request.response.close();
  }

  /// Transforms the [request]'s body to an instance of [SlackMessage].
  Future<SlackMessage> _messageFromRequest(HttpRequest request) async {
    if (request.contentLength == 0) {
      return null;
    } else {
      final bodyBytes = await request.first;
      final body = String.fromCharCodes(bodyBytes);
      return SlackMessage.fromJson(jsonDecode(body) as Map<String, dynamic>);
    }
  }

  /// Validates [message] from the request.
  ///
  /// Returns `true` if Slack Incoming Webhook API will accept the message and
  /// `false` otherwise.
  bool _validateMessage(SlackMessage message) {
    return message != null && message.validate().isValid;
  }
}
