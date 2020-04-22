import 'package:ci_integration/common/config/model/source_config.dart';
import 'package:ci_integration/common/config/parser/config_parser.dart';

/// An abstract class providing methods for parsing a source
/// configuration [Map] into the [SourceConfig] instance.
abstract class SourceConfigParser<T extends SourceConfig>
    extends ConfigParser<T> {}
