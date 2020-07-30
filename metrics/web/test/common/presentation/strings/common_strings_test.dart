import 'package:duration/duration.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:test/test.dart';

void main() {
  group('CommonStrings', () {
    test(
      ".getLoadingErrorMessage() returns an error message that contains the given description",
      () {
        const error = 'testErrorMessage';

        expect(CommonStrings.getLoadingErrorMessage(error), contains(error));
      },
    );

    test(
      ".duration() returns an string representing the given duration",
      () {
        const duration = Duration(hours: 1, minutes: 40, seconds: 20);
        final expected = prettyDuration(
          duration,
          spacer: '',
          delimiter: ' ',
          abbreviated: true,
        );

        expect(CommonStrings.duration(duration), equals(expected));
      },
    );
  });
}
