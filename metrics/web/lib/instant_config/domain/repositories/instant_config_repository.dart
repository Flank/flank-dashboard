import 'dart:async';

import 'package:metrics/instant_config/domain/entities/instant_config.dart';

/// A base class for instant config repositories.
///
/// Provides methods to work with the stored instant config data.
abstract class InstantConfigRepository {
  /// Provides an ability to fetch the [InstantConfig].
  Future<InstantConfig> fetch();
}
