import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:metrics/common/domain/entities/persistent_store_exception.dart';
import 'package:metrics/debug_menu/data/model/local_config_data.dart';
import 'package:metrics/debug_menu/domain/entities/local_config.dart';
import 'package:metrics/debug_menu/domain/repositories/local_config_repository.dart';

/// An implementation of the [LocalConfigRepository] for [Hive].
class HiveLocalConfigRepository implements LocalConfigRepository {
  @override
  Future<void> open() async {
    try {
      await Hive.openBox<String>('local_config');
    } catch (_) {
      throw const PersistentStoreException();
    }
  }

  @override
  LocalConfig readConfig() {
    try {
      final box = Hive.box<String>('local_config');

      final configString = box.get('local_config');

      if (configString == null) return null;

      final configJson = jsonDecode(configString) as Map<String, dynamic>;

      return LocalConfigData.fromJson(configJson);
    } catch (_) {
      throw const PersistentStoreException();
    }
  }

  @override
  Future<LocalConfig> updateConfig({bool isFpsMonitorEnabled}) async {
    try {
      final box = Hive.box<String>('local_config');

      final localConfig = LocalConfigData(
        isFpsMonitorEnabled: isFpsMonitorEnabled,
      );

      final configString = jsonEncode(localConfig.toJson());

      await box.put('local_config', configString);

      return localConfig;
    } catch (_) {
      throw const PersistentStoreException();
    }
  }

  @override
  Future<void> close() async {
    try {
      await Hive.close();
    } catch (_) {
      throw const PersistentStoreException();
    }
  }
}
