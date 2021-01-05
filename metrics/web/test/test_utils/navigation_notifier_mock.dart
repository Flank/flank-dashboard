import 'package:flutter/widgets.dart';
import 'package:metrics/common/presentation/navigation/state/navigation_notifier.dart';
import 'package:mockito/mockito.dart';

class NavigationNotifierMock extends Mock
    with ChangeNotifier
    implements NavigationNotifier {}
