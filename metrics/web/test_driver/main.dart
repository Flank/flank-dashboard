import 'arguments/parser/driver_test_arguments_parser.dart';
import 'flutter_web_driver.dart';

Future main(List<String> args) async {
  final parser = DriverTestArgumentsParser();

  final _args = parser.parseArguments(args);

  if (_args.showHelp) {
    parser.showHelp();
    return;
  }

  final driver = FlutterWebDriver(_args);
  await driver.startDriverTests();
}
