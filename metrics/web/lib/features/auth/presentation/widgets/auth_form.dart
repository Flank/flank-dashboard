import 'package:flutter/material.dart';
import 'package:metrics/features/auth/domain/value_objects/email.dart';
import 'package:metrics/features/auth/domain/value_objects/password.dart';
import 'package:metrics/features/auth/presentation/exceptions/exception_handler.dart';
import 'package:metrics/features/auth/service/user_service.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final ReactiveModel<UserService> userServiceRM =
      Injector.getAsReactive<UserService>().asNew('authForm');

  final _emailRM = ReactiveModel.create('');
  final _passwordRM = ReactiveModel.create('');

  bool get _isFormValid => _emailRM.hasData && _passwordRM.hasData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        StateBuilder(
          models: [_emailRM],
          builder: (context, _) {
            return TextField(
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(fontSize: 14.0),
                errorText:
                    ExceptionHandler.errorMessage(_emailRM.error).message,
              ),
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              autocorrect: false,
              onChanged: (value) {
                _emailRM.setValue(() => Email(value).value, catchError: true);
              },
            );
          },
        ),
        StateBuilder(
          models: [_passwordRM],
          builder: (context, _) {
            return TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: const TextStyle(fontSize: 14.0),
                errorText:
                    ExceptionHandler.errorMessage(_passwordRM.error).message,
              ),
              autocorrect: false,
              obscureText: true,
              onChanged: (value) {
                _passwordRM.setValue(() => Password(value).value,
                    catchError: true);
              },
            );
          },
        ),
        const SizedBox(
          height: 10,
        ),
        StateBuilder(
          models: [userServiceRM],
          builder: (context, _) {
            if (userServiceRM.hasError) {
              return Text(
                ExceptionHandler.errorMessage(userServiceRM.error).message,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 14.0,
                ),
              );
            } else {
              return const Text('');
            }
          },
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            StateBuilder(
              models: [_emailRM, _passwordRM, userServiceRM],
              builder: (BuildContext context, _) {
                return RaisedButton(
                  onPressed: _isFormValid
                      ? () {
                          userServiceRM.setState(
                            (userService) =>
                                userService.signInWithEmailAndPassword(
                                    _emailRM.value, _passwordRM.value),
                            onData: (BuildContext context, _) =>
                                Navigator.pushNamed(context, '/dashboard'),
                            catchError: true,
                          );
                        }
                      : null,
                  child: userServiceRM.isWaiting
                      ? const CircularProgressIndicator()
                      : const Text('Sign in'),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
