import 'package:metrics/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';

void main() {
  group("SignInUseeCase", () {
    test("can't be created with null repository", () {
      expect(
        () => SignInUseCase(null),
        MatcherUtil.throwsAssertionError,
      );
    });
  });
}
