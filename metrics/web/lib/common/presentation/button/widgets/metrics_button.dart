// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/button/theme/attention_level/metrics_button_attention_level.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';

/// An abstract widget that displays a metrics styled button and
/// applies the [MetricsThemeData.metricsButtonTheme].
abstract class MetricsButton extends StatelessWidget {
  /// A callback that is called when this button is pressed.
  final VoidCallback onPressed;

  /// A label text to display on this button.
  final String label;

  /// Creates a new instance of the [MetricsButton].
  ///
  /// The [label] must not be null.
  const MetricsButton({
    Key key,
    @required this.label,
    this.onPressed,
  })  : assert(label != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonTheme = MetricsTheme.of(context).metricsButtonTheme;
    final attentionLevel = buttonTheme.attentionLevel;
    final inactiveStyle = attentionLevel.inactive;
    final style = selectStyle(attentionLevel);

    return RaisedButton(
      color: style.color,
      hoverColor: style.hoverColor,
      disabledColor: inactiveStyle.color,
      elevation: style.elevation,
      hoverElevation: style.elevation,
      focusElevation: style.elevation,
      highlightElevation: style.elevation,
      disabledElevation: inactiveStyle.elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: onPressed == null ? inactiveStyle.labelStyle : style.labelStyle,
      ),
    );
  }

  /// Selects a [MetricsButtonStyle] for this button from
  /// the given [attentionLevel].
  MetricsButtonStyle selectStyle(MetricsButtonAttentionLevel attentionLevel);
}
