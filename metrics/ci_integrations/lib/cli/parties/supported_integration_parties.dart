// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:ci_integration/cli/parties/parties.dart';
import 'package:ci_integration/cli/parties/supported_destination_parties.dart';
import 'package:ci_integration/cli/parties/supported_source_parties.dart';
import 'package:ci_integration/integration/interface/destination/party/destination_party.dart';
import 'package:ci_integration/integration/interface/source/party/source_party.dart';

/// A class providing all the supported source and destination integrations.
class SupportedIntegrationParties {
  /// The parties instance used to define all
  /// the supported source integrations.
  final Parties<SourceParty> sourceParties;

  /// The parties instance used to define all
  /// the supported destination integrations.
  final Parties<DestinationParty> destinationParties;

  /// Creates an instance of this class.
  ///
  /// Both [sourceParties] and [destinationParties] are optional.
  /// If the [sourceParties] is `null`, the default [SupportedSourceParties]
  /// instance is created. If the [destinationParties] is `null`, the default
  /// [SupportedDestinationParties] instance is created.
  SupportedIntegrationParties({
    Parties<SourceParty> sourceParties,
    Parties<DestinationParty> destinationParties,
  })  : sourceParties = sourceParties ?? SupportedSourceParties(),
        destinationParties =
            destinationParties ?? SupportedDestinationParties();
}
