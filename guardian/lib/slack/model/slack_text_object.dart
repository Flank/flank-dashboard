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
