// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:metrics/common/presentation/toast/widgets/toast.dart';

/// A [RouteObserver] that helps to dismiss [Toast]s as a [Route] changes.
class ToastRouteObserver extends RouteObserver<PageRoute> {
  /// A [ToastManager] used to dismiss [Toast]s on a [Route] change.
  final _toastManager = ToastManager();

  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    _dismissAllToasts();
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    _dismissAllToasts();
    super.didPop(route, previousRoute);
  }

  /// Dismisses all toasts on the screen.
  void _dismissAllToasts() {
    _toastManager.dismissAll();
  }
}
