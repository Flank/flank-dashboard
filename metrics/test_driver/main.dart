import 'flutter_web_driver.dart';

Future main(List<String> args) async {
  final driver = FlutterWebDriver(args);

  await driver.startDriverTests();
}
