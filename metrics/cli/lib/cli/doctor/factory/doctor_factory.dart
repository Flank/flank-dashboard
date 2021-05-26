// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:cli/cli/doctor/doctor.dart';
import 'package:cli/common/model/factory/services_factory.dart';

/// A class providing method for creating a [Doctor] instance.
class DoctorFactory {
  /// A [ServicesFactory] class this factory uses to create the services.
  final ServicesFactory _servicesFactory;

  /// Creates a new instance of the [DoctorFactory]
  /// with the given [ServicesFactory].
  ///
  /// The services factory defaults to the [ServicesFactory] instance.
  ///
  /// Throws an [ArgumentError] if the given services factory is `null`.
  DoctorFactory([this._servicesFactory = const ServicesFactory()]) {
    ArgumentError.checkNotNull(_servicesFactory, 'servicesFactory');
  }

  /// Creates a new instance of the [Doctor].
  Doctor create() {
    final services = _servicesFactory.create();

    return Doctor(services: services);
  }
}
