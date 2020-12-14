import 'package:flutter/foundation.dart';
import 'package:metrics/feature_config/presentation/state/feature_config_notifier.dart';
import 'package:mockito/mockito.dart';

class FeatureConfigNotifierMock extends Mock
    with ChangeNotifier
    implements FeatureConfigNotifier {}
