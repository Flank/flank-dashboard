// Use of this source code is governed by the Apache License, Version 2.0
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/navigation/state/navigation_notifier.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/common/presentation/toast/widgets/negative_toast.dart';
import 'package:metrics/common/presentation/toast/widgets/toast.dart';
import 'package:metrics/common/presentation/widgets/metrics_theme_image.dart';
import 'package:metrics/common/presentation/widgets/platform_brightness_observer.dart';
import 'package:provider/provider.dart';

/// Shows the authentication form to sign in.
class LoginPage extends StatefulWidget {
  /// Creates a new instance of the [LoginPage].
  const LoginPage({
    Key key,
  }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

/// The logic and internal state for the [LoginPage] widget.
class _LoginPageState extends State<LoginPage> {
  /// An [AuthNotifier] needed to be able to remove the listener
  /// in the [dispose] method.
  AuthNotifier _authNotifier;

  @override
  void initState() {
    _authNotifier = Provider.of<AuthNotifier>(context, listen: false);

    _authNotifier.addListener(_loggedInListener);
    _authNotifier.addListener(_loggedInErrorListener);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loggedInListener();
    });

    super.initState();
  }

  /// Navigates to the dashboard screen once the user becomes logged in.
  void _loggedInListener() {
    final isLoggedIn = _authNotifier.isLoggedIn;

    if (isLoggedIn != null && isLoggedIn) {
      final navigationNotifier = Provider.of<NavigationNotifier>(
        context,
        listen: false,
      );

      Router.neglect(context, () {
        navigationNotifier.handleLoggedIn();
      });
    }
  }

  /// Shows the [NegativeToast] with an error message
  /// if either the auth error message, saving user profile error message
  /// or user profile error message is not null.
  void _loggedInErrorListener() {
    final errorMessage = _authNotifier.authErrorMessage;
    final savingUserProfileErrorMessage =
        _authNotifier.userProfileSavingErrorMessage;
    final userProfileErrorMessage = _authNotifier.userProfileErrorMessage;

    if (errorMessage != null) {
      showToast(context, NegativeToast(message: errorMessage));
    } else if (savingUserProfileErrorMessage != null) {
      showToast(context, NegativeToast(message: savingUserProfileErrorMessage));
    } else if (userProfileErrorMessage != null) {
      showToast(context, NegativeToast(message: userProfileErrorMessage));
    }
  }

  @override
  Widget build(BuildContext context) {
    final loginTheme = MetricsTheme.of(context).loginTheme;

    return Scaffold(
      body: PlatformBrightnessObserver(
        child: Center(
          child: SizedBox(
            width: 480,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(bottom: 104.0),
                  alignment: Alignment.center,
                  child: const MetricsThemeImage(
                    darkAsset: 'icons/logo-metrics.svg',
                    lightAsset: 'icons/logo-metrics-light.svg',
                    width: 180.0,
                    height: 44.0,
                    fit: BoxFit.contain,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    CommonStrings.welcomeMetrics,
                    style: loginTheme.titleTextStyle,
                  ),
                ),
                AuthForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _authNotifier.removeListener(_loggedInListener);
    _authNotifier.removeListener(_loggedInErrorListener);

    super.dispose();
  }
}
