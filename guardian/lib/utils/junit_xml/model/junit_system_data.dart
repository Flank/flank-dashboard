part of junit_xml;

class JUnitSystemOutData extends _JUnitSystemData {
  JUnitSystemOutData({String text}) : super(text: text);
}

class JUnitSystemErrData extends _JUnitSystemData {
  JUnitSystemErrData({String text}) : super(text: text);
}

abstract class _JUnitSystemData {
  final String text;

  _JUnitSystemData({this.text});
}
