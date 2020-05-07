import 'package:flutter/material.dart';
import 'package:metrics/features/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/features/common/presentation/routes/route_generator.dart';
import 'package:metrics/features/common/presentation/strings/common_strings.dart';
import 'package:provider/provider.dart';

/// A page that shows until the authentication status unknown.
class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage>
    with TickerProviderStateMixin {
  static const _animationDuration = Duration(seconds: 1);
  AnimationController _animationController;
  AuthNotifier _authNotifier;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
    _animationController.repeat(reverse: true);

    _authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    _authNotifier.addListener(_authNotifierListener);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _authNotifier.subscribeToAuthenticationUpdates();
    });

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

  /// Navigates from loading page corresponding to authentication status.
  void _authNotifierListener() {
    final isLoggedIn = _authNotifier.isLoggedIn;

    if (isLoggedIn == null) return;

    if (isLoggedIn) {
      Navigator.pushReplacementNamed(context, RouteGenerator.dashboard);
    } else {
      Navigator.pushReplacementNamed(context, RouteGenerator.login);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _authNotifier.removeListener(_authNotifierListener);
    super.dispose();
  }
}
