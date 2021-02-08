// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:meta/meta.dart';
import 'package:metrics/auth/domain/entities/email_domain_validation_result.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [DataModel] that represents an email domain validation result.
class EmailDomainValidationResultData extends EmailDomainValidationResult
    implements DataModel {
  /// Creates an [EmailDomainValidationResultData]
  /// with the given [isValid] status.
  EmailDomainValidationResultData({
    @required bool isValid,
  }) : super(isValid: isValid);

  /// Creates an instance of the [EmailDomainValidationResultData]
  /// from the given [json].
  ///
  /// Returns `null` if the given [json] is `null`.
  factory EmailDomainValidationResultData.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return EmailDomainValidationResultData(
      isValid: json["isValid"] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'isValid': isValid,
    };
  }
}
