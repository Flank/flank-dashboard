// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/common/presentation/navigation/state/navigation_state.dart';
import 'package:universal_html/html.dart';

/// A [NavigationState] that provides an ability to interact with
/// the browser navigation state.
class BrowserNavigationState implements NavigationState {
  /// A [History] used to interact with the browser history.
  final History _history;

  /// Creates a new instance of the [BrowserNavigationState] with
  /// the given [History].
  BrowserNavigationState(this._history) : assert(_history != null);

  @override
  void replaceState(dynamic data, String title, String path) {
    _history.replaceState(data, title, path);
  }
}
