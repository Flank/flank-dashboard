import 'package:metrics_core/src/domain/entities/coverage.dart';
import 'package:test/test.dart';

void main() {
  group("Coverage", () {
    test(
      "throws an ArgumentError if the given percent is null",
      () {
        expect(() => Coverage(percent: null), throwsArgumentError);
      },
    );
  });
}
