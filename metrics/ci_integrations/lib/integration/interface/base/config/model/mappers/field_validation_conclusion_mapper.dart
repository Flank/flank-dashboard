// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/client/mapper/mapper.dart';
import 'package:ci_integration/integration/interface/base/config/model/field_validation_conclusion.dart';

/// A class that provides methods for mapping field validation conclusions.
class FieldValidationConclusionMapper
    implements Mapper<String, FieldValidationConclusion> {
  /// A conclusion for a success field validation.
  static const String valid = 'valid';

  /// A conclusion for a failure field validation.
  static const String invalid = 'invalid';

  /// A conclusion for an unknown field validation.
  static const String unknown = 'unknown';

  /// Creates a new instance of the [FieldValidationConclusionMapper].
  const FieldValidationConclusionMapper();

  @override
  FieldValidationConclusion map(String value) {
    switch (value) {
      case valid:
        return FieldValidationConclusion.valid;
      case invalid:
        return FieldValidationConclusion.invalid;
      case unknown:
        return FieldValidationConclusion.unknown;
      default:
        return null;
    }
  }

  @override
  String unmap(FieldValidationConclusion value) {
    switch (value) {
      case FieldValidationConclusion.valid:
        return valid;
      case FieldValidationConclusion.invalid:
        return invalid;
      case FieldValidationConclusion.unknown:
        return unknown;
      default:
        return null;
    }
  }
}
