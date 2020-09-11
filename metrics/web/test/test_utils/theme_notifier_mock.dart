import 'package:flutter/cupertino.dart';
import 'package:metrics/common/presentation/metrics_theme/state/theme_notifier.dart';
import 'package:mockito/mockito.dart';

class ThemeNotifierMock extends Mock
    with ChangeNotifier
    implements ThemeNotifier {}
