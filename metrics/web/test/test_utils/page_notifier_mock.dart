// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/widgets.dart';
import 'package:metrics/common/presentation/state/page_notifier.dart';
import 'package:mockito/mockito.dart';

class PageNotifierMock extends Mock
    with ChangeNotifier
    implements PageNotifier {}
