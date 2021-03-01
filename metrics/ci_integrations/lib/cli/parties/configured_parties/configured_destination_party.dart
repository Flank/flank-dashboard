// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/cli/parties/configured_parties/configured_party.dart';
import 'package:ci_integration/integration/interface/destination/config/model/destination_config.dart';
import 'package:ci_integration/integration/interface/destination/party/destination_party.dart';

/// A class that represents a [DestinationConfig] and [DestinationParty] that
/// accepts this [DestinationConfig].
class ConfiguredDestinationParty
    extends ConfiguredParty<DestinationConfig, DestinationParty> {
  /// Creates a new instance of the [ConfiguredDestinationParty] with the given
  /// [config] and [party].
  ///
  /// Throws an [ArgumentError] if any of the parameters is `null`.
  ConfiguredDestinationParty(
    DestinationConfig config,
    DestinationParty party,
  ) : super(config, party);
}
