import 'package:coverage_converter/common/runner/coverage_converter_runner.dart';
import 'package:test/test.dart';

void main() {
  group("CoverageConverterRunner", () {
    test("successfully creates an instance", () {
      expect(() => CoverageConverterRunner(), returnsNormally);
    });
  });
}
