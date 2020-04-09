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
            validator: _validateEmail,
          ),
          AuthInputField(
            key: Key(LoginStrings.password),
            label: LoginStrings.password,
            controller: _passwordController,
            obscureText: true,
            validator: _validatePassword,
          ),
          StateBuilder(
            models: [Injector.getAsReactive<UserStore>()],
            builder: (_, ReactiveModel<UserStore> store) {
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
              key: const Key(LoginStrings.signIn),
              onPressed: () => _submit(),
              child: const Text(LoginStrings.signIn),
            ),
          ),
        ],
      ),
    );
  }

  /// Check if an email field is not empty and has the right format,
  /// otherwise show an error text.
  String _validateEmail(String value) {
    if (value.isEmpty) {
      return LoginStrings.emailIsRequired;
    }

    if (!EmailValidator.validate(value)) {
      return LoginStrings.emailIsInvalid;
    }

    return null;
  }

  /// Check if a password field is not empty and match the minimum length,
  /// otherwise show an error text.
  String _validatePassword(String value) {
    if (value.isEmpty) {
      return LoginStrings.passwordIsRequired;
    }

    if (value.length < 6) {
      return LoginStrings.passwordMinLength;
    }

    return null;
  }

  /// Validates the [Form] and signs in user to the app using an email and a password.
  void _submit() {
    if (_formKey.currentState.validate()) {
      Injector.getAsReactive<UserStore>().setState(
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
