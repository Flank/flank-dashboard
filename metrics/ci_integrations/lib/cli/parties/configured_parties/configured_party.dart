// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/integration/interface/base/config/model/config.dart';
import 'package:ci_integration/integration/interface/base/party/integration_party.dart';

/// An abstract class that represents a [Config] and an [IntegrationParty]
/// that accepts this [Config].
abstract class ConfiguredParty<T extends Config, P extends IntegrationParty> {
  /// A parsed [Config] that the [party] accepts.
  final T config;

  /// An [IntegrationParty] of this configured party.
  final P party;

  /// Creates a new instance of the [ConfiguredParty] with the given [config]
  /// and [party].
  ///
  /// Throws an [ArgumentError] if any of the parameters is `null`.
  ConfiguredParty(
    this.config,
    this.party,
  ) {
    ArgumentError.checkNotNull(config, 'config');
    ArgumentError.checkNotNull(party, 'party');
  }
}
