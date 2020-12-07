import 'package:flutter/foundation.dart';
import 'package:metrics/common/presentation/state/instant_config_notifier.dart';
import 'package:mockito/mockito.dart';

class InstantConfigNotifierMock extends Mock
    with ChangeNotifier
    implements InstantConfigNotifier {}
