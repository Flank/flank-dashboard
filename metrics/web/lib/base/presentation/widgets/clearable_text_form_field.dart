import 'package:flutter/material.dart';

/// A [TextFormField] widget with an ability to clean its content.
class ClearableTextFormField extends StatefulWidget {
  /// A text field label.
  final String label;

  /// A text field controller.
  final TextEditingController controller;

  /// A text field form validator.
  final FormFieldValidator<String> validator;

  /// The shape of the border to draw around the decoration's container.
  final InputBorder border;

  /// Creates a new instance of the [ClearableTextFormField].
  ///
  /// The [label] and the [controller] arguments must not be null.
  const ClearableTextFormField({
    @required this.label,
    @required this.controller,
    this.validator,
    this.border,
  })  : assert(label != null),
        assert(controller != null);

  @override
  _ClearableTextFormFieldState createState() => _ClearableTextFormFieldState();
}

class _ClearableTextFormFieldState extends State<ClearableTextFormField> {
  /// Indicates whether this widget is ready for clearing.
  bool _isClearable;

  @override
  void initState() {
    super.initState();

    _isClearable = widget.controller.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      validator: widget.validator,
      onChanged: _checkClearable,
      decoration: InputDecoration(
        labelText: widget.label,
        suffixIcon: _isClearable
            ? IconButton(
                splashColor: Colors.transparent,
                hoverColor: Colors.transparent,
                icon: const Icon(Icons.close, size: 18.0),
                onPressed: widget.controller.clear,
              )
            : null,
        border: widget.border,
      ),
    );
  }

  /// Checks whether this widget is ready for clearing.
  void _checkClearable(String value) {
    setState(() {
      _isClearable = value != null && value.isNotEmpty;
    });
  }
}
