import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_input_field.dart';

void main() {
  const String testLabel = 'testLabel';

  group("AuthInputField", () {
    testWidgets("displays the label", (WidgetTester tester) async {
      await tester.pumpWidget(const _AuthInputFieldTestbed(
        label: testLabel,
      ));

      expect(find.widgetWithText(AuthInputField, testLabel), findsOneWidget);
    });

    testWidgets("delegates a controller to the TextField widget",
        (WidgetTester tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(_AuthInputFieldTestbed(
        controller: controller,
      ));

      final textInput = tester.widget<TextField>(find.byType(TextField));

      expect(textInput.controller, equals(controller));
    });

    testWidgets("delegates an obscureText property to the text input widget",
        (WidgetTester tester) async {
      await tester.pumpWidget(const _AuthInputFieldTestbed(obscureText: true));

      final firstInputText = tester.widget<TextField>(find.byType(TextField));

      expect(firstInputText.obscureText, isTrue);

      await tester.pumpWidget(const _AuthInputFieldTestbed());

      final secondInputText = tester.widget<TextField>(find.byType(TextField));

      expect(secondInputText.obscureText, isFalse);
    });

    testWidgets("delegates an autofocus property to the text input widget",
        (WidgetTester tester) async {
      final FocusNode firstFocusNode = FocusNode();

      await tester.pumpWidget(_AuthInputFieldTestbed(
        autofocus: true,
        focusNode: firstFocusNode,
      ));

      expect(firstFocusNode.hasFocus, isTrue);

      final FocusNode secondFocusNode = FocusNode();

      await tester.pumpWidget(_AuthInputFieldTestbed(
        focusNode: secondFocusNode,
      ));

      expect(secondFocusNode.hasFocus, isFalse);
    });

    testWidgets(
        "onFieldSubmitted callback is called after submitting the input",
        (WidgetTester tester) async {
      bool callbackIsCalled = false;

      await tester.pumpWidget(_AuthInputFieldTestbed(onFieldSubmitted: (value) {
        callbackIsCalled = true;
      }));

      await tester.showKeyboard(find.byType(_AuthInputFieldTestbed));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(callbackIsCalled, isTrue);
    });

    testWidgets("validator callback is called after a form was validated",
        (WidgetTester tester) async {
      final GlobalKey<FormState> _formKey = GlobalKey();
      bool callbackIsCalled = false;

      await tester.pumpWidget(Form(
        key: _formKey,
        child: _AuthInputFieldTestbed(
          validator: (String value) {
            callbackIsCalled = true;
            return null;
          },
        ),
      ));

      await tester.showKeyboard(find.byType(_AuthInputFieldTestbed));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      _formKey.currentState.validate();

      expect(callbackIsCalled, isTrue);
    });

    testWidgets("delegates keyboardType property to the text field",
        (WidgetTester tester) async {
      await tester.pumpWidget(const _AuthInputFieldTestbed(
        keyboardType: TextInputType.emailAddress,
      ));

      final emailTextInput = tester.widget<TextField>(find.byType(TextField));

      expect(emailTextInput.keyboardType, isNotNull);
      expect(emailTextInput.keyboardType, equals(TextInputType.emailAddress));

      await tester.pumpWidget(const _AuthInputFieldTestbed(
        keyboardType: TextInputType.phone,
      ));

      final phoneTextInput = tester.widget<TextField>(find.byType(TextField));

      expect(phoneTextInput.keyboardType, equals(TextInputType.phone));
    });

    testWidgets("delegates focusNode property to the text field",
        (WidgetTester tester) async {
      await tester.pumpWidget(_AuthInputFieldTestbed(
        focusNode: FocusNode(),
      ));

      final textInput = tester.widget<TextField>(find.byType(TextField));

      expect(textInput.focusNode, isNotNull);
    });
  });
}

class _AuthInputFieldTestbed extends StatelessWidget {
  final String label;
  final bool obscureText;
  final bool autofocus;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onFieldSubmitted;
  final FormFieldValidator<String> validator;
  final TextInputType keyboardType;

  const _AuthInputFieldTestbed({
    this.label,
    this.obscureText = false,
    this.autofocus = false,
    this.controller,
    this.focusNode,
    this.onFieldSubmitted,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: AuthInputField(
          label: label,
          obscureText: obscureText,
          controller: controller,
          autofocus: autofocus,
          focusNode: focusNode,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator,
          keyboardType: keyboardType,
        ),
      ),
    );
  }
}
