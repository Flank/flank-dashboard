import 'package:ci_integration/ci_integration/parties/parties.dart';
import 'package:ci_integration/ci_integration/parties/supported_destination_parties.dart';
import 'package:ci_integration/ci_integration/parties/supported_source_parties.dart';
import 'package:ci_integration/common/party/destination_party.dart';
import 'package:ci_integration/common/party/source_party.dart';

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
