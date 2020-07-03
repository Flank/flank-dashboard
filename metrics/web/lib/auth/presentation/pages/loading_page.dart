import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/common/presentation/routes/route_name.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:provider/provider.dart';

/// A page that shows until the authentication status is unknown.
class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with TickerProviderStateMixin {
  /// Duration of the `metrics` text animation.
  static const _animationDuration = Duration(seconds: 1);

  /// Animation controller of the `metrics` text.
  AnimationController _animationController;

  /// An [AuthNotifier] needed to remove added listeners in the [dispose] method.
  AuthNotifier _authNotifier;

  @override
  void initState() {
    _initAnimation();
    _subscribeToAuthUpdates();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (_, __) {
          return Opacity(
            opacity: _animationController.value,
            child: const Center(
              child: Text(
                CommonStrings.metrics,
                style: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Starts the repeated 'metrics' text animation.
  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _animationController.repeat(reverse: true);
  }

  /// Subscribes to authentication updates.
  void _subscribeToAuthUpdates() {
    _authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    _authNotifier.addListener(_authNotifierListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authNotifier.subscribeToAuthenticationUpdates();
    });
  }

  /// Navigates from loading page corresponding to authentication status.
  void _authNotifierListener() {
    final isLoggedIn = _authNotifier.isLoggedIn;

    if (isLoggedIn == null) return;

    if (isLoggedIn) {
      _navigateTo(RouteName.dashboard);
    } else {
      _navigateTo(RouteName.login);
    }
  }

  /// Navigates to [routeName] and removes all underlying routes.
  void _navigateTo(String routeName) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      routeName,
      (_) => false,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _authNotifier.removeListener(_authNotifierListener);
    super.dispose();
  }
}
