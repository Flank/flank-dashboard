import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:metrics/features/auth/presentation/state/user_store.dart';
import 'package:metrics/features/auth/presentation/strings/login_strings.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

/// Shows an authentication form to sign in.
class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

/// The logic and internal state for the [AuthForm] widget.
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
          AuthInputField(
            key: Key(LoginStrings.email),
            label: LoginStrings.email,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            onFieldSubmitted: (_) => _submit(),
            validator: _validateEmail,
          ),
          AuthInputField(
            key: Key(LoginStrings.password),
            label: LoginStrings.password,
            controller: _passwordController,
            obscureText: true,
            onFieldSubmitted: (_) => _submit(),
            validator: _validatePassword,
          ),
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            alignment: Alignment.centerRight,
            child: RaisedButton(
              key: const Key(LoginStrings.signIn),
              onPressed: () => _submit(),
              child: const Text(LoginStrings.signIn),
            ),
          ),
        ],
      ),
    );
  }

  String _validateEmail(String value) {
    if (value.isEmpty) {
      return LoginStrings.emailIsRequired;
    }

    if (!EmailValidator.validate(value)) {
      return LoginStrings.emailIsInvalid;
    }

    return null;
  }

  String _validatePassword(String value) {
    if (value.isEmpty) {
      return LoginStrings.passwordIsRequired;
    }

    return null;
  }

  /// Submits the [Form].
  void _submit() {
    if (_formKey.currentState.validate()) {
      Injector.getAsReactive<UserStore>().state.signInWithEmailAndPassword(
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
