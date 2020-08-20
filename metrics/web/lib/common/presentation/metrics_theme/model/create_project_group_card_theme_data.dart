import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';

/// The class that stores the theme data for the create project group card.
class CreateProjectGroupCardThemeData {
  /// The enabled [MetricsButtonStyle] for the create project group card.
  final MetricsButtonStyle enabledStyle;

  /// The disabled [MetricsButtonStyle] for the create project group card.
  final MetricsButtonStyle disabledStyle;

  /// Creates a new [CreateProjectGroupCardThemeData] instance.
  const CreateProjectGroupCardThemeData({
    this.enabledStyle = const MetricsButtonStyle(),
    this.disabledStyle = const MetricsButtonStyle(),
  });
}
