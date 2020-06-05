import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/common/presentation/widgets/metrics_text_form_field.dart';

void main() {
  group("MetricsTextFormField", () {
    const text = 'label';
    final controller = TextEditingController();

    testWidgets("displays the given label", (tester) async {
      await tester.pumpWidget(
        _MetricsTextFormFieldTestbed(
          controller: controller,
          label: text,
        ),
      );

      expect(find.text(text), findsOneWidget);
    });

    testWidgets(
        "does not display a close icon button for clearing text as a default",
        (tester) async {
      await tester.pumpWidget(
        _MetricsTextFormFieldTestbed(
          controller: controller,
          label: text,
        ),
      );

      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets(
        "displays a close icon button for clearing text if isClearable value is true",
        (tester) async {
      await tester.pumpWidget(
        _MetricsTextFormFieldTestbed(
          controller: controller,
          label: text,
          isClearable: true,
        ),
      );

      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets("clears the entered text on tap on close icon", (tester) async {
      await tester.pumpWidget(
        _MetricsTextFormFieldTestbed(
          controller: controller,
          label: text,
          isClearable: true,
        ),
      );

      await tester.enterText(find.byType(MetricsTextFormField), text);
      await tester.pump();

      expect(controller.text, equals(text));

      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(controller.text, isEmpty);
    });

    testWidgets(
      "validator callback is called on the form validation",
      (tester) async {
        final GlobalKey<FormState> _formKey = GlobalKey();
        bool callbackIsCalled = false;

        await tester.pumpWidget(Form(
          key: _formKey,
          child: _MetricsTextFormFieldTestbed(
            controller: controller,
            label: text,
            validator: (String value) {
              callbackIsCalled = true;
              return null;
            },
          ),
        ));

        _formKey.currentState.validate();

        expect(callbackIsCalled, isTrue);
      },
    );
  });
}

/// A testbed widget, used to test the [MetricsTextFormField] widget.
class _MetricsTextFormFieldTestbed extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool isClearable;
  final String Function(String) validator;

  const _MetricsTextFormFieldTestbed({
    Key key,
    this.controller,
    this.label,
    this.isClearable = false,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: MetricsTextFormField(
          controller: controller,
          label: label,
          isClearable: isClearable,
          validator: validator,
        ),
      ),
    );
  }
}
