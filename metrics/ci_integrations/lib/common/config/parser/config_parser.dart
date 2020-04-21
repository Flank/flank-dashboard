import 'package:ci_integration/common/config/model/config.dart';

abstract class ConfigParser<T extends Config> {
  T parse(Map<String, dynamic> json);
  bool canParse(Map<String, dynamic> json);
}
