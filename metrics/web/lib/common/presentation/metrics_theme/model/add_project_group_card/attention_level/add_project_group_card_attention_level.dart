import 'package:meta/meta.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/style/add_project_group_card_style.dart';

/// A class that holds the different style configurations for
/// the add project group card widget.
@immutable
class AddProjectGroupCardAttentionLevel {
  /// A default [AddProjectGroupCardStyle] used if any of given statuses in null.
  static const _defaultAddProjectGroupCardStyle = AddProjectGroupCardStyle();

  /// An [AddProjectGroupCardStyle] for add project group card widget
  /// displaying the positive status.
  final AddProjectGroupCardStyle positiveStyle;

  /// An [AddProjectGroupCardStyle] for add project group card widget
  /// displaying the inactive status.
  final AddProjectGroupCardStyle inactiveStyle;

  const AddProjectGroupCardAttentionLevel({
    AddProjectGroupCardStyle positiveStyle,
    AddProjectGroupCardStyle inactiveStyle,
  })  : positiveStyle = positiveStyle ?? _defaultAddProjectGroupCardStyle,
        inactiveStyle = inactiveStyle ?? _defaultAddProjectGroupCardStyle;
}
