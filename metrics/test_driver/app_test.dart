// This is a Flutter Web Driver test
// https://github.com/flutter/flutter/pull/45951

import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() 
{
  group('flutter driver test', (){

    FlutterDriver driver;

    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        await driver.close();
      }
    });

    test('driver health check', () async {
      Health health = await driver.checkHealth();
      print(health.status);
    });

    // final percentage = find.byValueKey(AppKeys.percentageKey);
    // final title = find.byValueKey(AppKeys.circularProgressTitleKey);

    // test('check progress', () async {
    //   Health health = await driver.checkHealth();
    //   print(health.status);
    //   SerializableFinder progressBar = find.byValueKey(AppKeys.circularProgressKey);
    // try {
    // await driver.waitFor(progressBar);
    // expect(await driver.getText(percentage), "50%");
    //   expect(await driver.getText(title), AppStrings.stability); 
    // } catch (e) {
    // print(e);
    // }     
    // });   
  });
}
