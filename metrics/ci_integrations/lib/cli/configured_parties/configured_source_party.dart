// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/cli/configured_parties/configured_party.dart';
import 'package:ci_integration/integration/interface/source/config/model/source_config.dart';
import 'package:ci_integration/integration/interface/source/party/source_party.dart';
import 'package:meta/meta.dart';

/// A class that represents a [SourceConfig] and a [SourceParty] that
/// accepts this [SourceConfig].
class ConfiguredSourceParty extends ConfiguredParty<SourceConfig, SourceParty> {
  /// Creates a new instance of the [ConfiguredSourceParty] with the given
  /// [config] and [party].
  ///
  /// Throws an [ArgumentError] if any of the parameters is `null`.
  ConfiguredSourceParty({
    @required SourceConfig config,
    @required SourceParty party,
  }) : super(config, party);
}
