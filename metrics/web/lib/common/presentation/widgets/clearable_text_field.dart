import 'package:flutter/material.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';

class ClearableTextFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String Function(String) validator;

  const ClearableTextFormField({
    @required this.label,
    @required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(ProjectGroupsStrings.nameYourStrings),
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          decoration: InputDecoration(
            suffixIcon: controller.text.isEmpty
                ? null
                : IconButton(
                    splashColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    icon: Icon(Icons.close, size: 18.0),
                    onPressed: () {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        controller.clear();
                      });
                    },
                  ),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
          ),
        )
      ],
    );
  }
}
