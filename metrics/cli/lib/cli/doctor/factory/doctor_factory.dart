// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/cli/doctor/constants/doctor_constants.dart';
import 'package:cli/cli/doctor/doctor.dart';
import 'package:cli/common/model/services/factory/services_factory.dart';
import 'package:cli/util/dependencies/factory/dependencies_factory.dart';

/// A class providing method for creating a [Doctor] instance.
class DoctorFactory {
  /// A [ServicesFactory] class this factory uses to create the services.
  final ServicesFactory _servicesFactory;

  /// A [DependenciesFactory] class this factory uses to create the dependencies.
  final DependenciesFactory _dependenciesFactory;

  /// Creates a new instance of the [DoctorFactory]
  /// with the given [ServicesFactory] and [DependenciesFactory].
  ///
  /// The services factory defaults to the [ServicesFactory] instance.
  /// The dependencies factory defaults to the [DependenciesFactory] instance.
  ///
  /// Throws an [ArgumentError] if the given services factory is `null`.
  /// Throws an [ArgumentError] if the given dependencies factory is `null`.
  DoctorFactory([
    this._servicesFactory = const ServicesFactory(),
    this._dependenciesFactory = const DependenciesFactory(),
  ]) {
    ArgumentError.checkNotNull(_servicesFactory, 'servicesFactory');
    ArgumentError.checkNotNull(_dependenciesFactory, 'dependenciesFactory');
  }

  /// Creates a new instance of the [Doctor].
  Doctor create() {
    final services = _servicesFactory.create();
    final dependencies = _dependenciesFactory.create(
      DoctorConstants.dependenciesPath,
    );

    return Doctor(
      services: services,
      dependencies: dependencies,
    );
  }
}
