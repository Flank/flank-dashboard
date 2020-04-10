import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:metrics/features/auth/presentation/state/auth_store.dart';
import 'package:metrics/features/auth/presentation/strings/auth_strings.dart';
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

  final _minPasswordLength = 6;

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
            key: Key(AuthStrings.email),
            label: AuthStrings.email,
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: _validateEmail,
          ),
          AuthInputField(
            key: Key(AuthStrings.password),
            label: AuthStrings.password,
            controller: _passwordController,
            obscureText: true,
            validator: _validatePassword,
          ),
          StateBuilder(
            models: [Injector.getAsReactive<AuthStore>()],
            builder: (_, ReactiveModel<AuthStore> store) {
              if (store.state.authErrorMessage == null) return Container();

              return Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Text(
                  store.state.authErrorMessage,
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

  /// Checks if an email field is not empty and has the right format,
  /// otherwise returns an error message.
  String _validateEmail(String value) {
    if (value.isEmpty) {
      return AuthStrings.emailIsRequired;
    }

    if (!EmailValidator.validate(value)) {
      return AuthStrings.emailIsInvalid;
    }

    return null;
  }

  /// Checks if a password field is not empty and match the minimum length,
  /// otherwise returns an error message.
  String _validatePassword(String value) {
    if (value.isEmpty) {
      return AuthStrings.passwordIsRequired;
    }

    if (value.length < _minPasswordLength) {
      return AuthStrings.getPasswordMinLengthErrorMessage(_minPasswordLength);
    }

    return null;
  }

  /// Starts sign in process
  void _submit() {
    if (_formKey.currentState.validate()) {
      Injector.getAsReactive<AuthStore>().setState(
        (store) => store.signInWithEmailAndPassword(
          _emailController.text,
          _passwordController.text,
        ),
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
