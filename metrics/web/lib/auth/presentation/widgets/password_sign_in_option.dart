import 'package:flutter/material.dart';
import 'package:metrics/auth/presentation/state/auth_notifier.dart';
import 'package:metrics/auth/presentation/strings/auth_strings.dart';
import 'package:metrics/auth/presentation/validators/email_validator.dart';
import 'package:metrics/auth/presentation/validators/password_validator.dart';
import 'package:metrics/base/presentation/widgets/svg_image.dart';
import 'package:metrics/base/presentation/widgets/tappable_area.dart';
import 'package:metrics/common/presentation/button/widgets/metrics_positive_button.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_form_field.dart';
import 'package:provider/provider.dart';

/// A widget that displays a form for email and password sign-in method.
class PasswordSignInOption extends StatefulWidget {
  /// Creates a new instance of the [PasswordSignInOption].
  const PasswordSignInOption({
    Key key,
  }) : super(key: key);

  @override
  _PasswordSignInOptionState createState() => _PasswordSignInOptionState();
}

class _PasswordSignInOptionState extends State<PasswordSignInOption> {
  /// Global key that uniquely identifies the [Form] widget and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  /// Controls the email text being edited.
  final TextEditingController _emailController = TextEditingController();

  /// Controls the password text being edited.
  final TextEditingController _passwordController = TextEditingController();

  /// Indicates whether to hide the password or not.
  bool _isPasswordObscure = true;

  @override
  Widget build(BuildContext context) {
    final iconColor =
        MetricsTheme.of(context).loginTheme.passwordVisibilityIconColor;
    final passwordIcon =
        _isPasswordObscure ? 'icons/eye_on.svg' : 'icons/eye_off.svg';

    return Consumer<AuthNotifier>(
      builder: (_, notifier, __) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MetricsTextFormField(
                controller: _emailController,
                validator: EmailValidator.validate,
                errorText: notifier.emailErrorMessage,
                hint: AuthStrings.email,
                keyboardType: TextInputType.emailAddress,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: MetricsTextFormField(
                  controller: _passwordController,
                  validator: PasswordValidator.validate,
                  errorText: notifier.passwordErrorMessage,
                  obscureText: _isPasswordObscure,
                  hint: AuthStrings.password,
                  suffixIcon: TappableArea(
                    onTap: _changePasswordObscure,
                    builder: (context, isHovered, child) => child,
                    child: SvgImage(
                      passwordIcon,
                      color: iconColor,
                    ),
                  ),
                ),
              ),
              if (notifier.isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: LinearProgressIndicator(),
                ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 72.0),
                child: MetricsPositiveButton(
                  onPressed: notifier.isLoading ? null : () => _submit(),
                  label: AuthStrings.signIn,
                ),
              ),
            ],
          ),
        );
      },
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

  /// Changes the [_isPasswordObscure] value to the opposite one.
  void _changePasswordObscure() {
    setState(() => _isPasswordObscure = !_isPasswordObscure);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
