import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/toast/widgets/toast.dart';
import 'package:metrics/common/presentation/toast/theme/attention_level/toast_attention_level.dart';
import 'package:metrics/common/presentation/toast/theme/style/toast_style.dart';

/// A [Toast] widget that applies the [ToastAttentionLevel.negative] toast style
/// from the [ToastThemeData].
class NegativeToast extends Toast {
  /// Creates a new instance of the [PositiveToast].
  ///
  /// The [message] must not be null.
  const NegativeToast({
    Key key,
    @required String message,
  }) : super(key: key, message: message);

  @override
  ToastStyle getStyle(ToastAttentionLevel attentionLevel) {
    return attentionLevel.negative;
  }
}
