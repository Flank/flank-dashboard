// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/metrics_theme/model/add_project_group_card/attention_level/add_project_group_card_attention_level.dart';
import 'package:metrics/common/presentation/metrics_theme/model/attention_level_theme_data.dart';

/// The class that stores the theme data for the add project group card.
class AddProjectGroupCardThemeData
    extends AttentionLevelThemeData<AddProjectGroupCardAttentionLevel> {
  /// Creates the [AddProjectGroupCardThemeData] with the given [attentionLevel].
  ///
  /// If the [attentionLevel] is null, the [AddProjectGroupCardAttentionLevel] used.
  const AddProjectGroupCardThemeData({
    AddProjectGroupCardAttentionLevel attentionLevel,
  }) : super(attentionLevel ?? const AddProjectGroupCardAttentionLevel());
}
