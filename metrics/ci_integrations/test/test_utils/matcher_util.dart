// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/cli/error/sync_error.dart';
import 'package:ci_integration/integration/validation/model/field_validation_conclusion.dart';
import 'package:ci_integration/integration/validation/model/field_validation_result.dart';
import 'package:test/test.dart';

/// A utility class providing base matchers for tests.
class MatcherUtil {
  /// A [Matcher] for functions that throw a [SyncError].
  static final throwsSyncError = throwsA(isA<SyncError>());

  /// A [Matcher] for a [FieldValidationResult.success].
  static final isSuccessfulValidationResult = predicate<FieldValidationResult>(
    (result) {
      return result?.conclusion == FieldValidationConclusion.valid;
    },
  );

  /// A [Matcher] for a [FieldValidationResult.failure].
  static final isFailureValidationResult = predicate<FieldValidationResult>(
    (result) {
      return result?.conclusion == FieldValidationConclusion.invalid;
    },
  );

  /// A [Matcher] for a [FieldValidationResult.unknown].
  static final isUnknownValidationResult = predicate<FieldValidationResult>(
    (result) {
      return result?.conclusion == FieldValidationConclusion.unknown;
    },
  );
}
