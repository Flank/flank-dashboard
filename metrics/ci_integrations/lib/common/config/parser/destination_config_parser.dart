import 'package:ci_integration/common/config/model/destination_config.dart';
import 'package:ci_integration/common/config/parser/config_parser.dart';

abstract class DestinationConfigParser<T extends DestinationConfig>
    extends ConfigParser<T> {}
