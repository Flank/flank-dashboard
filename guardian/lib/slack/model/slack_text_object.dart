import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

/// Represents a [SlackTextObject] type.
enum SlackTextObjectType {
  plainText,
  markdown,
}

/// A class representing Slack Block Kit text object
/// (https://api.slack.com/reference/block-kit/composition-objects#text).
class SlackTextObject extends Equatable {
  /// The text for the block.
  ///
  /// This field accepts any of the standard text formatting markup
  /// (https://api.slack.com/reference/surfaces/formatting) when type is
  /// [SlackTextObjectType.markdown].
  final String text;

  /// The formatting to use for this text object.
  ///
  /// Can be one of `plain_text` or `mrkdwn`. For better experience above types
  /// are converted to the enum that has to be parsed before sending to
  /// Slack API (see [toJson] implementation).
  final SlackTextObjectType type;

  /// Indicates whether emojis in a text field should be escaped into the colon
  /// emoji format.
  final bool emoji;

  /// Indicates whether to use Slack's preprocessing for the [text].
  final bool verbatim;

  /// Creates an instance of text object.
  ///
  /// [emoji] field is only usable when [type]
  /// is [SlackTextObjectType.plainText].
  /// [verbatim] field is only usable when [type]
  /// is [SlackTextObjectType.markdown].
  /// [type] is [SlackTextObjectType.markdown] by default.
  /// [text] and [type] are required.
  const SlackTextObject({
    @required this.text,
    this.type = SlackTextObjectType.markdown,
    this.emoji,
    this.verbatim,
  });

  @override
  List<Object> get props => [text, type, emoji, verbatim];

  /// Converts object into the [Map].
  ///
  /// Resulting map will include only non-null fields of an object it
  /// represents. Result is valid to be sent to Slack API.
  /// [type] is parsed to one of `plain_text`, `mrkdwn`:
  ///   - [SlackTextObjectType.plainText] is `plain_text`,
  ///   - [SlackTextObjectType.markdown] is `mrkdwn`.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'text': text,
      'type': type == SlackTextObjectType.plainText
          ? 'plain_text'
          : type == SlackTextObjectType.markdown ? 'mrkdwn' : null,
    };

    if (emoji != null) map['emoji'] = emoji;
    if (verbatim != null) map['verbatim'] = verbatim;

    return map;
  }

  @override
  String toString() {
    return '$runtimeType ${toJson()}';
  }
}
