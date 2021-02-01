import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

/// An extension on [VerificationResult] that provides a facilitated way
/// to assert that method was called once.
extension CalledOnceVerificationResult on VerificationResult {
  /// Assert that the method was called once.
  void calledOnce() {
    called(equals(1));
  }
}
