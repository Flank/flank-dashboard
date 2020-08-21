import 'package:metrics/common/presentation/metrics_theme/model/attention_level_theme_data.dart';
import 'package:metrics/common/presentation/toast/theme/attention_level/toast_attention_level.dart';

/// The class that stores the theme data for application toasts.
class ToastThemeData extends AttentionLevelThemeData<ToastAttentionLevel> {
  /// Creates a new instance of the [ToastThemeData].
  ///
  /// If the [toastAttentionLevel] is null, an empty [ToastAttentionLevel]
  /// instance is used.
  const ToastThemeData({
    ToastAttentionLevel toastAttentionLevel,
  }) : super(toastAttentionLevel ?? const ToastAttentionLevel());
}
