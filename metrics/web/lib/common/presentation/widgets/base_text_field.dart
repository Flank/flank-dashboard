import 'package:flutter/material.dart';

class BaseTextField extends StatelessWidget {
  final TextEditingController controller;

  const BaseTextField({this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Name Your group',
          style: TextStyle(color: Colors.black),
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
          height: 50.0,
          child: TextField(
            controller: controller,
            style: TextStyle(
              color: Colors.black,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                  size: 18.0,
                ),
                onPressed: () {
                  print('clear button');
                },
              ),
              labelStyle: TextStyle(color: Colors.black),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey[600], width: 2.0),
              ),
            ),
          ),
        )
      ],
    );
  }
}
