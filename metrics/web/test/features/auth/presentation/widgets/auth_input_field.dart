import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:metrics/features/auth/presentation/widgets/auth_input_field.dart';

void main() {
  const String testLabel = 'testLabel';
  const String textForInput = 'abc';

  group('Auth input field', () {
    testWidgets('displays the label', (WidgetTester tester) async {
      await tester.pumpWidget(const AuthInputFieldTestbed(
        label: testLabel,
      ));

      expect(find.widgetWithText(AuthInputField, testLabel), findsOneWidget);
    });

    testWidgets('obscureText hides provided text for the input',
        (WidgetTester tester) async {
      await tester.pumpWidget(const AuthInputFieldTestbed(
        obscureText: true,
        label: testLabel,
      ));

      final Finder input = find.widgetWithText(AuthInputField, testLabel);

      await tester.enterText(input, textForInput);

      final String visibleText = findRenderEditable(tester).text.text;

      expect(visibleText, isNot(equals(textForInput)));
    });

    testWidgets('autofocus sets focus on the input',
        (WidgetTester tester) async {
      final FocusNode focusNode = FocusNode();

      await tester.pumpWidget(AuthInputFieldTestbed(
        autofocus: true,
        focusNode: focusNode,
      ));

      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets('onFieldSubmitted callback is called',
        (WidgetTester tester) async {
      bool callbackIsCalled = false;

      await tester.pumpWidget(AuthInputFieldTestbed(onFieldSubmitted: (value) {
        callbackIsCalled = true;
      }));

      await tester.showKeyboard(find.byType(AuthInputFieldTestbed));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(callbackIsCalled, isTrue);
    });

    testWidgets('validator callback is called', (WidgetTester tester) async {
      final GlobalKey<FormState> _formKey = GlobalKey();
      bool callbackIsCalled = false;

      await tester.pumpWidget(Form(
        key: _formKey,
        child: AuthInputFieldTestbed(
          validator: (String value) {
            callbackIsCalled = true;
            return null;
          },
        ),
      ));

      await tester.showKeyboard(find.byType(AuthInputFieldTestbed));
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      _formKey.currentState.validate();

      expect(callbackIsCalled, isTrue);
    });
  });
}

// Returns the first RenderEditable.
RenderEditable findRenderEditable(WidgetTester tester) {
  final RenderObject root = tester.renderObject(find.byType(EditableText));
  expect(root, isNotNull);

  RenderEditable renderEditable;
  void recursiveFinder(RenderObject child) {
    if (child is RenderEditable) {
      renderEditable = child;
      return;
    }
    child.visitChildren(recursiveFinder);
  }

  root.visitChildren(recursiveFinder);
  expect(renderEditable, isNotNull);
  return renderEditable;
}

class AuthInputFieldTestbed extends StatelessWidget {
  final String label;
  final bool obscureText;
  final bool autofocus;
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onFieldSubmitted;
  final FormFieldValidator<String> validator;

  const AuthInputFieldTestbed({
    this.label,
    this.obscureText = false,
    this.autofocus = false,
    this.controller,
    this.focusNode,
    this.onFieldSubmitted,
    this.validator,
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
        ),
      ),
    );
  }
}
