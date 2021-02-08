// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/value_form_field.dart';

void main() {
  group("ValueFormField", () {
    const value = 10;

    testWidgets(
      "throws an AssertionError if the given builder is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(const _ValueFormFieldTestbed(
          value: 1.0,
          builder: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given value is null",
      (WidgetTester tester) async {
        await tester.pumpWidget(_ValueFormFieldTestbed(
          builder: (state) => Container(),
          value: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the given value to the form field initial value",
      (WidgetTester tester) async {
        await tester.pumpWidget(_ValueFormFieldTestbed(
          builder: (state) => Container(),
          value: value,
        ));

        final formField = tester.widget<FormField<int>>(find.byWidgetPredicate(
          (widget) => widget is FormField<int>,
        ));

        expect(formField.initialValue, equals(value));
      },
    );

    testWidgets(
      "applies the given value to the form field state value",
      (WidgetTester tester) async {
        final testKey = GlobalKey();

        await tester.pumpWidget(_ValueFormFieldTestbed(
          formKey: testKey,
          builder: (state) => Container(),
          value: value,
        ));

        final state = testKey.currentState as FormFieldState;

        expect(state.value, equals(value));
      },
    );
  });
}

/// A testbed class needed to test the [ValueFormField] widget.
class _ValueFormFieldTestbed<T> extends StatelessWidget {
  /// A [Key] used to obtain the [FormFieldState] in tests.
  final Key formKey;

  /// Function that returns the widget representing the [ValueFormField]. It is
  /// passed the form field state as input, containing the current value and
  /// validation state of the [ValueFormField].
  final FormFieldBuilder<T> builder;

  /// A value to validate.
  final T value;

  /// An auto validation mode of the value form field.
  final AutovalidateMode autovalidateMode;

  /// A [FormFieldValidator] callback used to validate the [value].
  final FormFieldValidator<T> validator;

  /// Defines whether the form is able to receive user input.
  final bool enabled;

  /// An optional method to call with the final value when the form is saved via
  /// [FormState.save].
  final FormFieldSetter<T> onSaved;

  /// Creates a new instance of the testbed [_ValueFormFieldTestbed].
  ///
  /// The [enabled] default value is `true`.
  /// The [autovalidateMode] default value is [AutovalidateMode.disabled].
  const _ValueFormFieldTestbed({
    Key key,
    this.builder,
    this.value,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.validator,
    this.enabled = true,
    this.onSaved,
    this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ValueFormField<T>(
          key: formKey,
          builder: builder,
          value: value,
          autovalidateMode: autovalidateMode,
          validator: validator,
          enabled: enabled,
          onSaved: onSaved,
        ),
      ),
    );
  }
}
