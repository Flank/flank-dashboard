import 'package:flutter/material.dart';
import 'package:metrics/project_groups/presentation/strings/project_groups_strings.dart';

class ClearableTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const ClearableTextField({
    @required this.label,
    @required this.controller,
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
        TextField(
          controller: controller,
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
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).accentColor,
                width: 2.0,
              ),
            ),
          ),
        )
      ],
    );
  }
}
