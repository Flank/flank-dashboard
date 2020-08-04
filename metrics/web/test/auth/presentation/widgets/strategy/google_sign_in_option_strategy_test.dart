import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/widgets/strategy/google_sign_in_option_strategy.dart';
import 'package:test/test.dart';

void main() {
  group("GoogleSignInOptionStrategy", () {
    test(".asset equals to the google logo asset", () {
      const expectedAsset = 'icons/logo-google.svg';

      final strategy = GoogleSignInOptionStrategy();
      final actualAsset = strategy.asset;

      expect(actualAsset, equals(expectedAsset));
    });

    test(".label equals to the sign in with google message", () {
      const expectedLabel = AuthStrings.signInWithGoogle;

      final strategy = GoogleSignInOptionStrategy();
      final actualLabel = strategy.label;

      expect(actualLabel, equals(expectedLabel));
    });
  });
}
