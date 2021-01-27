import 'package:ci_integration/util/validator/number_validator.dart';
import 'package:test/test.dart';

void main() {
  group("NumberValidator", () {
    test(".checkPositive() throws an ArgumentError if a number is null", () {
      expect(() => NumberValidator.checkPositive(null), throwsArgumentError);
    });

    test(".checkPositive() throws an ArgumentError if a number is negative",
        () {
      expect(() => NumberValidator.checkPositive(-1), throwsArgumentError);
    });

    test(".checkPositive() validates the given number", () {
      expect(() => NumberValidator.checkPositive(1), returnsNormally);
    });

    test(
      ".checkPositiveRange() throws an ArgumentError if the begin value is null",
      () {
        expect(
          () => NumberValidator.checkPositiveRange(null, 1),
          throwsArgumentError,
        );
      },
    );

    test(
      ".checkPositiveRange() throws an ArgumentError if the end value is null",
      () {
        expect(
          () => NumberValidator.checkPositiveRange(1, null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".checkPositiveRange() throws an ArgumentError if the begin value is negative",
      () {
        expect(
          () => NumberValidator.checkPositiveRange(-1, 1),
          throwsArgumentError,
        );
      },
    );

    test(
      ".checkPositiveRange() throws an ArgumentError if the end value is negative",
      () {
        expect(
          () => NumberValidator.checkPositiveRange(1, -1),
          throwsArgumentError,
        );
      },
    );

    test(
      ".checkPositiveRange() throws an ArgumentError if the end value is less than the begin one",
      () {
        expect(
          () => NumberValidator.checkPositiveRange(2, 1),
          throwsArgumentError,
        );
      },
    );

    test(".checkPositiveRange() validates the given range", () {
      expect(() => NumberValidator.checkPositiveRange(1, 2), returnsNormally);
    });

    test(
      ".checkGreaterThan() throws an ArgumentError if the given number is null",
      () {
        expect(
          () => NumberValidator.checkGreaterThan(null, 1),
          throwsArgumentError,
        );
      },
    );

    test(
      ".checkGreaterThan() throws an ArgumentError if the given number to compare is null",
      () {
        expect(
          () => NumberValidator.checkGreaterThan(1, null),
          throwsArgumentError,
        );
      },
    );

    test(
      ".checkGreaterThan() throws an ArgumentError if the given number is less than the given number to compare",
      () {
        expect(
          () => NumberValidator.checkGreaterThan(1, 2),
          throwsArgumentError,
        );
      },
    );

    test(
      ".checkGreaterThan() throws an ArgumentError if the given number is equal to the given number to compare",
      () {
        expect(
          () => NumberValidator.checkGreaterThan(1, 1),
          throwsArgumentError,
        );
      },
    );
  });
}
