import 'package:flutter/material.dart';

/// A widget that used for validating the [value] on UI.
class ValueFormField<T> extends FormField<T> {
  /// A value to validate.
  final T value;

  /// Creates a new instance of [ValueFormField].
  ///
  /// The [autovalidate] default value is `false`.
  /// The [enabled] default value is `true`.
  ///
  /// The [builder] and [value] must not be null.
  const ValueFormField({
    Key key,
    FormFieldSetter<T> onSaved,
    FormFieldValidator<T> validator,
    bool autovalidate = false,
    bool enabled = true,
    @required Widget Function(FormFieldState<T>) builder,
    @required this.value,
  })  : assert(builder != null),
        assert(value != null),
        super(
        key: key,
        initialValue: value,
        onSaved: onSaved,
        validator: validator,
        autovalidate: autovalidate,
        enabled: enabled,
        builder: builder,
      );

  @override
  _ValueFormFieldState<T> createState() => _ValueFormFieldState<T>();
}

class _ValueFormFieldState<T> extends FormFieldState<T> {
  @override
  ValueFormField<T> get widget => super.widget as ValueFormField<T>;

  @override
  void didUpdateWidget(FormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    setValue(widget.value);
  }
}
