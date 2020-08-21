import 'package:metrics/common/presentation/toast/theme/style/toast_style.dart';

/// A class that stores [ToastStyle]s for different visual feedback levels
/// for toasts in the application.
class ToastAttentionLevel {
  /// A [ToastStyle] for toasts that provide positive visual feedback.
  final ToastStyle positive;

  /// A [ToastStyle] for toasts that provide negative visual feedback.
  final ToastStyle negative;

  /// Creates a new instance of [ToastAttentionLevel].
  ///
  /// If either [positive] or [negative] is null, an empty [ToastStyle] used.
  const ToastAttentionLevel({
    ToastStyle positive,
    ToastStyle negative,
  })  : positive = positive ?? const ToastStyle(),
        negative = negative ?? const ToastStyle();
}
