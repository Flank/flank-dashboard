import 'package:metrics/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:test/test.dart';

import '../../../../test_utils/matcher_util.dart';

void main() {
  group("SignOutUseCase", () {
    test("can't be created with null repository", () {
      expect(
        () => SignOutUseCase(null),
        MatcherUtil.throwsAssertionError,
      );
    });
  });
}
