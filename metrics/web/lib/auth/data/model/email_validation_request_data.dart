import 'package:metrics_core/metrics_core.dart';

/// A [DataModel] that represents an email validation request.
class EmailValidationRequestData implements DataModel {
  /// An email to validate.
  final String email;

  /// Creates the [EmailValidationRequestData] with the given [email].
  ///
  /// Throws an [ArgumentError] if the [email] is `null`.
  EmailValidationRequestData({
    this.email,
  }) {
    ArgumentError.checkNotNull(email, 'email');
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }
}
