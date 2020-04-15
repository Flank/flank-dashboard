import 'package:flutter/material.dart';
import 'package:metrics/features/dashboard/presentation/widgets/expandable_text.dart';

/// The widget stands for displaying the [value] text with some [description].
class TextMetric extends StatelessWidget {
  final String description;
  final String value;
  final EdgeInsets valuePadding;
  final TextStyle valueStyle;
  final TextStyle descriptionStyle;

  /// Creates the [TextMetric] with given [description] and [value] texts.
  ///
  /// The [description] and [value] must not be null.
  ///
  /// [valuePadding] is the padding of the value text.
  /// [valueStyle] is the [TextStyle] of the value text.
  /// [descriptionStyle] is the [TextStyle] of the title text.
  const TextMetric({
    Key key,
    @required this.description,
    @required this.value,
    this.valuePadding = EdgeInsets.zero,
    this.valueStyle,
    this.descriptionStyle,
  })  : assert(description != null),
        assert(value != null),
        super(key: key);

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
              value,
              style: valueStyle,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.zero,
            child: ExpandableText(
              description,
              style: descriptionStyle,
            ),
          ),
        )
      ],
    );
  }
}
