import 'package:metrics/dashboard/presentation/view_models/percent_view_model.dart';
import 'package:test/test.dart';

// ignore_for_file: prefer_const_constructors

void main() {
  group("PercentViewModel", () {
    test("can be created with null value", () {
      expect(
        () => PercentViewModel(null),
        returnsNormally,
      );
    });

    test("creates a new view model with the given value", () {
      const value = 1.0;
      const expected = PercentViewModel(value);

      final percent = PercentViewModel(value);

      expect(percent, equals(expected));
    });
  });
}
