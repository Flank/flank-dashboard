import 'package:test/test.dart';

import '../../../lib/common/exception/coverage_converter_error_strings.dart';
import '../../../lib/common/exception/coverage_converter_exception.dart';
import '../../../lib/common/exception/error_code/coverage_converter_error_code.dart';

void main() {
  group("CoverageConverterException", () {
    test(
      "maps the 'no such file' error code to the 'no such file' error message",
      () {
        const coverageConverterException =
            CoverageConverterException(CoverageConverterErrorCode.noSuchFile);

        expect(coverageConverterException.message,
            CoverageConverterErrorStrings.noSuchFile);
      },
    );

    test(
      "maps the 'file is empty' error code to the 'file is empty' error message",
      () {
        const coverageConverterException =
            CoverageConverterException(CoverageConverterErrorCode.fileIsEmpty);

        expect(coverageConverterException.message,
            CoverageConverterErrorStrings.fileIsEmpty);
      },
    );

    test(
      "maps the 'invalid file format' error code to the 'invalid file format' error message",
      () {
        const coverageConverterException = CoverageConverterException(
            CoverageConverterErrorCode.invalidFileFormat);

        expect(coverageConverterException.message,
            CoverageConverterErrorStrings.invalidFileFormat);
      },
    );

    test(
      "returns null if the given error code is null",
      () {
        const coverageConverterException = CoverageConverterException(null);

        expect(coverageConverterException.message, isNull);
      },
    );
  });
}
