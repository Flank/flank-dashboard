import 'package:flutter/cupertino.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:metrics/common/presentation/constants/duration_constants.dart';
import 'package:metrics/common/presentation/toast/widgets/toast.dart';

class ToastUtil {
  static void showToast(Toast toast, BuildContext context) {
    showToastWidget(
      toast,
      context: context,
      duration: DurationConstants.toast,
      position: StyledToastPosition(
        align: Alignment.topCenter,
      ),
    );
  }
}
