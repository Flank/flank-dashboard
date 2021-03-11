// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:ci_integration/client/firestore/model/firebase_grpc_error_reason.dart';
import 'package:ci_integration/integration/interface/base/client/mapper/mapper.dart';

/// A class that provides methods for mapping [FirebaseGrpcErrorReason]s.
class FirebaseGrpcErrorReasonMapper
    implements Mapper<String, FirebaseGrpcErrorReason> {
  /// An error reason indicating that the provided Firebase project ID is not
  /// valid or does not exist.
  static const String consumerInvalid = 'CONSUMER_INVALID';

  /// An error reason indicating that the provided Firebase with the given
  /// project ID is not found.
  static const String notFound = 'NOT_FOUND';

  /// Creates a new intance of the [FirebaseGrpcErrorReasonMapper].
  const FirebaseGrpcErrorReasonMapper();

  @override
  FirebaseGrpcErrorReason map(String value) {
    switch (value) {
      case consumerInvalid:
        return FirebaseGrpcErrorReason.consumerInvalid;
      case notFound:
        return FirebaseGrpcErrorReason.notFound;
      default:
        return null;
    }
  }

  @override
  String unmap(FirebaseGrpcErrorReason value) {
    switch (value) {
      case FirebaseGrpcErrorReason.consumerInvalid:
        return consumerInvalid;
      case FirebaseGrpcErrorReason.notFound:
        return notFound;
    }
    return null;
  }
}
