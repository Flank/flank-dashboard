import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:metrics/features/auth/presentation/state/user_metrics_store.dart';
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
          TextFormField(
            controller: _emailController,
            autofocus: true,
            keyboardType: TextInputType.emailAddress,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(fontSize: 14.0),
            ),
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
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'Password',
              labelStyle: TextStyle(fontSize: 14.0),
            ),
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
