// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/debug_menu/presentation/state/debug_menu_notifier.dart';
import 'package:mockito/mockito.dart';

class DebugMenuNotifierMock extends Mock
    with ChangeNotifier
    implements DebugMenuNotifier {}
