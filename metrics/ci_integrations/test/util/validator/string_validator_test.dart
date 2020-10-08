import 'package:ci_integration/util/validator/string_validator.dart';
import 'package:test/test.dart';

// ignore_for_file: avoid_redundant_argument_values

void main() {
  group("StringValidator", () {
    Function _validatorCallback(String value, {String name}) {
      return () => StringValidator.checkNotNullOrEmpty(value, name: name);
    }

    test(
      "throws an ArgumentError if the given value is null",
      () {
        expect(_validatorCallback(null), throwsArgumentError);
      },
    );

    test(
      "throws an ArgumentError if the given value is empty",
      () {
        expect(_validatorCallback(''), throwsArgumentError);
      },
    );

    test(
      "validates the given value",
      () {
        expect(_validatorCallback('test'), returnsNormally);
      },
    );

    test(
      "throws an ArgumentError that contains the name of a validated variable if specified",
      () {
        const variableName = 'test';

        expect(
          _validatorCallback(null, name: variableName),
          throwsA(
            (error) =>
                error is ArgumentError && error.name.contains(variableName),
          ),
        );
      },
    );

    test(
      "throws an ArgumentError that doesn't contain the name of a validated variable if it wasn't specified",
      () {
        expect(
          _validatorCallback(null, name: null),
          throwsA(
            (error) => error is ArgumentError && error.name == null,
          ),
        );
      },
    );
  });
}
