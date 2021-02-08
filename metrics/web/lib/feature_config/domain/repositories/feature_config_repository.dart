// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:async';

import 'package:metrics/feature_config/domain/entities/feature_config.dart';

/// A base class for feature config repositories.
///
/// Provides methods to work with the stored feature config data.
abstract class FeatureConfigRepository {
  /// Provides an ability to fetch the [FeatureConfig].
  Future<FeatureConfig> fetch();
}
