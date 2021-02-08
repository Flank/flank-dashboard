// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/slack/model/slack_text_object.dart';
import 'package:meta/meta.dart';

/// A class that represents Slack Block Kit text object of `plain_text` type.
class SlackPlainTextObject extends SlackTextObject {
  /// Indicates whether emojis in a [text] should be escaped into the colon
  /// emoji format.
  final bool emoji;

  /// Creates an instance of text object of `plaint_text` type.
  ///
  /// [text] is required.
  const SlackPlainTextObject({
    @required String text,
    this.emoji,
  }) : super(text);

  /// Creates an instance of text object of `plaint_text` type from
  /// decoded JSON object.
  ///
  /// Returns `null` if [json] is `null`.
  factory SlackPlainTextObject.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return SlackPlainTextObject(
      text: json['text'] as String,
      emoji: json['emoji'] as bool,
    );
  }

  @override
  List<Object> get props => super.props..add(emoji);

  /// Converts object into the [Map].
  ///
  /// Extends [SlackTextObject.toJson] with `type` field equals to `plain_text`.
  /// Resulting map will include [emoji] if it not equals to `null`.
  /// Result is valid to be sent to Slack API.
  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();

    map['type'] = 'plain_text';
    if (emoji != null) map['emoji'] = emoji;

    return map;
  }
}
