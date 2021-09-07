# Update flutter version

> Summary of the proposed change.

The latest versions of Flutter bring some changes to the existing API of the framework, so we should make some changes to the code to adapt our project to the latest version of Flutter.

# References

> Link to supporting documentation, GitHub tickets, etc.

* [`RaisedButton` class](https://api.flutter.dev/flutter/material/RaisedButton-class.html)
* [`ElevatedButton` class](https://api.flutter.dev/flutter/material/ElevatedButton-class.html)
* [Migrating to the New Material Buttons and their Themes](https://docs.google.com/document/d/1yohSuYrvyya5V1hB6j9pJskavCdVq9sVeTqSoEPsWH0/edit#heading=h.pub7jnop54q0)
* [Use `BuildContext` synchronously lint rule](https://dart-lang.github.io/linter/lints/use_build_context_synchronously.html)
* [Use named constants lint rule](https://dart-lang.github.io/linter/lints/use_named_constants.html)

# Goals

> Identify success metrics and measurable goals.

* Metrics web application is updated to the latest Flutter version.
* Deprecated classes are not used in the project anymore.
* All functionalities present in the application work as expected.

# Analysis

> Describe a general analysis approach.

If we update Flutter to the 2.2.3 stable version, we can see that the output of the dart analysis tool contains some warnings. The steps required to fix them are described below.
* The [`RaisedButton`](https://api.flutter.dev/flutter/material/RaisedButton-class.html) class is deprecated, so we should use the new [`ElevatedButton`](https://api.flutter.dev/flutter/material/ElevatedButton-class.html) class instead. To do this, we also should make changes in declarations of button styles according to the [Migrating to the New Material Buttons and their Themes](https://docs.google.com/document/d/1yohSuYrvyya5V1hB6j9pJskavCdVq9sVeTqSoEPsWH0/edit#heading=h.pub7jnop54q0) guide. To do this, please consider the following steps:

  1. Add a `buttonStyle` getter to the `MetricsButtonStyle` class, which will return an object of `ButtonStyle` class with passed style parameters. For example:
  ```dart
  /// A [ButtonStyle] with passed [color], [hoverColor], [labelStyle] and
  /// [elevation] values.
  ButtonStyle get buttonStyle => ButtonStyle(
    backgroundColor: MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.disabled)) {
        return color;
      }
      if (states.contains(MaterialState.hovered)) {
        return hoverColor;
      }
      return color;
    }),
    elevation: MaterialStateProperty.all(elevation),
    shape: MaterialStateProperty.all(shape),
    textStyle: MaterialStateProperty.all(labelStyle),
  );
  ```

  2. Replace usages of `RaisedButton` class with `ElevatedButton` in `SignInOptionButton` and `MetricsButton` classes. Let's review the changed `build()` method of `SignInOptionButton` class with `ElevatedButton` usage:
  ```dart
  @override
  Widget build(BuildContext context) {
    final metricsTheme = MetricsTheme.of(context);

    return Selector<AuthNotifier, bool>(
      selector: (_, notifier) => notifier.isLoading,
      builder: (_, isLoading, __) {
        final loginOptionStyle = strategy.getWidgetAppearance(
          metricsTheme,
          isLoading,
        );

        return ElevatedButton(
          style: loginOptionStyle.buttonStyle,
          onPressed: isLoading ? null : () => _signIn(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: SvgImage(
                  strategy.asset,
                  height: 20.0,
                  width: 20.0,
                  fit: BoxFit.contain,
                ),
              ),
              Text(
                strategy.label,
                style: loginOptionStyle.labelStyle,
              ),
            ],
          ),
        );
      },
    );
  }
  ```
    Here is how the `build()` method of the `MetricsButton` class can look like:
  ```dart
  @override
  Widget build(BuildContext context) {
    final buttonTheme = MetricsTheme.of(context).metricsButtonTheme;
    final attentionLevel = buttonTheme.attentionLevel;
    final inactiveStyle = attentionLevel.inactive;
    final style = selectStyle(attentionLevel);

    ElevatedButton(
      style: style.buttonStyle,
      onPressed: onPressed,
      child: Text(
        label,
        style: onPressed == null ? inactiveStyle.labelStyle : style.labelStyle,
      ),
    );
  }
  ```

  3. Replace the `RaisedButton` usages with the `ElevatedButton` in the following files:
    * `password_sign_in_option_test.dart`.
    * `sign_in_option_button_test.dart`.
    * `dropdown_body_test.dart`.
    * `metrics_button_test.dart`.
    * `injection_container_test.dart`.
    * `delete_project_group_dialog_test.dart`.
    * `project_group_dialog_test.dart`.


* Add check that the `State` is still present in the widget tree before using `BuildContext` inside async functions in accordance with the [use_build_context_synchronously](https://dart-lang.github.io/linter/lints/use_build_context_synchronously.html) lint rule. For example:
  ```dart
  /// Starts deleting process of a project group.
  Future<void> _deleteProjectGroup(
    DeleteProjectGroupDialogViewModel projectGroupDeleteDialogViewModel,
  ) async {
    final notifier = Provider.of<ProjectGroupsNotifier>(context, listen: false);

    _setLoading(true);

    await notifier.deleteProjectGroup(projectGroupDeleteDialogViewModel.id);

    final projectGroupSavingError = notifier.projectGroupSavingError;

    Toast toast;

    if (!mounted) {
      return;
    }

    if (projectGroupSavingError == null) {
      Navigator.pop(context);
      final message = ProjectGroupsStrings.getDeletedProjectGroupMessage(
        projectGroupDeleteDialogViewModel.name,
      );
      toast = PositiveToast(message: message);
    } else {
      _setLoading(false);
      toast = NegativeToast(message: projectGroupSavingError);
    }

    showToast(context, toast);
  }
  ```
  This recommendation should be applied to the following classes:
  * `_DeleteProjectGroupDialogState` class, `_deleteProjectGroup()` method.
  * `_ProjectGroupDialogState` class, `_actionCallback()` method.


* Replace `const Duration()` usages with predefined constant `Duration.zero` to prevent duplicating its value. This change is required in the following places in the code:
  * `DropdownBody` class constructor.
  * `PerformanceSparklineViewModel.dart` class constructor.
  * `build_result_bar_padding_strategy_test.dart` tests.
  
  You can read more about this lint rule on the [use_named_constants](https://dart-lang.github.io/linter/lints/use_named_constants.html) page.


* Replace `BorderRadius.all(Radius.zero)` usages with predefined constant `BorderRadius.zero` to prevent duplicating its value. Please, apply this change to the `material_container_test.dart` file. You can read more about this lint rule on the [use_named_constants](https://dart-lang.github.io/linter/lints/use_named_constants.html) page.
