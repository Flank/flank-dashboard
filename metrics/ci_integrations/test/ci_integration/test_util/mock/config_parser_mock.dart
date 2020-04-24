import 'package:ci_integration/common/config/model/destination_config.dart';
import 'package:ci_integration/common/config/model/source_config.dart';
import 'package:ci_integration/common/config/parser/destination_config_parser.dart';
import 'package:ci_integration/common/config/parser/source_config_parser.dart';
import 'package:mockito/mockito.dart';

class SourceConfigParserMock<T extends SourceConfig> extends Mock implements SourceConfigParser<T>{}

class DestinationConfigParserMock<T extends DestinationConfig> extends Mock implements DestinationConfigParser<T>{}
