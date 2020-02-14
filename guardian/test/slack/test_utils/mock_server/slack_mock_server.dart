import 'dart:convert';
import 'dart:io';

import 'package:guardian/slack/model/slack_message.dart';

import '../../../test_utils/api_mock_server/api_mock_server.dart';

class SlackMockServer extends ApiMockServer {
  @override
  List<RequestHandler> get handlers => [
        RequestHandler.post(
          pathPattern: RegExp(r"\/?services\/[\w]+\/[\w]+\/[\w]+"),
          dispatcher: _handlePost,
        ),
      ];

  Future<SlackMessage> _messageFromRequest(HttpRequest request) async {
    if (request.contentLength == 0) {
      return null;
    } else {
      final bodyBytes = await request.first;
      final body = String.fromCharCodes(bodyBytes);
      return SlackMessage.fromJson(jsonDecode(body) as Map<String, dynamic>);
    }
  }

  String _validateMessage(SlackMessage message) {
    if (message == null) {
      return 'invalid_payload';
    }

    final hasText = message.text != null && message.text.isNotEmpty;
    final hasBlocks = message.blocks != null && message.blocks.isNotEmpty;

    if (!hasText && !hasBlocks) {
      return 'invalid_payload';
    }

    if (!hasText) {
      return 'no_text';
    }

    if (hasBlocks && message.blocks.any((block) => !block.valid)) {
      return 'invalid_blocks';
    }

    return null;
  }

  Future<void> _handlePost(HttpRequest request) async {
    final message = await _messageFromRequest(request);

    final errorMessage = _validateMessage(message);
    if (errorMessage == null) {
      request.response.statusCode = HttpStatus.ok;
    } else {
      request.response
        ..statusCode = HttpStatus.badRequest
        ..write(errorMessage);
    }

    await request.response.close();
  }
}
