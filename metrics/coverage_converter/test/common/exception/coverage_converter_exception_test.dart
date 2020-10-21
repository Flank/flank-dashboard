import 'package:coverage_converter/common/exception/coverage_converter_exception.dart';
import 'package:coverage_converter/common/exception/error_code/coverage_converter_error_code.dart';
import 'package:coverage_converter/common/strings/common_strings.dart';
import 'package:test/test.dart';

void main() {
  group("CoverageConverterException", () {
    test(
      ".message returns no such file error message if the given code is `noSuchFile`",
      () {
        const coverageConverterException =
            CoverageConverterException(CoverageConverterErrorCode.noSuchFile);

        expect(coverageConverterException.message, CommonStrings.noSuchFile);
      },
    );

    test(
      ".message returns file is empty error message if the given code is `fileIsEmpty`",
      () {
        const coverageConverterException =
            CoverageConverterException(CoverageConverterErrorCode.fileIsEmpty);

        expect(coverageConverterException.message, CommonStrings.fileIsEmpty);
      },
    );

    test(
      ".message returns invalid file format error message if the given code is `invalidFileFormat`",
      () {
        const coverageConverterException = CoverageConverterException(
            CoverageConverterErrorCode.invalidFileFormat);

        expect(coverageConverterException.message,
            CommonStrings.invalidFileFormat);
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
