// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:mockito/mockito.dart';

class ThemeNotifierMock extends Mock
    with ChangeNotifier
    implements ThemeNotifier {}
