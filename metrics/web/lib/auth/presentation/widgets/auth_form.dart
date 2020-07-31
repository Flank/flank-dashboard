import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/validators/email_validator.dart';
import 'package:metrics/auth/presentation/validators/password_validator.dart';
import 'package:metrics/auth/presentation/widgets/sign_in_option_button.dart';
import 'package:metrics/auth/presentation/widgets/strategy/google_sign_in_option_strategy.dart';
import 'package:metrics/common/presentation/button/widgets/metrics_positive_button.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_form_field.dart';
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          MetricsTextFormField(
            key: const Key(AuthStrings.email),
            controller: _emailController,
            validator: EmailValidator.validate,
            hint: AuthStrings.email,
            keyboardType: TextInputType.emailAddress,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: MetricsTextFormField(
              key: const Key(AuthStrings.password),
              controller: _passwordController,
              validator: PasswordValidator.validate,
              obscureText: true,
              hint: AuthStrings.password,
            ),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, top: 72.0),
            child: MetricsPositiveButton(
              onPressed: () => _submit(),
              label: AuthStrings.signIn,
            ),
          ),
          SignInOptionButton(
            strategy: GoogleSignInOptionStrategy(),
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
