# Update flutter version

> Summary of the proposed change.

The latest versions of Flutter bring some changes to the existing API of the framework, so we will need to make some changes to the code to update our project to the latest version of Flutter successfully.

# References

> Link to supporting documentation, GitHub tickets, etc.

* [`ElevatedButton` class](https://api.flutter.dev/flutter/material/ElevatedButton-class.html)
* [Use `BuildContext` synchronously linter rule](https://dart-lang.github.io/linter/lints/use_build_context_synchronously.html)
* [Use named constants linter rule](https://dart-lang.github.io/linter/lints/use_named_constants.html)

# Motivation

> What problem is this project solving?

# Goals

> Identify success metrics and measurable goals.

* Metrics web project is updated to the latest Flutter version.
* Deprecated classes are not used in the project anymore.
* All functionalities present in the project work as expected.

# Non-Goals

> Identify what's not in scope.

# Design

> Explain and diagram the technical design.

Consider the following changes to the existing code:
* Replace the `RaisedButton` class usages with `ElevatedButton`. To do this we should also make changes in button style declarations. For example:
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
      backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
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

* Add checkout that the `State` is still present in the widget tree before using `BuildContext` inside async functions. For example:
```dart
Future<void> asyncFunction() async {
  if (mounted) {
    Navigator.pop(context);
  }
}
```

* Replace `const Duration()` usages with predefined constant `Duration.zero` to prevent duplicating its value.
* Replace `BorderRadius.all(Radius.zero)` usages with predefined constant `BorderRadius.zero` to prevent duplicating its value.

# API

> What will the proposed API look like?

# Dependencies

> What is the project blocked on?

> What will be impacted by the project?

# Testing

> How will the project be tested?

We should not add any new unit tests, widget tests, and integration tests because the expected behavior of the system will not change. However, we should apply changes mentioned in [Design](#design) section to unit tests to make them work properly with the latest Flutter version.
# Alternatives Considered

> Summarize alternative designs (pros & cons).

# Timeline

> Document milestones and deadlines.

DONE:

-

NEXT:

-

# Results

> What was the outcome of the project?