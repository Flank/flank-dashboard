// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:args/command_runner.dart';
import 'package:cli/cli/doctor/doctor.dart';
import 'package:cli/cli/doctor/factory/doctor_factory.dart';

/// A [Command] that shows version information of the third-party dependencies.
class DoctorCommand extends Command {
  @override
  final String name = 'doctor';

  @override
  final String description =
      'Shows the version information of the third-party dependencies.';

  /// A [DoctorFactory] this command uses to create a [Doctor].
  final DoctorFactory _doctorFactory;

  /// Creates a new instance of the [DoctorCommand]
  /// with the given [DoctorFactory].
  ///
  /// Throws an [ArgumentError] if the given [DoctorFactory] is `null`.
  DoctorCommand(this._doctorFactory) {
    ArgumentError.checkNotNull(_doctorFactory, 'doctorFactory');
  }

  @override
  Future<void> run() async {
    final doctor = _doctorFactory.create();

    return doctor.checkVersions();
  }
}
