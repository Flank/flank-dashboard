import 'package:flutter/material.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_form.dart';
import 'package:metrics/features/common/presentation/strings/common_strings.dart';

class AuthScaffold extends StatelessWidget {
  final AuthForm form;
  final String title;

  const AuthScaffold({
    this.title = CommonStrings.projectName,
    this.form,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              form
            ],
          ),
        ),
      ),
    );
  }
}
