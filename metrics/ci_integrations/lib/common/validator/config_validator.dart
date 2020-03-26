import 'package:ci_integration/common/config/ci_config.dart';
import 'package:ci_integration/common/validator/config_validation_result.dart';

/// An abstract class for validating [CiConfig] instances.
abstract class ConfigValidator {
  /// Validates [config] and returns [ConfigValidationResult] instance as
  /// a result of validation.
  ConfigValidationResult validate(CiConfig config);
}
