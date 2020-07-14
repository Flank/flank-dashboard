import 'package:flutter/material.dart';
import 'package:metrics/base/presentation/widgets/hand_cursor.dart';

/// A [TextFormField] widget with an ability to clean its content.
class ClearableTextFormField extends StatefulWidget {
  /// A [TextStyle] to use for the text being edited.
  final TextStyle textStyle;

  /// An icon to use for the clear content button within this text field.
  final Widget clearIcon;

  /// A text field controller.
  final TextEditingController controller;

  /// A text field form validator.
  final FormFieldValidator<String> validator;

  /// The decoration to show around this text field.
  ///
  /// The [InputDecoration.suffixIcon] is ignored and replaced with
  /// the clear [IconButton]. To change the clear button use the [clearIcon].
  final InputDecoration inputDecoration;

  /// Creates a new instance of the [ClearableTextFormField].
  ///
  /// If the [inputDecoration] is null, the empty [InputDecoration] is used.
  /// If the [clearIcon] is null, the [Icon] with [Icons.close] is used.
  ///
  /// The [controller] argument must not be null.
  const ClearableTextFormField({
    @required this.controller,
    InputDecoration inputDecoration,
    Widget clearIcon,
    this.validator,
    this.textStyle,
  })  : assert(controller != null),
        inputDecoration = inputDecoration ?? const InputDecoration(),
        clearIcon = clearIcon ?? const Icon(Icons.close, size: 18.0);

  @override
  _ClearableTextFormFieldState createState() => _ClearableTextFormFieldState();
}

class _ClearableTextFormFieldState extends State<ClearableTextFormField> {
  @override
  void initState() {
    super.initState();

    widget.controller.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      style: widget.textStyle,
      decoration: widget.inputDecoration.copyWith(
        suffixIcon: widget.controller.text.isNotEmpty
            ? HandCursor(
                child: IconButton(
                  splashColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  icon: widget.clearIcon,
                  onPressed: _clearField,
                ),
              )
            : null,
      ),
    );
  }

  /// Clears the text in this text field.
  ///
  /// Uses the workaround with addPostFrameCallback due to issue
  /// in the [TextEditingController] https://github.com/flutter/flutter/issues/17647
  void _clearField() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.controller.clear();
    });
  }
}
