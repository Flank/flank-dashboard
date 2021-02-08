// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';

/// A class that stores [MetricsButtonStyle]s for different visual feedback
/// levels for buttons within application.
class MetricsButtonAttentionLevel {
  /// A [MetricsButtonStyle] for buttons that provide positive visual feedback.
  /// They are usually buttons that sign in, add or edit configurations, etc.
  final MetricsButtonStyle positive;

  /// A [MetricsButtonStyle] for buttons that provide neutral visual feedback.
  /// They are usually buttons that cancel a current action.
  final MetricsButtonStyle neutral;

  /// A [MetricsButtonStyle] for buttons that provide negative visual feedback.
  /// They are usually buttons that delete a configuration.
  final MetricsButtonStyle negative;

  /// A [MetricsButtonStyle] for disabled buttons.
  final MetricsButtonStyle inactive;

  /// Creates a new instance of [MetricsButtonAttentionLevel].
  ///
  /// All the parameters default to [MetricsButtonStyle] default instance.
  const MetricsButtonAttentionLevel({
    this.positive = const MetricsButtonStyle(),
    this.neutral = const MetricsButtonStyle(),
    this.negative = const MetricsButtonStyle(),
    this.inactive = const MetricsButtonStyle(),
  });
}
