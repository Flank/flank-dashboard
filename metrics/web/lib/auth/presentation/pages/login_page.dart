import 'dart:async';

import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/common/presentation/routes/route_generator.dart';
import 'package:metrics/common/presentation/strings/common_strings.dart';
import 'package:metrics/dashboard/presentation/state/project_metrics_notifier.dart';
import 'package:provider/provider.dart';

/// Shows the authentication form to sign in.
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

/// The logic and internal state for the [LoginPage] widget.
class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    final authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    authNotifier.addListener(_loggedInListener);

    super.initState();
  }

  Future<void> _loggedInListener() async {
    final isLoggedIn =
        Provider.of<AuthNotifier>(context, listen: false).isLoggedIn;

    if (isLoggedIn != null && isLoggedIn) {
      await Provider.of<ProjectMetricsNotifier>(context, listen: false)
          .subscribeToProjects();

      await Navigator.pushNamedAndRemoveUntil(
        context,
        RouteGenerator.dashboard,
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
}
