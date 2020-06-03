import 'package:metrics/dashboard/presentation/view_models/stability_view_model.dart';
import 'package:test/test.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("StabilityViewModel", () {
    test("can be created with null value", () {
      expect(
        () => StabilityViewModel(value: null),
        returnsNormally,
      );
    });

    test("creates a new view model with the given value", () {
      const value = 1.0;
      const expected = StabilityViewModel(value: value);

      final stability = StabilityViewModel(value: value);

      expect(stability.value, equals(expected));
    });
  });
}
