import 'package:flutter/material.dart';
import 'package:metrics/common/presentation/metrics_theme/model/metrics_theme_data.dart';
import 'package:metrics/common/presentation/metrics_theme/widgets/metrics_theme.dart';

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

  /// An icon that appears before the editable part of this text field,
  /// within the decoration's container.
  final Widget prefixIcon;

  /// An active icon that appears before the editable part of this text field
  /// once it's active, within the decoration's container.
  final Widget activePrefixIcon;

  /// An icon that appears after the editable part of this text field,
  /// within the decoration's container.
  final Widget suffixIcon;

  /// Text that suggests what sort of input this field accepts.
  final String hint;

  /// Text that describes this input field.
  final String label;

  /// Creates a new instance of the Metrics text form field.
  ///
  /// The [obscureText] defaults to `false` and must not be `null`.
  const MetricsTextFormField({
    Key key,
    this.obscureText = false,
    this.controller,
    this.validator,
    this.onChanged,
    this.keyboardType,
    this.prefixIcon,
    this.activePrefixIcon,
    this.suffixIcon,
    this.hint,
    this.label,
  })  : assert(obscureText != null),
        super(key: key);

  @override
  _MetricsTextFormFieldState createState() => _MetricsTextFormFieldState();
}

class _MetricsTextFormFieldState extends State<MetricsTextFormField> {
  /// Defines the focus for this text field.
  final _focusNode = FocusNode();

  /// The default decoration for this text field.
  InputDecoration _defaultDecoration;

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
  /// Otherwise, returns [_defaultDecoration].
  InputDecoration get _decoration {
    if (_isFocused) return _focusDecoration;

    if (_isHovered) return _hoverDecoration;

    return _defaultDecoration;
  }

  @override
  void initState() {
    _isHovered = false;
    _isFocused = false;
    _defaultDecoration = InputDecoration(
      prefixIcon: widget.prefixIcon,
      suffixIcon: widget.suffixIcon,
      hintText: widget.hint,
    );

    _focusNode.addListener(_changeFocused);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    final textFieldTheme = MetricsTheme.of(context).textFieldTheme;
    final decorationTheme = Theme.of(context).inputDecorationTheme;

    final border = decorationTheme.border ?? InputBorder.none;
    _hoverDecoration = _defaultDecoration.copyWith(
      border: border.copyWith(
        borderSide: BorderSide(color: textFieldTheme.hoverBorderColor),
      ),
    );

    _focusDecoration = _defaultDecoration.copyWith(
      fillColor: textFieldTheme.focusColor,
      prefixIcon: widget.activePrefixIcon,
    );

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final textFieldTheme = MetricsTheme.of(context).textFieldTheme;
    final decorationTheme = Theme.of(context).inputDecorationTheme;

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
            decoration: _decoration,
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
