// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/auth/presentation/widgets/strategy/sign_in_option_appearance_strategy.dart';
import 'package:metrics/base/presentation/widgets/svg_image.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:provider/provider.dart';

/// A widget that displays a button for a sign in option.
class SignInOptionButton extends StatelessWidget {
  /// A strategy for a sign in option this button stands for.
  final SignInOptionAppearanceStrategy strategy;

  /// Creates a new instance of the login option button
  /// with the given [strategy].
  ///
  /// The [strategy] must not be null.
  const SignInOptionButton({
    Key key,
    @required this.strategy,
  })  : assert(strategy != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final metricsTheme = MetricsTheme.of(context);

    return Selector<AuthNotifier, bool>(
      selector: (_, notifier) => notifier.isLoading,
      builder: (_, isLoading, __) {
        final loginOptionStyle = strategy.getWidgetAppearance(
          metricsTheme,
          isLoading,
        );

        return RaisedButton(
          color: loginOptionStyle.color,
          disabledColor: loginOptionStyle.color,
          hoverColor: loginOptionStyle.hoverColor,
          elevation: loginOptionStyle.elevation,
          hoverElevation: loginOptionStyle.elevation,
          focusElevation: loginOptionStyle.elevation,
          highlightElevation: loginOptionStyle.elevation,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          onPressed: isLoading ? null : () => _signIn(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: SvgImage(
                  strategy.asset,
                  height: 20.0,
                  width: 20.0,
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                strategy.label,
                style: loginOptionStyle.labelStyle,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Starts the sign in process.
  void _signIn(BuildContext context) {
    final notifier = Provider.of<AuthNotifier>(context, listen: false);
    strategy.signIn(notifier);
  }
}
