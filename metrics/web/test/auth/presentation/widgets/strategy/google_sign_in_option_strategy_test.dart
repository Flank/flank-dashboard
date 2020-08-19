import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/widgets/strategy/google_sign_in_option_strategy.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../../../test_utils/auth_notifier_mock.dart';

void main() {
  group("GoogleSignInOptionStrategy", () {
    final strategy = GoogleSignInOptionStrategy();

    test(".asset equals to the google logo asset", () {
      const expectedAsset = 'icons/logo-google.svg';

      final actualAsset = strategy.asset;

      expect(actualAsset, equals(expectedAsset));
    });

    test(".label equals to the sign in with google message", () {
      const expectedLabel = AuthStrings.signInWithGoogle;

      final actualLabel = strategy.label;

      expect(actualLabel, equals(expectedLabel));
    });

    test(".signIn() delegates sign in to the given notifier", () {
      final notifier = AuthNotifierMock();

      strategy.signIn(notifier);

      verify(notifier.signInWithGoogle()).called(1);
    });
  });
}
