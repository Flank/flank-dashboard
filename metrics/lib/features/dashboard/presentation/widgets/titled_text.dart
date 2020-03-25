import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:metrics/features/dashboard/presentation/widgets/expandable_text.dart';

/// The widget stands for displaying the [value] text with some [title].
class TitledText extends StatelessWidget {
  final String title;
  final String value;
  final EdgeInsets valuePadding;
  final TextStyle valueStyle;
  final TextStyle titleStyle;

  /// Creates the [TitledText] with given [title] and [value] texts.
  ///
  /// The [title] and [value] must not be null.
  ///
  /// [valuePadding] is the padding of the value text.
  /// [valueStyle] is the [TextStyle] of the value text.
  /// [titleStyle] is the [TextStyle] of the title text.
  const TitledText({
    Key key,
    @required this.title,
    @required this.value,
    this.valuePadding = const EdgeInsets.all(32.0),
    this.valueStyle,
    this.titleStyle,
  })  : assert(title != null),
        assert(value != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Expanded(
          child: ExpandableText(
            title,
            style: titleStyle,
          ),
        ),
        Expanded(
          flex: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: valuePadding,
                  child: ExpandableText(
                    value,
                    style: valueStyle,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
