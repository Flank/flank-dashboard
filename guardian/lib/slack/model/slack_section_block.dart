// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:equatable/equatable.dart';
import 'package:guardian/slack/model/slack_text_object.dart';
import 'package:guardian/slack/model/validation_result.dart';

/// A class representing Section Block element
/// (https://api.slack.com/reference/block-kit/blocks#section)
class SlackSectionBlock extends Equatable {
  /// Maximum allowed number of items in [fields] array.
  static const int _maxFieldsPerSection = 10;

  /// Maximum allowed length of [SlackTextObject.text] within [fields]'s item.
  static const int _maxFieldTextLength = 2000;

  /// Maximum allowed length of [text].
  static const int _maxSectionTextLength = 3000;

  /// The text for the block, in the form of a [SlackTextObject].
  ///
  /// Maximum length for the text in this field is 3000 characters.
  final SlackTextObject text;

  /// An array of text objects. Any text objects included with fields will be
  /// rendered in a compact format that allows for 2 columns of side-by-side
  /// text.
  ///
  /// Maximum number of items is 10. Maximum length for the
  /// [SlackTextObject.text] in each item is 2000 characters.
  final List<SlackTextObject> fields;

  /// Creates an instance of Slack section block.
  ///
  /// Either [text] or [fields] is required, however can be provided
  /// simultaneously.
  const SlackSectionBlock({
    this.text,
    this.fields,
  });

  /// Creates an instance of Section Block from decoded JSON object.
  ///
  /// Returns `null` if [json] is `null`.
  factory SlackSectionBlock.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return SlackSectionBlock(
      text: SlackTextObject.fromJson(json['text'] as Map<String, dynamic>),
      fields: SlackTextObject.listFromJson(json['fields'] as List<dynamic>),
    );
  }

  /// Creates a list of Section Blocks from list of decoded JSON objects.
  static List<SlackSectionBlock> listFromJson(List<dynamic> list) {
    return list
        ?.map(
            (json) => SlackSectionBlock.fromJson(json as Map<String, dynamic>))
        ?.toList();
  }

  @override
  List<Object> get props => [text, fields];

  /// Validates [SlackSectionBlock] to match following rules:
  ///   1. Either [text] or [fields] is required.
  ///   2. If [fields] is not presented, [text] must be not `null` and valid
  ///      (not empty and contain up to 3000 characters).
  ///   3. If [text] is not presented, [fields] must be not `null` and valid
  ///      (not empty and contain up to 10 non-null items with maximum 2000
  ///      characters each).
  ///   4. Both [text] and [fields] must be valid if presented simultaneously.
  ValidationResult validate() {
    final textValidation = text?.validate(_maxSectionTextLength) ??
        ValidationResult.invalid('Text is missing');

    if (text == null) {
      return _validateFields();
    } else if (fields == null) {
      return textValidation;
    } else {
      return textValidation.combine(_validateFields());
    }
  }

  /// Validates [fields] to be not `null`, contain up to 10 valid and non-null
  /// [SlackTextObject]s limited to 2000 characters.
  ValidationResult _validateFields() {
    if (fields == null) {
      return ValidationResult.invalid('Text is missing');
    } else if (fields.length > _maxFieldsPerSection) {
      return ValidationResult.invalid(
        'Fields is limited to contain up to 10 '
        'items but ${fields.length} found',
      );
    } else {
      return fields.fold(ValidationResult.valid(), (validation, field) {
        final fieldValidation = field?.validate(_maxFieldTextLength) ??
            ValidationResult.invalid('Text is missing');
        return validation.combine(fieldValidation);
      });
    }
  }

  /// Converts object into the [Map].
  ///
  /// Resulting map will include only non-null fields of an object it
  /// represents. Result is valid to be sent to Slack API.
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{'type': 'section'};

    if (text != null) map['text'] = text.toJson();
    if (fields != null && fields.isNotEmpty) {
      map['fields'] = fields.map((field) => field.toJson()).toList();
    }

    return map;
  }

  @override
  String toString() {
    return '$runtimeType ${toJson()}';
  }
}
