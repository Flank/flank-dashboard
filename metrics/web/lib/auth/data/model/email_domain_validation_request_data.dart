import 'package:metrics_core/metrics_core.dart';

/// A [DataModel] that represents an email domain validation request.
class EmailDomainValidationRequestData implements DataModel {
  /// An email domain to validate.
  final String emailDomain;

  /// Creates the [EmailDomainValidationRequestData]
  /// with the given [emailDomain].
  ///
  /// Throws an [ArgumentError] if the [emailDomain] is `null`.
  EmailDomainValidationRequestData({
    this.emailDomain,
  }) {
    ArgumentError.checkNotNull(emailDomain, 'emailDomain');
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'emailDomain': emailDomain,
    };
  }
}
