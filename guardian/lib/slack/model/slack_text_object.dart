// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:guardian/slack/model/slack_markdown_text_object.dart';
import 'package:guardian/slack/model/slack_plain_text_object.dart';
import 'package:guardian/slack/model/validation_result.dart';
import 'package:meta/meta.dart';

/// A class that represents Slack Block Kit text object
/// (https://api.slack.com/reference/block-kit/composition-objects#text).
abstract class SlackTextObject extends Equatable {
  /// The text for the block.
  ///
  /// This field accepts any of the standard text formatting markup
  /// (https://api.slack.com/reference/surfaces/formatting) when type is
  /// [SlackTextObjectType.markdown].
  final String text;

  const SlackTextObject(this.text);

  /// Delegates creating text object to implementers depending on `type` of text
  /// object from decoded JSON object.
  ///
  /// Delegates to [SlackPlainTextObject.fromJson] if `type` is `plain_text`
  /// and to [SlackMarkdownTextObject.fromJson] if `mrkdwn`.
  /// Returns `null` if [json] is `null` or if `type` is not one of:
  /// `plain_text`, `mrkdwn`.
  factory SlackTextObject.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    if (json['type'] == 'plain_text') {
      return SlackPlainTextObject.fromJson(json);
    } else if (json['type'] == 'mrkdwn') {
      return SlackMarkdownTextObject.fromJson(json);
    } else {
      return null;
    }
  }

  /// Creates a list of text objects from list of decoded JSON objects.
  static List<SlackTextObject> listFromJson(List<dynamic> list) {
    return list
        ?.map((json) => SlackTextObject.fromJson(json as Map<String, dynamic>))
        ?.toList();
  }

  @override
  List<Object> get props => [text];

  /// Validates [SlackTextObject] to match following rules:
  ///   1. [text] is required and must be not `null` and not empty.
  ///   2. If [maxLength] is provided, [text] must contain up to
  ///  `maxLength` characters.
  @nonVirtual
  ValidationResult validate([int maxLength]) {
    final hasText = text != null && text.isNotEmpty;

    if (hasText) {
      if (maxLength == null) return ValidationResult.valid();
      return text.length <= maxLength
          ? ValidationResult.valid()
          : ValidationResult.invalid(
              'Text is limited to contain up to $maxLength '
              'characters but ${text.length} found',
            );
    } else {
      return ValidationResult.invalid('Text is missing');
    }
  }

  /// Converts object into the [Map].
  ///
  /// Implementers must call super to get map with text and extend it with
  /// `type` field. Results with value that is not ready to be sent to Slack API.
  @mustCallSuper
  Map<String, dynamic> toJson() {
    return {'text': text};
  }

  @override
  String toString() {
    return '$runtimeType ${toJson()}';
  }
}
