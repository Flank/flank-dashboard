import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';

/// The class that stores the theme data for the add project group card.
class AddProjectGroupCardThemeData {
  /// A [MetricsButtonStyle] for the enabled add project group card.
  final MetricsButtonStyle enabledStyle;

  /// A [MetricsButtonStyle] for the disabled add project group card.
  final MetricsButtonStyle disabledStyle;

  /// Creates a new [AddProjectGroupCardThemeData] instance.
  const AddProjectGroupCardThemeData({
    this.enabledStyle = const MetricsButtonStyle(),
    this.disabledStyle = const MetricsButtonStyle(),
  });
}
