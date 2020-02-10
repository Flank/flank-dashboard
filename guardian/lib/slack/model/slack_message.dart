import 'package:guardian/slack/model/slack_attachment.dart';

/// A class representing Slack message to be sent.
class SlackMessage {
  /// The main body text of the message.
  /// It can be formatted as plain text, or with markdown.
  final String text;

  /// An array of legacy secondary attachments.
  final List<SlackAttachment> attachments;

  SlackMessage({
    this.text,
    this.attachments,
  });

  /// Returns [Map] representing the object.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (text != null) map['text'] = text;
    if (attachments != null && attachments.isNotEmpty) {
      map['attachments'] = attachments.map((a) => a.toJson()).toList();
    }

    return map;
  }

  @override
  String toString() {
    return '$runtimeType ${toJson()}';
  }
}
