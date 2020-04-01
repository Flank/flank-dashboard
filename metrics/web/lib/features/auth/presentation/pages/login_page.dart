import 'package:flutter/material.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/features/common/presentation/strings/common_strings.dart';

/// Shows the authentication form to sign in.
class LoginPage extends StatelessWidget {
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
}
