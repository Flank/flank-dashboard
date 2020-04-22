import 'package:ci_integration/ci_integration/parties/supported_destination_parties.dart';
import 'package:ci_integration/ci_integration/parties/supported_source_parties.dart';

/// A class providing all the supported source and destination integrations.
class SupportedIntegrationParties {
  /// The supported source parties instance used to define
  /// all the supported source integrations.
  final SupportedSourceParties sourceParties;

  /// The supported destination parties instance used to define
  /// all the supported destination integrations.
  final SupportedDestinationParties destinationParties;

  /// Creates an instance of this class.
  ///
  /// Both [sourceParties] and [destinationParties]
  /// are optional. If the [sourceParties] is `null`,
  /// the default [SupportedSourceParties] instance is created. If the
  /// [destinationParties] is `null`, the default
  /// [SupportedDestinationParties] instance is created.
  SupportedIntegrationParties({
    SupportedSourceParties sourceParties,
    SupportedDestinationParties destinationParties,
  })  : sourceParties = sourceParties ?? SupportedSourceParties(),
        destinationParties =
            destinationParties ?? SupportedDestinationParties();
}
