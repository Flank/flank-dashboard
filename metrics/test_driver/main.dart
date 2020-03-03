import 'arguments/parser/driver_test_arguments_parser.dart';
import 'flutter_web_driver.dart';

Future main(List<String> args) async {
  DriverTestArgumentsParser.configureParser();
  final _args = DriverTestArgumentsParser.parseArguments(args);

  if (_args.showHelp) {
    DriverTestArgumentsParser.showHelp();
    return;
  }

  final driver = FlutterWebDriver(_args);
  await driver.startDriverTests();
}
