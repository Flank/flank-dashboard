import 'package:ci_integration/ci_integration/parties/supported_destination_parties.dart';
import 'package:ci_integration/ci_integration/parties/supported_source_parties.dart';

class SupportedIntegrationParties {
  final SupportedSourceParties supportedSourceParties;
  final SupportedDestinationParties supportedDestinationParties;

  SupportedIntegrationParties({
    SupportedSourceParties supportedSourceParties,
    SupportedDestinationParties supportedDestinationParties,
  })  : supportedSourceParties =
            supportedSourceParties ?? SupportedSourceParties(),
        supportedDestinationParties =
            supportedDestinationParties ?? SupportedDestinationParties();
}
