import 'package:flutter/material.dart';

/// A widget that provides an ability to validate the given [value].
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
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    bool enabled = true,
    @required FormFieldBuilder<T> builder,
    @required this.value,
  })  : assert(builder != null),
        assert(value != null),
        super(
          key: key,
          initialValue: value,
          onSaved: onSaved,
          validator: validator,
          autovalidateMode: autovalidateMode,
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
