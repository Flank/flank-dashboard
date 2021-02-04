// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:metrics/common/domain/entities/persistent_store_exception.dart';
import 'package:metrics/debug_menu/domain/entities/local_config.dart';

/// A base class for local config repositories.
///
/// Provides an ability to interact with local storage and manage the stored
/// local config data.
abstract class LocalConfigRepository {
  /// Provides an ability to open the local config storage.
  ///
  /// Throws a [PersistentStoreException] if opening a [LocalConfig] storage
  /// fails.
  Future<void> open();

  /// Provides an ability to read the local config.
  ///
  /// Throws a [PersistentStoreException] if reading a [LocalConfig] fails.
  LocalConfig readConfig();

  /// Provides an ability to update the local config.
  ///
  /// The [isFpsMonitorEnabled] is a required parameter.
  ///
  /// Throws a [PersistentStoreException] if updating a [LocalConfig] fails.
  Future<LocalConfig> updateConfig({
    @required bool isFpsMonitorEnabled,
  });

  /// Provides an ability to close the local config storage.
  ///
  /// Throws a [PersistentStoreException] if closing a [LocalConfig] storage
  /// fails.
  Future<void> close();
}
