// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metrics/common/domain/entities/persistent_store_error_code.dart';
import 'package:metrics/common/domain/entities/persistent_store_exception.dart';
import 'package:metrics/feature_config/data/model/feature_config_data.dart';
import 'package:metrics/feature_config/domain/entities/feature_config.dart';
import 'package:metrics/feature_config/domain/repositories/feature_config_repository.dart';

/// An implementation of the [FeatureConfigRepository] for [Firestore].
class FirestoreFeatureConfigRepository extends FeatureConfigRepository {
  final Firestore _firestore = Firestore.instance;

  @override
  Future<FeatureConfig> fetch() async {
    try {
      final featureConfigSnapshot = await _firestore
          .collection('feature_config')
          .document('feature_config')
          .get();

      return FeatureConfigData.fromJson(featureConfigSnapshot.data);
    } catch (_) {
      throw const PersistentStoreException(
        code: PersistentStoreErrorCode.unknown,
      );
    }
  }
}
