import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/toast/theme/attention_level/toast_attention_level.dart';
import 'package:metrics/common/presentation/toast/theme/style/toast_style.dart';
import 'package:metrics/common/presentation/toast/widgets/toast.dart';

/// A [Toast] widget displaying the positive visual feedback.
///
/// Applies the [ToastAttentionLevel.positive] toast style.
class PositiveToast extends Toast {
  /// Creates a new instance of the [PositiveToast].
  ///
  /// The [message] must not be null.
  const PositiveToast({
    Key key,
    @required String message,
  }) : super(key: key, message: message);

  @override
  ToastStyle getStyle(ToastAttentionLevel attentionLevel) {
    return attentionLevel.positive;
  }
}
