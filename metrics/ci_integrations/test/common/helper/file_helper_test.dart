import 'package:ci_integration/common/helper/file_helper.dart';
import 'package:test/test.dart';

void main() {
  group("FileHelper", () {
    const nonExistingFilePath = 'test/common/resources/notafile.txt';
    const existingFilePath = 'test/common/resources/file.txt';
    final fileHelper = FileHelper();

    test(
      ".exists() should return false if a file by the given path does not exist",
      () {
        final result = fileHelper.exists(nonExistingFilePath);

        expect(result, isFalse);
      },
    );

    test(
      ".exists() should return true if a file by the given path exists",
      () {
        final result = fileHelper.exists(existingFilePath);

        expect(result, isTrue);
      },
    );

    test(
      ".read() should return a file content",
      () {
        final result = fileHelper.read(existingFilePath);

        expect(result, equals('test'));
      },
    );
  });
}
