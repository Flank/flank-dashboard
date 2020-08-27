import 'package:flutter/cupertino.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:metrics/common/presentation/constants/duration_constants.dart';
import 'package:metrics/common/presentation/toast/widgets/toast.dart';

/// A class provides utility methods to work with [Toast]s.
class ToastUtil {
  /// Shows the [Toast] on top of the screen
  /// for the duration of [DurationConstants.toast].
  static ToastFuture showToast(BuildContext context, Toast toast) {
    return showToastWidget(
      toast,
      context: context,
      duration: DurationConstants.toast,
      position: StyledToastPosition(
        align: Alignment.topCenter,
      ),
    );
  }
}
