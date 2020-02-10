import 'package:guardian/slack/model/slack_attachment.dart';

class SlackMessage {
  final String text;
  final List<SlackAttachment> attachments;

  SlackMessage({
    this.text,
    this.attachments,
  });

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
