import 'package:ci_integration/integration/interface/base/config/parser/config_parser.dart';
import 'package:ci_integration/integration/interface/destination/config/model/destination_config.dart';

/// An abstract class providing methods for parsing a destination
/// configuration [Map] into the [DestinationConfig] instance.
abstract class DestinationConfigParser<T extends DestinationConfig>
    extends ConfigParser<T> {}
