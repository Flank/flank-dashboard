// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';

/// A [Function] used to build a prefix icon using the [prefixColor].
typedef PrefixBuilder = Widget Function(
  BuildContext context,
  Color prefixColor,
);

/// A widget that displays a metrics styled text field and
/// applies the [MetricsThemeData.textFieldTheme].
class MetricsTextFormField extends StatefulWidget {
  /// A text field controller.
  final TextEditingController controller;

  /// A text field form validator.
  final FormFieldValidator<String> validator;

  /// The callback that is called when text field value has changed.
  final ValueChanged<String> onChanged;

  /// Indicates whether to hide the text being edited.
  final bool obscureText;

  /// A type of keyboard to use for editing the text.
  final TextInputType keyboardType;

  /// A [PrefixBuilder] that builds a prefix icon for this text field
  /// depending on the passed parameters.
  final PrefixBuilder prefixIconBuilder;

  /// An icon that appears after the editable part of this text field,
  /// within the decoration's container.
  final Widget suffixIcon;

  /// Text that suggests what sort of input this field accepts.
  final String hint;

  /// Text that describes this input field.
  final String label;

  /// An error text that appears below this input field.
  final String errorText;

  /// Creates a new instance of the Metrics text form field.
  ///
  /// The [obscureText] defaults to `false` and must not be `null`.
  const MetricsTextFormField({
    Key key,
    this.obscureText = false,
    this.prefixIconBuilder,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.suffixIcon,
    this.hint,
    this.label,
    this.errorText,
  })  : assert(obscureText != null),
        super(key: key);

  @override
  _MetricsTextFormFieldState createState() => _MetricsTextFormFieldState();
}

class _MetricsTextFormFieldState extends State<MetricsTextFormField> {
  /// Defines the focus for this text field.
  final _focusNode = FocusNode();

  /// The decoration for this text field when it is hovered.
  InputDecoration _hoverDecoration;

  /// The decoration for this text field when it is focused.
  InputDecoration _focusDecoration;

  /// Indicates whether this text field is hovered.
  bool _isHovered;

  /// Indicates whether this text field is focused.
  bool _isFocused;

  /// The decoration to apply to this text field according to the current state.
  ///
  /// Returns [_focusDecoration], if field [_isFocused].
  /// Returns [_hoverDecoration], if field [_isHovered].
  /// Otherwise, returns an empty instance of the [InputDecoration].
  InputDecoration get _decoration {
    if (_isFocused) return _focusDecoration;

    if (_isHovered) return _hoverDecoration;

    return const InputDecoration();
  }

  @override
  void initState() {
    _isHovered = false;
    _isFocused = false;
    _focusNode.addListener(_changeFocused);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    final textFieldTheme = MetricsTheme.of(context).textFieldTheme;
    final decorationTheme = Theme.of(context).inputDecorationTheme;
    final border = decorationTheme.border ?? InputBorder.none;

    _hoverDecoration = InputDecoration(
      enabledBorder: border.copyWith(
        borderSide: BorderSide(color: textFieldTheme.hoverBorderColor),
      ),
    );
    _focusDecoration = InputDecoration(
      fillColor: textFieldTheme.focusColor,
    );

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final textFieldTheme = MetricsTheme.of(context).textFieldTheme;
    final decorationTheme = Theme.of(context).inputDecorationTheme;
    final prefixIcon = widget.prefixIconBuilder?.call(
      context,
      _isFocused
          ? textFieldTheme.focusedPrefixIconColor
          : textFieldTheme.prefixIconColor,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        if (widget.label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              widget.label,
              style: decorationTheme.labelStyle,
            ),
          ),
        MouseRegion(
          onEnter: (_) => _setHovered(true),
          onExit: (_) => _setHovered(false),
          child: TextFormField(
            focusNode: _focusNode,
            onChanged: widget.onChanged,
            controller: widget.controller,
            validator: widget.validator,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            style: textFieldTheme.textStyle,
            decoration: _decoration.copyWith(
              prefixIcon: prefixIcon != null
                  ? Padding(
                      padding: const EdgeInsets.only(left: 14.0, right: 16.0),
                      child: prefixIcon,
                    )
                  : null,
              prefixIconConstraints: const BoxConstraints(maxWidth: 50.0),
              suffixIcon: widget.suffixIcon,
              hintText: widget.hint,
              errorText: widget.errorText,
            ),
          ),
        ),
      ],
    );
  }

  /// Changes the [_isHovered] state to the given [isHovered] value.
  void _setHovered(bool isHovered) {
    setState(() => _isHovered = isHovered);
  }

  /// Changes the [_isFocused] state depending on the
  /// [FocusNode.hasFocus] of this text field.
  void _changeFocused() {
    final isFocused = _focusNode.hasFocus;
    if (_isFocused != isFocused) {
      setState(() => _isFocused = isFocused);
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
