import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/validators/email_validator.dart';
import 'package:metrics/auth/presentation/validators/password_validator.dart';
import 'package:provider/provider.dart';

/// Shows an authentication form to sign in.
class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  /// Global key that uniquely identifies the [Form] widget and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  /// Controls the email text being edited.
  final TextEditingController _emailController = TextEditingController();

  /// Controls the password text being edited.
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            key: const Key(AuthStrings.email),
            decoration: const InputDecoration(
              labelText: AuthStrings.email,
            ),
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: EmailValidator.validate,
          ),
          TextFormField(
            key: const Key(AuthStrings.password),
            decoration: const InputDecoration(
              labelText: AuthStrings.password,
            ),
            controller: _passwordController,
            obscureText: true,
            validator: PasswordValidator.validate,
          ),
          Selector<AuthNotifier, String>(
            selector: (_, state) => state.authErrorMessage,
            builder: (_, authErrorMessage, __) {
              if (authErrorMessage == null) return Container();

              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  authErrorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 10.0),
            alignment: Alignment.centerRight,
            child: RaisedButton(
              key: const Key(AuthStrings.signIn),
              onPressed: () => _submit(),
              child: const Text(AuthStrings.signIn),
            ),
          ),
        ],
      ),
    );
  }

  /// Starts sign in process.
  void _submit() {
    if (_formKey.currentState.validate()) {
      Provider.of<AuthNotifier>(context, listen: false)
          .signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
