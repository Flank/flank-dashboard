import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/hand_cursor.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';

/// A widget that displays the metrics page title with the navigate back arrow.
class MetricsPageTitle extends StatelessWidget {
  /// A title text to display.
  final String title;

  /// Creates the [MetricsPageTitle] with the given [title].
  ///
  /// The [title] must not be null.
  const MetricsPageTitle({
    Key key,
    @required this.title,
  })  : assert(title != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Tooltip(
            message: CommonStrings.navigateBack,
            child: HandCursor(
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => _navigateBack(context),
                child: Image.network(
                  'icons/arrow-back.svg',
                  width: 33.0,
                  height: 22.0,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 36.0,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Navigates back to the previous page.
  void _navigateBack(BuildContext context) {
    final _navigator = Navigator.of(context);

    if (_navigator.canPop()) {
      _navigator.pop();
    }
  }
}
