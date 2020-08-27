import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

/// A [Navigator] observer that helps to dismiss [Toast]s as a [Route] changes.
class ToastNavigationObserver extends RouteObserver<PageRoute> {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPush(route, previousRoute);
    ToastManager().dismissAll();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    super.didPop(route, previousRoute);
    ToastManager().dismissAll();
  }
}
