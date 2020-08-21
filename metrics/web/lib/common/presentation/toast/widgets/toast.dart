import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/decorated_container.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/toast/theme/attention_level/toast_attention_level.dart';
import 'package:metrics/common/presentation/toast/theme/style/toast_style.dart';

/// An abstract widget that displays a metrics styled toast
/// in response to a user action and applies a [MetricsThemeData.toastTheme].
abstract class Toast extends StatelessWidget {
  /// A message that displays within this toast.
  final String message;

  /// Creates a new instance of the [Toast].
  ///
  /// The [message] must not be null.
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
        constraints: const BoxConstraints(
          maxWidth: 680.0,
          minWidth: 680.0,
          minHeight: 56.0,
        ),
        margin: const EdgeInsets.only(top: 20.0),
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
            maxLines: null,
            textAlign: TextAlign.center,
            style: style.textStyle,
          ),
        ),
      ),
    );
  }

  /// Selects the [ToastStyle] for this toast
  /// from the given [attentionLevel].
  ToastStyle getStyle(ToastAttentionLevel attentionLevel);
}
