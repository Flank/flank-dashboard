import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/widgets/strategy/sign_in_option_appearance_strategy.dart';

/// A [SignInOptionAppearanceStrategy] implementation for the Google Sign In option.
class GoogleSignInOptionAppearanceStrategy
    extends SignInOptionAppearanceStrategy {
  @override
  final String asset = 'icons/logo-google.svg';

  @override
  final String label = AuthStrings.signInWithGoogle;

  @override
  void signIn(AuthNotifier notifier) {
    notifier.signInWithGoogle();
  }
}
