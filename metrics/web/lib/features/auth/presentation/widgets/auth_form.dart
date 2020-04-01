import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:metrics/features/auth/presentation/state/user_metrics_store.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_input_field.dart';
import 'package:metrics/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

/// The widget that shows an authentication form to sign in.
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
            label: 'Email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            onFieldSubmitted: (String value) async => _submit(),
            validator: (value) {
              if (value.isEmpty) {
                return 'Email address is required';
              }

              if (!EmailValidator.validate(value)) {
                return 'Invalid email address';
              }

              return null;
            },
          ),
          AuthInputField(
            label: 'Password',
            controller: _passwordController,
            obscureText: true,
            onFieldSubmitted: (String value) async => _submit(),
            validator: (value) {
              if (value.isEmpty) {
                return 'Password is required';
              }

              return null;
            },
          ),
          Container(
            margin: const EdgeInsets.only(top: 20.0),
            alignment: Alignment.centerRight,
            child: RaisedButton(
              onPressed: () async => _submit(),
              child: const Text('Sign in'),
            ),
          ),
        ],
      ),
    );
  }

  /// Submits the [Form] and navigates to the [DashboardPage].
  Future<void> _submit() async {
    if (_formKey.currentState.validate()) {
      final ReactiveModel<UserMetricsStore> userMetricsStoreRM =
          Injector.getAsReactive<UserMetricsStore>();

      await userMetricsStoreRM.state.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);

      await Navigator.pushNamed(context, '/dashboard');
    }
  }

  /// Discards any resources used by [_emailController] and [_passwordController].
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
