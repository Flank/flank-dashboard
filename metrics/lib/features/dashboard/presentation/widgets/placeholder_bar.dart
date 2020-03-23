import 'package:flutter/material.dart';
import 'package:metrics/features/dashboard/presentation/widgets/colored_bar.dart';

/// Represents the placeholder bar of the [BarGraph].
class PlaceholderBar extends StatelessWidget {
  final double width;

  /// Creates the [PlaceholderBar].
  ///
  /// This bar displays the missing/empty build in [BarGraph].
  /// [width] is the width of this bar.
  const PlaceholderBar({
    Key key,
    @required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      height: 6.0,
      child: ColoredBar(
        color: Colors.transparent,
        width: width,
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
          color: Colors.grey,
          width: 2.0,
        ),
      ),
    );
  }
}
