import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:test/test.dart';

void main() {
  group('CommonStrings', () {
    test(
        ".getLoadingErrorMessage() returns an error message that contains the given description",
        () {
      const error = 'testErrorMessage';

      expect(CommonStrings.getLoadingErrorMessage(error), contains(error));
    });
  });
}
