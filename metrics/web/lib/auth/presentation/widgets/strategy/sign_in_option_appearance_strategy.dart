// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/button/theme/style/metrics_button_style.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/strategy/value_based_appearance_strategy.dart';

/// An abstract [ValueBasedAppearanceStrategy] that provides configurations
/// for a sign in option.
abstract class SignInOptionAppearanceStrategy
    implements ValueBasedAppearanceStrategy<MetricsButtonStyle, bool> {
  /// A label of the sign in option this strategy provides.
  String get label;

  /// An asset to use for the sign in option this strategy provides.
  String get asset;

  /// Starts a sign in process using the given [notifier].
  void signIn(AuthNotifier notifier);

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
