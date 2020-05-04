import 'package:ci_integration/common/config/model/destination_config.dart';
import 'package:ci_integration/common/config/parser/config_parser.dart';

/// An abstract class providing methods for parsing a destination
/// configuration [Map] into the [DestinationConfig] instance.
abstract class DestinationConfigParser<T extends DestinationConfig>
    extends ConfigParser<T> {}
