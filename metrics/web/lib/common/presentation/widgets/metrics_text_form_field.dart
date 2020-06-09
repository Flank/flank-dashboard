import 'package:flutter/material.dart';

/// Displays a metrics text form field widget.
class MetricsTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String Function(String) validator;
  final bool isClearable;

  /// Creates a widget that represents a specific version of a [TextFormField].
  ///
  /// The text field has the given [label]. 
  /// The text field is controlled by the [controller]. 
  /// The [validator] callback allows to validate the entered text. 
  /// Setting the [isClearable] argument to [true] allows clearing a text inside the input.
  /// The [isClearable] argument is [false] by default.
  /// 
  /// The [label] and the [controller] arguments should not be null.
  const MetricsTextFormField({
    @required this.label,
    @required this.controller,
    this.validator,
    this.isClearable = false,
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
            suffixIcon: controller.text.isNotEmpty || isClearable
                ? IconButton(
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    icon: Icon(Icons.close, size: 18.0),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        controller.clear();
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        )
      ],
    );
  }
}
