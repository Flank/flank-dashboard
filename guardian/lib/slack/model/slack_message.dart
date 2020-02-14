import 'package:equatable/equatable.dart';
import 'package:guardian/slack/model/slack_section_block.dart';

/// A class representing Slack message to be sent.
class SlackMessage extends Equatable {
  /// The main body text of the message.
  ///
  /// It can be formatted as plain text, or with markdown.
  /// If [blocks] is presented, this is used as a fallback string to display
  /// in notifications.
  final String text;

  /// An array of layout sections.
  ///
  /// Slack Block Kit is described here https://api.slack.com/block-kit.
  /// Only section blocks are currently implemented.
  final List<SlackSectionBlock> blocks;

  /// Creates an instance of Slack message.
  ///
  /// If [blocks] is presented, [text] is not enforced as required, however it
  /// is highly recommended to be included as the aforementioned fallback.
  const SlackMessage({
    this.text,
    this.blocks,
  });

  factory SlackMessage.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return SlackMessage(
      text: json['text'] as String,
      blocks: SlackSectionBlock.listFromJson(json['blocks'] as List<dynamic>),
    );
  }

  @override
  List<Object> get props => [text, blocks];

  /// Converts object into the [Map].
  ///
  /// Resulting map will include only non-null fields of an object it
  /// represents. Result is valid to be sent to Slack API.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};

    if (text != null) map['text'] = text;
    if (blocks != null && blocks.isNotEmpty) {
      map['blocks'] = blocks.map((a) => a.toJson()).toList();
    }

    return map;
  }

  @override
  String toString() {
    return '$runtimeType ${toJson()}';
  }
}
