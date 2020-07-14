import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/base/presentation/widgets/clearable_text_form_field.dart';

void main() {
  group("ClearableTextFormField", () {
    const label = 'label';

    final clearIconButtonFinder = find.descendant(
      of: find.byType(IconButton),
      matching: find.byIcon(Icons.close),
    );

    testWidgets(
      "throws an AssertionError if the given label is null",
      (tester) async {
        await tester.pumpWidget(
          _ClearableTextFormFieldTestbed(
            label: null,
            controller: TextEditingController(),
          ),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "throws an AssertionError if the given controller is null",
      (tester) async {
        await tester.pumpWidget(
          const _ClearableTextFormFieldTestbed(label: label, controller: null),
        );

        expect(tester.takeException(), isAssertionError);
      },
    );

    testWidgets(
      "applies the given label",
      (WidgetTester tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          _ClearableTextFormFieldTestbed(label: label, controller: controller),
        );

        expect(find.text(label), findsOneWidget);
      },
    );

    testWidgets(
      "does not display a clear icon if an input is empty",
      (WidgetTester tester) async {
        final controller = TextEditingController();

        await tester.pumpWidget(
          _ClearableTextFormFieldTestbed(label: label, controller: controller),
        );

        expect(clearIconButtonFinder, findsNothing);
      },
    );

    testWidgets(
      "displays a clear icon if an input is not empty",
      (WidgetTester tester) async {
        final controller = TextEditingController(text: 'text');

        await tester.pumpWidget(
          _ClearableTextFormFieldTestbed(label: label, controller: controller),
        );

        expect(clearIconButtonFinder, findsOneWidget);
      },
    );

    testWidgets(
      "applies a hand cursor to the clear icon",
      (WidgetTester tester) async {
        final controller = TextEditingController(text: 'text');

        await tester.pumpWidget(
          _ClearableTextFormFieldTestbed(label: label, controller: controller),
        );

        expect(clearIconButtonFinder, findsOneWidget);
      },
    );

    testWidgets(
      "calls the validation callback on form validation",
      (WidgetTester tester) async {
        bool _callbackIsCalled = false;
        final _formKey = GlobalKey<FormState>();

        await tester.pumpWidget(
          _ClearableTextFormFieldTestbed(
            formKey: _formKey,
            label: label,
            controller: TextEditingController(text: 'text'),
            validator: (String value) {
              _callbackIsCalled = true;
              return null;
            },
          ),
        );

        _formKey.currentState.validate();

        expect(_callbackIsCalled, isTrue);
      },
    );

    testWidgets(
      "applies the given border",
      (WidgetTester tester) async {
        final controller = TextEditingController(text: 'text');
        const border = OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        );

        await tester.pumpWidget(
          _ClearableTextFormFieldTestbed(
            label: label,
            controller: controller,
            border: border,
          ),
        );

        final widget = tester.widget<ClearableTextFormField>(
          find.byType(ClearableTextFormField),
        );

        expect(widget.border, border);
      },
    );

    testWidgets(
      "clears an input on tap on a clear icon",
      (tester) async {
        final controller = TextEditingController(text: 'text');

        await tester.pumpWidget(
          _ClearableTextFormFieldTestbed(label: label, controller: controller),
        );

        await tester.tap(clearIconButtonFinder);
        await tester.pump();

        expect(controller.text, isEmpty);
      },
    );
  });
}

/// A testbed class required to test the [ClearableTextFormField] widget.
class _ClearableTextFormFieldTestbed extends StatelessWidget {
  /// A text field label.
  final String label;

  /// A text field controller.
  final TextEditingController controller;

  /// A text field form validator.
  final FormFieldValidator<String> validator;

  /// The shape of the border to draw around the decoration's container.
  final InputBorder border;

  /// The unique key for accessing the [Form].
  final GlobalKey formKey;

  /// Creates an instance of this testbed with the given parameters.
  const _ClearableTextFormFieldTestbed({
    Key key,
    this.formKey,
    this.label,
    this.controller,
    this.validator,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Form(
          key: formKey,
          child: ClearableTextFormField(
            label: label,
            controller: controller,
            validator: validator,
            border: border,
          ),
        ),
      ),
    );
  }
}
