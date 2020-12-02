import 'dart:async';

import 'package:metrics/common/domain/entities/instant_config.dart';

/// A base class for instant config repositories.
///
/// Provides an ability to get the instant config data.
abstract class InstantConfigRepository {
  /// Provides an ability to fetch the [InstantConfig].
  Future<InstantConfig> fetch();
}
