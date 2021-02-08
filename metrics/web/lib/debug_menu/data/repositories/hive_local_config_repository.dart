// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:meta/meta.dart';
import 'package:metrics/common/domain/entities/persistent_store_error_code.dart';
import 'package:metrics/common/domain/entities/persistent_store_exception.dart';
import 'package:metrics/debug_menu/data/model/local_config_data.dart';
import 'package:metrics/debug_menu/domain/entities/local_config.dart';
import 'package:metrics/debug_menu/domain/repositories/local_config_repository.dart';

/// An implementation of the [LocalConfigRepository] for [Hive].
class HiveLocalConfigRepository implements LocalConfigRepository {
  /// A name of the Hive [Box] that stores the [LocalConfig] data.
  static const String _localConfigBoxName = 'local_config';

  /// A name of a key within the Hive [Box] associated with
  /// the [LocalConfig] data.
  static const String _localConfigKeyName = 'local_config';

  @override
  Future<void> open() async {
    try {
      await Hive.openBox<String>(_localConfigBoxName);
    } catch (_) {
      throw const PersistentStoreException(
        code: PersistentStoreErrorCode.openConnectionFailed,
      );
    }
  }

  @override
  LocalConfig readConfig() {
    try {
      final box = Hive.box<String>(_localConfigBoxName);

      final configString = box.get(_localConfigKeyName);

      if (configString == null) return null;

      final configJson = jsonDecode(configString) as Map<String, dynamic>;

      return LocalConfigData.fromJson(configJson);
    } catch (_) {
      throw const PersistentStoreException(
        code: PersistentStoreErrorCode.readError,
      );
    }
  }

  @override
  Future<LocalConfig> updateConfig({
    @required bool isFpsMonitorEnabled,
  }) async {
    try {
      final box = Hive.box<String>(_localConfigBoxName);

      final localConfig = LocalConfigData(
        isFpsMonitorEnabled: isFpsMonitorEnabled,
      );

      final configString = jsonEncode(localConfig.toJson());

      await box.put(_localConfigKeyName, configString);

      return localConfig;
    } catch (_) {
      throw const PersistentStoreException(
        code: PersistentStoreErrorCode.updateError,
      );
    }
  }

  @override
  Future<void> close() async {
    try {
      await Hive.box(_localConfigBoxName).close();
    } catch (_) {
      throw const PersistentStoreException(
        code: PersistentStoreErrorCode.closeConnectionFailed,
      );
    }
  }
}
