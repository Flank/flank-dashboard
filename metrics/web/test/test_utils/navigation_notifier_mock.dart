// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:metrics/common/presentation/navigation/state/navigation_notifier.dart';
import 'package:mockito/mockito.dart';

class NavigationNotifierMock extends Mock
    with ChangeNotifier
    implements NavigationNotifier {}
