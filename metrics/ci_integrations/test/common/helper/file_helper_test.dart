import 'package:ci_integration/common/helper/file_helper.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../ci_integration/test_util/mock/file_mock.dart';

void main() {
  group("FileHelper", () {
    final fileHelper = FileHelper();
    FileMock fileMock;

    setUp(() {
      fileMock = FileMock();
    });

    test(
      ".exists() should return false if a file by the given path does not exist",
      () {
        when(fileMock.existsSync()).thenReturn(false);
        final result = fileHelper.exists(fileMock);

        expect(result, isFalse);
      },
    );

    test(
      ".exists() should return true if a file by the given path exists",
      () {
        when(fileMock.existsSync()).thenReturn(true);
        final result = fileHelper.exists(fileMock);

        expect(result, isTrue);
      },
    );

    test(
      ".read() should return a file content",
      () {
        const fileContent = 'test';
        when(fileMock.readAsStringSync()).thenReturn(fileContent);
        final result = fileHelper.read(fileMock);

        expect(result, equals(fileContent));
      },
    );
  });
}
