import 'package:ci_integration/common/config/model/config.dart';
import 'package:ci_integration/common/config/parser/config_parser.dart';
import 'package:mockito/mockito.dart';

class ConfigParserMock<T extends Config> extends Mock implements ConfigParser<T> {}
