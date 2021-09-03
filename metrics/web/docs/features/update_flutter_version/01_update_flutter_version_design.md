# Update flutter version

> Summary of the proposed change.

The latest versions of Flutter bring some changes to the existing API of the framework, so we should make some changes to the code to update our project to the latest version of Flutter successfully.

# References

> Link to supporting documentation, GitHub tickets, etc.

* [`RaisedButton` class](https://api.flutter.dev/flutter/material/RaisedButton-class.html)
* [`ElevatedButton` class](https://api.flutter.dev/flutter/material/ElevatedButton-class.html)
* [Migrating to the New Material Buttons and their Themes](https://docs.google.com/document/d/1yohSuYrvyya5V1hB6j9pJskavCdVq9sVeTqSoEPsWH0/edit#heading=h.pub7jnop54q0)
* [Use `BuildContext` synchronously linter rule](https://dart-lang.github.io/linter/lints/use_build_context_synchronously.html)
* [Use named constants lint rule](https://dart-lang.github.io/linter/lints/use_named_constants.html)

# Goals

> Identify success metrics and measurable goals.

* Metrics web application is updated to the latest Flutter version.
* Deprecated classes are not used in the project anymore.
* All functionalities present in the application work as expected.

# Analysis

> Describe a general analysis approach.

If we update Flutter to the 2.2.3 stable version, we can see that the output of the dart analysis tool contains some warnings. To fix them, we should consider the following steps:
* The [`RaisedButton`](https://api.flutter.dev/flutter/material/RaisedButton-class.html) class is deprecated, so we should use the new [`ElevatedButton`](https://api.flutter.dev/flutter/material/ElevatedButton-class.html) class instead. To do this, we also should make changes in declarations of button styles according to the [Migrating to the New Material Buttons and their Themes](https://docs.google.com/document/d/1yohSuYrvyya5V1hB6j9pJskavCdVq9sVeTqSoEPsWH0/edit#heading=h.pub7jnop54q0) guide. For example:
  ```dart
  Widget button() {
    return RaisedButton(
      color: loginOptionStyle.color,
      disabledColor: loginOptionStyle.color,
      hoverColor: loginOptionStyle.hoverColor,
      elevation: loginOptionStyle.elevation,
      hoverElevation: loginOptionStyle.elevation,
      focusElevation: loginOptionStyle.elevation,
      highlightElevation: loginOptionStyle.elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
  }
  ```
  should be replaced with the following:
  ```dart
  Widget button() {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.disabled)) {
            return loginOptionStyle.color;
          }
          if (states.contains(MaterialState.hovered)) {
            return loginOptionStyle.hoverColor;
          }
          return loginOptionStyle.color;
        }),
        elevation: MaterialStateProperty.all(loginOptionStyle.elevation),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
      ),
    );
  }
  ```
  We should make such changes in the following places in the code:
  * `SignInOptionButton` class.
  * `MetricsButton` class.


* Replace the `RaisedButton` usages with the `ElevatedButton` in the following files:
  * `password_sign_in_option_test.dart`.
  * `sign_in_option_button_test.dart`.
  * `dropdown_body_test.dart`.
  * `metrics_button_test.dart`.
  * `injection_container_test.dart`.
  * `delete_project_group_dialog_test.dart`.
  * `project_group_dialog_test.dart`.


* Add checkout that the `State` is still present in the widget tree before using `BuildContext` inside async functions in accordance with [use_build_context_synchronously](https://dart-lang.github.io/linter/lints/use_build_context_synchronously.html) lint rule. For example:
  ```dart
  Future<void> asyncFunction() async {
    if (mounted) {
      Navigator.pop(context);
    }
  }
  ```
  This recommendation should be applied to the following files:
  * `delete_project_group_dialog.dart`.
  * `project_group_dialog.dart`.


* Replace `const Duration()` usages with predefined constant `Duration.zero` to prevent duplicating its value. This change is required in the following places in the code:
  * `dropdown_body.dart`
  * `performance_sparkline_view_model.dart`
  * `build_result_bar_padding_strategy_test.dart`
  
  You can read more about this lint rule on the [use_named_constants](https://dart-lang.github.io/linter/lints/use_named_constants.html) page.


* Replace `BorderRadius.all(Radius.zero)` usages with predefined constant `BorderRadius.zero` to prevent duplicating its value. Please, apply this change to the `material_container_test.dart` file. You can read more about this lint rule on the [use_named_constants](https://dart-lang.github.io/linter/lints/use_named_constants.html) page.
