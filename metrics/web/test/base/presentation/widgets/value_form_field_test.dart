import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/value_form_field.dart';

void main() {
  group("ValueFormField", () {
    const value = 10;

    testWidgets(
      "throws an AssertionError if the builder is null",
          (WidgetTester tester) async {
        await tester.pumpWidget(const _ValueFormFieldTestbed(
          value: 1.0,
          builder: null,
        ));

        expect(tester.takeException(), isAssertionError);
      },
    );
    testWidgets(
      "throws an AssertionError if the value is null",
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
      "updates the state value to the given value",
          (WidgetTester tester) async {
        final testKey = GlobalKey();

        await tester.pumpWidget(_ValueFormFieldTestbed(
          testKey: testKey,
          builder: (state) => Container(),
          value: value,
        ));

        final state = testKey.currentState as FormFieldState;

        expect(state.value, equals(value));
      },
    );
  });
}

/// A testbed class needed to test the [Scorecard] widget.
class _ValueFormFieldTestbed<T> extends StatelessWidget {
  /// The [Key] used in tests.
  final Key testKey;

  /// Function that returns the widget representing the [ValueFormField]. It is
  /// passed the form field state as input, containing the current value and
  /// validation state of the [ValueFormField].
  final Widget Function(FormFieldState<T>) builder;

  /// A value to validate.
  final T value;

  /// If true, the [ValueFormField] will validate and update its error text
  /// immediately after every change. Otherwise, you must call
  /// [FormFieldState.validate] to validate. If part of a [Form] that
  /// auto-validates, this value will be ignored.
  final bool autovalidate;

  /// An optional method that validates an input. Returns an error string to
  /// display if the input is invalid, or null otherwise.
  final FormFieldValidator<T> validator;

  /// Whether the form is able to receive user input.
  ///
  /// Defaults to true. If [autovalidate] is true, the field will be validated.
  /// Likewise, if this field is false, the widget will not be validated
  /// regardless of [autovalidate].
  final bool enabled;

  /// An optional method to call with the final value when the form is saved via
  /// [FormState.save].
  final FormFieldSetter<T> onSaved;

  /// Creates a new instance of the testbed [_ValueFormFieldTestbed].
  ///
  /// The [enabled] default value is `true`.
  /// The [autovalidate] default value is `false`.
  const _ValueFormFieldTestbed({
    Key key,
    this.builder,
    this.value,
    this.autovalidate = false,
    this.validator,
    this.enabled = true,
    this.onSaved,
    this.testKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ValueFormField<T>(
          key: testKey,
          builder: builder,
          value: value,
          autovalidate: autovalidate,
          validator: validator,
          enabled: enabled,
          onSaved: onSaved,
        ),
      ),
    );
  }
}
