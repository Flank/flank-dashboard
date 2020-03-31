import 'package:flutter/material.dart';

import '../widgets/auth_form.dart';
import '../widgets/auth_scaffold.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthScaffold(
        form: AuthForm(),
      ),
    );
  }
}
