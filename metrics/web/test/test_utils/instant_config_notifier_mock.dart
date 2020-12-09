import 'package:flutter/foundation.dart';
import 'package:metrics/instant_config/presentation/state/instant_config_notifier.dart';
import 'package:mockito/mockito.dart';

class InstantConfigNotifierMock extends Mock
    with ChangeNotifier
    implements InstantConfigNotifier {}
