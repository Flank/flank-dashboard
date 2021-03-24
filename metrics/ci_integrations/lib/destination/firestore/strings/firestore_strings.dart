// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

// ignore_for_file: public_member_api_docs

/// A class that holds the strings used across the Firestore destination
/// integration.
class FirestoreStrings {
  static const String apiKeyInvalid = 'The Firebase API key is invalid.';
  static const String projectIdInvalid =
      'The given Firebase project id is invalid';
  static const String metricsProjectIdDoesNotExist =
      'The metrics project with the given identifier does not exist.';
  static const String unknownErrorWhenSigningIn =
      'An unknown error occurred when signing in to the Firebase. Please try again later.';
  static const String publicApiKeyInvalidInterruptReason =
      "Can't be validated as the provided Firebase public API key is invalid.";
  static const String authValidationFailedInterruptReason =
      "Can't be validated as the Firebase user email and password validation failed.";
  static const String firebaseProjectIdInterruptReason =
      "Can't be validated as the Firebase project ID validation failed.";

  static String authValidationFailed(
    String code,
    String message,
  ) {
    return "Cannot validate the given auth. The validation has "
        "failed with the following exception code: $code and message: '$message'."
        " Please try again later.";
  }

  static String metricsProjectIdValidationFailed(
    String code,
    String message,
  ) {
    return "Cannot validate the given Metrics project ID. The validation has "
        "failed with the following exception code: $code and message: '$message'."
        " Please check your security rules or try again later.";
  }
}
