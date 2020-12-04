import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:metrics/common/data/model/instant_config_data.dart';
import 'package:metrics/common/domain/entities/instant_config.dart';
import 'package:metrics/common/domain/entities/persistent_store_error_code.dart';
import 'package:metrics/common/domain/entities/persistent_store_exception.dart';
import 'package:metrics/common/domain/repositories/instant_config_repository.dart';

/// An implementation of the [InstantConfigRepository] for [Firestore].
class FirestoreInstantConfigRepository extends InstantConfigRepository {
  final Firestore _firestore = Firestore.instance;

  @override
  Future<InstantConfig> fetch() async {
    try {
      final instantConfigSnapshot = await _firestore
          .collection('instant_config')
          .document('instant_config')
          .get();

      return InstantConfigData.fromJson(instantConfigSnapshot.data);
    } catch (_) {
      throw const PersistentStoreException(
        code: PersistentStoreErrorCode.unknown,
      );
    }
  }
}
