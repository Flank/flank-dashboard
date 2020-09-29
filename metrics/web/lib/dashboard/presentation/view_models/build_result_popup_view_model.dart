import 'package:flutter/cupertino.dart';

class BuildResultPopupViewModel {
  /// The abstract value of the build.
  ///
  /// Usually stands for the duration of the build this view model belongs to.
  /// But can be any other integer parameter of the build.
  final int value;

  final DateTime startDate;

  BuildResultPopupViewModel({
    @required this.value,
    this.startDate,
  });
}
