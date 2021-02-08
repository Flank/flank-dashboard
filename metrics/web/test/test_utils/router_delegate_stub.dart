// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

/// A stub implementation of the [RouterDelegate] used in tests.
class RouterDelegateStub extends RouterDelegate with ChangeNotifier {
  /// A [Widget] to display.
  final Widget body;

  /// Creates a new instance of the [RouterDelegateStub].
  RouterDelegateStub({this.body});

  @override
  Widget build(BuildContext context) {
    return body;
  }

  @override
  Future<bool> popRoute() async {
    return true;
  }

  @override
  Future<void> setNewRoutePath(dynamic configuration) async {}
}
