import 'dart:io';

import 'package:guardian/utils/junit_xml/junit_xml.dart';
import 'package:test/test.dart';
import 'package:xml/xml.dart';

void main() {
  group('JUnitXmlParser', () {
    const parser = JUnitXmlParser();
    final androidPassTest = File('test/resources/android_pass.xml');
    final androidFailTest = File('test/resources/android_fail.xml');
    final iosPassTest = File('test/resources/ios_pass.xml');
    final iosFailTest = File('test/resources/ios_fail.xml');

    test('parse() should throw ArgumentError on null input', () {
      expect(() => parser.parse(null), throwsArgumentError);
    });

    test('parse() should throw XmlException on empty XML string', () {
      const emptyXml = '';
      expect(() => parser.parse(emptyXml), throwsA(isA<XmlException>()));
    });

    test(
      'parse() should throw XmlException on XML string with no root element',
      () {
        const noRootXml = "<?xml version='1.0' encoding='UTF-8' ?>";
        expect(() => parser.parse(noRootXml), throwsA(isA<XmlException>()));
      },
    );

    test(
      'parse() should throw XmlException on XML string with two root elements',
      () {
        const twoRootXml = '''
          <?xml version='1.0' encoding='UTF-8' ?>
          <node></node>
          <node></node>
        ''';
        expect(() => parser.parse(twoRootXml), throwsA(isA<XmlException>()));
      },
    );

    test('parse() should throw ArgumentError on not JUnitXML input', () {
      const randomXml = '''
        <?xml version='1.0' encoding='UTF-8' ?>
        <node></node>
      ''';
      expect(() => parser.parse(randomXml), throwsArgumentError);
    });

    test(
      'parse() should throw FormatException on '
      'invalid JUnitXML report',
      () {
        const missedTestSuiteAttributesXml = '''
          <?xml version='1.0' encoding='UTF-8' ?>
          <testsuite>
          </testsuite>
        ''';

        expect(
          () => parser.parse(missedTestSuiteAttributesXml),
          throwsFormatException,
        );
      },
    );

    //<?xml version='1.0' encoding='UTF-8' ?>
    //<testsuite name="" tests="1" failures="0" errors="0" skipped="0" time="2.278" timestamp="2018-09-14T20:45:55" hostname="localhost" testLabExecutionId="matrix-1234_execution-asdf">
    //    <properties />
    //    <testcase name="testPasses" classname="com.example.app.ExampleUiTest" time="0.328" />
    //</testsuite>
    test('parse() should parse android_pass.xml', () {
      final result = parser.parse(androidPassTest.readAsStringSync());

      final expected = JUnitXmlReport(JUnitTestSuites(
        testSuites: [
          JUnitTestSuite(
            name: '',
            tests: 1,
            failures: 0,
            errors: 0,
            skipped: 0,
            time: 2.278,
            timestamp: DateTime.tryParse('2018-09-14T20:45:55'),
            hostname: 'localhost',
            testLabExecutionId: 'matrix-1234_execution-asdf',
            properties: const [],
            testCases: const [
              JUnitTestCase(
                name: 'testPasses',
                classname: 'com.example.app.ExampleUiTest',
                time: 0.328,
              ),
            ],
          ),
        ],
      ));

      expect(result, equals(expected));
    });

    //<?xml version='1.0' encoding='UTF-8' ?>
    //<testsuite name="" tests="2" failures="1" errors="0" skipped="0" time="3.87" timestamp="2018-09-09T00:16:36" hostname="localhost">
    //    <properties />
    //    <testcase name="testFails" classname="com.example.app.ExampleUiTest" time="0.857">
    //        <failure>junit.framework.AssertionFailedError: expected:&lt;true&gt; but was:&lt;false&gt;
    //junit.framework.Assert.fail(Assert.java:50)</failure>
    //    </testcase>
    //    <testcase name="testPasses" classname="com.example.app.ExampleUiTest" time="0.276" />
    //</testsuite>
    test('parse() should parse android_fail.xml', () {
      final result = parser.parse(androidFailTest.readAsStringSync());

      final expected = JUnitXmlReport(JUnitTestSuites(
        testSuites: [
          JUnitTestSuite(
            name: '',
            tests: 2,
            failures: 1,
            errors: 0,
            skipped: 0,
            time: 3.87,
            timestamp: DateTime.tryParse('2018-09-09T00:16:36'),
            hostname: 'localhost',
            properties: const [],
            testCases: const [
              JUnitTestCase(
                name: 'testFails',
                classname: 'com.example.app.ExampleUiTest',
                time: 0.857,
                failures: [
                  JUnitTestCaseFailure(
                    text: 'junit.framework.AssertionFailedError: expected:<true> but was:<false>\n'
                        'junit.framework.Assert.fail(Assert.java:50)',
                  ),
                ],
              ),
              JUnitTestCase(
                name: 'testPasses',
                classname: 'com.example.app.ExampleUiTest',
                time: 0.276,
              ),
            ],
          ),
        ],
      ));

      expect(result, equals(expected));
    });

    //<?xml version='1.0' encoding='UTF-8'?>
    //<testsuites>
    //    <testsuite name='EarlGreyExampleSwiftTests' hostname='localhost' tests='2' failures='0' errors='0' time='25.892'>
    //        <properties />
    //        <testcase name='testBasicSelection()' classname='EarlGreyExampleSwiftTests' time='2.0' />
    //        <testcase name='testBasicSelectionActionAssert()' classname='EarlGreyExampleSwiftTests' time='0.712' />
    //        <system-out />
    //        <system-err />
    //    </testsuite>
    //</testsuites>
    test('parse() should parse ios_pass.xml', () {
      final result = parser.parse(iosPassTest.readAsStringSync());

      const expected = JUnitXmlReport(JUnitTestSuites(
        testSuites: [
          JUnitTestSuite(
            name: 'EarlGreyExampleSwiftTests',
            tests: 2,
            failures: 0,
            errors: 0,
            time: 25.892,
            hostname: 'localhost',
            properties: [],
            systemOut: JUnitSystemOutData(text: ''),
            systemErr: JUnitSystemErrData(text: ''),
            testCases: [
              JUnitTestCase(
                name: 'testBasicSelection()',
                classname: 'EarlGreyExampleSwiftTests',
                time: 2.0,
              ),
              JUnitTestCase(
                name: 'testBasicSelectionActionAssert()',
                classname: 'EarlGreyExampleSwiftTests',
                time: 0.712,
              ),
            ],
          ),
        ],
      ));

      expect(result, equals(expected));
    });

    //<?xml version='1.0' encoding='UTF-8'?>
    //<testsuites>
    //    <testsuite name='EarlGreyExampleSwiftTests' hostname='localhost' tests='2' failures='1' errors='0' time='25.881'>
    //        <properties />
    //        <testcase name='testBasicSelectionActionAssert()' classname='EarlGreyExampleSwiftTests' time='0.719' />
    //        <testcase name='testBasicSelectionAndAction()' classname='EarlGreyExampleSwiftTests' time='0.584'>
    //            <failure>Exception: NoMatchingElementException</failure>
    //            <failure>failed: caught "EarlGreyInternalTestInterruptException", "Immediately halt execution of testcase"</failure>
    //        </testcase>
    //        <system-out />
    //        <system-err />
    //    </testsuite>
    //</testsuites>
    test('parse() should parse ios_fail.xml', () {
      final result = parser.parse(iosFailTest.readAsStringSync());

      const expected = JUnitXmlReport(JUnitTestSuites(
        testSuites: [
          JUnitTestSuite(
            name: 'EarlGreyExampleSwiftTests',
            tests: 2,
            failures: 1,
            errors: 0,
            time: 25.881,
            hostname: 'localhost',
            properties: [],
            systemOut: JUnitSystemOutData(text: ''),
            systemErr: JUnitSystemErrData(text: ''),
            testCases: [
              JUnitTestCase(
                name: 'testBasicSelectionActionAssert()',
                classname: 'EarlGreyExampleSwiftTests',
                time: 0.719,
              ),
              JUnitTestCase(
                name: 'testBasicSelectionAndAction()',
                classname: 'EarlGreyExampleSwiftTests',
                time: 0.584,
                failures: [
                  JUnitTestCaseFailure(
                    text: 'Exception: NoMatchingElementException',
                  ),
                  JUnitTestCaseFailure(
                    text: 'failed: caught '
                        '"EarlGreyInternalTestInterruptException", '
                        '"Immediately halt execution of testcase"',
                  ),
                ],
              ),
            ],
          ),
        ],
      ));

      expect(result, equals(expected));
    });
  });
}
