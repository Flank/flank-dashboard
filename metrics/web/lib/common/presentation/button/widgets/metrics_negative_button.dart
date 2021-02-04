// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/button/widgets/metrics_button.dart';
import 'package:metrics/common/presentation/button/theme/attention_level/metrics_button_attention_level.dart';
import 'package:metrics/common/presentation/button/theme/theme_data/metrics_button_theme_data.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';

/// A [MetricsButton] widget that applies
/// the [MetricsButtonAttentionLevel.negative] button style from
/// the [MetricsButtonThemeData].
class MetricsNegativeButton extends MetricsButton {
  /// Creates a new instance of the [MetricsNegativeButton].
  const MetricsNegativeButton({
    Key key,
    @required String label,
    VoidCallback onPressed,
  }) : super(key: key, onPressed: onPressed, label: label);

  @override
  MetricsButtonStyle selectStyle(MetricsButtonAttentionLevel attentionLevel) {
    return attentionLevel.negative;
  }
}
