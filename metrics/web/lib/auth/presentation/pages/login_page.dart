import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/common/presentation/routes/route_name.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:provider/provider.dart';

/// Shows the authentication form to sign in.
class LoginPage extends StatefulWidget {
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

    super.initState();
  }

  /// Navigates to the dashboard screen once the user becomes logged in.
  void _loggedInListener() {
    final isLoggedIn = _authNotifier.isLoggedIn;

    if (isLoggedIn != null && isLoggedIn) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RouteName.dashboard,
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  CommonStrings.metrics,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AuthForm(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _authNotifier.removeListener(_loggedInListener);
    super.dispose();
  }
}
