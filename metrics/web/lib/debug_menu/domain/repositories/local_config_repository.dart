import 'package:metrics/debug_menu/domain/entities/local_config.dart';

/// A base class for local config repositories.
///
/// Provides an ability to work with the stored local config data.
abstract class LocalConfigRepository {
  /// Provides an ability to open the local config storage.
  Future<void> open();

  /// Provides an ability to read the local config.
  LocalConfig readConfig();

  /// Provides an ability to update the local config.
  Future<void> updateConfig({bool isFpsMonitorEnabled});

  /// Provides an ability to close the local config storage.
  Future<void> close();
}
