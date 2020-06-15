import 'package:flutter/material.dart';

/// Displays a clearable text form field widget.
class ClearableTextFormField extends StatelessWidget {
  /// A text field label.
  final String label;

  /// A text field controller.
  final TextEditingController controller;

  /// A text field form validator.
  final FormFieldValidator<String> validator;

  /// Creates a widget that represents a specific version of a [TextFormField],
  /// with an ability to clear the text.
  ///
  /// The [label] and the [controller] arguments must not be null.
  const ClearableTextFormField({
    @required this.label,
    @required this.controller,
    this.validator,
  })  : assert(label != null),
        assert(controller != null);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(label),
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            suffixIcon: controller.text.isNotEmpty
                ? IconButton(
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    icon:const Icon(Icons.close, size: 18.0),
                    onPressed: () => controller.clear(),
                  )
                : null,
            border: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        )
      ],
    );
  }
}
