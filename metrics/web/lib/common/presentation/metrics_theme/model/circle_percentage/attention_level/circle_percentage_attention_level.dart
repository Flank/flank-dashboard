import 'package:meta/meta.dart';
import 'package:metrics/common/presentation/metrics_theme/model/circle_percentage/style/circle_percentage_style.dart';

/// A class that holds the different style configurations for
/// the circle percentage widget.
@immutable
class CirclePercentageAttentionLevel {
  /// A [CirclePercentageStyle] for a circle percentage widget
  /// displaying the positive visual feedback.
  final CirclePercentageStyle positive;

  /// A [CirclePercentageStyle] for a circle percentage widget
  /// displaying the neutral visual feedback.
  final CirclePercentageStyle neutral;

  /// A [CirclePercentageStyle] for a circle percentage widget
  /// displaying the negative visual feedback.
  final CirclePercentageStyle negative;

  /// A [CirclePercentageStyle] for a circle percentage widget
  /// displaying the inactive status.
  final CirclePercentageStyle inactive;

  /// Creates a new instance of [CirclePercentageAttentionLevel].
  ///
  /// If the [positive], [neutral], [negative] or [inactive] is null,
  /// an empty [CirclePercentageStyle] used.
  const CirclePercentageAttentionLevel({
    CirclePercentageStyle positive,
    CirclePercentageStyle neutral,
    CirclePercentageStyle negative,
    CirclePercentageStyle inactive,
  })  : positive = positive ?? const CirclePercentageStyle(),
        neutral = neutral ?? const CirclePercentageStyle(),
        negative = negative ?? const CirclePercentageStyle(),
        inactive = inactive ?? const CirclePercentageStyle();
}
