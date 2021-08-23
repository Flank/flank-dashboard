// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/cli/doctor/doctor.dart';
import 'package:metrics_core/metrics_core.dart';

/// A class that represents the [ValidationConclusion] within the [Doctor]
/// versions checking process.
class DoctorValidationConclusion extends ValidationConclusion {
  /// Creates a new instance of the [DoctorValidationConclusion]
  /// with the given [name] and [indicator].
  ///
  /// The given [name] must not be `null`.
  const DoctorValidationConclusion._({
    String name,
    String indicator,
  }) : super(
          name: name,
          indicator: indicator,
        );

  /// Creates a new instance of the [DoctorValidationConclusion] that represents
  /// the successful conclusion of a validation.
  factory DoctorValidationConclusion.successful() {
    return const DoctorValidationConclusion._(
      name: 'successful',
      indicator: '+',
    );
  }

  /// Creates a new instance of the [DoctorValidationConclusion] that represents
  /// the failure conclusion of a validation.
  factory DoctorValidationConclusion.failure() {
    return const DoctorValidationConclusion._(
      name: 'failure',
      indicator: '-',
    );
  }

  /// Creates a new instance of the [DoctorValidationConclusion] that represents
  /// the warning conclusion of a validation.
  factory DoctorValidationConclusion.warning() {
    return const DoctorValidationConclusion._(
      name: 'warning',
      indicator: '!',
    );
  }
}
