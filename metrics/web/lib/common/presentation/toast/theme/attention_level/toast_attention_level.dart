// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/toast/theme/style/toast_style.dart';
import 'package:metrics/common/presentation/toast/widgets/toast.dart';

/// A class that stores [ToastStyle]s for different visual feedback levels
/// for toasts in the application.
class ToastAttentionLevel {
  /// A [ToastStyle] for [Toast]s that provide positive visual feedback.
  final ToastStyle positive;

  /// A [ToastStyle] for [Toast]s that provide negative visual feedback.
  final ToastStyle negative;

  /// Creates a new instance of the [ToastAttentionLevel].
  ///
  /// If either the [positive] or [negative] is null, an empty [ToastStyle] used.
  const ToastAttentionLevel({
    ToastStyle positive,
    ToastStyle negative,
  })  : positive = positive ?? const ToastStyle(),
        negative = negative ?? const ToastStyle();
}
