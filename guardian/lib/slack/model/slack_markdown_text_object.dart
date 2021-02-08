// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:guardian/slack/model/slack_text_object.dart';
import 'package:meta/meta.dart';

/// A class that represents Slack Block Kit text object of `mrkdwn` type.
class SlackMarkdownTextObject extends SlackTextObject {
  /// Indicates whether to use Slack's preprocessing for the [text].
  final bool verbatim;

  /// Creates an instance of text object of `mrkdwn` type.
  ///
  /// [text] is required.
  const SlackMarkdownTextObject({
    @required String text,
    this.verbatim,
  }) : super(text);

  /// Creates an instance of text object of `mrkdwn` type from
  /// decoded JSON object.
  ///
  /// Returns `null` if [json] is `null`.
  factory SlackMarkdownTextObject.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return SlackMarkdownTextObject(
      text: json['text'] as String,
      verbatim: json['verbatim'] as bool,
    );
  }

  @override
  List<Object> get props => super.props..add(verbatim);

  /// Converts object into the [Map].
  ///
  /// Extends [SlackTextObject.toJson] with `type` field equals to `mrkdwn`.
  /// Resulting map will include [verbatim] if it not equals to `null`.
  /// Result is valid to be sent to Slack API.
  @override
  Map<String, dynamic> toJson() {
    final map = super.toJson();

    map['type'] = 'mrkdwn';
    if (verbatim != null) map['verbatim'] = verbatim;

    return map;
  }
}
