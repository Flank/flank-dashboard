// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:args/command_runner.dart';
import 'package:cli/doctor/doctor.dart';
import 'package:cli/doctor/factory/doctor_factory.dart';

/// A [Command] that shows version information of the third-party dependencies.
class DoctorCommand extends Command {
  @override
  final String name = 'doctor';

  @override
  final String description =
      'Shows the version information of the third-party dependencies.';

  /// A [DoctorFactory] this command uses to create a [Doctor].
  final DoctorFactory doctorFactory;

  /// Creates a new instance of the [DoctorCommand]
  /// with the given [DoctorFactory].
  ///
  /// Throws an [ArgumentError] if the given [DoctorFactory] is `null`.
  DoctorCommand(this.doctorFactory) {
    ArgumentError.checkNotNull(doctorFactory, 'doctorFactory');
  }

  @override
  Future<void> run() async {
    final doctor = doctorFactory.create();

    return doctor.checkVersions();
  }
}
