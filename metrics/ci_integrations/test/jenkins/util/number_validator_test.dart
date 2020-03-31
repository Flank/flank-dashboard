import 'package:ci_integration/jenkins/util/number_validator.dart';
import 'package:test/test.dart';

void main() {
  group("NumberValidator", () {
    test(".checkPositive() should throw ArgumentError if a number is null", () {
      expect(() => NumberValidator.checkPositive(null), throwsArgumentError);
    });

    test(".checkPositive() should throw ArgumentError if a number is negative",
        () {
      expect(() => NumberValidator.checkPositive(-1), throwsArgumentError);
    });

    test(".checkPositive() should validate the given number", () {
      expect(() => NumberValidator.checkPositive(1), returnsNormally);
    });

    test(
      ".checkPositiveRange() should throw ArgumentError if the begin value is null",
      () {
        expect(
          () => NumberValidator.checkPositiveRange(null, 1),
          throwsArgumentError,
        );
      },
    );

    test(
      ".checkPositiveRange() should throw ArgumentError if the end value is null",
      () {
        expect(
          () => NumberValidator.checkPositiveRange(1, null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".checkPositiveRange() should throw ArgumentError if the begin value is negative",
      () {
        expect(
          () => NumberValidator.checkPositiveRange(-1, 1),
          throwsArgumentError,
        );
      },
    );

    test(
      ".checkPositiveRange() should throw ArgumentError if the end value is negative",
      () {
        expect(
          () => NumberValidator.checkPositiveRange(1, -1),
          throwsArgumentError,
        );
      },
    );

    test(
      ".checkPositiveRange() should throw ArgumentError if the end value is less than the begin one",
      () {
        expect(
          () => NumberValidator.checkPositiveRange(2, 1),
          throwsArgumentError,
        );
      },
    );

    test(".checkPositiveRange() should validate the given range", () {
      expect(() => NumberValidator.checkPositiveRange(1, 2), returnsNormally);
    });
  });
}
