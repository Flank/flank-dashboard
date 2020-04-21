import 'package:ci_integration/common/config/model/source_config.dart';
import 'package:ci_integration/common/config/parser/config_parser.dart';

abstract class SourceConfigParser<T extends SourceConfig>
    extends ConfigParser<T> {}
