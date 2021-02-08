// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:guardian/slack/model/slack_section_block.dart';
import 'package:guardian/slack/model/validation_result.dart';

/// A class representing Slack message to be sent.
class SlackMessage extends Equatable {
  /// Maximum allowed number of items in [blocks] array.
  static const int _maxBlocksPerMessage = 50;

  /// The main body text of the message.
  ///
  /// It can be formatted as plain text, or with markdown.
  /// If [blocks] is presented, this is used as a fallback string to display
  /// in notifications.
  final String text;

  /// An array of layout sections.
  ///
  /// Slack Block Kit is described here https://api.slack.com/block-kit.
  /// Only section blocks are currently implemented. You can include up to 50
  /// blocks in each message.
  final List<SlackSectionBlock> blocks;

  /// Creates an instance of Slack message.
  ///
  /// If [blocks] is presented, [text] is not enforced as required, however it
  /// is highly recommended to be included as the aforementioned fallback.
  const SlackMessage({
    this.text,
    this.blocks,
  });

  /// Creates an instance of Slack message from decoded JSON object.
  ///
  /// Returns `null` if [json] is `null`.
  factory SlackMessage.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return SlackMessage(
      text: json['text'] as String,
      blocks: SlackSectionBlock.listFromJson(json['blocks'] as List<dynamic>),
    );
  }

  @override
  List<Object> get props => [text, blocks];

  /// Validates [SlackMessage] to match following rules:
  ///   1. Either [text] or [blocks] is required.
  ///   2. [text] must not be `null` or empty if [blocks] is not presented.
  ///   3. Both [text] and [blocks] must be valid if presented simultaneously.
  ///   4. [blocks] can include up to 50 items and each item must be not `null`
  ///      and valid.
  ValidationResult validate() {
    final hasText = text != null && text.isNotEmpty;
    final hasBlocks = blocks != null && blocks.isNotEmpty;

    if (hasText) {
      if (hasBlocks) return _validateBlocks();
      return ValidationResult.valid();
    } else if (hasBlocks) {
      return _validateBlocks();
    } else {
      return ValidationResult.invalid('Text is missing');
    }
  }

  /// Validates [blocks] to contain up to 50 valid and non-null items.
  ValidationResult _validateBlocks() {
    if (blocks.length > _maxBlocksPerMessage) {
      return ValidationResult.invalid(
        'Message is limited to contain up to $_maxBlocksPerMessage blocks '
        'but ${blocks.length} found',
      );
    } else {
      return blocks.fold(ValidationResult.valid(), (validation, block) {
        final fieldValidation =
            block?.validate() ?? ValidationResult.invalid('Invalid blocks');
        return validation.combine(fieldValidation);
      });
    }
  }

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
