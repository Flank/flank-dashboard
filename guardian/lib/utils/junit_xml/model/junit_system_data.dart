// Use of this source code is governed by the Apache License, Version 2.0 
// that can be found in the LICENSE file.

part of junit_xml;

/// An abstract class representing system data that was written during
/// execution.
abstract class _JUnitSystemData extends Equatable {
  final String text;

  const _JUnitSystemData({this.text});

  @override
  List<Object> get props => [text];
}
