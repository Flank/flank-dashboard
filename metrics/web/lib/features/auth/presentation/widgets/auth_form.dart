import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:metrics/features/auth/presentation/state/user_metrics_store.dart';
import 'package:metrics/features/common/presentation/widgets/input_field.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  /// Global key that uniquely identifies the Form widget and allows validation of the form.
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
          InputField(
            label: 'Email',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
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
          InputField(
            label: 'Password',
            controller: _passwordController,
            obscureText: true,
            validator: (value) {
              if (value.isEmpty) {
                return 'Password is required';
              }

              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                StateBuilder(
                  models: [Injector.getAsReactive<UserMetricsStore>()],
                  builder: (BuildContext context, userMetricsStore) {
                    return RaisedButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          userMetricsStore.state
                              .signInWithEmailAndPassword(_emailController.text,
                                  _passwordController.text)
                              .then((value) =>
                                  Navigator.pushNamed(context, '/dashboard'));
                        }
                      },
                      child: const Text('Sign in'),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
