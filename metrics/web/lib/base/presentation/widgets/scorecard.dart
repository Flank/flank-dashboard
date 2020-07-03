import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/expandable_text.dart';

/// A widget that stands for displaying the [value] text with [description].
class Scorecard extends StatelessWidget {
  /// The text that describes the [value].
  final String description;

  /// The text to display.
  final String value;

  /// The padding of the [value] text.
  final EdgeInsets valuePadding;

  /// The [TextStyle] of the [value] text.
  final TextStyle valueStyle;

  /// The [TextStyle] of the [description] text.
  final TextStyle descriptionStyle;

  /// Creates the [Scorecard] with given [description] and [value] texts.
  ///
  /// The [valuePadding] defaults to the [EdgeInsets.zero].
  const Scorecard({
    Key key,
    @required this.description,
    @required this.value,
    this.valuePadding = EdgeInsets.zero,
    this.valueStyle,
    this.descriptionStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Padding(
            padding: valuePadding,
            child: ExpandableText(
              '$value',
              style: valueStyle,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.zero,
            child: ExpandableText(
              '$description',
              style: descriptionStyle,
            ),
          ),
        )
      ],
    );
  }
}
