import 'package:equatable/equatable.dart';
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

  @override
  List<Object> get props => [text];

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
