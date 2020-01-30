part of junit_xml;

class SystemOutData extends _SystemData {
  SystemOutData({String text}) : super(text: text);
}

class SystemErrData extends _SystemData {
  SystemErrData({String text}) : super(text: text);
}

abstract class _SystemData {
  final String text;

  _SystemData({this.text});
}
