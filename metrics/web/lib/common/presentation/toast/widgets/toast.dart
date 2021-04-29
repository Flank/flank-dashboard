// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:metrics/base/presentation/widgets/decorated_container.dart';
import 'package:metrics/common/presentation/constants/duration_constants.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/toast/theme/attention_level/toast_attention_level.dart';
import 'package:metrics/common/presentation/toast/theme/style/toast_style.dart';

/// An abstract widget that displays a metrics styled toast
/// in response to a user action and applies a [MetricsThemeData.toastTheme].
abstract class Toast extends StatelessWidget {
  /// The default width of the toast.
  static const double _width = 680.0;

  /// A message that is displayed within this toast.
  final String message;

  /// Creates a new instance of the [Toast].
  ///
  /// The given [message] must not be null.
  const Toast({
    Key key,
    @required this.message,
  })  : assert(message != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final toastTheme = MetricsTheme.of(context).toastTheme;
    final style = getStyle(toastTheme.attentionLevel);

    return FittedBox(
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      child: DecoratedContainer(
        margin: const EdgeInsets.only(top: 20.0),
        constraints: const BoxConstraints(
          maxWidth: _width,
          minWidth: _width,
          minHeight: 56.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: style.backgroundColor,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 16.0,
            horizontal: 32.0,
          ),
          alignment: Alignment.center,
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: style.textStyle,
          ),
        ),
      ),
    );
  }

  /// Selects the [ToastStyle] for this toast from the given [attentionLevel].
  ToastStyle getStyle(ToastAttentionLevel attentionLevel);
}

/// Shows the [Toast] on top of the screen for the duration
/// of [DurationConstants.toast].
ToastFuture showToast(BuildContext context, Toast toast) {
  return showToastWidget(
    toast,
    context: context,
    duration: DurationConstants.toast,
    position: const StyledToastPosition(
      align: Alignment.topCenter,
    ),
  );
}
