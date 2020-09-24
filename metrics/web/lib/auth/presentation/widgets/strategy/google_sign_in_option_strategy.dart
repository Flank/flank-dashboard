import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/widgets/strategy/sign_in_option_strategy.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';

/// A [SignInOptionAppearanceStrategy] implementation for the Google Sign In option.
class GoogleSignInOptionAppearanceStrategy
    implements SignInOptionAppearanceStrategy {
  @override
  final String asset = 'icons/logo-google.svg';

  @override
  final String label = AuthStrings.signInWithGoogle;

  @override
  void signIn(AuthNotifier notifier) {
    notifier.signInWithGoogle();
  }

  @override
  MetricsButtonStyle getWidgetAppearance(
    MetricsThemeData themeData,
    bool isLoading,
  ) {
    final loginTheme = themeData.loginTheme;

    if (isLoading) return loginTheme.inactiveLoginOptionButtonStyle;

    return loginTheme.loginOptionButtonStyle;
  }
}
