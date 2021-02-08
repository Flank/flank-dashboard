// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/style/add_project_group_card_style.dart';

/// A class that holds the different style configurations for
/// the add project group card widget.
@immutable
class AddProjectGroupCardAttentionLevel {
  /// A default [AddProjectGroupCardStyle] used if any of given statuses is null.
  static const _defaultAddProjectGroupCardStyle = AddProjectGroupCardStyle();

  /// An [AddProjectGroupCardStyle] for add project group card widget
  /// with positive visual feedback.
  final AddProjectGroupCardStyle positive;

  /// An [AddProjectGroupCardStyle] for add project group card widget
  /// with inactive visual feedback.
  final AddProjectGroupCardStyle inactive;

  /// Creates a new [AddProjectGroupCardAttentionLevel] instance.
  ///
  /// If [positive] or [inactive] is null,
  /// an empty [AddProjectGroupCardStyle] is used.
  const AddProjectGroupCardAttentionLevel({
    AddProjectGroupCardStyle positive,
    AddProjectGroupCardStyle inactive,
  })  : positive = positive ?? _defaultAddProjectGroupCardStyle,
        inactive = inactive ?? _defaultAddProjectGroupCardStyle;
}
