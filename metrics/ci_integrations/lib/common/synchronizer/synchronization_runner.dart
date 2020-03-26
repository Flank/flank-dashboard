import 'dart:async';

import 'package:ci_integration/common/config/ci_config.dart';
import 'package:ci_integration/common/interactor/ci_interactor.dart';
import 'package:ci_integration/common/interactor/firestore_interactor.dart';
import 'package:ci_integration/common/synchronizer/synchronizer.dart';
import 'package:ci_integration/common/validator/config_validator.dart';
import 'package:meta/meta.dart';

/// An abstract class providing a method for running a synchronization process.
abstract class SynchronizationRunner {
  /// A validator for a CI configurations.
  ConfigValidator get configValidator;

  /// An interactor with a Firestore database.
  FirestoreInteractor get firestoreInteractor;

  /// An interactor with a CI tool's API.
  CiInteractor get ciInteractor;

  /// Validates [config] using [configValidator] and if it's valid runs
  /// [Synchronizer.sync].
  @nonVirtual
  Future<void> run(CiConfig config) async {
    final validationResult = configValidator.validate(config);
    if (validationResult == null || validationResult.isInvalid) {
      print(validationResult?.message ?? 'config is invalid');
      return;
    }

    final synchronizer = Synchronizer(
      ciInteractor: ciInteractor,
      firestoreInteractor: firestoreInteractor,
    );
    final result = await synchronizer.sync(config);
    print(result.message);
  }
}
