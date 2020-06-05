import 'package:flutter/material.dart';

class MetricsTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String Function(String) validator;
  final bool isClearable;

  const MetricsTextFormField({
    @required this.label,
    @required this.controller,
    this.validator,
    this.isClearable = false,
  });

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
