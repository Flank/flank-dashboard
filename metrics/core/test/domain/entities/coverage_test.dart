import 'package:metrics_core/src/domain/entities/coverage.dart';
import 'package:test/test.dart';

void main() {
  group("Coverage", () {
    test(
      "can't be created with the null percent",
      () {
        expect(() => Coverage(percent: null), throwsArgumentError);
      },
    );
  });
}
