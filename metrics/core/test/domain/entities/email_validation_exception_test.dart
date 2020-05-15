import 'package:metrics_core/metrics_core.dart';
import 'package:test/test.dart';

void main() {
  group("EmailValidationException", () {
    test("throws an ArgumentError if the given code is null", () {
      expect(() => EmailValidationException(null), throwsArgumentError);
    });
  });
}
