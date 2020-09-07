import 'package:metrics/auth/domain/entities/email_validation_result.dart';
import 'package:metrics_core/metrics_core.dart';

/// A [DataModel] that represents the email validation result.
class EmailValidationResultData extends EmailValidationResult
    implements DataModel {
  /// Creates an [EmailValidationResultData] with the given [email]
  /// and [isValid] status.
  EmailValidationResultData({
    String email,
    bool isValid,
  }) : super(email: email, isValid: isValid);

  /// Creates an instance of the [EmailValidationResultData]
  /// from the given [json].
  ///
  /// Returns `null` if the given [json] is `null`.
  factory EmailValidationResultData.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;

    return EmailValidationResultData(
      email: json["email"] as String,
      isValid: json["isValid"] as bool,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'isValid': isValid,
    };
  }
}
