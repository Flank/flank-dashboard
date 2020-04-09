import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metrics/features/auth/presentation/state/auth_store.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/features/common/presentation/routes/route_generator.dart';
import 'package:metrics/features/common/presentation/strings/common_strings.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

/// Shows the authentication form to sign in.
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

/// The logic and internal state for the [LoginPage] widget.
class _LoginPageState extends State<LoginPage> {
  StreamSubscription _loggedInStreamSubscription;

  @override
  void initState() {
    final authStore = Injector.get<AuthStore>();

    _loggedInStreamSubscription =
        authStore.loggedInStream.listen((isUserLoggedIn) {
      if (isUserLoggedIn != null && isUserLoggedIn) {
        Navigator.pushNamedAndRemoveUntil(
            context, RouteGenerator.dashboard, (Route<dynamic> route) => false);
      }
    });
    super.initState();
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  CommonStrings.metrics,
                  style: const TextStyle(
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
    _loggedInStreamSubscription.cancel();
    super.dispose();
  }
}
